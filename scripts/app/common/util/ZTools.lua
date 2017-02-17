--[[--------------------------
[csu]常用操作封装

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	定义公共操作
	- Author: 	zengbinsi
	- Date: 	2015-07-09 

--]]--------------------------  







--[[
	类
--]]


local M 	= {}
M.TAG 		= "ZTools"




--========================
-- 功能方法
--========================   

--[[--
类型转换

<br/>  
### Useage:
	将一个保存有“CCPoint”类型对象的table转换成box2D使用的“b2Vec2*”类型的数组

### Notice:
	解决lua无法构建b2Vec2数组类型的问题，用于box2D多边形顶点的指定。

### Example:

	-------------------
	-- 案例一
	-------------------
	local points 	= {ccp(0, 0), ccp(3, 0), ccp(3, 3), ccp(1, 2),}
	local vec2s 	= ZTools.ccps2Vec2Arr(points)

### Parameters:
- 	table 	**ccpoints** 				[必选] 保存有“CCPoint”类型对象的table  

### Returns: 
-   b2Vec2* 							b2Vec2[]数组

--]]--
function M.ccps2Vec2Arr(ccpoints)
	local str = ""
	local ccpointsLen = #ccpoints

	for i, point in ipairs(ccpoints) do
		str = str .. point.x .. "," .. point.y

		if i < ccpointsLen then
			str = str .. "|"
		end
	end

	return BridgeUtils:arrb2Vec2(str)
end


--[[--
判断坐标是否在某个节点内部

<br/>  
### Useage:
	计算节点的包围盒是否包含某个坐标点。

### Parameters:
- 	CCNode 	**node** 			[必选] 要检测的节点对象  
- 	number 	**x** 				[必选] 要检测的x坐标  
- 	number 	**y** 				[必选] 要检测的y坐标  

### Returns: 
-   bool 						坐标是否在指定节点内部

--]]--
function M.isTouchInside(node, x, y)

	return node:getBoundingBox():containsPoint(ccp(x, y))
end 

--[[--
是否点击在多边形区域内

<br/>  
### Useage:
	判断某个点是否在一个不规则的凸多边形内部。

### Notice:
	只适用于凸多边形，凹多边形应该将其分成多个凸多边形计算。

### Parameters:
- 	CCPoint 	**pos** 				[必选] 要验证的点  
- 	table 		**polygonVertexs** 		[必选] 多边形顶点集合，顺序列表  
- 	CCPoint 	**pointInPolygon** 		[必选] 多边形内任意一点，不在边上  

### Returns: 
-   boolean | CCPoint 					是否在多边形内 | 相交点

--]]--
function M.isTouchPolygon(pos, polygonVertexs, pointInPolygon)
	local len = #polygonVertexs

	for i = 1, len do  
		local p1 = polygonVertexs[i]
		local p2 = polygonVertexs[i == len and 1 or i + 1]
		if ccpSegmentIntersect(pos, pointInPolygon, p1, p2) then 
			-- 有交点，不在内部
			return false, ccpIntersectPoint(pos, pointInPolygon, p1, p2) 
		end
	end

	return true 
end

--[[--
创建按钮[系统按钮]

<br/>  
### Useage:
	创建系统按钮，一般用于返回键。

### Notice:
	左上角和右上角的系统按钮必须使用该方法创建，统一通用按钮的效果。

### Parameters:
- 	string 		**img** 				[必选] 图片路径  
- 	CCNode 		**parent** 				[必选] 父节点  
- 	number 		**zOrder** 				[必选] 层级  
- 	CCPoint 	**pos** 				[必选] 位置  
- 	function 	**callback** 			[必选] 点击回调  

### Returns: 
-   CCNode 							系统按钮

--]]--
function M.createSystemButton(img, parent, zOrder, pos, callback)
 	-- 添加结点
    local button = U.loadScaleButton({
    	-- 按钮图片
        imagename      = img,                
        -- 父亲节点（选填)
        parent         = parent,                     
        -- 层深度（选填)
        zorder         = zOrder,                      
        -- 缩放起始效果(默认0.7)
        scaleBegan     = 0.6,                       
        -- 缩放结束效果(默认1.0)
        scaleEnd       = 1.0,                       
        -- 位置(默认返回键位置)
        pos            = pos or ccp(0, 0),             
        -- 缩放时间（默认1.0）
        scaleTime      = 0.2,                       
        -- 点击事件
        fnClicked      = callback,
    })

    return button 
end

