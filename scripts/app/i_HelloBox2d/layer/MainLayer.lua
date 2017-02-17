--[[--

方法

### Useage:

### Aliases:

### Notice:
	说明

### Example:

### Parameters:
- 	类型 	**参数名** 				[可选性] 参数说明

### OptionParameters

### Returns: 
-   返回值类型 							返回值说明

--]]--[[
xx场景xx层类


--]]


local M    = classLayer("Main")




--------------------------
-- 构造函数
--------------------------

function M:ctor(params)
-- [超类调用]
M.super.ctor(self, params)
  -- [本类调用]
end

--------------------------
-- 渲染
--------------------------

function M:onRender()
	-- [超类调用]
	M.super.onRender(self)

	-- [本类调用]
	-- 创建物理世界
	self:createWorld()
	-- self:createGround()
	self:createEdge()
	-- A.cycle({
	-- 	{"delay", .3},
	-- 	{"fn", function()
	-- 	 	 self:creatCircleBody()
	-- 	end},
	-- }):at(self)
	
	A.cycle({
		{"fn", function()
			--开始模拟
			self.world:Step(1/60, 1, 1)
		end},
		{"delay", 1/60},
	}):at(self)

	-- 加载渲染以外的其他操作
	self:loadRenderOtherwise()
end 



-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
	self:bindTouch()
	local debugDraw = GB2DebugDrawLayer:create(self.world, 32)
	self:add(debugDraw, 9999)
end




--------------------------
-- 析构
--------------------------

function M:onDestructor()
  -- [超类调用]
M.super.onDestructor(self)

-- [本类调用]
end








--------------------------
-- 触控
-------------------------- 

function M:onTouchBegan(x, y, touches)
--  触控有效
return true 
end

function M:onTouchMoved(x, y, touches)
--   
end

function M:onTouchEnded(x, y, touches)
--  
end








--------------------------
-- 功能函数
--------------------------
--创建游戏中的物理世界
function M:createWorld( )
	--定义重力
	local gravity = b2Vec2(0, -10)
	--调用世界的构造函数，返回一个物理世界
	local world = b2World(gravity)

	--为物理世界设置两个属性
	--进行模拟时快速跳过不需要处理的刚体,可以提高物理世界中物体的处理效率，只有在发生碰撞时才唤醒该对象。当动态物体静止时使它休眠，减少性能开销
	world:SetAllowSleeping(true)
	--开启物理世界的连续检测，了物理模拟的更加真实，（虽然这会消耗一定性能）速度较快的两个物体碰撞时就可能会产生“穿透”现象，启用特殊的算法来避免该现象。
	world:SetContinuousPhysics(true)

	self.world = world
end

--创建底面
function M:createGround( )
	local groundDef = b2BodyDef()
	groundDef.position = b2Vec2(480/32, 0/32)
	--允许休眠
	groundDef.allowSleep = true
	--
	groundBody = self.world:CreateBody(groundDef)

	groundFixtureDef = b2FixtureDef()
	local groundShape = b2PolygonShape()
	groundShape:SetAsBox(960/32, 1/32)
	--设置形状
	groundFixtureDef.shape = groundShape
	--摩擦系数
	groundFixtureDef.friction = 0.1

	groundBody:CreateFixture(groundFixtureDef)

end

--创建世界的边缘，在这个范围内进行物理的模拟运算
--这个创建出来的刚体是静态的不会动
function M:createEdge( )
	local edgePos = {b2Vec2(0, 270/32), b2Vec2(960/32, 270/32), b2Vec2(480/32, 0/32), b2Vec2(480/32, 540/32)}
	local edgeWidths = {1/32, 1/32, 960/32 , 960/32}
	local edgeHeights = {540/32, 540/32, 1/32 , 1/32}
	for i=1,4 do
		local edgeDef = b2BodyDef()
		edgeDef.position = edgePos[i]
		--允许休眠
		edgeDef.allowSleep = true
		--创建刚体
		edgeBody = self.world:CreateBody(edgeDef)
		--创建夹具定义
		edgeFixtureDef = b2FixtureDef()
		--创建形状
		local edgeShape = b2PolygonShape()
		edgeShape:SetAsBox(edgeWidths[i], edgeHeights[i])
		--设置形状
		edgeFixtureDef.shape = edgeShape
		--摩擦系数
		edgeFixtureDef.friction = 0.05
		--创建夹具
		edgeBody:CreateFixture(edgeFixtureDef)
	end
end

--创建圆形刚体，并设置类型为动态，再设置其材质属性
function M:creatCircleBody( )
	local circleDef = b2BodyDef()
	circleDef.position = b2Vec2(RD.number(300, 500)/32, 480/32)
	circleDef.type = b2_dynamicBody
	circleDef.allowSleep = true
	circleBody = self.world:CreateBody(circleDef)
	circleFixtureDef = b2FixtureDef()
	local circleShape = b2CircleShape()
	circleShape.m_radius = .5
	circleFixtureDef.shape = circleShape
	--设置材质的相关属性
	--摩擦力，影响移动、旋转等等
	circleFixtureDef.friction = 1.5
	--恢复系数，影响碰撞后的反弹等等
	circleFixtureDef.restitution = .5
	--密度，影响质量等等
	circleFixtureDef.density = 1

	circleBody:CreateFixture(circleFixtureDef)

end



--------------------------
-- 属性
--------------------------




--------------------------
-- 父类重写
-------------------------- 




return M






