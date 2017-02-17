--[[--------------------------
[csu]瓦片地图工具类

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	工具类[TiledMap瓦片地图]
	- Author: 	zengbinsi
	- Date: 	2015-07-07  

--]]--------------------------  







--[[
	静态类[所有函数通过类对象调用]
--]]


local M 	= {}
M.TAG 		= "ZTiledMap"









--------------------------
-- CCTMXTiledMap
--------------------------

--[[--
创建瓦片地图对象

<br/>  
### Useage:
	创建一个瓦片地图的对象。

### Notice:
	瓦片地图也是一个节点。

### Example:

	local map 	= ZTiledMap.createTiledMap("tiledmap/map.tmx"):p(0, 0):to(self, -100)

### Parameters:
- 	String 		**tmxFilePath** 		[必选] 瓦片地图文件路径  
- 	CCPoint 	**position** 			[可选] 瓦片地图坐标  
- 	CCPoint 	**anchorPoint** 		[可选] 瓦片地图锚点  
- 	CCNode 		**parentNode** 			[可选] 瓦片地图父节点  
- 	int 		**level** 				[可选] 瓦片地图层级  

### Returns: 
-   CCTMXTiledMap 							瓦片地图对象

--]]--
function M.createTiledMap(tmxFilePath, position, anchorPoint)
	-- 创建瓦片地图对象
	local node 	= CCTMXTiledMap:create(tmxFilePath)

	assert(node ~= nil, "in function createTiledMap, create TiledMap Error!")

	-- 拓展节点
	CCNodeExtend.extend(node)
	M.extendMap(node)

	-- 设置地图坐标
	node:p(position or ccp(0, 0))
	-- 设置地图锚点
 	node:anchor(anchorPoint or ccp(0, 0))

 	return node 
end 

--[[--
拓展节点

<br/>  
### Useage:
	对CCTMXTiledMap类型的对象添加新的方法。

### Parameters:
- 	CCTMXTiledMap 	**map** 				[必选] 瓦片地图对象  

--]]--
function M.extendMap(map)
	assert(map ~= nil, "in function extendMap, args #1 'map'(is nil value).")

	-- 获取图层对象
	function map:getLayer(layerName)
		local layer = map:layerNamed(layerName)

		if not layer then 
			layer = map:objectGroupNamed(layerName)
		end

		-- 重写 CCTMXObjectGroup/CCTMXLayer 的 getProperties()方法
		M.overrideGetProperties(layer) 

		return layer 
	end

	-- 重写 CCTMXTiledMap 的 getProperties() 方法
	M.overrideGetProperties(map) 
end

--[[--
重写对象的getProperties方法

<br/>  
### Useage:
	覆盖对象的getProperties()方法，将结果转为table后再返回。

### Notice:
	getProperties()方法返回的结果是CCDictionary类型。使用不方便。

### Parameters:
- 	CCObject 	**node** 				[必选] 要被重写方法的对象  

--]]--
function M.overrideGetProperties(node)
	if not node then return end

	-- 保留原先的getProperties功能。
	node.getAttributs = node.getProperties

	-- 定制新的getProperties，获取地图对象的所有属性信息
	function node:getProperties()
		-- 获取地图对象的所有属性CCDictionary 
		local properties 	= self:getAttributs()

		return M.dictionaryToTable(properties), properties
	end
end 

--[[--
获取瓦片地图的大小（瓦片数）

<br/>  
### Useage:
	获取瓦片地图的尺寸。

### Notice:
	瓦片地图尺寸是以块为单位的，并非像素。

### Example:

	local map 	= ZTiledMap.createTiledMap("tiledmap/map.tmx"):p(0, 0):to(self, -100)
	local size 	= ZTiledMap.getMapSize(map)
	print("size = ", size.width, size.height)

### Parameters:
- 	CCTMXTiledMap 	**map** 				[必选] 瓦片地图对象  

### Returns: 
-   CCSize 							地图的瓦片数量

--]]--
function M.getMapSize(map)
	return map:getMapSize()
end

--[[--
设置地图大小[瓦片数]

<br/>  
### Useage:
	设置地图大小的尺寸。

### Notice:
	瓦片地图尺寸是以块为单位的，并非像素。

### Parameters:
- 	CCTMXTiledMap 	**map** 				[必选] 瓦片地图对象  
- 	CCSize 			**size** 				[必选] 瓦片地图对象的大小  

--]]--
function M.setMapSize(map, size)
	map:setMapSize(size)
