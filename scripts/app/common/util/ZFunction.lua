--[[--------------------------
[csu]定义全局操作

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	定义操作
	- Author: 	zengbinsi
	- Date: 	2015-05-15  

--]]--------------------------  










--[[
	全局类
--]]


local M 	= {}

M.TAG 		= "ZFunction"











--========================
-- 功能方法
--======================== 

 --[[-
 获取圆周上的点    
    
 <br/>  
 ### Useage:
   	将一个圆周等分，返回所有的分割点。    
 
 ### Aliases:
 	别名  
 
 ### Notice:
 	注意   
 
 ### Example:
 	示例  
 
 ### Parameters:
 - 	CCPoint 	**cPoint** 				[必选] 圆心坐标
 - 	number 		**radius** 				[必选] 半径  
 - 	number 		**pNum** 				[必选] 返回的点的个数  
 
 ### Returns: 
 -   table 						  
 
 --]]
function getCircumferencePoints(cPoint, radius, pNum)
	local points 	= {}

	for i = 0, pNum - 1 do
		  local x 	= radius * math.cos(math.rad(360 / pNum * i)) + cPoint.x
		  local y 	= radius * math.sin(math.rad(360 / pNum * i)) + cPoint.y 

		  table.insert(points, ccp(x, y))
	end

	return points 
end 

--[[--
包装匿名函数

<br/>  
### Useage:
	包装匿名函数。

### Aliases:
	**zhandlerInLine**  

### Notice:
	第一个参数不是函数的调用者。这里包装的是函数（function）不是实例对象的方法（method）。

### Parameters:
- 	function 	**method** 				[必选] 要调用的函数  
- 	undefanl 	**。。。** 				[可选] 要传递到目标函数的参数列表  

### Returns: 
-   function 							包装过的无参函数

--]]--
function delegateInLine(method, ... )
	local params = { ... }

	local function callBack()
		method(unpack(params))
	end

	return callBack
end
zhandlerInLine = delegateInLine

--[[--
包装匿名方法

<br/>  
### Useage:
	将要调用的实例对象的方法包装成一个匿名函数。第一个参数是实例对象（方法的调用者）。

### Aliases:

### Notice:
	这里会产生函数闭包，注意内存积压。

### Example:

### Parameters:
- 	CCObject 	**target** 				[必选] 调用函数的对象  
- 	function 	**method** 				[必选] 要调用的函数  
- 	undefanl 	**...** 				[可选] 传递到目标函数的参数列表  

### OptionParameters

### Returns: 
-   function 							包装过的无参函数

--]]--
function zhandler(target, method, ... )
	local params = { ... }

	local function callBack()
		method(target, unpack(params))
	end

	return callBack
end
-- handler = zhandler

--[[--
运算[自增]

<br/>  
### Useage:
	进行自增操作。

### Notice:
	默认情况下，每次自增的步长为1。

### Parameters:
- 	float 	**value** 				[必选] 计算前的值  
- 	float 	**maxValue** 			[可选] 自增的最大值  
- 	float 	**defaultValue** 		[可选] 默认值  

### Returns: 
-   float 							计算后的值

--]]--
function increment(value, maxValue, defaultValue)
	value 	= value or defaultValue
	value 	= value + 1

	if maxValue and value > maxValue then 
		value = defaultValue or 0
	end
	return value
end

--[[--
运算[自减]

<br/>  
### Useage:
	进行自减操作。

### Notice:
	默认情况下，每次自减的步长为1。

### Parameters:
- 	float 	**value** 				[必选] 计算前的值  
- 	float 	**maxValue** 			[可选] 自减的最小值  
- 	float 	**defaultValue** 		[可选] 默认值  

### Returns: 
-   float 							计算后的值

--]]--
function decrement(value, mixValue, defaultValue)
	value 	= value or defaultValue
	value 	= value - 1

	if mixValue and value < mixValue then 
		value = defaultValue or 0 
	end
	return value
end 

--[[--
计算向量的模

<br/>  
### Useage:
	求向量的模长。

### Parameters:
- 	vector 	**vec** 				[必选] 向量  

### Returns: 
-   Number 							向量的模

--]]--
function vecLen(vec)
	assert(vec.x and vec.y, "args #1 is not a vector.")

 	return math.sqrt(vec.x ^ 2 + vec.y ^ 2)
end

