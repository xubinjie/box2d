--[[----
[csu]骨骼动画工具类

	骨骼动画工具类，定义了骨骼动画的操作方法和实现逻辑

	-- created by 2D组骨骼动画兴趣小组  

]]---

----------------------
-- DragonBone类  
----------------------
local DragonBone = {}

DragonBone.TAG = "DragonBone"

--[常量]  
local FPS 				= 24 / 60 -- flash与cocos2d-x的帧频比率。Flash 24, cocos2d-x 60  
local TWEEN_EASING_MAX 	= 10000








----------------------
-- 私有方法  
----------------------

-- 骨骼对象监听动作信号  
local function _connectMovementEventSignal(armature, animOption)
	if animOption and animOption.movementHandler then
		armature:connectMovementEventSignal(animOption.movementHandler)
	end
end

-- 改变子骨骼的透明度  
local function _changeChildrenBoneOpacity(parentBone, opacity)
	local armature 	= parentBone:getArmature()
	local bones 	= armature:getBoneDic()
	local boneNames = bones:allKeys()

	for i = 0, boneNames:count() - 1 do  
		local boneName = boneNames:objectAtIndex(i):getCString()
		local bone 	   = bones:objectForKey(boneName)

		if bone:getParentBone() == parentBone then
			bone:updateDisplayedOpacity(opacity)
		end
	end
end

--[[--

指定的骨架播放指定的动作

### Useage:
	_playAnimation(骨架对象, 动作名, 帧率, 动作可选参数)
	
### Aliases:

### Notice:
	movementHandler(__evtType, __moveId)函数会有两个形参。
	__evtType: 动作的执行状态。0:开始播放; 1:不循环的动作结束; 2:循环的动作结束一次循环
	__moveId:  动作的id
### Example:
    ----------------------
    -- 示例1: 通用操作  
    ----------------------
	
### Parameters:
- 	CCArmature **armature** 	骨架对象  
- 	string **animName** 		动作名字  
- 	string **fps**				帧率  
- 	string **animOption** 		动作的可选参数  

### OptionParameters
- 	number   **durationTo** 		跳转到该动作需要补充的帧数，避免跳转太突兀。-1使用美术调整的节奏  
- 	number   **durationTween** 		跳转到该动作需要补充的帧数，避免跳转太突兀。-1使用美术调整的节奏  
- 	number   **loop** 				是否循环。<0使用的是美术调整的节奏，=0播放一遍，>0则循环  
- 	number   **tweenEasing 			两个关键帧之间的缓动  
- 	function ** movementHandler** 	动作结束的处理函数。  


### Returns: 
-   CCArmature 					骨架对象  

--]]--
local function _playAnimation(armature, animName, mult, animOption)
	animOpt = totable(animOption)

	local durationTo 	= animOpt.durationTo or -1
	local durationTween = animOpt.durationTween or -1
	local loop 			= animOpt.loop or -1
	local tweenEasing 	= animOpt.tweenEasing or TWEEN_EASING_MAX
	local animation 	= armature:getAnimation()

	-- 设置播放速度  
	armature:setSpeed(mult)

    -- 播放指定的骨骼动作  
    if type(animName) == "string" then
		animation:play(animName, durationTo, durationTween, loop, tweenEasing)
	elseif type(animName) == "number" then
		animation:playByIndex(animName, durationTo, durationTween, loop, tweenEasing)
	end

    return armature
end

--[[--

换装

### Useage:
	_change(骨骼, 换装的索引或名字, 是否强制换装)
	
### Aliases:
	
### Notice:
	换装有两种方式，一种通过索引，一种精灵帧。
	索引方式主要取决于美术那边的资源制作，美术在骨骼上要有多套才能换装
	精灵帧方式只要精灵帧已被添加到缓存中就行，此种方式较索引方式优秀
### Example:
    ----------------------
    -- 示例1: 通用操作  
    ----------------------
	DragonBone.addFile("Dragon")
	local dragon = DragonBone.createArmatureAndPlay("Dragon", "stand")
	:to(self):pc()
	
	A.line({
		{"delay", 2.0},
		{"fn", function()
			-- 通过index换装  
			dragon:change("clothes", 1, true)
		end},
		{"delay", 2.0},
		{"fn", function()
			-- 通过精灵帧换装  
			dragon:change("clothes", "parts-clothes4.png", true)
		end},
	}):at(dragon)

### Parameters:
- 	CCBone **bone** 			骨骼对象  
- 	string **indexOrName** 		换装的索引或名字  
- 	string **isForce**			是否强制换装  

### OptionParameters

### Returns: 
-   nil  

--]]--
local function _change(bone, indexOrName, isForce)
	if type(indexOrName) == "number" then
		bone:changeDisplayByIndex(indexOrName, isForce)
	elseif type(indexOrName) == "string" then
		local spriteData = CCSpriteDisplayData:create()
		spriteData.displayName = indexOrName

		-- 移除原本位置的显示数据  
		bone:removeDisplay(0)
		-- 添加新的显示数据  
		bone:addDisplay(spriteData, 0)
		-- 切换到新的显示数据  
		bone:changeDisplayByIndex(0, true)
	end