end 

--[[--
获取整个瓦片地图的像素尺寸

<br/>  
### Useage:
	得到瓦片地图对象的像素尺寸

### Notice:
	瓦片地图尺寸是以块为单位的，并非像素。这里将地图尺寸再乘以没块瓦片的像素尺寸。

### Example:

	local map 	= ZTiledMap.createTiledMap("tiledmap/map.tmx"):p(0, 0):to(self, -100)
	local size 	= ZTiledMap.getMapSizeAP(map)
	print("size = ", size.width, size.height)

### Parameters:
- 	CCTMXTiledMap 	**map** 				[必选] 瓦片地图对象  

### Returns: 
-   CCSize 							整个瓦片地图的像素尺寸

--]]--
function M.getMapSizeAP(map)
	local mapSize 	= M.getMapSize(map)
	local tileSize 	= M.getTileSize(map)

	return CCSize(mapSize.width * tileSize.width, mapSize.height * tileSize.height)
end

--[[--
获取单个瓦片尺寸

<br/>  
### Useage:
	获取单个瓦片像素尺寸。

### Aliases:

### Notice:
	瓦片的尺寸是以像素为单位的。

### Example:

	local map 	= ZTiledMap.createTiledMap("tiledmap/map.tmx"):p(0, 0):to(self, -100)
	local size 	= ZTiledMap.getTileSize(map)
	print("size = ", size.width, size.height)

### Parameters:
- 	CCTMXTiledMap 	**map** 				[必选] 瓦片地图对象  

### Returns: 
-   CCSize 							当个瓦片的像素尺寸

--]]--
function M.getTileSize(map)
	return map:getTileSize() 
end

--[[--
设置单个瓦片尺寸

<br/>  
### Useage:
	设置单个瓦片像素尺寸。

### Notice:
	瓦片的尺寸是以像素为单位的。

### Parameters:
- 	CCTMXTiledMap 	**map** 				[必选] 瓦片地图对象  
- 	CCSize 			**size** 				[必选] 瓦片对象的大小  

--]]--
function M.setTileSize(map, size)
	map:setTileSize(size) 
end

--[[--
获得对象（物体）层中所有的对象信息

<br/>  
### Useage:
	返回对象层中所有对象的信息列表

### Notice:
	对象层上面包含多个对象。

### Parameters:
- 	CCTMXTiledMap 	**map** 			[必选] 瓦片地图对象  

### Returns: 
-   CCArray 							对象层中所有对象的信息列表

--]]--
function M.getObjectGroups(map)
	return map:getObjectGroups() 
end 

--[[--
设置对象（物体）层的容器

<br/>  
### Useage:
	设置对象（物体）层的容器

### Parameters:
- 	CCTMXTiledMap 	**map** 			[必选] 瓦片地图对象  
- 	CCArray 		**objs** 			[必选] 作为对象层的父节点  

--]]--
function M.setObjectGroups(map, objs)
	map:setObjectGroups(objs)
end 

--[[--
获得地图或者图层的属性

<br/>  
### Useage:
	获取对象的所有属性。

### Notice:
	只能获取瓦片地图、图层、图块和对象的实例对象属性。

### Parameters:
- 	CCObject 	**node** 		[必选] 瓦片地图或者图层对象  

### Returns: 
-   table 							属性表
-   CCDictionary 					地图属性字典

--]]--
function M.getProperties(node)
	-- 获取地图对象的所有属性
	return node:getProperties()
end

--[[--
设置地图或者图层的属性

<br/>  
### Useage:
	设置地图或者图层的属性

### Notice:
	直接设置到C++的字典中。

### Parameters:
- 	CCObject 		**node** 			[必选] 瓦片地图或者图层对象  
- 	CCDictionary 	**properties** 		[必选] 地图属性字典  

--]]--
function M.setProperties(node, properties)
	node:setProperties(properties)
end 