--[[--
创建按钮[系统按钮]

<br/>  
### Useage:
	创建系统按钮，一般用于返回键。

### Notice:
	左上角和右上角的系统按钮必须使用该方法创建，统一通用按钮的效果。

### Parameters:
- 	string 		**img** 				[必选] 图片路径  
- 	CCNode 		**parent** 				[必选] 父节点  
- 	number 		**zOrder** 				[必选] 层级  
- 	CCPoint 	**pos** 				[必选] 位置  
- 	function 	**callback** 			[必选] 点击回调  
- 	function 	**touchCallback** 		[必选] 点击下去的时候回调，通常是播放点击声音  

### Returns: 
-   CCNode 							系统按钮

--]]--
function M.createSystemButton2(img, parent, zOrder, pos, callback, touchCallback)
    local button 			= D.img(img):p(pos or ccp(0, 0)):to(parent, zOrder or 20000)
    button.touchCallback 	= touchCallback
    button.callback 		= callback

    button:bindTouch({pnCool = true, coolTime = .5,})

    function button:onTouchBegan(x, y, touches)
    	self:scale(.9)
    	if self.touchCallback then 
    		self.touchCallback()
    	end
    	return SIGN_TOUCH_BEGAN_SWALLOWS
    end

    function button:onTouchEnded(x, y, touches)
    	A.line({
    		{"scaleTo", .2, 1},
    		{"fn", function()
    		 	if TH.isTouchInside(self, x, y) and self.callback then
    		 		self.callback()
    		 	end
    		end},
    		}):at(self)
    end

    return button 
end

--[[--
在骨骼上添加粒子系统

<br/>  
### Useage:
	在骨骼动画上添加一个粒子系统节点。

### Notice:
	CCParticle无法直接添加到骨骼动画上。

### Parameters:
- 	string 					**boneName** 				[必选] 粒子骨骼名称  
- 	string 					**plistPath** 				[必选] 粒子plist文件路径  
- 	CCArmature | CCBone 	**parent** 					[必选] 父骨骼对象或者骨架对象  

### Returns: 
-   CCBone 					附着粒子系统的骨骼对象

--]]--
function M.addBoneParticle(boneName, plistPath, parent)
 	local pBone = SkeletonUtils:createBoneParticle(boneName, plistPath)

	CCNodeExtend.extend(pBone)
	pBone:p(0, 0):scale(1)
	parent:addBone(pBone, boneName)

	return pBone 
end

--[[--
在骨头上添加粒子系统

<br/>  
### Useage:
	在骨骼动画上添加一个粒子系统节点。

### Notice:
	粒子系统无法直接添加到骨架或者骨头上，需要创建一个可以附着粒子系统的骨头，然后添加到骨架或者骨头上才可以。

### Parameters:
- 	table 		**params** 				参数集合  

### OptionParameters
- 	CCArmature | CCBone 	**parent** 					[必选] 父节点  
- 	string 					**displayName** 			[必选] 显示名称（其实我也不知道是什么鬼，设置和boneName一样吧，空字符串会报错）  
- 	string 					**boneName** 				[必选] 骨头名称  
- 	string 					**plistPath** 				[必选] 粒子文件路径  
- 	string 					**pngPath** 				[可选] 粒子纹理图片  
- 	number 					**zOrder** 					[可选] 骨头层级  
- 	number 					**scaleNum** 				[可选] 粒子系统缩放比例  
- 	CCPoint 				**position** 				[可选] 骨头位置  

### Returns: 
-   CCBone 							附着粒子系统的骨头对象

--]]--
function M.addParticleToBone(params)
	params 				= params or {}
	local parent 		= params.parent 
	local displayName 	= params.displayName 
	local boneName 		= params.boneName 
	local plistPath 	= params.plistPath 
	local pngPath 		= params.pngPath 
	local zOrder 		= params.zOrder 
	local scaleNum 		= params.scaleNum 
	local position 		= params.position


 	local bone = SkeletonUtils:createBoneParticle(displayName, plistPath)
 	-- 设置层深度
    bone:setZOrder(zOrder or 100)                                     
    -- 设置缩放比例
    bone:setScale(scaleNum or 1)   

    if pngPath then 
    	bone:setTexture()
    end

    if position then 
    	bone:setPosition(position)
    end 

    -- 添加到对应的骨骼上
    parent:addBone(bone, boneName)   

    return bone                    
end  

--[[--
创建[批渲染节点]

<br/>  
### Useage:
	创建一个CCSpriteBatchNode对象。

### Notice:
	使用批渲染节点的对象不能拥有不同的层级，他们会被绘制在同一个层级上面。

### Parameters:
- 	string 	**fileName** 				[必选] 纹理图片路径  
- 	number 	**size** 					[可选] 批渲染的节点个数  
- 	table 	**points** 					[可选] 节点坐标列表  

### Returns: 
-   CCSpriteBatchNode 					批渲染节点对象

--]]--
function M.createBatchNode(fileName, size, points)
 	local  batchNode 	= CCSpriteBatchNode:create(fileName, size or 30)
	batchNode 			= CCNodeExtend.extend(batchNode)

	function batchNode:show()
		self:setVisible(true)
	end

	function batchNode:hide()
		self:setVisible(false)
	end

	for i, pos in ipairs(points or {}) do
		local node 	= CCSprite:createWithTexture(batchNode:getTexture())
		node 		= CCNodeExtend.extend(node)

		node:setPosition(pos)
		batchNode:addChild(node)
	end

	return batchNode
end