end


--[[--

拓展bone

### Useage:
	
### Aliases:

### Notice:

### Example:
    ----------------------
    -- 示例1: 通用操作  
    ----------------------
	local dragon = DragonBone.addFileAndPlay("Dragon", "Dragon", "stand", 24 / 60, {
		durationTo = -1,
		durationTween = -1,
		animOpt.loop = -1,
		animOpt.tweenEasing = TWEEN_EASING_MAX,
	})
	:to(self):pc()
	
	local clothes = dragon:getBone("clothes")

	A.line({
		{"delay", 2.0},
		{"fn", function()
			clothes:hide(false)
		end},
		{"delay", 2.0},
		{"fn", function()
			clothes:show(true)
		end},
		{"delay", 2.0},
		{"fn", function()
			clothes:change(2, true)
		end},
		{"delay", 2.0},
		{"fn", function()
			clothes:change("parts-clothes4", true)
		end},
	}):at(dragon)

### Parameters:

### OptionParameters

### Returns: 
-   nil  

--]]--
local function _extendBone(armature, bone)
	bone.armature = armature
	function bone:getArmature()
		return self.armature
	end

	-- 隐藏自己  
	function bone:hide(isHideChildren)
		if isHideChildren then
			_changeChildrenBoneOpacity(self, 0)
		end

		self:updateDisplayedOpacity(0)

		return self
	end

	-- 显示自己  
	function bone:show(isShowChildren)
		if isShowChildren then
			_changeChildrenBoneOpacity(self, 255)
		end
		
		self:updateDisplayedOpacity(255)

		return self
	end

	-- 换装  
	function bone:change(indexOrName, isForce)
		_change(self, indexOrName, isForce)

		return self
	end

	return CCNodeExtend.extend(bone)
end

--[[--

复写CCBone对象方法

### Useage:
	
### Aliases:

### Notice:
	
### Example:
    ----------------------
    -- 示例1: 通用操作  
    ----------------------
	local dragon = DragonBone.addFileAndPlay("Dragon", "Dragon", "stand", 24 / 60, {
		durationTo = -1,
		durationTween = -1,
		animOpt.loop = -1,
		animOpt.tweenEasing = TWEEN_EASING_MAX,
	})
	:to(self):pc()

	A.line({
		{"delay", 2.0},
		{"fn", function()
			local tail = dragon:getBone("tail")
			local tailTip = dragon:getBone("tailTip")
			tail:removeChildBone(tailTip)
		end},
	}):at(dragon)

### Parameters:

### OptionParameters

### Returns: 
-   nil  

--]]--
local function _overrideBone(bone)
	bone._removeChildBone = bone.removeChildBone
	bone._setOpacity = bone.setOpacity

	bone:setCascadeOpacityEnabled(true)
	function bone:setOpacity(opacity)
		self:updateDisplayedOpacity(opacity)
	end
	bone.opacity = bone.setOpacity

	function bone:removeChildBone(bone, recursion)
		local armature 	= self:getArmature()
		local childBone = armature:getBone(bone)

		if childBone:getParentBone() ~=  self then
			error(string.format("bone \"%s\" is not the childBone of bone \"%s\"", 
				childBone:getName(), self:getName()), 2)
		end

		if recursion then
			self:_removeChildBone(childBone, recursion)
		else
			childBone:remove()
		end
	end
end