--[[--
获得图层对象/对象层对象

<br/>  
### Useage:
	根据层名称获得图层对象/对象层对象

### Aliases:
	**layerNamed**  
	**objectGroupNamed**  

### Notice:
	这个函数会优先查找地图的普通层（CCTMXLayer），找到就返回。否则会遍历对象层（CCTMXObjectGroup）。都没有找到返回nil。

### Example:

	local map 		= ZTiledMap.createTiledMap("tiledmap/map.tmx"):p(0, 0):to(self, -100)
	local layer 	= ZTiledMap.getLayer(map, "objsLayer")
	print("layer = ", layer) 	-- 打印userdata

### Parameters:
- 	CCTMXTiledMap 	**map** 				[必选] 瓦片地图对象  
- 	String 			**layerName** 			[必选] 图层名称  

### Returns: 
-   CCTMXLayer/CCTMXObjectGroup 			地图层（组）

--]]--
function M.getLayer(map, layerName)
	return map:getLayer(layerName)
end 
M.layerNamed 		= M.getLayer
M.objectGroupNamed 	= M.getLayer

--[[--
获得属性值

<br/>  
### Useage:
	根据属性的名字,来获得属性值

### Aliases:
	**getPropertyForName**

### Notice:
	结果为字符串类型

### Parameters:
- 	CCObject 		**node** 				[必选] 瓦片地图对象/图层对象/对象层对象  
- 	String 			**propertyName** 		[必选] 属性的名字  

### Returns: 
-   string 									属性的值 

--]]--
function M.propertyNamed(node, propertyName)
	return node:propertyNamed(propertyName):getCString() 
end 

M.getPropertyForName 	= M.propertyNamed 

--[[--
获得图块的属性字典

<br/>  
### Useage:
	根据GID,获得图块的属性字典

### Notice:
	属性都是CCDictionary，这里会将其转成table。

### Parameters:
- 	CCTMXTiledMap 	**map** 				[必选] 瓦片地图对象  
- 	int 			**gID** 				[必选] 全局编号  

### Returns: 
-   table 									图块属性集合
-   CCDictionary 							图块属性字典

--]]--
function M.propertiesForGID(map, gID)
	local properties 	= map:propertiesForGID(gID)
	return M.dictionaryToTable(properties), properties
end








--------------------------
-- CCTMXLayer
--------------------------

--[[--
返回图层尺寸的大小(瓦片数)

<br/>  
### Parameters:
- 	CCTMXLayer 	**layer** 			[必选] 图层   

### OptionParameters

### Returns: 
-   CCSize 							图层尺寸的大小

--]]--
function M.getLayerSize(layer)
	return layer:getLayerSize() 
end

--[[--
设置图层尺寸的大小（瓦片数）

<br/>  
### Parameters:
- 	CCTMXLayer 	**layer** 			[必选] 图层   
- 	CCSize 		**size** 			[必选] 尺寸大小   

### Returns: 
-   nil 

--]]--
function M.setLayerSize(layer, size)
	layer:setLayerSize(size) 
end

--[[--
返回瓦片（砖块）尺寸的大小（像素）

<br/>  
### Parameters:
- 	CCTMXLayer 	**layer** 			[必选] 图层   

### Returns: 
-   CCSize 							瓦片尺寸的大小

--]]--
function M.getMapTileSize(layer)
	return layer:getMapTileSize() 
end

--[[--
设置瓦片（砖块）尺寸的大小（像素）

<br/>  
### Parameters:
- 	CCTMXLayer 	**layer** 			[必选] 图层   
- 	CCSize 		**size** 			[必选] 尺寸大小   

### Returns: 
-   nil

--]]--
function M.setMapTileSize(layer)
	layer:setMapTileSize() 
end 

--[[--
释放图层中砖块的拼接信息

<br/>  
### Parameters:
- 	CCTMXLayer 			**layer** 			[必选] 图层   

--]]--
function M.releaseMap(layer)
	layer:releaseMap() 
end

--[[--
返回指定位置的瓦片精灵对象

<br/>  
### Useage:
	返回指定位置的瓦片精灵对象

### Aliases:
	**getTileSprite**

### Example:

	self.map 			= ZTiledMap.createTiledMap("DesertMap_1.tmx"):p(0, 0):to(self, -100)
	local bg 			= ZTiledMap.getLayer(self.map, "background")
	local tileSprite 	= ZTiledMap.tileAt(bg, ccp(0, 1))

 	tileSprite:setVisible(false)

### Parameters:
- 	CCTMXLayer 			**layer** 			[必选] 图层   
- 	CCPoint 			**position** 		[必选] 地图上的瓦片的地图位置坐标  

### Returns: 
-   CCSprite 								地图上的瓦片对象 

--]]--
function M.tileAt(layer, position)
	return layer:tileAt(position)