--[[--
创建裁切精灵

<br/>  
### Useage:
	创建一个CCClippingNode对象。

### Parameters:
- 	CCNode  	**stencilNode** 		[必选] 裁切模板  
- 	boolean  	**isInverted** 			[可选] 是否正向裁切  
- 	number  	**alphaThreshold** 		[可选] 透明度过滤  

### Returns: 
-   CCClippingNode 						裁切精灵

--]]--
function M.createClippingNode(stencilNode, isInverted, alphaThreshold)
	local size 	= stencilNode:getContentSize()
 	-- 创建裁切精灵
	local clip 	= CCNodeExtend.extend(CCClippingNode:create())
	-- 设置裁切模板
	clip:setStencil(stencilNode)
	-- 是否正向裁切
	clip:setInverted(ifnil(isInverted, false))
	-- 裁切透明度过滤参数
	clip:setAlphaThreshold(alphaThreshold or 0)
	-- 设置尺寸
	clip:setContentSize(size)

	return clip
end

--[[--
创建纹理画板

<br/>  
### Useage:
	创建一个CCRenderTexture对象。

### Example:

	--------------------------------
	-- 案例一
	--------------------------------
	local renderTexture 	= ZTools.createRenderTexture(V.w, V,h, kCCTexture2DPixelFormat_RGBA8888):bindTouch()
	renderTexture.prev 		= {x = 0, y = 0}
	renderTexture.brush 	= CCSprite:create("g/box/r.png")

	function renderTexture:onTouchBegan(x, y, touches)
		self.prev.x = x
       	self.prev.y = y
		return SIGN_TOUCH_BEGAN_SWALLOWS 
	end
	
	function renderTexture:onTouchMoved(x, y, touches)
		local startP 	= ccp(x, y)
        local endP 		= ccp(self.prev.x, self.prev.y)

        self:begin()
        local distance = ccpDistance(startP, endP)
        if distance > 1 then
            local d = distance
            local i = 0

            for i = 0, d - 1 do
                local difx = endP.x - startP.x
                local dify = endP.y - startP.y
                local delta = i / distance

                self.brush:setPosition(ccp(startP.x + (difx * delta), startP.y + (dify * delta)))
                self.brush:visit()
            end
        end

        self:endToLua()

        self.prev.x = x
        self.prev.y = y
	end
	
	function renderTexture:onTouchEnded(x, y, touches)
		--  
	end

### Parameters:
- 	number 						**width** 				[必选] 宽度  
- 	number 						**height** 				[必选] 高度  
- 	kCCTexture2DPixelFormat 	**pixelFormat** 		[可选] 画布纹理的像素格式    

### Returns: 
-   CCRenderTexture 				动态纹理画板对象

--]]--
function M.createRenderTexture(width, height, pixelFormat)
	-- 创建纹理
	local renderTexture = CCNodeExtend.extend(CCRenderTexture:create(width, height
		, pixelFormat or kCCTexture2DPixelFormat_RGBA8888))

	-- -- 绘制
	-- renderTexture:begin()
	-- -- 创建笔刷
	-- D.img("xxx.png"):p(x, y):visit()
	-- renderTexture:endToLua()

	return renderTexture
end 

--[[--
创建纹理画板

<br/>  
### Useage:
	创建一个CCRenderTexture对象。

### Notice:
	绑定了touch事件。

### Parameters:
- 	number 		**width** 				[必选] 宽度  
- 	number 		**height** 				[必选] 高度  
- 	number 		**pixelFormat** 		[可选] 高度  
- 	CCSprite 	**brushSprite** 		[必选] 笔刷精灵  

### Returns: 
-   CCRenderTexture 				动态纹理画板对象

--]]--
function M.createRenderTextureAndBindEvent(width, height, pixelFormat, brushSprite)
	local renderTexture 	= M.createRenderTexture(width, height, pixelFormat):bindTouch()
	renderTexture.prev 		= {x = 0, y = 0}
	renderTexture.brush 	= brushSprite

	function renderTexture:onTouchBegan(x, y, touches)
		self.prev.x = x
       	self.prev.y = y
		return SIGN_TOUCH_BEGAN_SWALLOWS 
	end
	
	function renderTexture:onTouchMoved(x, y, touches)
		local startP 	= ccp(x, y)
        local endP 		= ccp(self.prev.x, self.prev.y)

        self:begin()
        local distance = ccpDistance(startP, endP)
        if distance > 1 then
            local d = distance
            local i = 0

            for i = 0, d - 1 do
                local difx = endP.x - startP.x
                local dify = endP.y - startP.y
                local delta = i / distance

                self.brush:setPosition(ccp(startP.x + (difx * delta), startP.y + (dify * delta)))
                self.brush:visit()
            end
        end

        self:endToLua()

        self.prev.x = x
        self.prev.y = y
	end
	
	function renderTexture:onTouchEnded(x, y, touches)
		--  
	end
	
	return renderTexture 
end