--[[--

拓展CCArmature对象

### Useage:
	
### Aliases:
	
### Notice:
	
### Example:
    ----------------------
    -- 示例1: 通用操作  
    ----------------------
	local dragon = DragonBone.addFileAndPlay("Dragon", "Dragon", "stand", 24 / 60, {
		durationTo = -1,
		durationTween = -1,
		animOpt.loop = -1,
		animOpt.tweenEasing = TWEEN_EASING_MAX,
	})
	:to(self):pc()
	
	-- 演示骨架对象的pause, resume, play, stop等函数  
	A.line({
        {"fn", function()
            dragon:play("jump", nil, {
                durationTo  = 2.0,
                loop        = 1,
            })
        end},    
        {"delay", 2.0},
        {"fn", function() dragon:pause() end},
        {"delay", 2.0},
        {"fn", function() dragon:resume() end},
        {"delay", 2.0},
        {"fn", function()
            dragon:play("jump", nil, {
                durationTo  = 2.0,
                loop        = 1,
            })
        end},
        {"delay", 2.0},
        {"fn", function()
            dragon:change("clothes", "parts-clothes4.png", true)
        end},
        {"delay", 2.0},
        {"fn", function()
            dragon:hideBone("tail", false)
        end},
        {"delay", 2.0},
        {"fn", function()
            dragon:showBone("tail", true)
        end},
        {"delay", 2.0},
        {"fn", function() dragon:flipX(true) end},
        {"delay", 2.0},
        {"fn", function() dragon:flipX(false) end},
        {"delay", 2.0},
        {"fn", function() dragon:stop() end},
    }):at(dragon)
	
### Parameters:

### Returns: 
-     

--]]--
local function _extendArmature(armature)
	-- 播放动作  
	function armature:play(animName, fps, animOption)
		_playAnimation(self, animName, fps, animOption)

		return self
	end

	function armature:pause()
		local animation = self:getAnimation()
		animation:pause()

		return self
	end

	function armature:resume()
		local animation = self:getAnimation()
		animation:resume()

		return self
	end

	function armature:stop()
		local animation = self:getAnimation()
		animation:stop()

		return self
	end

	-- 换装  
	function armature:change(boneName, indexOrName, isForce)
		local bone = self:getBone(boneName)
		_change(bone, indexOrName, isForce)

		return self
	end

	function armature:flipX(isFlip)
		self._factorX = isFlip and -1 or 1
		self:setScaleX(math.abs(self:getScaleX()))
	end
	armature.setFlipX = armature.flipX

	function armature:flipY(isFlip)
		self._factorY = isFlip and -1 or 1
		self:setScaleY(math.abs(self:getScaleY()))
	end
	armature.setFlipY = armature.flipY

	-- 隐藏骨骼  
	function armature:hideBone(boneName, isHideChildren)
		local bone = self:getBone(boneName)
		bone:hide(isHideChildren)

		return self
	end

	-- 显示骨骼  
	function armature:showBone(boneName, isShowChildren)
		local bone = self:getBone(boneName)
		bone:show(isShowChildren)

		return self
	end

	-- 设置帧率  
	function armature:setAnimationScale(mult)
		mult = mult or 1.0
		local animation = self:getAnimation()
		animation:setAnimationScale(mult * FPS)
	end
	armature.setSpeed = armature.setAnimationScale

	-- 获得动作个数  
	function armature:getMovementCount()
		local animation = self:getAnimation()
		return animation:getMovementCount()
	end

	-- 是否点击在骨骼对象上  
	function armature:isTouchMe(x, y)
		local worldPoint = y and ccp(x, y) or x
		local localPoint = armature:convertToNodeSpace(worldPoint)
		return armature:boundingBox():containsPoint(localPoint)
	end

	return CCNodeExtend.extend(armature)
end

