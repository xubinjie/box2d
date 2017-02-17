--[[
	节点1类
--]]


local M 	= classSprite("Node1")




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
	M.super.onRender(self)

 	-- [本类调用]
	-- 加载节点
	self:loadDisplay() 
	-- 加载渲染以外的其他操作
	self:loadRenderOtherwise()
end 

-- 加载节点
function M:loadDisplay()
	self:display("g/box/r.png")
end 

-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
	self:bindTouch()
	self:bodyA()
	self:bodyB()

	-- self.dj = self:createDistanceJoint(bodyA, bodyB, 5)
	self:createRevoluteJoint(bodyA, bodyB) 
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
	self.mj = self:createMouseJoint(x, y, bodyA)
	
return SIGN_TOUCH_BEGAN_SWALLOWS 
end

function M:onTouchMoved(x, y, touches)
	 self.mj:SetTarget(b2Vec2(x/32, y/32))
end

function M:onTouchEnded(x, y, touches)
	world:DestroyJoint(self.mj)
	self.mj = nil
	-- if self.dj then
	-- world:DestroyJoint(self.dj)
	-- self.dj = nil
	-- self:applyF()
	-- end
	-- bodyA.fixedRotation = false
	-- bodyA:SetFixedRotation(false)
	-- bodyA:SetAngularVelocity(-30)
end








--------------------------
-- 功能函数
--------------------------
--
function M:bodyA()
	local def = b2BodyDef()
	def.type = b2_dynamicBody
	def.position = b2Vec2(480/bl, 420/bl)
	-- def.fixedRotation = true
	local body = world:CreateBody(def)
	body.angularDamping = 3000

	--创建夹具定义
	local fixtureDef = b2FixtureDef()
	--创建一个多边形
	local shape = b2PolygonShape()
	shape:SetAsBox(20/32, 70/32)
	--赋值给材质的属性
	fixtureDef.shape       = shape
	--摩擦
	fixtureDef.friction    = .1
	--恢复
	fixtureDef.restitution = .1
	--密度
	fixtureDef.density     = .02
	--用户数据
	body:CreateFixture(fixtureDef)
	bodyA = body
end

--
function M:bodyB()
	local bodyDef      = b2BodyDef()
	bodyDef.position   = b2Vec2(480/bl, 250/bl)
	--动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
	bodyDef.type       = b2_staticBody
	--允许休眠
	bodyDef.allowSleep = true
	local body         = world:CreateBody(bodyDef)
	bodyB = body	
end

--施加力
function M:applyF()
	-- local force = b2Vec2(150,150)
	--  bodyA:ApplyForce(force, bodyA:GetPosition())
	local impulse = b2Vec2(2, 3)
	bodyA:ApplyLinearImpulse(impulse, bodyA:GetPosition())
end

function M:tongbu( )
	local pos = bodyA:GetPosition()
	self:p(pos.x*32, pos.y*32)
	local ang = bodyA:GetAngle()
	local ang2 = -math.deg(ang)
	self:rotate(ang2)
	-- print("===111====", bodyA:GetLinearVelocity().x)
	-- print("===111====", bodyA:IsAwake())
end




--鼠标关节，x，y设置关节位置，刚体bodyA, bodyB
function M:createMouseJoint(x, y, bodyB)
	local mouseJointDef            = b2MouseJointDef()
	--刚体A,设置成空的刚体
	mouseJointDef.bodyA            = self:bodyNil()
	--刚体B,被鼠标关节约束的刚体
	mouseJointDef.bodyB            = bodyB
	--被约束的刚体是否发生可以碰撞
	mouseJointDef.collideConnected = true
	--阻尼
	mouseJointDef.frequencyHz      = 64
	--最大的力
	mouseJointDef.maxForce         = 100
	--关节的位置
	mouseJointDef.target           = b2Vec2(x/32, y/32)
	local mouseJt = tolua.cast(world:CreateJoint(mouseJointDef), "b2MouseJoint")
	return mouseJt
end

--创建一个空的bodyA
function M:bodyNil()
	local bodyDef      = b2BodyDef()
	bodyDef.position   = b2Vec2(0,0)
	--动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
	bodyDef.type       = b2_staticBody
	-- 允许休眠
	-- bodyDef.allowSleep = true
	-- userData           = NULL
	local body1         = world:CreateBody(bodyDef)
	return body1
end

--创建距离关节：刚体A 刚体B 长度
function M:createDistanceJoint(bodyA, bodyB, lenght)
	local jointDef              = b2DistanceJointDef()
	jointDef.bodyA              = bodyA
	jointDef.bodyB              = bodyB
	jointDef.lenght             = 0
	jointDef.frequencyHz        = 10000
	-- 是否碰撞
	jointDef.collideConnected   = false
	local point = b2Vec2(bodyA:GetWorldCenter().x, (bodyA:GetWorldCenter().y*32-70)/32)
	jointDef:Initialize(bodyA, bodyB, point, bodyB:GetWorldCenter())
	local joint = world:CreateJoint(jointDef)
	return joint
end

--创建旋转关节, 
function M:createRevoluteJoint(bodyA, bodyB)
	local jointDef            = b2RevoluteJointDef()
    --初始化关节，第一个是需要旋转的刚体，第三个是围绕的是哪个刚体旋转
	jointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter())
	world:CreateJoint(jointDef)
end



--------------------------
-- 属性
--------------------------




--------------------------
-- 父类重写
-------------------------- 




return M