--[[--
创建进度条

<br/>  
### Useage:
	创建游戏的进度条和技能CD效果的进度

### Example:

	--------------------------
	-- 案例一
	--------------------------
	local bar 	= ZTools.createProgressBar("g/box/r.png", kCCProgressTimerTypeBar, ccp(0.5, 0), ccp(0, 1), 90)

	bar:runAction(CCProgressTo:create(3, 0))


	--------------------------
	-- 案例二
	--------------------------
	local bar 	= ZTools.createProgressBar("g/box/r.png", kCCProgressTimerTypeBar, ccp(0.5, 0), ccp(0, 1), 90)

	bar:progressTo(3, 0, function() print("倒计时结束") end)

### Parameters:
- 	string 	**filePath** 				[必选] 显示进度的图片路径  
- 	CCPoint **progressType** 			[可选] 进度模式（默认为条形）  
- 	CCPoint **midPoint** 				[可选] 起始点（可以理解为进度的作用锚点）  
- 	CCPoint **barChangeRate** 			[可选] 进度改变的方向  
- 	string 	**valuePercentage** 		[可选] 初始进度  

### OptionParameters
- 	midPoint
		** 
- 	progressType 
		**kCCProgressTimerTypeBar** 	条形（类似进度条的效果）
			设置barChangeRate 属性为ccp(0, 1)则为竖向，ccp(1, 0)则为横向， ccp(0.5, 0.5)则为中间向两边。
		**kCCProgressTimerTypeRadial** 	原型（类似技能冷却的那个效果）

### Returns: 
-   CCProgressTimer 					进度条对象

--]]--
function M.createProgressBar(filePath, progressType, midPoint, barChangeRate, valuePercentage)
	local sprite 	= display.newSprite(filePath)
	local bar 		= CCProgressTimer:create(sprite)
	bar 			= CCSpriteExtend.extend(bar)

	-- 设置进度条模式
	bar:setType(progressType or kCCProgressTimerTypeBar)
	-- 设置属性[起始点]
	bar:setMidpoint(midPoint or ccp(0.5, 0))
	-- 设置属性[改变比率]
	bar:setBarChangeRate(barChangeRate or ccp(0, 1))

	-- 等上面这些参数都设置好了之后才能设置这个参数
	bar:setPercentage(valuePercentage or 100)




	-- 进行进度动作
	function bar:progressTo(time, valuePercentage, callback)
		self.actionProgressTo 	= M.stopAction(self, self.actionProgressTo)
		self.actionProgressTo 	= A.line({
			CCProgressTo:create(time, valuePercentage),
			{"fn", callback},
			})

		bar:runAction(self.actionProgressTo)

		return self, self.actionProgressTo 
	end

	-- 停止进度变化的动作
	function bar:stopProgressTo()
		self.actionProgressTo 	= M.stopAction(self, self.actionProgressTo)

		return self 
	end

	return bar 
end

--[[--
创建[批渲染节点上面的节点]

<br/>  
### Useage:
	根据批渲染节点对象创建精灵。

### Notice:
	批渲染节点需要使用同一张纹理。

### Parameters:
- 	CCSpriteBatchNode 	**batchNode** 	[必选] 批渲染节点  
- 	CCPoint 			**pos** 		[可选] 子节点坐标  

### Returns: 
-   CCSprite 							批渲染节点的子节点

--]]--
function M.createBatchNodeChild(batchNode, pos)
 	local node 	= CCSprite:createWithTexture(batchNode:getTexture())
 	node 		= CCNodeExtend.extend(node)

 	node:p(pos or ccp(0, 0)):to(batchNode)

 	return node
end

--[[--
创建滤镜精灵

<br/>  
### Useage:
	创建一个CCFilteredSpriteWithOne对象。

### Notice:
	创建带有滤镜效果的精灵，可以通过精灵的setFilter()和clearFilter()来设置和清除滤镜效果。

### Example:

	-------------------------
	-- 案例一
	-------------------------
	-- 创建滤镜精灵
	local node 			= D.img("gameplay/node.png", { class = CCFilteredSpriteWithOne })
 	-- 创建滤镜（灰色）
	local filterGray 	= filter.newFilter("GRAY")
	-- 设置滤镜
    node:setFilter(filterGray)	
    -- 关闭滤镜
    node:clearFilter() 

### Parameters:
- 	string 	**img** 				[必选] 纹理图片路径  

### Returns: 
-   CCFilteredSpriteWithOne 		滤镜精灵

--]]--
function M:createFilteredSprite(img)
 	return D.img(img, { class = CCFilteredSpriteWithOne})
end