--[[--

复写CCArmature对象方法

### Useage:
	
### Aliases:

### Notice:

### Example:
    ----------------------
    -- 示例1: 通用操作  
    ----------------------
	local dragon = DragonBone.addFileAndPlay("Dragon", "Dragon", "stand", 24 / 60, {
		durationTo = -1,
		durationTween = -1,
		loop = -1,
		tweenEasing = TWEEN_EASING_MAX,
	})
	:to(self):pc()
	
	local tail = dragon:getBone("tail")
	A.line({
		{"fn", function()
			local tail = dragon:getBone("tail")
			dragon:changeBoneParent(tail, "armL", ccp(0, 0))
		end},
		{"delay", 2.0},
		{"fn", function()
			dragon:addBone("myBone", "tail", "parts-head", ccp(100, 0))
		end},
		{"delay", 2.0},
		{"fn", function()
			dragon:removeBone(tail, true)
		end},
	}):at(dragon)

### Parameters:

### OptionParameters

### Returns: 
-   nil  

--]]--
local function _overrideArmature(armature)
	if true then
		local fnNames = {
			"getBone", "removeBone", "changeBoneParent", 
			"setScale","setScaleX", "setScaleY", "addBone", "getAnimation"
		}
		for _, fnName in ipairs(fnNames) do
			local newName = string.format("_%s", fnName)
			armature[newName] = armature[fnName]
		end
	end

	function armature:getAnimation()
		return armature:_getAnimation()
	end

	function armature:setScale(scale)
		armature:setScaleX(scale)
		armature:setScaleY(scale)
	end

	function armature:setScaleX(scale)
		local scaleX = (self._factorX or 1) * scale
		self:_setScaleX(scaleX)
	end

	function armature:setScaleY(scale)
		local scaleY = (self._factorY or 1) * scale
		self:_setScaleY(scaleY)
	end

	-- 获得指定骨骼，并拓展  
	function armature:getBone(bone)
		local targetBone
		if tolua.type(bone) == "CCBone" then
			targetBone = bone
		elseif type(bone) == "string" then
			targetBone = armature:_getBone(bone)
		end

		if not targetBone then error("the bone do not exit.", 2) end
		-- 复写并拓展bone对象的方法  
		_overrideBone(targetBone)
		return _extendBone(armature, targetBone)
	end

	-- 移除骨骼，通过CCBone的removeFromParent方法实现，避免闪退  
	function armature:removeBone(bone, recursion)
		local targetBone = armature:getBone(bone)

		if targetBone:getParentBone() and recursion then
			targetBone:removeFromParent(recursion)
		else
			targetBone:remove()
		end
	end

	-- 改变骨骼的父节点  
	function armature:changeBoneParent(bone, parentName, pos)
		bone = armature:getBone(bone)
		armature:_changeBoneParent(bone, parentName)
		if pos then
			bone:setPosition(pos)
		end
	end

	-- 添加骨骼，这里的img还不能随便指定图片，要从CCSpriteFrameCache读取  
	function armature:addBone(bone, parentName, img, pos)
		local newBone = nil

		if "CCBone" == tolua.type(bone) then
			newBone = bone
		elseif "string" == type(bone) then
			local displayData = CCSpriteDisplayData:create()
		    displayData.displayName = img

		    local boneData = CCBoneData:create()
		    boneData.name = bone

		    newBone = CCBone:create()

		    newBone:setBoneData(boneData)
		    newBone:addDisplay(displayData, 0)
		    newBone:changeDisplayByIndex(0, true)
		end

	    if pos then
	    	newBone:setPosition(pos)
	    end

	    armature:_addBone(newBone, parentName)
	end
end








----------------------
-- 公有方法  
----------------------
--[[--
添加骨骼动画信息文件

<br/>  
### Useage:
	DragonBone.addFile(文件路径)

### Aliases:

### Notice:
	只需传入文件的路径即可，函数内部会自动构造.png, .plist, .xml文件
### Example:
    ----------------------
    -- 示例1: 通用操作  
    ----------------------
	DragonBone.addFile("Dragon")
	local dragon = DragonBone.createArmature("Dragon")
	:to(self):pc()
	
	dragon:play("stand")

### Parameters:
-   string **filePath**      文件路径  

### Returns: 
-   nil  

--]]--
function DragonBone.addFile(filePath)
	-- 格式化png, plist, xml路径  
	local imagePath 		= string.format("%s.png", filePath)
	local plistPath 		= string.format("%s.plist", filePath)
	local configFilePath 	= string.format("%s.xml", filePath)

	-- 骨架数据管理对象  
	local armatureDataManager = CCArmatureDataManager:sharedArmatureDataManager()
    -- 添加骨架文件信息  
    armatureDataManager:addArmatureFileInfo(imagePath, plistPath, configFilePath)
end

--[[--
释放骨骼动画资源

<br/>  
### Notice:
	删除骨骼图片资源

--]]--
function DragonBone.removeFile()
	-- 需要更新quick-x-player  
	-- 2016/10/09 by 框架组 yqs  
 	-- CCArmatureDataManager:sharedArmatureDataManager():purgeArmatureSystem()  
end

--[[--
创建骨架

<br/>  
### Useage:
	DragonBone.createArmature(骨架名)

### Aliases:

### Notice:
	该函数返回的骨架对象拥有play, pause, resume, stop, getMovementCount, isTouchMe等方法
### Example:
    ----------------------
    -- 示例1: 通用操作  
    ----------------------
	DragonBone.addFile("Dragon")
	local dragon = DragonBone.createArmature("Dragon")
	:to(self):pc()
	
	dragon:play("stand")

### Parameters:
-   string **armatureName** 	骨架名  

### Returns: 
-   CCArmature 				骨架对象  

--]]--
function DragonBone.createArmature(armatureName, animOption)
	local armature = CCArmature:create(armatureName)
	-- 连接动作事件信号  
	_connectMovementEventSignal(armature, animOption)
	-- 复写CCArmature对象方法  
	_overrideArmature(armature)
	-- 拓展CCArmature对象  
	return _extendArmature(armature)
