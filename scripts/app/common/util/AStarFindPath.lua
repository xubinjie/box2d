--[[--------------------------
[csu]A*算法工具类

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	A*算法工具类
	- Author: 	zengbinsi
	- Date: 	2016-10-27 

--]]--------------------------  







--========================
-- 引入命名空间
--========================
-- local BaseLayer = import("app.common.layer.BaseLayer")




---
-- A*算法
---
local M 	= class("AStarFindPath")




--========================
-- 构造函数
--========================

--[[--
构造函数

<br/>  

### Useage:

### Aliases:

### Notice:
	创建一个A*寻路对象。

### Example:

### Parameters:
- 	table 	**params** 				[必选] 参数集合  

### OptionParameters
	**params** 
	- function 		**checkPointInMapValid** 	验证点是否是可以行走的（包含一个CCPoint参数，返回值为boolean类型。）

### Returns: 
-   c.AStarFindPath 				A*寻路对象

--]]--
function M:ctor(params)
 	--[本类调用]
 	params 						= params or {}

 	-- 网格大小
 	self.tiledSize 				= params.tiledSize or CCSize(64, 64)
 	-- 检测改点是否有效[在地图上]
 	self.checkPointInMapValid 	= params.checkPointInMapValid
end






--========================
-- 析构
--========================

function M:onDestructor()
	--[超类调用]
	M.super.onDestructor(self)
 	--[本类调用]

end








--========================
-- 功能方法
--========================

--[[--
判断两个点是否相等

<br/>  
### Useage:

### Aliases:

### Notice:
	判断两个点的值是否相等，第三个参数为true的时候，除了值相等之外，还必须是同一个对象。

### Example:

### Parameters:
- 	CCPoint 	**p1** 				[必选] 第一个点  
- 	CCPoint 	**p2** 				[必选] 第二个点  
- 	boolean 	**isForce** 		[可选] 是否强等（值相等，且是同一个对象）  

### OptionParameters

### Returns: 
-   boolean 						点的值是否相等

--]]--
function isPointEqual(p1, p2, isForce)
	if isForce then 
		return p1 == p2 
	else
		return p1 and p2 and p1.x == p2.x and p1.y == p2.y 
	end
end 


--[[--
获取最短路径

<br/>  
### Useage:

### Aliases:

### Notice:
	比较取出所有的路径，返回最短路径。
	如果目标无法到达，返回空表。

### Example:
	-------------------------------------------
	-- 案例一
	-------------------------------------------
	
	-- 点是否在地图上
	local function pointInMap(point)
		-- 有效的地图区域集合
		local maps 	= {
			ccrect(13, 70, 323, 64), 
			ccrect(276, 134, 64, 64 * 3), 
			ccrect(78, 264, 64 * 3, 64), 
			ccrect(208, 330, 64, 64), 
			ccrect(208, 395, 64 * 4, 64), 
			ccrect(403, 330, 64 * 5, 64), 
			ccrect(600, 200, 64, 64 * 2), 
			ccrect(664, 200, 64, 64), 
			ccrect(664, 394, 64 * 3, 64), 
			ccrect(790, 329, 64 * 2, 64), 
			ccrect(860, 135, 64, 64 * 3), 
			ccrect(664, 70, 64 * 4, 64),
			ccrect(400, 5, 64 * 5, 64), 
			ccrect(400, 70, 64, 64), 
			ccrect(337, 137, 64 * 2, 64), 
		}

		for i, rect in ipairs(maps) do
			if PT.inRect(point, rect) then 
				return true 
			end
		end

		return false 
	end

	
	local aStarFindPath 	= c.AStarFindPath.new({
		checkPointInMapValid 	= function(point)
			return pointInMap(point)
		end,
		tiledSize 				= CCSize(64, 64), 
		})
	local path 	= aStarFindPath:getMinPath(ccp(52, 90), ccp(868, 101), 32)
	local node 	= D.img("g/box/r.png"):anchor(ccp(.5, 0)):p(52, 90):to(self, 10)
	local actions = {}

	for k, pos in pairs(path) do
		table.insert(actions, {"moveTo", .5, pos})
	end

	A.line(actions):at(node)




### Parameters:
- 	CCPoint 	**currentPos** 			[必选] 起点  
- 	CCPoint 	**targetPos** 			[必选] 目标点  
- 	number 		**minDistance** 		[必选] 终点与目标点的有效距离  

### OptionParameters

### Returns: 
-   table 								最短路径坐标集合

--]]--
function M:getMinPath(currentPos, targetPos, minDistance)
	-- 得到所有路径
	local paths 	= self:getValidPaths(currentPos, targetPos, minDistance)

	if next(paths) then 
		local currentPath 	= paths[1]
		local currentLen 	= #currentPath

		for k, path in pairs(paths) do
			local newLen 	= #path

			if newLen > 0 and newLen < currentLen then 
				currentPath = path
				currentLen 	= newLen
			end
		end

		return currentPath
	else
		return {}
	end
end  

