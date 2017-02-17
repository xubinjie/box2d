--[[
	测试精灵类
--]]


local M 	= classSprite("TestNode")




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
	self:addBodyA() 
	-- 加载渲染以外的其他操作
	self:loadRenderOtherwise()
end 

-- 加载节点
function M:loadDisplay()
	self:display("g/box/r.png")
end 

-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
	-- 

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
	-- self.mj = self:createMouseJoint(x, y)
return SIGN_TOUCH_BEGAN_SWALLOWS 
end

function M:onTouchMoved(x, y, touches)
	-- self.mj:SetTarget(b2Vec2(x/32, y/32))   
end

function M:onTouchEnded(x, y, touches)
	-- world:DestroyJoint(self.mj)
	-- self.mj = nil
end








--------------------------
-- 功能函数
--------------------------
--创建精灵刚体
function M:addBodyA()
	local bodyDef      = b2BodyDef()
	bodyDef.position   = b2Vec2(100/32, 100/32)
	--动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
	bodyDef.type       = b2_dynamicBody
	--允许休眠
	bodyDef.allowSleep = true
	userData           = self
	local body         = world:CreateBody(bodyDef)
	
	--创建夹具定义
	local fixtureDef = b2FixtureDef()
	--创建一个多边形
	local shape = b2PolygonShape()
	shape:SetAsBox(40/32, 40/32)
	--赋值给材质的属性
	fixtureDef.shape       = shape
	--摩擦
	fixtureDef.friction    = .3
	--恢复
	fixtureDef.restitution = .2
	--密度
	fixtureDef.density     = .1
	body:CreateFixture(fixtureDef)
	self.body = body
end

--同步刚体数据
function M:synchronizationFn( )
	-- --同步位置
	-- local pos = self.body:GetPosition()
	-- self:p(pos.x*32, pos.y*32)

	-- --同步角度
	-- local ang = self.body:GetAngle()
	-- self:rotate(-math.deg(ang))
end


-- --鼠标关节，x，y设置关节位置，刚体bodyA, bodyB
-- function M:createMouseJoint(x, y)
-- 	local mouseJointDef            = b2MouseJointDef()
-- 	-- 刚体A,从b2JointDef里面继承的，在鼠标关节中不受节点的约束，不参与关节的约束性的活动，
-- 	-- 但是这个属性又不能为空，所以通常设置一个空的刚体
-- 	mouseJointDef.bodyA            = self:bodyA()
-- 	--刚体B,被鼠标关节约束的刚体
-- 	mouseJointDef.bodyB            = self.body
-- 	--被约束的刚体是否发生可以碰撞
-- 	mouseJointDef.collideConnected = true
-- 	--
-- 	mouseJointDef.frequencyHz      = 12
-- 	--最大的力
-- 	mouseJointDef.maxForce         = 3000
-- 	--关节的位置
-- 	mouseJointDef.target           = b2Vec2(x/32, y/32)
-- 	local mouseJt = tolua.cast(world:CreateJoint(mouseJointDef), "b2MouseJoint")
-- 	return mouseJt
-- end

-- --创建一个空的bodyA
-- function M:bodyA()
-- 	local bodyDef      = b2BodyDef()
-- 	bodyDef.position   = b2Vec2(0,0)
-- 	--动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
-- 	bodyDef.type       = b2_staticBody
-- 	-- 允许休眠
-- 	-- bodyDef.allowSleep = true
-- 	-- userData           = NULL
-- 	local body         = world:CreateBody(bodyDef)
-- 	return body
-- end

--------------------------
-- 属性
--------------------------




--------------------------
-- 父类重写
-------------------------- 




return M






