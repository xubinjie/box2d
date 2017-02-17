--[[--------------------------
[csu]对象缓存池

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	对象缓存池
	- Author: 	zengbinsi
	- Date: 	2016-04-29 

--]]--------------------------  







--[[
	类
--]]


local M 		= class("ZPool", {})
M.TAG    		= "ZPool"
---
-- 对象缓存池实例对象
---
M.pool   		= nil 









--------------------------
--  模板
--------------------------

function M:ctor(params)
	self._pool 			= {}
end


function M:onDestructor()
	self._pool = {}
end

function M.getInstance()
	M.pool = M.pool or M.new()

	return M.pool
end






--========================
-- 功能方法
--========================

--[[--
缓存对象

<br/>  
### Useage:
	往缓存池中缓存一个对象。

### Parameters:
- 	CCObject 	**obj** 				[必选] 要添加到缓存池里面的对象  

--]]--
function M:putInPool(obj)
	assert(obj, "obj is nil")

 	-- 获得类型名称
 	local className = obj._cname or obj.__cname

 	-- 创建缓存类别
 	if not self._pool[className] then 
 		self._pool[className] = {} 
 	end
 	-- 添加引用计数
 	if obj.retain then 
 		obj:retain() 
 	end
 	-- 缓存前处理
 	if obj.unuse then 
 		obj:unuse() 
 	end

 	-- 添加到缓存池
 	table.insert(self._pool[className], obj)
end

--[[--
判断缓存池中是否拥有该类型的对象

<br/>  
### Useage:
	判断缓存池中是否拥有该类型的对象

### Parameters:
- 	CCClass|string 	**objClass** 	[必选] 类型对象或者类型名称  

### Returns: 
-   boolean 							否拥有该类型的对象

--]]--
function M:hasObject(objClass)
	local className = objClass

 	if type(className) ~= "string" then 
 		className = objClass._cname or objClass.__cname
 	end

 	local list = self._pool[className]

 	if type(list) ~= "table" or (not next(list)) then 
 		return false 
 	end 

 	return true  
end

--[[--
从缓存池移除对象

<br/>  
### Useage:
	从缓存池移除对象

### Parameters:
- 	CCObject 	**obj** 				[必选] 被添加到缓存池里面的对象  

--]]--
function M:removeObject(obj)
 	assert(obj, "obj is nil")

 	-- 获得类型名称
 	local className = obj._cname or obj.__cname
 	if className then 
	 	local list 		= self._pool[className]

	 	if list then 
	 		local index = T.indexOf(list, obj)

	 		if index > 0 then 
		 		table.remove(list, index)
		 	end
	 	end
	end
end

--[[--
从缓存池获取对象

<br/>  
### Useage:
	从缓存池获取对象，如果对象不存在，会创建相应的对象。

### Parameters:
- 	CCClass|string 	**objClass** 	[必选] 类型对象或者类型名称  
- 	不定参数 				**...** 	[可选] 传递给被缓存对象用于重置状态的参数  

### Returns: 
-   CCObject 							被缓存的对象

--]]--
function M:getFromPool(objClass, ...)
 	if not self:hasObject(objClass) then 
 		return self:recreate(objClass, ...) 
 	end

 	local className = objClass

 	if type(className) ~= "string" then 
 		className = objClass._cname or objClass.__cname
 	end

	local list 		= self._pool[className]
	local obj 		= list[1]

	if obj then 
		table.remove(list, 1)
		if obj.reuse then 
			obj:reuse(...)
		end
		if obj.release then
			obj:release()
		end

		return obj 
	else
		return self:recreate(objClass, ...) 
	end
end


--[[-
重新创建一个对象  

<br/>  
### Useage:
  	用于创建一个指定类型的对象。

### Parameters:
- 	type 		**objClass** 			[必选] 要创建的对象的类型    
- 	undefault 	**...** 				[可选] 对象在重新使用时的参数列表    

### Returns: 
-   T 									新建的对象

--]]
function M:recreate(objClass, ...)
	local obj = objClass.new():reuse(...)

	-- self:putInPool(obj)
	
	return obj
end

--[[--
清空缓存池

<br/>  
### Useage:
	销毁缓存池中所有的对象。

### Notice:
	只触发对象的release()方法，并将其从缓存池移除。

--]]--
function M:drainAllPools()
 	for i, list in ipairs(self._pool) do
 		for i, obj in ipairs(list) do
 			if obj.release then 
 				obj:release()
 			end
 		end
 	end
 	self._pool = {}
end



return M 








