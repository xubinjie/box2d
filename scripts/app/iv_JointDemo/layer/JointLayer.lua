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
	self:createWorld()
	self:createEdge()
	self:createBodyA()
	self:createBodyB()
	self:createBodyC()
	-- self:createPrismaticJoint(self.bodyA, self.bodyB)
	self:createRopeJoint(self.bodyA, self.bodyB, 5)
	-- self:createFriction(self.bodyA, self.bodyB)
	-- self:createRevoluteJoint(self.bodyA, self.bodyC)
	-- self:createDistanceJoint(self.bodyA, self.bodyB, 2)
	-- 加载渲染以外的其他操作
	self:loadRenderOtherwise()
end





-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
	A.cycle({
		{"fn", function()
			--开始模拟
			world:Step(1/60, 1, 1)
		end},
		{"delay", 1/60},
	}):at(self) 

	local debugDraw = GB2DebugDrawLayer:create(world, 32)
	self:add(debugDraw, 9999)  
	self:bindTouch() 
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
	if not self.mouseJoint then
		self.mouseJoint = self:createMouseJoint(x, y, self.edgeBody, self.bodyA )
	end
return true 
end

function M:onTouchMoved(x, y, touches)
	if self.mouseJoint then
		self.mouseJoint:SetTarget(b2Vec2(x/32, y/32))
	end
end

function M:onTouchEnded(x, y, touches)
	if self.mouseJoint then
		world:DestroyJoint(self.mouseJoint)
		self.mouseJoint = nil
	end
end








--------------------------
-- 功能函数
--------------------------
function M:createWorld()
	local gravity = b2Vec2(0, -10)
	world = b2World(gravity)
	--为物理世界设置两个属性
	--进行模拟时快速跳过不需要处理的刚体,可以提高物理世界中物体的处理效率，只有在发生碰撞时才唤醒该对象。当动态物体静止时使它休眠，减少性能开销
	world:SetAllowSleeping(true)
	--开启物理世界的连续检测，了物理模拟的更加真实，（虽然这会消耗一定性能）速度较快的两个物体碰撞时就可能会产生“穿透”现象，启用特殊的算法来避免该现象。
	world:SetContinuousPhysics(true)
end

--创建边缘
function M:createEdge(  )
	local bodyDef      = b2BodyDef()
	bodyDef.position   = b2Vec2(0/32, 0/32)
	--动态刚体b2_dynamicBody,静态刚体b2_staticBody,平台刚体b2_kinematicBody
	bodyDef.type       = b2_staticBody
	--允许休眠
	bodyDef.allowSleep = true
	-- userData           = NULL
	local body         = world:CreateBody(bodyDef)
	local edgePosX = {b2Vec2(0/32, 0/32), b2Vec2(960/32, 0/32), b2Vec2(960/32, 540/32), b2Vec2(0/32, 540/32)}
	local edgePosY = {b2Vec2(960/32, 0/32), b2Vec2(960/32, 540/32), b2Vec2(0/32, 540/32), b2Vec2(0/32, 0/32)}
	for i=1,4 do
		--创建夹具定义
		local fixtureDef = b2FixtureDef()
		local shape = b2EdgeShape()
		shape:Set(edgePosX[i], edgePosY[i])
		--赋值给材质的属性
		fixtureDef.shape       = shape
		--摩擦
		fixtureDef.friction    = .3
		--恢复
		fixtureDef.restitution = .2
		--密度
		fixtureDef.density     = .3
		--用户数据
		body:CreateFixture(fixtureDef)
	end
	self.edgeBody = body
end

function M:createBodyA( )
	local bodyDef      = b2BodyDef()
	bodyDef.position   = b2Vec2(400/32, 50/32)
	--动态刚体b2_dynamicBody,静态刚体b2_staticBodym,平台刚体b2_kinematicBody
	bodyDef.type       = b2_dynamicBody
	--允许休眠
	bodyDef.allowSleep = true
	-- userData           = NULL
	local body         = world:CreateBody(bodyDef)
	
	--创建夹具定义
	local fixtureDef = b2FixtureDef()
	--创建一个多边形
	-- local shape = b2PolygonShape()
	-- shape:SetAsBox(60/32, 50/32)
	local shape = b2CircleShape()
	shape.m_radius = 1.5
	--赋值给材质的属性
	fixtureDef.shape       = shape
	--摩擦
	fixtureDef.friction    = 100
	--恢复
	fixtureDef.restitution = .2
	--密度
	fixtureDef.density     = .05
	--用户数据
	-- userData               = NULL
	body:CreateFixture(fixtureDef)
	self.bodyA = body
end

function M:createBodyB( )
	local bodyDef      = b2BodyDef()
	bodyDef.position   = b2Vec2(400/32, 150/32)
	--动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
	bodyDef.type       = b2_staticBody
	--允许休眠
	bodyDef.allowSleep = true
	-- userData           = NULL
	local body         = world:CreateBody(bodyDef)

	--创建夹具定义
	local fixtureDef = b2FixtureDef()
	--创建一个多边形
	local shape = b2PolygonShape()
	shape:SetAsBox(60/32, 50/32)
	--赋值给材质的属性
	fixtureDef.shape       = shape
	--摩擦
	fixtureDef.friction    = 111
	--恢复
	fixtureDef.restitution = .2
	--密度
	fixtureDef.density     = .9
	--用户数据
	-- userData               = NULL
	body:CreateFixture(fixtureDef)
	self.bodyB = body	