--[[--
返回所有的有效路径

<br/>  
### Useage:

### Aliases:

### Notice:
	得到所有可以到达终点的路径集合。
	如果目标点无法到达，那么返回空表

### Example:

### Parameters:
- 	CCPoint 	**currentPos** 			[必选] 起点  
- 	CCPoint 	**targetPos** 			[必选] 目标点  
- 	number 		**minDistance** 		[必选] 终点与目标点的有效距离  

### OptionParameters

### Returns: 
-   table  								包含所有有效路径的集合

--]]--
function M:getValidPaths(currentPos, targetPos, minDistance)
	-- 所有的路径集合
	self.paths 		= {}
 	-- 起点的节点
	local n 		= {pos = currentPos, nexts = {}, prev = {}, }

	-- 查找路径
	self:findPath(n, targetPos, minDistance)

	return self.paths
end


--[[--
查找路径

<br/>  
### Useage:

### Aliases:

### Notice:
	根据当前节点和目标点坐标，以及与目标点的有效距离，查找路径。
	当查找到的点与目标点的距离小于等于minDistance时，视为找到路径的终点。
	递归需要return返回值来防止无限递归。

### Parameters:
- 	table 		**n** 						[必选] 当前节点  
- 	CCPoint 	**targetPos** 				[必选] 目标点  
- 	number 		**minDistance** 			[必选] 与目标点的有效距离  

### OptionParameters
	** n **
	- 	table 	**prev** 				[必选] 前驱节点，可以是一个空表，表示当前节点没有前驱节点  
	- 	CCPoint **pos** 				[必选] 当前节点的坐标  
	- 	table 	**nexts** 				[必选] 所有的后继节点  

### Returns: 
- 	table 		**n** 						[必选] 当前节点  

--]]--
function M:findPath(n, targetPos, minDistance)
	pos 		= n.pos

	if ccpDistance(pos, targetPos) <= minDistance then
		self:savePath(n)
		return n 
	end
	
	local up 	= ccp(pos.x, pos.y + self.tiledSize.height)
	if (not self:isHavePos(n, up)) and self.checkPointInMapValid(up) then
		local new 	= {prev = n, pos = up, nexts = {}, }
		table.insert(n.nexts, new)
	end

	local down 	= ccp(pos.x, pos.y - self.tiledSize.height)
	if (not self:isHavePos(n, down)) and self.checkPointInMapValid(down) then
		local new 	= {prev = n, pos = down, nexts = {}, }
		table.insert(n.nexts, new)
	end

	local left 	= ccp(pos.x - self.tiledSize.width, pos.y)
	if (not self:isHavePos(n, left)) and self.checkPointInMapValid(left) then
		local new 	= {prev = n, pos = left, nexts = {}, }
		table.insert(n.nexts, new)
	end

	local right = ccp(pos.x + self.tiledSize.width, pos.y)
	if (not self:isHavePos(n, right)) and self.checkPointInMapValid(right) then
		local new 	= {prev = n, pos = right, nexts = {}, }
		table.insert(n.nexts, new)
	end

	for i, nextNode in ipairs(n.nexts) do
		self:findPath(nextNode, targetPos, minDistance)
	end

	return n
end 

--[[--
保存路径

<br/>  
### Notice:
	当一条路径到达终点的时候，需要遍历路径上的所有点，生成路径，缓存。

### Parameters:
- 	table 	**n** 						[必选] 当前节点  

### OptionParameters
	** n **
	- 	table 	**prev** 				[必选] 前驱节点，可以是一个空表，表示当前节点没有前驱节点  
	- 	CCPoint **pos** 				[必选] 当前节点的坐标  
	- 	table 	**nexts** 				[必选] 所有的后继节点  

--]]--
function M:savePath(n)
	-- 当前路径
	local path 	= {}
	local initPath
	initPath 	= function(n, path)
		table.insert(path, 1, n.pos)

		if n.prev.pos then 
			return initPath(n.prev, path)
		else
			return path 
		end
	end
	
	path 	= initPath(n, path)

	table.insert(self.paths, path)
end

--[[--
是否在该路径上已经拥有某个点

<br/>  
### Useage:

### Aliases:

### Notice:
	用于屏蔽循环路径无限递归。

### Example:

### Parameters:
- 	table 	**n** 						[必选] 当前节点  
- 	CCPoint **pos** 					[必选] 要验证的坐标  

### OptionParameters
	** n **
	- 	table 	**prev** 				[必选] 前驱节点，可以是一个空表，表示当前节点没有前驱节点  
	- 	CCPoint **pos** 				[必选] 当前节点的坐标  
	- 	table 	**nexts** 				[必选] 所有的后继节点  

### Returns: 
-   boolean 							是否已经拥有

--]]--
function M:isHavePos(n, pos)
	if isPointEqual(n.pos, pos) then 
		return true
	elseif n.prev.pos then 
		return self:isHavePos(n.prev, pos)
	else
		return false 
	end
end




--========================
-- 属性
--========================




--========================
-- 父类重写
--========================




return M