end

--[[--
创建骨架并播放动作

<br/>  
### Useage:
	DragonBone.createArmatureAndPlay(骨架名, 动作名, 帧率, 动作可选参数)

### Aliases:

### Notice:
	该函数返回的骨架对象拥有play, pause, resume, stop, getMovementCount, isTouchMe等方法
	movementHandler(__evtType, __moveId)函数会有两个形参。
	__evtType: 动作的执行状态。0:开始播放; 1:不循环的动作结束; 2:循环的动作结束一次循环
	__moveId:  动作的id
### Example:
    ----------------------
    -- 示例1: 通用操作  
    ----------------------
	DragonBone.addFile("Dragon")
	local dragon = DragonBone.createArmatureAndPlay("Dragon", "stand")
	:to(self):pc()

### Parameters:
-   string **armatureName** 	骨架名  
- 	string **animName** 		动作名  
- 	string **fps** 				帧率  
- 	string **animOption** 		动作可选参数  

### OptionParameters
- 	number   **durationTo** 		跳转到该动作需要补充的帧数，避免跳转太突兀。-1使用美术调整的节奏  
- 	number   **durationTween** 		跳转到该动作需要补充的帧数，避免跳转太突兀。-1使用美术调整的节奏  
- 	number   **loop** 				是否循环。<0使用的是美术调整的节奏，=0播放一遍，>0则循环  
- 	number 	 **tweenEasing 			两个关键帧之间的缓动  
- 	function ** movementHandler** 	动作结束的处理函数。  

### Returns: 
-   CCArmature 					骨架对象  

--]]--
function DragonBone.createArmatureAndPlay(armatureName, animName, fps, animOption)
	assert(armatureName, 
	"error in function 'createArmatureAndPlay'. argument #1 is nil; 'string' expected")
	assert(animName, 
	"error in function 'createArmatureAndPlay'. argument #2 is nil; 'string' expected")
	
	local armature = DragonBone.createArmature(armatureName, animOption)
	_playAnimation(armature, animName, fps, animOption)

    return armature
end

--[[--
添加骨骼动画信息文件，同时创建骨架并让骨架播放动作

<br/>  
### Useage:
	DragonBone.addFileAndPlay(文件路径, 骨架名, 动作名, 帧率, 动作可选参数)

### Aliases:

### Notice:
	该函数返回的骨架对象拥有play, pause, resume, stop, getMovementCount, isTouchMe等方法
	movementHandler(__evtType, __moveId)函数会有两个形参。
	__evtType: 动作的执行状态。0:开始播放; 1:不循环的动作结束; 2:循环的动作结束一次循环
	__moveId:  动作的id
### Example:
    ----------------------
    -- 示例1: 通用操作  
    ----------------------
	local dragon = DragonBone.addFileAndPlay("Dragon", "Dragon", "stand", 24 / 60, {
		durationTo = -1,
		durationTween = -1,
		loop = -1,
		tweenEasing = TWEEN_EASING_MAX,
	})
	:to(self):pc()
	
### Parameters:
-   string **filePath**      	文件路径  
- 	string **armatureName** 	骨架名字  
- 	string **animName** 		动作名字  
- 	string **fps**				帧率  
- 	string **animOption** 		动作的可选参数  

### OptionParameters
- 	number   **durationTo** 		跳转到该动作需要补充的帧数，避免跳转太突兀。-1使用美术调整的节奏  
- 	number   **durationTween** 		跳转到该动作需要补充的帧数，避免跳转太突兀。-1使用美术调整的节奏  
- 	number   **loop** 				是否循环。<0使用的是美术调整的节奏，=0播放一遍，>0则循环  
- 	number 	 **tweenEasing 			两个关键帧之间的缓动  
- 	function ** movementHandler** 	动作结束的处理函数。  

### Returns: 
-   CCArmature 					骨架对象  

--]]--
function DragonBone.addFileAndPlay(filePath, armatureName, animName, fps, animOption)
	-- 添加骨骼动画文件信息  
	DragonBone.addFile(filePath)	

    return DragonBone.createArmatureAndPlay(armatureName, animName, fps, animOption)
end

return DragonBone