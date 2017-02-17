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
 	--初始化位置
 	self.iniP = params.iniP
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
	self.mj = self:createMouseJoint(x, y)
return SIGN_TOUCH_BEGAN_SWALLOWS 
end

function M:onTouchMoved(x, y, touches)
	self.mj:SetTarget(b2Vec2(x/32, y/32))   
end

function M:onTouchEnded(x, y, touches)
	world:DestroyJoint(self.mj)
	self.mj = nil
end








--------------------------
-- 功能函数
--------------------------
--创建精灵刚体
function M:addBodyA()
	local bodyDef      = b2BodyDef()
	bodyDef.position   = b2Vec2(self.iniP.x/32, self.iniP.y/32)
	--动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
	bodyDef.type       = b2_dynamicBody
	--允许休眠
	bodyDef.allowSleep = true
	userData           = self
	bodyDef.fixedRotation = true
	local body         = world:CreateBody(bodyDef)
	
	-- --创建夹具定义
	-- local fixtureDef = b2FixtureDef()
	-- --创建一个多边形
	-- local shape = b2PolygonShape()
	-- shape:SetAsBox(40/32, 40/32)
	-- --赋值给夹具的属性
	-- fixtureDef.shape       = shape
	-- --摩擦
	-- fixtureDef.friction    = .3
	-- --恢复
	-- fixtureDef.restitution = .2
	-- --密度
	-- fixtureDef.density     = .1
	-- body:CreateFixture(fixtureDef)

	self.body = body
	self:addComplexFixture(body,"r.plist", "r")
	
end

--同步刚体数据
function M:synchronizationFn( )
	-- --同步位置
	local pos = self.body:GetPosition()
	self:p(pos.x*32, pos.y*32)

	--同步角度
	local ang = self.body:GetAngle()
	self:rotate(-math.deg(ang))
end


-- --鼠标关节，x，y设置关节位置，刚体bodyA, bodyB
function M:createMouseJoint(x, y)
	local mouseJointDef            = b2MouseJointDef()
	-- 刚体A,从b2JointDef里面继承的，在鼠标关节中不受节点的约束，不参与关节的约束性的活动，
	-- 但是这个属性又不能为空，所以通常设置一个空的刚体
	mouseJointDef.bodyA            = self:bodyA()
	--刚体B,被鼠标关节约束的刚体
	mouseJointDef.bodyB            = self.body
	--被约束的刚体是否发生可以碰撞
	mouseJointDef.collideConnected = true
	--
	mouseJointDef.frequencyHz      = 64
	--最大的力
	mouseJointDef.maxForce         = 30000
	--关节的位置
	mouseJointDef.target           = b2Vec2(x/32, y/32)
	local mouseJt = tolua.cast(world:CreateJoint(mouseJointDef), "b2MouseJoint")
	return mouseJt
end

--创建一个空的bodyA
function M:bodyA()
	local bodyDef      = b2BodyDef()
	bodyDef.position   = b2Vec2(0,0)
	--动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
	bodyDef.type       = b2_staticBody
	-- 允许休眠
	-- bodyDef.allowSleep = true
	-- userData           = NULL
	local body         = world:CreateBody(bodyDef)
	return body
end


-- self:addComplexFixture(body,"r.plist", "r")

--[[--
添加复杂的纹理
-   b2Body  **body**        [必选] 刚体对象
-   String  **plistPath**   [必选] PhysicsEditor导出的.plist文件
-   String  **key**         [必选] plist文件中物理形状图片名称

### Returns:
--]]--
function M:addComplexFixture(body, plistPath, key)
    -- 加载physicsDesigner的.plist格式文件
    GB2ShapeCache:sharedGB2ShapeCache():addShapesWithFile(plistPath)
    -- 把生成的刚体和形状绑在一起，key即图片名
    GB2ShapeCache:sharedGB2ShapeCache():addFixturesToBody(body, key)
    -- 获取plist里面的锚点信息
    local anchor    = GB2ShapeCache:sharedGB2ShapeCache():anchorPointForShape(key)
    -- 获取刚体的用户数据，并转换为CCSprite类型
    local userData  = tolua.cast(body:GetUserData(), "CCSprite")
    -- 如果用户数据存在并且是精灵类型，设置精灵锚点为plist文件里面的刚体锚点位置（同步锚点）。
    if userData then userData:setAnchorPoint(anchor) end
end

--------------------------
-- 属性
--------------------------




--------------------------
-- 父类重写
-------------------------- 




return M