end

M.getTileSprite = M.tileAt

--[[--
返回指定位置图块对象的ID

<br/>  
### Useage:
	返回指定位置图块对象的ID

### Aliases:
	**getTileGID**

### Parameters:
- 	CCTMXLayer 			**layer** 			[必选] 图层   
- 	CCPoint 			**position** 		[必选] 地图上瓦片的地图位置坐标  

### Returns: 
-   int 									图块对象的ID（这里是图块不是瓦片）

--]]--
function M.tileGIDAt(layer, position)
	return layer:tileGIDAt(position)
end

M.getTileGID = M.tileGIDAt

--[[--
设置指定位置砖块对象的ID

<br/>  
### Parameters:
- 	CCTMXLayer 			**layer** 			[必选] 图层   
- 	int 				**gID** 			[必选] 全局ID   
- 	CCPoint 			**position** 		[必选] 位置坐标  

--]]--
function M.setTileGID(layer, gID, position)
	layer:setTileGID(gID, position)
end

--[[-
移除指定位置砖块对象

<br/>  
### Useage:
  	用途  

### Aliases:
	**removeTile**  

### Parameters:
- 	CCTMXLayer 			**layer** 			[必选] 图层   
- 	CCPoint 			**position** 		[必选] 瓦片在地图上的位置坐标（瓦片数）  

### Returns: 
-   返回值类型 							返回值说明  

--]]
function M.removeTileAt(layer, position)
	layer:removeTileAt(position)
end

M.removeTile = M.removeTileAt 

--[[--
返回指定瓦片左下角的cocos2d坐标

<br/>  
### Aliases:
	**convertToSceneSpace**  

### Notice:
	self.map 	= ZTiledMap.createTiledMap("DesertMap_1.tmx"):p(0, 0):to(self, -100)
 	local bg 	= self.map:getLayer("background")
 	local p 	= bg:positionAt(ccp(0, 0))
	
 	print(p.x, p.y)

### Example:

### Parameters:
- 	CCTMXLayer 			**layer** 			[必选] 图层   
- 	CCPoint 			**position** 		[必选] 瓦片在地图上的位置坐标（瓦片数）  

### Returns: 
-   CCPoint 								瓦片左下角对应的cocos2d坐标 

--]]--
function M.positionAt(layer, position)
	return layer:positionAt(position) 
end

M.convertToSceneSpace = M.positionAt

--[[--
得到图层的名字

<br/>  
### Parameters:
- 	CCTMXLayer 			**layer** 			[必选] 图层   

### Returns: 
-   String 									图层的名字

--]]--
function M.getLayerName(layer)
	return layer:getLayerName()
end









--------------------------
-- CCTMXObjectGroup
-------------------------- 

--[[--
根据对象名从对象层里面获取对象

<br/>  
### Useage:
	根据对象名从对象层里面获取对象


### Example:

	local dictionary  = ZTiledMap.getObjectByObjName(objLayer, name)
	dump(dictionary)

### Parameters:
- 	CCTMXObjectGroup 	**objLayer** 	[必性] 对象层对象
- 	String 				**name** 		[必性] 对象名 

### Returns: 
-   table 								对象表
-   CCDictionary 						对象信息对象[字典]

--]]--
function M.getObjectByObjName(objLayer, name)
	local dic = objLayer:objectNamed(name)

	if not dic then return end  

	return M.dictionaryToTable(dic), dic
end

--[[--
根据key获取对象的值

<br/>  
### Useage:
	根据key获取对象的值

### Notice:
	返回值的类型根据数值来判断

### Example:
	
	local value = ZTiledMap.getValueForKey(self.obj, "SpawnPoint")
	print("value")

### Parameters:
- 	CCDictionary 	**dict** 				[必选] 对象信息字典  
- 	String 			**key** 				[必选] 属性key值  
- 	String 			**valueType** 			[可选] 属性value值类型  

### Returns: 
-   valueType 								返回key对应的值 

--]]--
function M.getValueForKey(dict, key, valueType)
	valueType 	= string.lower(valueType or "int")

	if valueType == "float" or valueType == "f" then 
		return dict:valueForKey(key):floatValue()
	elseif valueType == "bool" or valueType == "boolean" or valueType == "b" then  
		return dict:valueForKey(key):boolValue()
	else
		return dict:valueForKey(key):intValue()
	end