--[[--
创建序列帧动画[根据帧缓存名称]

<br/>  
### Useage:
	把序列帧的名称有序的存放到一个table表格里面，然后从帧缓存里面读取帧纹理，然后实例化一个动画对象，再包装成动作对象返回。

### Notice:
	action对象如果不马上执行会被lua虚拟机回收，所以需要retain()。

### Example:

	----------
	案例一：
	----------
	local frameNames 	= ZTools.getImgs("#f_flower_flower_", {2, 3, 4,})
	local animate 		= ZTools.createAnimateByFrameNames(frameNames, 1.0 / 3)
	local node 			= D.img("#f_flower_flower_1.png"):pc():to(self, 100)
	node:runAction(animate)

### Parameters:
- 	table 	**frameNames** 				[必选] 要使用的序列帧的帧缓存名称集合  
- 	Number 	**time** 					[必选] 每帧间隔时间  

### Returns: 
-   CCAnimate 							动画动作对象

--]]--
function M.createAnimateByFrameNames(frameNames, time)
 	local spriteFrameCache 	= CCSpriteFrameCache:sharedSpriteFrameCache()
	local frames 			= CCArray:createWithCapacity(#frameNames)

	for i, frameName in ipairs(frameNames) do
		frames:addObject(spriteFrameCache:spriteFrameByName(string.sub(frameName, 2)))
	end

	local animation = CCAnimation:createWithSpriteFrames(frames, time or 1.0 / 10)
	local result 	= CCAnimate:create(animation)

	-- 添加动作引用计数，防止action对象返回后被释放
	result:retain()

	return result
end 


--[[--
设置粒子系统位置类型

<br/>  
### Useage:
	设置粒子系统位置类型

### Aliases:
	**setPositionType**

### Notice:
	有的粒子发射后不进行位置跟随，可形成拖尾效果，有的则要跟随移动，不生成拖尾。

### Example:

	local particle = P.newParticle("particles/panel1/snow.plist", V.w_2, 720):to(self, LEVEL_EFFECT)
	ZTools.setPositionType(particle)

### Parameters:
- 	CCParticleSystem 	**particleNode** 		[必选] 粒子系统节点对象  
- 	int 				**positionType** 		[可选] 粒子位置类型（默认为：kCCPositionTypeRelative）  

### OptionParameters
	positionType:
		kCCPositionTypeFree: 		相对屏幕自由【游离的，可拖尾】
		kCCPositionTypeRelative: 	相对被绑定精灵静止
		kCCPositionTypeGrouped: 	相对发射点移动，可向上

--]]--
function M.setParticlePositionType(particleNode, positionType)
	-- pNode:setPositionType(kCCPositionTypeFree)
 	particleNode:setPositionType(positionType or kCCPositionTypeRelative)
end

M.setPositionType = M.setParticlePositionType

--[[--
设置粒子发射频率

<br/>  
### Useage:
	修改粒子系统的发射频率。

### Notice:
	当频率为0时，粒子系统停止发射粒子。

### Parameters:
- 	CCParticleSystem 	**particleNode** 		[必选] 粒子系统节点对象  
- 	number 				**rate** 				[必选] 频率  

--]]--
function M.setEmissionRate(particleNode, rate)
	particleNode:setEmissionRate(rate)
end

--[[--
停止粒子系统的发射

<br/>  
### Useage:
	设置粒子系统的发射频率为0，停止发射粒子。

### Notice:
	建议使用粒子系统对象的stopSystem()方法实现。

### Parameters:
- 	CCParticleSystem 	**particleNode** 		[必选] 粒子系统节点对象  

--]]--
function M.stopParticleSystem(particleNode)
 	particleNode:setEmissionRate(0)
end



--[[--
复写框架[重置层级]

<br/>  
### Useage:
	重新排列节点的渲染层级。

### Aliases:
	**z**  

### Notice:
	框架的setZOrder()和z()两个方法为了提高效率，没有遍历精灵的子节点层级进行重新排列	渲染。

### Parameters:
- 	CCNode 	**node** 				[必选] 要改变层级的节点对象    
- 	Number	**z** 					[必选] 改变后的层级    

--]]--
function M.resetZOrder(node, z)
	local parent 	= node:getParent()

	if parent then 
	 	parent:reorderChild(node, z or 0)
	else
		node:z(z or 0)
	end
end
M.z  	= M.resetZOrder

--[[--
重新设置父节点

<br/>  
### Useage:
	切换设置节点的父节点对象。

### Aliases:
	**readd**
	**to**

### Notice:
	修改节点的父节点，注意，重新添加到场景里面时，节点的onRender会被重新调用。

### Example:

### Parameters:
- 	CCNode  		**node** 				[必选] 重置的节点    
- 	CCNode  		**parentNode** 			[必选] 新的父节点    
- 	number  		**z** 					[可选] 层级    
- 	table | CCPoint **posOffset** 			[可选] 坐标偏移    

### Returns: 
-   CCNode 								重置的节点  

--]]--
function M.resetParent(node, parentNode, z)
	local wPoint 	= node:convertToWorldSpaceAR(ccp(0, 0))
	local nPoint 	= parentNode:convertToNodeSpace(wPoint)

 	node:retain()
 	node:removeFromParent()
 	node:to(parentNode, z or node:z()):p(nPoint)
 	node:release()

 	return node
end
M.readd 	= M.resetParent
M.to 		= M.resetParent

--[[--
获取动画路径集合

<br/>  
### Useage:
	获取动画路径集合。

### Notice:
	有时候帧动画的顺序和美术的图片顺序不一致，或者有些帧需要重复，这时候可以写一个索引列表，然后根据图片前缀pre自动拼接，并返回序列帧的路径集合。

### Example:

	--------------------
	-- 案例一：
	--------------------
	local pre 		= "gameplay/dog/dog_"
	local indexs 	= {1, 2, 3, 4, 5, 4, 3, 4, 5, 4, 3, 2, }
	local imgs 		= ZTools.getImgs(pre, indexs)
	dump(imgs)


### Parameters:
- 	String 	**pre** 				[必选] 路径前缀  
- 	table 	**indexs** 				[必选] 图片索引集合  

### Returns: 
-   table 							动画路径集合

--]]--
function M.getImgs(pre, indexs)
 	local imgs 		= {}

 	for i, index in ipairs(indexs) do
 		table.insert(imgs, pre .. index .. ".png")
 	end

 	return imgs
end

--[[--
计算两点之间的距离

<br/>  
### Useage:
	两点之间的距离

### Notice:
	可以百度“quick-cocos2d-x懒人数学函数”，里面有个ccpDistance(v1, v2)是一样的效果。

### Parameters:
- 	类型 	**参数名** 				[可选性] 参数说明

### Returns: 
-   number 							两点之间的距离

--]]--
function M:distance(pointA, PointB)
 	return P.distance(pointA.x, pointA.y, pointB.x, pointB.y)
end

--[[--
抗锯齿

<br/>  
### Useage:
	纹理渲染过程中会出现锯齿化，开启抗锯齿后，边缘会变模糊。

### Notice:
	其实就是模糊锯齿，不让渲染的那么锋利而已。

### Parameters:
- 	CCSprite 	**sprite** 				[必选] 要操作的精灵对象  

--]]--
function M.setAntiAliasTexParameters(sprite)
 	sprite:getTexture():setAntiAliasTexParameters() 
end

--[[--
不抗锯齿

<br/>  
### Useage:
	关闭抗锯齿功能。边缘不会模糊，但是锯齿化明显锐利。

### Parameters:
- 	CCSprite 	**sprite** 				[必选] 要操作的精灵对象  

--]]--
function M.setAntiAliasTexParameters(sprite)
 	sprite:getTexture():setAliasTexParameters()  
end

--[[--
设置默认的纹理像素格式

<br/>  
### Useage:
	全局设置cocos2d-x默认的纹理像素格式。  

### Aliases:

### Notice:

	最快速地减少纹理内存占用的办法就是把它们作为16位颜色深度的纹理来加载。cocos2d默认的纹理像素格
		式是32位颜色深度。如果把颜色深度减半，那么内存消耗也就可以减少一半。并且这还会带来渲染效率
		的提升，大约提高10%。

	首先，纹理像素格式的改变会影响后面加载的所有纹理。因此，如果你想后面加载纹理使用不同的像素格式的
		话，必须再调用此方法，并且重新设置一遍像素格式。
	其次，如果你的CCTexture2D设置的像素格式与图片本身的像素格式不匹配的话，就会导致显示严重失真。比
		如颜色不对，或者透明度不对等等。

### Example:

	ZTools.setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)

### Parameters:
- 	类型 	**pixelFormat** 			[必选] 像素格式  

### OptionParameters
	pixelFormat: 
		generate 32-bit textures: kCCTexture2DPixelFormat_RGBA8888 (default)
		generate 16-bit textures: kCCTexture2DPixelFormat_RGBA4444
		generate 16-bit textures: kCCTexture2DPixelFormat_RGB5A1
		generate 16-bit textures: kCCTexture2DPixelFormat_RGB565 (no alpha)

--]]--
function M.setDefaultAlphaPixelFormat(pixelFormat)
 	CCTexture2D:setDefaultAlphaPixelFormat(pixelFormat or kCCTexture2DPixelFormat_RGBA4444)