--[[--
打印日志

<br/>  
### Useage:
	在控制台输出日志信息 

### Aliases:
	**CCLog**  
	**cclog**  

### Notice:
	参数格式和print()方法一样。

### Parameters:
- 	未知 	**...** 				[必选] 要打印的内容  

### Returns: 
-   nil

--]]--
function ccLog( ... )
	if DEBUG == 0 or RELEASE_MODE or (not DEBUG_FPS) then 
		return 
	end

	print("【CStudio debug log】 >>> :", ... )
end 
CCLog = ccLog 
cclog = ccLog

--[[--
引发错误

<br/>  
### Parameters:
- 	未知 	**...** 			[必选] 要显示的错误内容  

### Returns: 
-   void 						无返回值

--]]--
function zerror( ... )
	if RELEASE_MODE then return end 

 	print("----------------------------------")
 	print("ZERROR:", ... )
 	print("")
 	print(debug.traceback())
 	print("----------------------------------")
end 

--[[--
打印坐标

<br/>  
### Useage:
	打印一个坐标信息。

### Aliases:
	**printp**  
	**printP**  

### Notice:
	打印坐标的x, y。

### Parameters:
- 	CCPoint | ZPoint | number 	**x** 	[必选] 要打印的坐标对象或者x值。  
- 	number 						**y** 	[可选] 要打印的坐标的y值。  

### Returns: 
-   CCPoint 							打印的点对象

--]]--
function printPoint(x, y)
	if type(x) ~= "number" and x.y then 
		y, x = x.y, x.x 
	end

	local str = "ccp(" .. x .. ", " .. y .."), "
 	print(str)

 	return ccp(x, y), str 
end
printp = printPoint 
printP = printPoint 

--[[--
打印坐标

<br/>  
### Useage:
	打印坐标信息。

### Aliases:
	**printPInt**

### Notice:
	打印的坐标对应的值会被转成整数进行打印。

### Parameters:
- 	CCPoint | ZPoint | number 	**x** 	[必选] 要打印的坐标对象或者x值。  
- 	number 						**y** 	[可选] 要打印的坐标的y值。  

### Returns: 
-   CCPoint 							打印的点对象

--]]--
function printPointInt(x, y)
	if type(x) ~= "number" and x.y then 
		y, x = x.y, x.x 
	end
	
	return printPoint(math.floor(x), math.floor(y))
end

printPInt = printPointInt

--[[--
构造坐标

<br/>  
### Useage:
	用table构造一个Point类型。ccp(x, y)每次都要通过lua-bindings在C++上创建一个对象，对于性能不是很友好。

### Aliases:
	**zp**  
	**ZPoint**  
	**zPoint**  

### Notice:
	构造一个类似ccp()那样包含x, y两个属性的表结构。同时进行一些元方法的覆盖，方便开发。

### Example:

	local point = zp(100, 50)
	local pos 	= point + ccp(200, 220)
	print("p = ", pos.x, pos.y)
	D.img("gameplay/node.png"):p(pos:p()):to(self, 10) 

### Parameters:
- 	number | zpoint | CCPoint 	**x** 	[可选] 初始化zpoint的x值，或者用于初始化zpoint的坐标对象, 默认为0。  
- 	number  					**y** 	[可选] 初始化zpoint的y值, 默认为0。  

### Returns: 
-   zpoint 							返回自定义的点结构

--]]--
function zpoint(x, y)
	if type(x) ~= "number" and x.y then 
		y, x = x.y, x.x
	end

 	local point = {x = x or 0, y = y or 0}

 	point 		= M.extendZPoint(point)

 	return point 
end 
zp 		= zpoint
ZPoint 	= zpoint
zPoint 	= zpoint




