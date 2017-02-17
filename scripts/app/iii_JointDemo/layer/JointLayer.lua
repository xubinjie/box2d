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
    self.bodys = {}
    self.bodyPos = {b2Vec2(100/32, 100/32), b2Vec2(300/32, 100/32)}
end

--------------------------
-- 渲染
--------------------------

function M:onRender()
	-- [超类调用]
	M.super.onRender(self)
	-- [本类调用]

	--创建物理世界
	self:createWorld()
	--创建世界的边缘
	self:createEdge()
	self:createBodyB()
	self:createBodyCircle(1)
	self:createBodyCircle(2)
	--焊接关节
	-- self:createWeldJoint(self.bodys[1],self.bodyA)
	-- self:createWeldJoint(self.bodys[2],self.bodyA)
	--距离关节
	self:createDistanceJoint(self.bodys[1], self.bodyA, 5)
	-- self:createDistanceJoint(self.bodys[2], self.bodyA, 5)
	-- self:createDistanceJoint(self.bodys[1],self.bodys[2], 3)
	--旋转关节
	-- self:createRevoluteJoint(self.bodyA ,self.bodys[1])  
	-- 加载渲染以外的其他操作
	self:loadRenderOtherwise()
end 

 

-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
	A.cycle({
		{"fn", function()
			--开始模拟
			self.world:Step(1/60, 1, 1)
		end},
		{"delay", 1/60},
	}):at(self) 

	local debugDraw = GB2DebugDrawLayer:create(self.world, 32)
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
  self:createMouseJoint(x, y)
return true 
end

function M:onTouchMoved(x, y, touches)
   if self.mouseJt then
 		-- 设置关节的位置
 		-- print("==============移动=============")
		self.mouseJt:SetTarget(b2Vec2(x/32, y /32))
 	end
end

function M:onTouchEnded(x, y, touches)
	if self.mouseJt then
		self.world:DestroyJoint(self.mouseJt)
		self.mouseJt = nil
	end 
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

--创建圆形刚体
function M:createBodyCircle(i)
	local bodyDef = b2BodyDef()
	
	bodyDef.position = self.bodyPos[i]
	--动态刚体
	bodyDef.type = b2_dynamicBody
	--允许休眠
	bodyDef.allowSleep = true
	local body = self.world:CreateBody(bodyDef)
	--创建夹具定义
	local fixtureDef = b2FixtureDef()
	
	--创建形状
	local shape = b2CircleShape()
	shape.m_radius = 1
	--赋值给材质的属性
	fixtureDef.shape = shape
	fixtureDef.friction = .5
	fixtureDef.restitution = .3
	fixtureDef.density = .7
	body:CreateFixture(fixtureDef)

	table.insert(self.bodys, body)
end



--创建矩形刚体
function M:createBodyB( )
	--创建车身
	local bodyDef = b2BodyDef()
	bodyDef.position = b2Vec2(200/32, 180/32)
	--设置为静态
	-- b2_dynamicBody
	-- b2_staticBody
	bodyDef.type = b2_dynamicBody
	bodyDef.allowSleep = true
	body = self.world:CreateBody(bodyDef)

	-- local fixtureDef = b2FixtureDef()
	-- local shape = b2PolygonShape()
	-- shape:SetAsBox(120/32, 50/32)
	-- fixtureDef.shape = shape
	-- fixtureDef.friction = .0001
	-- fixtureDef.restitution = .1
	-- fixtureDef.density = .8

	-- body:CreateFixture(fixtureDef)

	self.bodyA = body

	-- self:addComplexFixture(self.bodyA, "r.plist", "r")
	self:addComplexFixture(self.bodyA, "2.plist", "r")
end

--鼠标关节
function M:createMouseJoint(x, y)
	if not self.mouseJt then
		print("=======创建鼠标关节======")
		local mouseJtDef            = b2MouseJointDef()
		--世界的边缘
		mouseJtDef.bodyA            = edgeBodyB
		--被鼠标关节约束的刚体
		mouseJtDef.bodyB            = self.bodyA
		-- self.bodyA
		--self.bodys[1]
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
--创建焊接关节
function M:createWeldJoint(bodyA, bodyB)
	local weldJointDef              = b2WeldJointDef()
	weldJointDef.frequencyHz        = 30
	weldJointDef.collideConnected   = true
	weldJointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter())
	self.world:CreateJoint(weldJointDef)
end



--距离关节
function M:createDistanceJoint(bodyA, bodyB, dis)
	local jointDef              = b2DistanceJointDef()
	
	jointDef.bodyA              = bodyA
	jointDef.bodyB              = bodyB
	jointDef.lenght             = dis
	-- jointDef.frequencyHz        = 0.1
	-- 是否连续碰撞
	jointDef.collideConnected   = true
	jointDef:Initialize(bodyA, bodyB, bodyA:GetWorldCenter(), bodyB:GetWorldCenter())
	self.world:CreateJoint(jointDef)
end

--创建旋转关节
function M:createRevoluteJoint(bodyA, bodyB)
	local jointDef = b2RevoluteJointDef()
	--是否连续碰撞
	jointDef.collideConnected = true
	-- 马达速度
    jointDef.motorSpeed = -5
    -- 马达最大扭力
    jointDef.maxMotorTorque = 400
    -- 是否启动马达
    jointDef.enableMotor=true
    --初始化关节，第一个是需要旋转的刚体，第三个是围绕的是哪个刚体旋转
	jointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter())
	self.world:CreateJoint(jointDef)
end

--[[--
添加复杂的纹理

<br/>  
### Useage:
    ZBox2D.addComplexFixture(刚体对象, 包含形状信息的.plist文件, 物理形状图片名称)
    
### Aliases:

### Notice:
    用于给刚体绑定物理形状、质量、摩擦力、弹性系数等物理属性。

### Example:
    ----------------------
    -- 示例1: 
    ----------------------
    
### Parameters:
-   b2Body  **body**        [必选] 刚体对象  
-   String  **plistPath**   [必选] PhysicsEditor导出的.plist文件  
-   String  **key**         [必选] plist文件中物理形状图片名称  

### OptionParameters

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