end

--[[--
十进制转换其他进制

<br/>  
### Useage:
	将十进制整数转换为其他进制的数字。  

### Notice:
	目前只测试过二进制，其他进制可能有问题，有空再测试。

### Example:

	local result = ZTools.convertHex(7, 2, 4)
	print(result)

### Parameters:
- 	int 	**value** 				[必选] 要转换的十进制数  
- 	int 	**hex** 				[必选] 要转换的进制基数  
- 	int 	**length** 				[可选] 转换后的格式化长度，长度不足的前面补“0”  

### Returns: 
-   String 							转换后的值
-   table 							转换后的值的每一位数

--]]--
function M.convertHex(value, hex, length)
 	local numbers 	= {}
 	local result 	= ""
	
	-- 只要商不小于进制基数就要继续使用“除留余数法”
	while value >= hex do
		local mod 	= math.fmod(value, hex)
		result 		= mod .. result
		value 		= math.floor(value / hex)

		table.insert(numbers, mod)
	end
	-- 最后的商作为第一位
	table.insert(numbers, value)
	result 		= value .. result

	local function formatLength()
		if #numbers < (length or 1) then 
			result 		= "0" .. result

			table.insert(numbers, 0)
			-- 递归
			formatLength()
		end
	end

	formatLength()

	numbers 	= T.reverse(numbers)

	return result, numbers