--[[--
判断两个点是否相等

<br/>  
### Useage:
	用于判断两个坐标点是否相等。判断两个点的值是否相等，第三个参数为true的时候，除了值相等之外，还必须是同一个对象。

### Notice:
	ccp(x, y)构造的是C++上的CCPoint对象，属于引用类型。如果自己进行相等操作，不是同一个对象的会不相等。

### Parameters:
- 	CCPoint 	**p1** 				[必选] 第一个点  
- 	CCPoint 	**p2** 				[必选] 第二个点  
- 	boolean 	**isForce** 		[可选] 是否强等（值相等，且是同一个对象）  

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

--[[-
向量旋转  

<br/>  
### Useage:
  	将一个起点为原点的向量旋转一定角度后的终点坐标（目标向量）。    

### Aliases:
	**ccpRotateByAngle**  

### Notice:

	适用范围一定是向量的起点在坐标系原点的向量。如果不在原点，要先平移到原点。得到结果后再加上原先的起点值（平移回去）。   
	逆时针旋转角度为正角。

### Parameters:
- 	CCPoint 	**v** 						[必选] 向量终点坐标  
- 	CCPoint 	**angle** 					[必选] 旋转角度

### OptionParameters
	其它参数  

### Returns: 
-   CCPoint 							  

--]]
function vecRotateByAngle(v, angle)
 	local x, y 		= v.x, v.y  
 	-- 弧度
 	local a 		= math.rad(angle)

 	return ccp(x * math.cos(a) - y * math.sin(a), x * math.sin(a) + y * math.cos(a))
end
ccpRotateByAngle 	= vecRotateByAngle









--------------------------
--  重写
--------------------------








--------------------------
--  扩展
--------------------------

--[[--
拓展[ZPoint]

<br/>  
### Useage:
	对zpoint构造的表进行拓展。

### Aliases:

### Notice:
	对{x = 100, y = -20} 结构进行相关功能的拓展。实现运算符重载等功能。

### Example:

	local ZFunction = import("app.common.tools.ZFunction")
	local point 	= ZFunction.extendZPoint({x = 100, y = -20})
	print("point = ", point.x, point.y)

### Parameters:
- 	zpoint 	**p** 				[必选] {x = 100, y = -20}形式的表  

### Returns: 
-   zpoint 						进行相关拓展 

--]]--
function M.extendZPoint(p)
	-- 创建元表
 	local meta = {
 		-- 加法运行
 		__add = function(a, b)
	 		return zpoint(a.x + b.x, a.y + b.y)
	 	end,
	 	-- 减法运算
	 	__sub = function(a, b)
	 		return zpoint(a.x - b.x, a.y - b.y)
	 	end,
	 	-- 乘法运算
	 	__mul = function(a, b)
	 		return zpoint(a.x * b.x, a.y * b.y)
	 	end,
	 	-- 除法运算
	 	__div = function(a, b)
	 		return zpoint(a.x / b.x, a.y / b.y)
	 	end,
	 	-- 取余运算
	 	__mod = function(a, b)
	 		return zpoint(a.x % b.x, a.y % b.y)
	 	end,
	 	-- 负值运算
	 	__unm = function(a)
	 		return zpoint(-a.x, -a.y)
	 	end
	 }

	-- 设置元表
 	setmetatable(p, meta)

 	-- 转换成CCPoint类型
 	function p:ccp(x, y)
 		if x and x.y then 
 			y, x = x.y, x.x
 		end

 		if x and y then 
 			self.x, self.y = x, y
 		end

 		return ccp(self.x, self.y)
 	end 

 	p.toCCPoint = p.ccp 
 	p.p 		= p.ccp 

 	-- 获取向量模长
 	function p:len() return math.sqrt(p.x * p.x + p.y * p.y) end
 	-- 获取向量的单位向量
 	function p:unit() return zpoint(self.x / self:len(), self.y / self:len()) end

 	return p 
end 

--[[--
判断是否点击在指定区域内部

<br/>  
### Useage:
	用于判定某个点是否在指定的区域内部

### Aliases:
	**ZTools.isTouchInRect**  

### Notice:
	只能用于判断矩形区域。

### Parameters:
- 	CCRect 	**rect** 				[必选] 指定的区域  
- 	CCRect 	**x** 					[必选] 指定的x坐标  
- 	CCRect 	**y** 					[必选] 指定的y坐标  

### Returns: 
-   bool 							点是否在区域内

--]]--
function TH.isTouchInRect(rect, x, y)
	if x < rect[1] or x > rect[1] + rect[3] or y < rect[2] or y > rect[2] + rect[4] then 
		return false  
	end

	return true  
end

ZTools 					= ZTools or {} 
ZTools.isTouchInRect  	= TH.isTouchInRect


--[[-
创建区域裁切对象  

<br/>  
### Useage:
  	创建一个矩形的裁切区域。

### Aliases:
	**D.newClippingRegionNode**

### Notice:
	覆盖了display.newClippingRegionNode的实现。

### Parameters:
- 	CCRect 	**rect** 				[必选] 区域    

### Returns: 
-   CCClippingRegionNode 			区域裁切节点

--]]
function display.newClippingRegionNode(rect)
    return CCNodeExtend.extend(CCClippingRegionNode:create(rect))
end

D.newClippingRegionNode = display.newClippingRegionNode








--[[--
构造[返回一个泛型集合对象]

<br/>  
### Useage:
	构造一个带有类型验证的集合对象，类型可以使用lua的type()函数进行实例化。

### Aliases:
	**zList**  
	**zlist**  

### Notice:
	参数必须是Lua类型。

### Example:

	--------------
	案例一：
	--------------
	local t 		= type(1)
	local numbers 	= newList(t)

	numbers:add(100)
	print(numbers:get(1))

### Parameters:
- 	type 	**T** 				[可选] 集合中项的类型  

### OptionParameters

	LUA_TYPE_NUMBER 	: 数值类型
	LUA_TYPE_BOOL 		: 布尔类型
	LUA_TYPE_BOOLEAN 	: 布尔类型
	LUA_TYPE_STRING 	: 字符串类型
	LUA_TYPE_TABLE 		: 表类型
	LUA_TYPE_USERDATA 	: 用户类型

### Returns: 
-   List<T> 					泛型集合

--]]--
function newList(T)
	local result 	= {}
	result.values 	= {}
	result.type 	= T

	function result:add(obj)
		if self.type then 
			local objType 	= type(obj)
			local msg 		= "The operation failed, unable to insert a "
				.. objType .." type object into a collection of ".. self.type.."."
			
			assert(objType == self.type, msg)
		end

		table.insert(self.values, obj)
	end

	function result:remove(obj) T.remove(self.values, obj) end

	function result:get(index)
		assert(index <= #self.values and index > 0, "The index is out of bounds.")

		return self.values[index]
	end

	return result 
end 


LUA_TYPE_NUMBER 	= type(1)
LUA_TYPE_BOOL 		= type(true)
LUA_TYPE_STRING 	= type("string")
LUA_TYPE_TABLE 		= type({})
LUA_TYPE_USERDATA 	= "userdata"
LUA_TYPE_N 			= LUA_TYPE_NUMBER
LUA_TYPE_BOOLEAN 	= LUA_TYPE_BOOL
LUA_TYPE_B 			= LUA_TYPE_BOOL
LUA_TYPE_STR 		= LUA_TYPE_STRING
LUA_TYPE_S 			= LUA_TYPE_STRING
LUA_TYPE_T 	 		= LUA_TYPE_TABLE
zList = newList
zlist = newList 


--[[--
构造[返回一个泛型字典对象]

<br/>  
### Useage:
	构造一个带有类型验证的字典对象，类型可以使用lua的type()函数进行实例化。

### Aliases:
	**zDictionary** 
	**zdictionary** 
	**zMap** 
	**zmap** 
	**zDic** 
	**zdic** 

### Notice:
	参数必须是Lua类型。

### Example:

	--------------
	案例一：
	--------------
	local t 		= type(1)
	local numbers 	= newDictionary(t)

	numbers:add(100)
	print(numbers:get(100))

### Parameters:
- 	type 	**T** 				[可选] 集合中项的类型  

### OptionParameters
	LUA_TYPE_NUMBER 	: 数值类型
	LUA_TYPE_BOOL 		: 布尔类型
	LUA_TYPE_BOOLEAN 	: 布尔类型
	LUA_TYPE_STRING 	: 字符串类型
	LUA_TYPE_TABLE 		: 表类型
	LUA_TYPE_USERDATA 	: 用户类型

### Returns: 
-   List<T> 					泛型字典

--]]--
function newDictionary(T)
	local result 	= {}
	result.values 	= {}
	result.type 	= T

	function result:add(obj)
		if self.type then 
			local objType 	= obj.type or type(obj)
			local msg 		= "The operation failed, unable to insert a "
				.. objType .." type of object into a ".. self.type .." type of dictionary."
			
			assert(objType == self.type, msg)
		end
		self.values[obj.name or obj.type] = obj
	end

	function result:remove(objName) 
		if type(objName) == "string" and self.values[objName] then 
			if self.values[objName].remove then 
				self.values[objName]:remove()
			end
			self.values[objName] = nil 
		else
			T.remove(self.values, objName) 
		end
	end

	function result:get(objName)
		local component = self.values[objName]

		-- assert(component, "Object does not exist.")
		if not component then 
			return zerror("Object does not exist.")
		end

		return component
	end

	return result 
end 

zDictionary = newDictionary
zdictionary = newDictionary 
zMap = newDictionary
zmap = newDictionary 
zDic = newDictionary
zdic = newDictionary 


--[[--
将C++的Array数组对象转换层table对象

<br/>  
### Notice:
	Array类型在lua上没有实现。

### Parameters:
- 	Array 	**arr** 				[必选] 数组对象  

### Returns: 
-   table 							table对象

--]]--
function arrayToTable(arr)
	local result = {}

 	for i = 0, arr:count() - 1 do
 		table.insert(result, arr:objectAtIndex(i))
 	end

 	return result 
end

--[[--
字典类型转换成table

<br/>  
### Useage:
	将字典类型里面的key-value转换成table保存

### Notice:
	CCDictionary类型是C++类型，在lua上使用不方便。

### Parameters:
- 	CCDictionary 	**dictionary** 	[必选] CCDictionary字典对象  

### Returns: 
-   table 							字典

--]]--
function dictionaryToTable(dictionary)
 	local result = {}

	-- 获取CCDictionary对象里面的所有key
 	local allKeys = dictionary:allKeys()

 	-- 根据keys获取所有的value添加到table表中
 	for i = 0, allKeys:count() - 1 do 
 		local keyString 	= allKeys:objectAtIndex(i):getCString()
 		result[keyString] 	= dictionary:objectForKey(keyString) --:getCString()
 	end

 	return result
end 


--[[--
字符串分割函数

<br/>  
### Useage:
	进行字符串的切割

### Aliases:
	**splitString**  

### Notice:
	传入字符串和分隔符，返回分割后的table

### Parameters:
- 	string 	**str** 				[必选] 要切割的字符串  
- 	string 	**delimiter** 			[必选] 分隔符  

### Returns: 
-   table 							切割结果

--]]--
function splitStr(str, delimiter)
	if str == nil or str == '' or delimiter == nil then
		return nil
	end
	
    local result = {}

    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    
    return result
end

splitString = splitStr








--------------------------
--  平台
--------------------------

--[[-
是否是低端iOS设备  

<br/>  
### Useage:
  	用于判断当前设备是否是低端iOS设备。  

### Notice:
	只对iOS平台有效。  

### Returns: 
-   boolean 							是否是低端iOS设备  

--]]
function isLimiteDevice()
	local deviceInfo    = NV.getDeviceInfo()
    local version       = deviceInfo.version 

    -- iphone4/4s
	if version == "iPhone3,1" or version == "iPod4,1" or 
        -- iPod Touch
        version == "iPod1,1" or version == "iPod2,1" or version == "iPod3,1" or 
        version == "iPod4,1" or version == "iPod5,1" or 
        -- iPad mini 1
        version == "iPad2,5" or version == "iPad2,6" or version == "iPad2,7" then
        return true 
    end
end








--------------------------
--  Umeng
--------------------------

--[[--
获取用户年龄字符串

<br/>  
### Useage:
	获取家长中心里面填写的用户出生日期，计算用于年龄。

### Notice:
	一般在Umeng分年龄采集中使用。

### Returns: 
-   string 							获取用户的年龄

--]]--
function getAgeString()
	-- 没有填写年龄
	if type(KEY_BABY_AGE) ~= "number" then 
		return "null"
	end

	-- 计算当前年份和小宝宝出生年份的差值
	local age = os.date("*t").year - KEY_BABY_AGE
	
	if age < 1 then 
		return "0-1周岁"
	elseif age < 2 then 
		return "1-2周岁"
	elseif age < 3 then 
		return "2-3周岁"
	elseif age < 4 then 
		return "3-4周岁"
	elseif age < 5 then 
		return "4-5周岁"
	elseif age < 6 then 
		return "5-6周岁"
	else
		return "6+周岁"
	end
end 



--[[--
发送Umeng数据

<br/>  
### Notice:
	扩展框架实现

### Parameters:
- 	string 		**eventKey** 				[必选] Umeng事件ID  
- 	boolean 	**isFirstSend** 			[可选] 是否只记录首次  

### Returns: 
-   nil 							

--]]--
DA 			= DA or {}
function DA.sendEventByAge(eventKey, isFirstSend)
	-- 个人全局数据
	ZBS_G_INFO 	= ZBS_G_INFO or {}

	-- 是否只发送首次
	if isFirstSend then 
		-- 是否发送过
		if ZBS_G_INFO[eventKey] then 
			return 
		else
			ZBS_G_INFO[eventKey] = true 
		end
	end

	-- 发送数据
	DA.sendEvent(eventKey, getAgeString())
end










return M 