end 









--========================
-- 功能方法
--======================== 

--[[--
字典类型转换成table

<br/>  
### Useage:
	将字典类型里面的key-value转换层table保存

### Parameters:
- 	CCDictionary 	**dictionary** 	[必选] CCDictionary字典对象  

### Returns: 
-   table 							字典

--]]--
function M.dictionaryToTable(dictionary)
 	local result = {}

	-- 获取CCDictionary对象里面的所有key
 	local allKeys = dictionary:allKeys()

 	-- 根据keys获取所有的value添加到table表中
 	for i = 0, allKeys:count() - 1 do 
 		local keyString 	= allKeys:objectAtIndex(i):getCString()
 		result[keyString] 	= dictionary:objectForKey(keyString):getCString()
 	end

 	return result
end

--[[--
开启地图跟随

<br/>  
### Useage:
	实现节点根据另一个节点聚焦让那个节点始终在屏幕中。

### Notice:
	由于已经有CCFollow的action了，这个方法弃用。

### Parameters:
- 	CCTMXTiledMap 	**map** 			[必选] 瓦片地图对象  
- 	CCTNode 		**node** 			[必选] 跟随的节点  

--]]--
function M.openFollow(map, node)
	map.actionFollow 	= A.cycle({
		{"fn", function()
		  	M.setViewpointCenter(map, ccp(node:getPosition()))
		 end},
		 {"delay", 1.0 / 60}, 
		})

	map:runAction(map.actionFollow)
end

--[[--
关闭地图跟随

<br/>  
### Parameters:
- 	CCTMXTiledMap 	**map** 			[必选] 瓦片地图对象  

--]]--
function M.closeFollow(map)
	if map and map.actionFollow then 
		map:stopAction(map.actionFollow)
	end
end

--[[--
设置屏幕中心点

<br/>  
### Parameters:
- 	CCTMXTiledMap 	**map** 				[必选] 瓦片地图对象  
- 	CCPoint 		**position** 			[必选] 跟随对象的坐标  

--]]--
function M.setViewpointCenter(map, position)
	--  求出屏幕的范围包括宽和高
	local winSize 	= CCDirector:sharedDirector():getWinSize()
	-- 显示屏幕中心点的坐标大于屏幕宽和高的一半
	local x 		= math.max(position.x, winSize.width / 2)
	local y 		= math.max(position.y, winSize.height / 2)
	 
	-- 求出的是整个瓦片地图的宽
	local mapSizeAP 	= M.getMapSizeAP(map)
	local mapWidth 		= mapSizeAP.width 
	local mapHeight 	= mapSizeAP.height
	 
	x = math.min(x, mapWidth- winSize.width / 2)
	y = math.min(y, mapHeight - winSize.height / 2)
	 
	-- 目标点
	local actualPoint 		= ccp(x, y)
	 
	-- 屏幕的中心点
	local viewCenterPoint 	= ccp(winSize.width / 2,winSize.height / 2)
	-- 计算出重置显示屏幕的中心点
	local viewPoint 		= ccp(viewCenterPoint.x - actualPoint.x, viewCenterPoint.y - actualPoint.y)
	-- 重置显示屏幕的中心点
	map:setPosition(viewPoint)
end