end 

--[[--
播放视频

<br/>  
--]]--
function M.playMov(sceneName)
	-- local videoPath 	= IO.fullPath("res/mov/video.mp4")
	-- local scalingMode 	= 1 -- MPMovieScalingModeFill or 3 
	-- local btnCloseImg 	= IO.fullPath("common/buttons/btn_back_mov.png")
	
	-- if isandroid() then 
	-- 	videoPath 	= "res/mov/video.mp4"
	-- 	scalingMode = nil
	-- end
	
	-- sound.disableMusic()

	-- -- 标记当前开始播放的时间
	-- MV_START_TIME = os.time()

	-- NV.playMovie(videoPath, function()
	-- 	sound.enableMusic()
	-- 	-- 点击返回键返回主页面
	-- 	game:enterScene((os.time() - MV_START_TIME) > 75 and "MV" or "Gameplay")
	-- end, true, false, nil, btnCloseImg, scalingMode)	

	game:enterScene("MVPlay")
end 

--------------------------
-- 析构型函数
--------------------------

--[[--
停止发射粒子

<br/>  
### Useage:
	设置粒子系统的发射频率为0。

### Notice:
	建议使用粒子系统的stopSystem()方法来实现。

### Parameters:
- 	CCParticle 	**particle** 			[必选] 要停止发射的粒子系统对象    

### Returns: 
-   CCParticle 							粒子系统对象

--]]--
function M.stopParticle(particle)
	if particle then 
	 	particle:setEmissionRate(0) 
	end

	return particle 
end

--[[--
停止指定动作

<br/>  
### Useage:
	停止一个节点的某个动作。

### Parameters:
- 	CCNode 		**node** 				[必选] 要停止动作的节点对象  
- 	CCAction 	**action** 				[必选] 要停止的动作对象  

### Returns: 
-   nil 								返回空值，方便指针置空。

--]]--
function M.stopAction(node, action)
 	if node and action then 
 		node:stopAction(action)
 	end

 	return nil 
end 

--[[-
停止所以的动作  

<br/>  
### Useage:
  	停止一个节点的所有动作。  

### Parameters:
- 	CCNode 		**node** 				[必选] 要停止动作的节点对象  

### Returns: 
-   nil 								返回空值，方便指针置空。

--]]
function M.stopAllActions(node)
 	if node then 
 		node:stopAllActions()
 	end

 	return nil 
end 

--[[--
暂停节点的所有动作

<br/>  
### Useage:
	暂停一个节点的所有动作调度。

### Notice:
	暂停一个节点对象的所有Action动作。导致后面执行的action也会无法执行。

### Parameters:
- 	CCNode 	**node** 				[必选] 节点对象  

--]]--
function M.pauseAction(node)
 	CCDirector:sharedDirector():getActionManager():pauseTarget(node)
end

--[[--
恢复节点的所有动作

<br/>  
### Useage:
	回复一个节点的所有动作调度。

### Notice:
	恢复一个节点对象的所有Action动作。

### Parameters:
- 	CCNode 	**node** 				[必选] 节点对象    

--]]--
function M.resumeAction(node)
 	CCDirector:sharedDirector():getActionManager():resumeTarget(node)
end

--[[-
停止音效  

<br/>  
### Useage:
  	停止某个音效的播放。  

### Notice:
	如果是使用UNative播放的音效，需要将第二个参数设置为true。   

### Parameters:
- 	int 	**soundHandle** 			[必选] 要停止的音效的句柄    
- 	bool 	**isNative** 				[可选] 是否是平台音效    

### Returns: 
-   nil 								返回空值，方便指针置空。  

--]]
function M.stopSound(soundHandle, isNative)
 	if soundHandle then 
 		if isNative then 
 			NV.stopSound(soundHandle)
 		else
 			sound.stopSound(soundHandle)
 		end
 	end

 	return nil 
end

--[[--
移除指定的对象

<br/>  
### Useage:
	将一个节点从场景中移除。  

### Notice:
	每次移除对象都要判断对象是否存在时，可以使用这个方法进行移除。  

### Parameters:
- 	CCNode 		**node** 				[必选] 要被移除的对象    

### Returns: 
-   nil 								返回空值，方便指针置空。  

--]]--
function M.remove(node)
 	if node and node.remove then 
 		node:remove()
 	end

 	return nil 
end

