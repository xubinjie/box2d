--[[--------------------------
骨骼精灵基类

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	搭载骨骼动画节点的精灵
	- Author: 	zengbinsi
	- Date: 	2016-11-21  

--]]-------------------------- 




--========================
-- 引入命名空间
--========================
-- local BaseLayer = import("app.common.layer.BaseLayer")




--[[
	类
--]]


local M 	= classSprite("BaseArmatureSprite")




--========================
-- 构造函数
--========================

function M:ctor(params)
	params 				= params or {}

	--[超类调用]
	M.super.ctor(self, params)
 	--[本类调用]
 	-- 字段[骨骼资源文件名，不带文件后缀名]
 	self.file 			= params.file
 	-- 字段[骨架名称]
	self.armatureName 	= params.armatureName
	-- 字段[其他参数]
	self.animOption 	= params.animOption
end

--========================
-- 渲染
--========================

function M:onRender()
	M.super.onRender(self)

 	--[本类调用]
	-- 字段[父节点]
 	self.parentNode 	= self:getParent()
	-- 加载节点
	self:loadDisplay() 
	-- 加载渲染以外的其他操作
	self:loadRenderOtherwise()
	self:setContentSize(self.armature:boundingBox().size or CCSize(0, 0))
	self:setCascadeBoundingBox(self.armature:boundingBox())
end 

-- 加载节点
function M:loadDisplay(file, armatureName, animOption)
	file 				= file or self.file
	self.file 			= file
	armatureName 		= armatureName or self.armatureName
	self.armatureName 	= armatureName
	animOption 			= animOption or self.animOption

	DragonBone.addFile(file)

	self.armature 		= DragonBone.createArmature(armatureName, animOption):anchor(ccp(0, 0)):p(0, 0):to(self)
	
	if type(self.playAnimationCallback) == "function" then 
		self.armature:connectMovementEventSignal(function(eventType, evnetId)
			if self.playAnimationCallback then 
				self:playAnimationCallback(eventType, evnetId)
			end
		end)
	end
end 

-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
	-- 并非所有的骨骼精灵都需要touch事件，所有基类不进行相关操作。  
	-- self:bindTouch() 
end




--========================
-- 析构
--========================

function M:onDestructor()
	--[超类调用]
	M.super.onDestructor(self)
 	--[本类调用]
 	self.armature = ZTools.remove(self.armature)
end








--========================
-- 触控
--======================== 

-- function M:onTouchBegan(x, y, touches)
-- 	--  触控有效
-- 	return SIGN_TOUCH_BEGAN_SWALLOWS 
-- end

-- function M:onTouchMoved(x, y, touches)
-- 	--   
-- end

-- function M:onTouchEnded(x, y, touches)
-- 	--  
-- end








--========================
-- 功能函数
--======================== 

--[[-
逻辑[动作播放一遍结束的回调]  

<br/>  
### Useage:
  	用途  

### Aliases:
	别名  

### Notice:
	注意   

### Example:
	示例  

### Parameters:
- 	number 		**delayTime** 			[必选] 延时时间  
- 	function 	**method** 				[必选] 回调函数  

--]]
function M:delayCallMethod(delayTime, method)
	self:stopDelayCallMethodAction()
	
	self.actionDelayCallMethod 	= A.line({
		{"delay", delayTime or 0},
		{"fn", method or function() end},
		})
	self:runAction(self.actionDelayCallMethod)
end 

--[[-
停止回调动作  

<br/>  
### Useage:
  	用于停止一个回调方法的action    

### Notice:
	当前精灵进行stopAllActions()的时候，改延时回调也会被停止。   

--]]
function M:stopDelayCallMethodAction()
	self.actionDelayCallMethod 	= ZTools.stopAction(self, self.actionDelayCallMethod)
end

--[[-
播放骨骼动画  

<br/>  
### Useage:
  	用于播放一个骨骼上的动画。    

### Aliases:
	**play**  

### Parameters:
- 	string 	**animationName** 			[必选] 动画名称  
- 	number 	**fps** 					[可选] 动画帧率倍数  
- 	table 	**options** 				[可选] 其它参数  

### OptionParameters

	- options ：
	- 	number   **durationTo** 		跳转到该动作需要补充的帧数，避免跳转太突兀。-1使用美术调整的节奏  
	- 	number   **durationTween** 		跳转到该动作需要补充的帧数，避免跳转太突兀。-1使用美术调整的节奏  
	- 	number   **loop** 				是否循环。<0使用的是美术调整的节奏，=0播放一遍，>0则循环  
	- 	number   **tweenEasing 			两个关键帧之间的缓动  
	- 	function ** movementHandler** 	动作结束的处理函数。  
  
--]]
function M:playAnimation(animationName, fps, options)
	if not self.armature then 
		self:loadDisplay()
	end
	self.armature:play(animationName, fps, options)
end
M.play = M.playAnimation

--[[-
停止动画播放  

<br/>  
### Useage:
  	用于暂停当前正在播放的动画。    

### Aliases:
	**stop**  

### Notice:
	只是暂停了当前的动画，所以会卡在那一帧的样子进行渲染，并不会回到初始帧。     

--]]
function M:stopAnimation()
 	self.armature:stop()
end
M.stop = M.stopAnimation




--========================
-- 属性
--========================

--[[-
是否点击在骨骼区域内  

<br/>  
### Useage:
  	判断某一个点是否在骨骼的包围盒内。    

### Aliases:
	别名  

### Notice:
	如果发现明明点中骨骼，但是返回值不正确请试试转换坐标系。     

### Parameters:
- 	number 	**x** 				[必选] 坐标x  
- 	number 	**y** 				[必选] 坐标y  

### Returns: 
-   boolean  

--]]
function M:isTouchMe(x, y)
	return self.armature:isTouchMe(x, y)
end




--========================
-- 父类重写
--======================== 

--[[-
动作播放一遍结束的回调   

<br/>  
### Useage:
  	进行骨骼动画播放结束的回调。    

### Notice:
	注意   

### Parameters:
- 	number 	**eventType** 				[必选] 动作的执行状态。0:开始播放; 1:不循环的动作结束; 2:循环的动作结束一次循环  
- 	string 	**eventId** 				[必选] 动作的id，就是动作名称  

--]]
-- function M:playAnimationCallback(eventType, eventId)
-- 	zerror("类".. self.__cname .."必须重写playAnimationCallback(eventType, eventId)方法。")
-- end

--[[-
隐藏骨架  

<br/>  
### Useage:
  	进行骨骼和骨架的隐藏操作。    

### Notice:
	对骨骼和当前节点都进行了隐藏。     

--]]
function M:hideArmature()
	self.armature:hide()
	self:hide()
end

--[[-
反向显示骨架  

<br/>  
### Useage:
  	用于对骨骼和当前精灵进行反向显示。    

### Notice:
	当前精灵和骨骼节点都进行了反向显示操作。   

### Parameters:
- 	boolean 	**isFlipX** 			[必选] 是否反向显示  

### Returns: 
-   BaseArmatureSprite   			  	

--]]
function M:flipXArmature(isFlipX)
	self:flipX(isFlipX)
	self.armature:flipX(isFlipX)

	return self 
end




return M