--[[--
根据坐标集合移动到指定位置

<br/>  
### Useage:
	根据坐标集合移动到指定位置

### Notice:
	一次移动到指定的坐标。

### Example:

	self.node 	= D.img("node.png"):pc():to(self)
	local pathPoints 	= {ccp(657, 78),ccp(658, 109),ccp(879, 112),ccp(882, 303),ccp(690, 301),ccp(690, 208),ccp(657, 208),
		ccp(657, 175),ccp(530, 176),ccp(526, 204),ccp(367, 208),ccp(367, 270),ccp(401, 272),ccp(398, 333),ccp(370, 334),
		ccp(368, 429),ccp(241, 435),ccp(243, 402),ccp(208, 401),ccp(205, 176),ccp(50, 176),ccp(50, 557),ccp(909, 556),
		ccp(911, 400),ccp(530, 398),ccp(528, 431),}

	ZTiledMap.pathTo(pathPoints, 10, self.node, function()
		print("x, y = ", self.node:getPosition())
	end, function()
		self.node:remove() 
	end)

### Parameters:
- 	Table 		**pathPoints** 				[必选] 路径点集合  
- 	float 		**time** 					[必选] 持续时间  
- 	CCNode 		**node** 					[必选] 运动的节点对象  
- 	function 	**callBack** 				[可选] 到达每个路径点的回调  
- 	function 	**endCallBack** 			[可选] 动作结束的回调  

### Returns: 
-   CCAction 								动作对象

--]]--
function M.pathTo(pathPoints, time, node, callBack, endCallBack)
	table.insert(pathPoints, 1, ccp(node:getPosition()))

	-- 计算每段路径的长度
	local distances 	= M.getSumDistance(pathPoints)

	table.remove(pathPoints, 1)

	-- 计算总路径长度
	local sumDistance 	= 0

	for i, distance in ipairs(distances) do
		sumDistance 	= sumDistance + distance 
	end

	-- 计算每段路径的时间
	local times 		= {} 	

	for i, distance in ipairs(distances) do
		table.insert(times, time * (distance / sumDistance))
	end

	-- 生成动作配置信息表 
	local actionInfo 	= {}

	for i, point in ipairs(pathPoints) do
		table.insert(actionInfo, {"moveTo", times[i], point})
		if callBack then table.insert(actionInfo, {"fn", callBack}) end 
	end
	if endCallBack then table.insert(actionInfo, {"fn", endCallBack}) end 
	
	-- 运行动作
	node.actionPathTo = A.line(actionInfo)

	node:runAction(node.actionPathTo)

	return node.actionPathTo 
end

--[[--
计算点集合中两点间的距离之和

<br/>  
### Useage:
	计算点集合中两点间的距离之和

### Aliases:

### Notice:
	依次遍历所有连线，计算距离之和。

### Example:
	
	local distances 	= ZTiledMap.getSumDistance(pathPoints)
	dump(distances)

### Parameters:
- 	table 	**pathPoints** 				[必选] 路径点集合  

### Returns: 
-   number 							路径长度

--]]--
function M.getSumDistance(pathPoints)
	local results 	= {}

	for i = 1, #pathPoints - 1 do 
		local distance 	= PT.distance(pathPoints[i].x, pathPoints[i].y, pathPoints[i + 1].x, pathPoints[i + 1].y)

		table.insert(results, distance)
	end

	return results
end 

--[[-
将像素坐标转换成TiledMap坐标。  

<br/>  
### Useage:
  	将像素坐标转换成TiledMap坐标。  

### Aliases:
	**convertToMapSpace**  

### Notice:
	
	坐标如果不是TiledMap的节点坐标应该进行转换，除非TiledMap坐标和转换前的一致。坐标索引从0开始。原点在左上角。   
	坐标索引从0开始，瓦片地图坐标矩阵如下：
	(0, 0), (1, 0), (2, 0), (3, 0), 
	(0, 1), (1, 1), (2, 1), (3, 1), 
	(0, 2), (1, 2), (2, 2), (3, 2), 

### Example:
	
	local mapNodePoint 	= map:convertToNodeSpace(worldPoint)
	local mapPoint 		= ZTiledMap.convertToTileSpace(map, mapNodePoint)
	print("x = ", mapPoint.x, ", y = ", mapPoint.y)    


### Parameters:
- 	CCTMXTiledMap 	**map** 				[必选] 瓦片地图对象    
- 	CCPoint 		**position** 			[必选] TiledMap中的OpenGL坐标   

### OptionParameters
	其它参数  

### Returns: 
-   CCPoint 						返回TiledMap的坐标  

--]]
function M.convertToTileSpace(map, position)
	-- 将坐标的x轴坐标转换成瓦片地图中的x轴的坐标
	local x 			= math.floor(position.x / map:getTileSize().width)
	-- 将坐标的y轴坐标转换成瓦片地图中的y轴的坐标(TiledMap原点在左上角，所以Y向下为正，所以这边要换算)
	local tileHeight 	= map:getTileSize().height
	local y 			= math.floor(((map:getMapSize().height * tileHeight) - position.y) / tileHeight)

	return ccp(x, y)
end 

M.convertToMapSpace = M.convertToTileSpace 









--========================
-- 属性
--========================









--========================
-- 父类重写
--========================




return M