--[[--
延迟后移除指定的对象

<br/>  
### Useage:
	在用延迟多少秒之后移除一个对象的可以使用这个方法。  

### Notice:
	被移除的对象不能在延时过程中调用stopAllActions()方法。

### Parameters:
- 	CCNode 		**node** 				[必选] 要被移除的对象  
- 	Number 		**delayTime** 			[可选] 延迟时间  

### Returns: 
-   nil 								返回空值，方便指针置空。

--]]--
function M.delayRemove(node, delayTime)
 	if node and node.remove then 
 		A.line({
 			{"delay", delayTime or 0},
 			{"remove"},
 			}):at(node)
 	end

 	return nil 
end



--[[-
清理缓存  

<br/>  
### Useage:
  	清理未使用的帧缓存和纹理缓存。  

### Notice:
	如果资源被占用，则无法清理。   

--]]
function M.removeUnusedTexturesAndFrames()
	-- 先移除帧缓存，消除对图片纹理的引用
	R.removeUnusedFrames()
	-- 再移除未使用的纹理对象
	R.removeUnusedTextures()
	
	-- CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
	-- CCTextureCache:sharedTextureCache():removeUnusedTextures()
end 


-- 加载引导
function M.loadGuide(parentNode, point)
	local x, y 	= point.x, point.y 
	local guide = D.img("common/guide/guide1.png"):to(parentNode, LEVEL_EFFECT):p(x + 8, y)
	guide.light  = D.img("common/guide/light_1.png"):to(guide, -1):p(15, 50):scale(.5)

	guide:cycle({{"file", "common/guide/guide", 2, 0.3}})
	guide.light:cycle({{"file", "common/guide/light_", 7, 0.2}})

	return guide
end


--[[--
求线段上距离端点p1为s的点的坐标

<br/>  
### Useage:
	求线段上距离端点p1为s的点的坐标。

### Notice:
	求线段p1p2上距离端点p1为distance的点的坐标

### Example:

	local TL 		= require("app.common.constent.ZTools")
	local newPoint 	= TL.getCurrentPoint(ccp(10,15),ccp(30,80),13)

### Parameters:
- 	CCPoint 	**p1** 				[必选] 端点1    
- 	CCPoint 	**p2** 				[必选] 端点2    
- 	number 		**distance** 		[必选] 线段上与端点1的距离    

### Returns: 
-   CCPoint 					距离端点1为distance的点

--]]--
function M.getPointInLineByDistance(p1, p2, distance)
	if distance <= 0 then return p1 end

	-- 计算线段长度
	local lineLenght 	= PT.distance(p1.x, p1.y, p2.x, p2.y) 

	-- 如果距离小于指定长度，则等于另一个端点
	if lineLenght < distance then 
		return p2
	end

	-- 根据比例得到坐标
	local x 			= distance * (p2.x - p1.x) / lineLenght + p1.x 
	local y 			= distance * (p2.y - p1.y) / lineLenght + p1.y 

	return ccp(x, y)
end 








--------------------------
--  框架拓展
--------------------------
--[[-
添加广告  

<br/>  
### Useage:
  	判断在小屏上不添加广告。 

### Notice:
	这个方法有屏幕高度值参与运算，所以后期可能并不准确。   


### Parameters:
- 	number 	**y** 				[可选] 屏幕高度    

--]]
function M.addAd(y)
	NV.removeAd()
	-- debugAdNode = M.remove(debugAdNode)

	if isandroid() then 
		-- 获取手机屏幕的物理尺寸
		local physicSize = NV.getScreenSizeOfDevice()

		if not (y and physicSize < 6) then 
			NV.addAd(AD_LAYOUT_TOP_CENTER)
			-- debugAdNode = D.img("g/box/r.png"):scaleX(5):p(480, V.fixY):anchor(ccp(.5, 1)):to(D.getRunningScene(), 9999999)
		end
	else
		if y and V.fixY < y then return end 
		
		NV.addAd(AD_LAYOUT_TOP_CENTER)
		-- debugAdNode = D.img("g/box/r.png"):scaleX(5):p(480, V.fixY):anchor(ccp(.5, 1)):to(D.getRunningScene(), 9999999)
	end
end







--========================
-- 父类重写
--========================









--------------------------
--  参数配置
--------------------------
--[[--
获取全屏适配比例

<br/>  
### Notice:
	进行全屏定位时，基于960 * 540比例的坐标对应偏移的全屏适配比例。

### Returns: 
-   number 							全屏适配比例

--]]--
function M.getFullScreenFactor()
 	-- 全屏适配比例
	Y_FACTOR 					= Y_FACTOR or (16 / 9 * (display.height / display.width))

	--[坐标]
	V 								= V or {}
	-- 全屏的屏幕宽度
	V.fixW 							= V.w
	-- 全屏的屏幕高度
	V.fixY 							= display.height / (display.width / 960)
	-- 左上角按钮
	P_BTN_LEFT_TOP 			 		= ccp(60, V.fixY - 60)
	-- 右上角按钮
	P_BTN_RIGHT_TOP 		 		= ccp(V.w - 60, V.fixY - 60)
	-- 右下角按钮
	P_BTN_RIGHT_BOTTOM 		 		= ccp(V.w - 60, 60) 

	return Y_FACTOR 
end












return M