end

--创建刚体C
function M:createBodyC( )
	local bodyDef      = b2BodyDef()
	bodyDef.position   = b2Vec2(400/32, 50/32)
	--动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
	bodyDef.type       = b2_dynamicBody
	--允许休眠
	bodyDef.allowSleep = true
	userData           = NULL
	local body         = world:CreateBody(bodyDef)
	self.bodyC = body
end

--创建移动关节
function M:createPrismaticJoint(bodyA, bodyB)
	local jointDef = b2PrismaticJointDef()
	--移动的单元轴，就是刚体A的移动方向
	local directVec     = b2Vec2(30, 0)
	--是否开启限制,限制的移动的长度，单位为米
	jointDef.enableLimit = true
	--最小限制，限制的方向与单元轴相反
	jointDef.lowerTranslation = -4
	--最大限制，限制的方向与单元轴一直
	jointDef.upperTranslation = 4

	--是否开启碰撞
	jointDef.collideConnected  = false
	--是否启动马达
	-- enableMotor = true
	-- maxMotorForce = 3000
	-- motorSpeed = 5
	--限制角度
	referenceAngle = 5
	jointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter(), directVec)
	local joint = tolua.cast(world:CreateJoint(jointDef), "b2PrismaticJoint")
end

--鼠标关节，x，y设置关节位置，刚体bodyA, bodyB
function M:createMouseJoint(x, y, bodyA, bodyB)
	local mouseJointDef            = b2MouseJointDef()
	--刚体A,设置成世界的边缘
	mouseJointDef.bodyA            = bodyA
	--刚体B,被鼠标关节约束的刚体
	mouseJointDef.bodyB            = bodyB
	--被约束的刚体是否发生可以碰撞
	mouseJointDef.collideConnected = true
	--阻尼
	mouseJointDef.frequencyHz      = 30
	--最大的力
	mouseJointDef.maxForce         = 300
	--关节的位置
	mouseJointDef.target           = b2Vec2(x/32, y/32)
	local mouseJt = tolua.cast(world:CreateJoint(mouseJointDef), "b2MouseJoint")
	return mouseJt
end

--创建绳索关节
function M:createRopeJoint(bodyA, bodyB, maxLength)
	local jointDef            = b2RopeJointDef()
	--最大长度
	jointDef.maxLength        = maxLength or 3
	jointDef.bodyA            = bodyA
	jointDef.bodyB            = bodyB
	--设置两个刚体的相衔接的锚点位置
	jointDef.localAnchorA     = b2Vec2(0, 0)
	jointDef.localAnchorB     = b2Vec2(2, 0)
	jointDef.collideConnected = true
	local joint = tolua.cast(world:CreateJoint(jointDef), "b2RopeJoint")
	return joint
end

--创建摩擦关节
--摩擦关节是降低两个关节相对运动
function M:createFriction(bodyA, bodyB)
	local jointDef = b2FrictionJointDef()
	jointDef.bodyA = bodyA
	jointDef.bodyB = bodyB
	jointDef.localAnchorA = b2Vec2(0,0)
	jointDef.localAnchorB = b2Vec2(0,0)
	--关节最大的摩擦力
	jointDef.maxForce = 100
	--关节最大扭力
	maxTorque = 10
	jointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter())
	local joint = tolua.cast(world:CreateJoint(jointDef), "b2FrictionJoint")
	return joint
end

--创建旋转关节
function M:createRevoluteJoint(bodyA, bodyB)
	local jointDef            = b2RevoluteJointDef()
	--是否连续碰撞
	jointDef.collideConnected = false
	-- 马达速度
    jointDef.motorSpeed       = -1
    -- 马达最大扭力
    jointDef.maxMotorTorque   = 400
    -- 是否启动马达
    jointDef.enableMotor      =true
    --初始化关节，第一个是需要旋转的刚体，第三个是围绕的是哪个刚体旋转
	jointDef:Initialize(bodyA, bodyB, bodyA:GetWorldCenter())
	local joint = world:CreateJoint(jointDef)
	self.jointA = joint
end

--创建齿轮关节
function M:createGearJoint(bodyA, bodyB, jointA, jointB)
	local jointDef  = b2GearJointDef()
	jointDef.bodyA  = bodyA
	jointDef.bodyB  = bodyB
	jointDef.joint1 = jointA
	jointDef.joint2 = jointB
	jointDef.ratio  = 1
end

--创建距离关节：刚体A 刚体B 长度
function M:createDistanceJoint(bodyA, bodyB, lenght)
	local jointDef              = b2DistanceJointDef()
	jointDef.bodyA              = bodyA
	jointDef.bodyB              = bodyB
	jointDef.lenght             = lenght
	jointDef.frequencyHz        = 0.01
	-- 是否碰撞
	jointDef.collideConnected   = true
	jointDef:Initialize(bodyA, bodyB, bodyA:GetWorldCenter(), bodyB:GetWorldCenter())
	local joint = world:CreateJoint(jointDef)
	return joint
end


--------------------------
-- 属性
--------------------------




--------------------------
-- 父类重写
-------------------------- 




return M






