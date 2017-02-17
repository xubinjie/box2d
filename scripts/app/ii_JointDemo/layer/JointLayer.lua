--[[
	xx场景xx层类


--]]


local M    = classLayer("Joint")




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
	-- 创建游戏中的物理世界
	self:createWorld()
	self:createEdge()
	--使用了鼠标关节，还需在touch事件中取消那些代码注释
	self:createBodyA()
	-- self:createBodyB()

	--使用了旋转关节
	-- self:createBodyC()
	-- self:createBodyD()
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

		if i == 4 then
			edgeBodyB = edgeBody
		end
	end
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
	-- self:createMouseJoint(x, y)
return true 
end

function M:onTouchMoved(x, y, touches)
 	if self.mouseJt then
 		-- 设置关节的位置
 		-- print("==============移动=============")
		-- self.mouseJt:SetTarget(b2Vec2(x/32, y /32))
 	end
end

function M:onTouchEnded(x, y, touches)
  -- if self.mouseJt then
  -- 	self.world:DestroyJoint(self.mouseJt)
  -- 	self.mouseJt = nil
  -- end 
end








--------------------------
-- 功能函数
--------------------------
--矩形刚体
function M:createBodyA()
	--创建一个底座
	local testBodyDef    = b2BodyDef()
	testBodyDef.position = b2Vec2(480/32, 270/32)
	--设置为静态
	-- b2_dynamicBody
	-- b2_staticBody
	testBodyDef.type       = b2_dynamicBody
	testBodyDef.allowSleep = true
	testBody               = self.world:CreateBody(testBodyDef)

	local testFixtureDef   = b2FixtureDef()
	local testShape        = b2PolygonShape()
	testShape:SetAsBox(150/32, 20/32)
	testFixtureDef.shape   = testShape
	testFixtureDef.friction    = .5
	testFixtureDef.restitution = .1
	testFixtureDef.density     = .6

	testBody:CreateFixture(testFixtureDef)

	self.bodyA                 = testBody
end

--十字形刚体
function M:createBodyB( )
	--创建一个底座
	local testBodyDef    = b2BodyDef()
	testBodyDef.position = b2Vec2(480/32, 300/32)
	--设置为静态
	-- b2_dynamicBody
	testBodyDef.type     = b2_dynamicBody
	-- testBodyDef.allowSleep = true
	testBody             = self.world:CreateBody(testBodyDef)

	local testFixtureDef = b2FixtureDef()
	local testShape      = b2PolygonShape()
	testShape:SetAsBox(80/32, 10/32)
	testFixtureDef.shape = testShape
	testFixtureDef.friction    = .5
	testFixtureDef.restitution = .1
	testFixtureDef.density     = 5

	testBody:CreateFixture(testFixtureDef)

	local testFixtureDef2      = b2FixtureDef()
	local testShape            = b2PolygonShape()
	testShape:SetAsBox(10/32, 80/32)
	testFixtureDef2.shape      = testShape
	testFixtureDef2.friction   = .5
	testFixtureDef2.restitution = .1
	testFixtureDef2.density    = 5

	testBody:CreateFixture(testFixtureDef2)

	self.bodyB = testBody

	self:createRevoluteJoint()
end

--创建旋转关节
function M:createRevoluteJoint( )
	local jointDef            = b2RevoluteJointDef()
	--是否连续碰撞
	jointDef.collideConnected = true
	-- 马达速度
    jointDef.motorSpeed       = 5
    -- 马达最大扭力
    jointDef.maxMotorTorque   = 400
    -- 是否启动马达
    jointDef.enableMotor      = true
    --初始化关节，第一个是需要旋转的刚体，第三个是围绕的是哪个刚体旋转
	jointDef:Initialize(self.bodyB, self.bodyA, self.bodyB:GetWorldCenter())
	self.world:CreateJoint(jointDef)
end

--刚体C
function M:createBodyC()
	--放在中间，设置小一些
	local testBodyDef    = b2BodyDef()
	testBodyDef.position = b2Vec2(480/32, 270/32)
	--设置为静态
	-- b2_dynamicBody
	testBodyDef.type     = b2_staticBody
	testBodyDef.allowSleep = true
	testBody             = self.world:CreateBody(testBodyDef)

	local testFixtureDef = b2FixtureDef()
	local testShape      = b2PolygonShape()
	testShape:SetAsBox(15/32, 2/32)
	testFixtureDef.shape = testShape
	testFixtureDef.friction    = .5
	testFixtureDef.restitution = .1
	testFixtureDef.density     = 1

	testBody:CreateFixture(testFixtureDef)

	self.bodyC                 = testBody
end

--十字形刚体，体积较小
function M:createBodyD( )
	--创建一个底座
	local testBodyDef = b2BodyDef()
	testBodyDef.position = b2Vec2(480/32, 350/32)
	--设置为静态
	-- b2_dynamicBody
	testBodyDef.type = b2_dynamicBody
	-- testBodyDef.allowSleep = true
	testBody = self.world:CreateBody(testBodyDef)

	local testFixtureDef = b2FixtureDef()
	local testShape = b2PolygonShape()
	testShape:SetAsBox(30/32, 1/32)
	testFixtureDef.shape = testShape
	testFixtureDef.friction = .5
	testFixtureDef.restitution = .1
	testFixtureDef.density = 5

	testBody:CreateFixture(testFixtureDef)

	local testFixtureDef2 = b2FixtureDef()
	local testShape = b2PolygonShape()
	testShape:SetAsBox(1/32, 30/32)
	testFixtureDef2.shape = testShape
	testFixtureDef2.friction = .5
	testFixtureDef2.restitution = .1
	testFixtureDef2.density = 5

	testBody:CreateFixture(testFixtureDef2)

	self.bodyD = testBody

	self:createRevoluteJoint2()
end

--设置第二种旋转关节
function M:createRevoluteJoint2( )
	local jointDef = b2RevoluteJointDef()
	--是否连续碰撞
	jointDef.collideConnected = true
	-- 马达速度
    jointDef.motorSpeed = 1
    -- 马达最大扭力
    jointDef.maxMotorTorque = 40
    -- 是否启动马达
    jointDef.enableMotor=true
    --初始化关节，第一个是需要旋转的刚体，第三个是围绕的是哪个刚体旋转
	jointDef:Initialize(self.bodyC, self.bodyD, self.bodyD:GetWorldCenter())
	self.world:CreateJoint(jointDef)
end

--鼠标关节
function M:createMouseJoint(x, y)
	if not self.mouseJt then
		print("=======创建鼠标关节======")
		local mouseJtDef            = b2MouseJointDef()
		--被鼠标关节约束的刚体
		mouseJtDef.bodyA            = edgeBodyB
		--世界的边缘
		mouseJtDef.bodyB            = self.bodyA
		--阻尼
		mouseJtDef.frequencyHz      = 64
		--被约束的敢提是否发生可以碰撞
		mouseJtDef.collideConnected = true 
		--最大的力
		mouseJtDef.maxForce         = 300
		-- 关节的位置
		mouseJtDef.target           = b2Vec2(x/32, y/32)
		
		self.mouseJt = tolua.cast(self.world:CreateJoint(mouseJtDef), "b2MouseJoint")
	end
end


--------------------------
-- 属性
--------------------------




--------------------------
-- 父类重写
-------------------------- 




return M






