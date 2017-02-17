--[[
	xx场景x层类
--]]

local M    = classLayer("Main")



--------------------------
-- 构造函数
--------------------------

function M:ctor(params)
	-- [超类调用]
	M.super.ctor(self, params)
	-- [本类调用]
	--米转化为像素除以的系数
	bl = 32
	self.bubs = {}
	bubNum = 0
end

--------------------------
-- 渲染
--------------------------

function M:onRender()
	-- [超类调用]
	M.super.onRender(self)
	-- [本类调用]
	self:createWorld()

	-- self:loadNode1()
	-- 加载渲染以外的其他操作
	self:loadRenderOtherwise()
end



-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
	self:bindTouch()

	self.worldRun = SC.open(handlerP(self, self.tick), 1.0 / 60)
	A.cycle({
		{"delay", .1},
		{"fn", function()
		 	self:createBub() 
		end},
	}, 20):at(self)
end

--------------------------
-- 触控
--------------------------

function M:onTouchBegan(x, y, touches)
	--  触控有效
	return true
end

function M:onTouchMoved(x, y, touches)

end
function M:onTouchEnded(x, y, touches)

end






--------------------------
-- 功能函数
--------------------------
--world
function M:createWorld()
	local gravity = b2Vec2(-0.2,  1)
	world = b2World(gravity)
	world:SetAllowSleeping(true)
	world:SetContinuousPhysics(true)

	local layer = GB2DebugDrawLayer:create(world, 32)
	self:add(layer, 9999)
	self:createEdge()
	-- local Listener = BbContactListener()
    -- b2ContactListener:onCreate()
    -- local listener = GB2ContactListener:new_local()
end

function M:createEdge()
    local bodyDef      = b2BodyDef()
    bodyDef.position   = b2Vec2(0, 0)
    --动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
    bodyDef.type       = b2_staticBody
    --允许休眠
    -- bodyDef.allowSleep = true
    -- userData           = NULL
    local body         = world:CreateBody(bodyDef)
    
    local beganP = {b2Vec2(0/32, 0/32), b2Vec2(960/32, 0/32), b2Vec2(960/32, 540/32), b2Vec2(0/32, 540/32)}
    local endP   = {b2Vec2(960/32, 0/32), b2Vec2(960/32, 540/32), b2Vec2(0/32, 540/32), b2Vec2(0/32, 0/32)}
    for i=1,4 do
        --创建夹具定义
        local fixtureDef = b2FixtureDef()
        local shape      = b2EdgeShape()
        shape:Set(beganP[i], endP[i])
        --赋值给材质的属性
        fixtureDef.shape       = shape
        --摩擦
        fixtureDef.friction    = .05
        --恢复
        fixtureDef.restitution = .01
        --密度
        fixtureDef.density     = .01
        --用户数据
        body:CreateFixture(fixtureDef)
    end
end



--世界更新
function M:tick()
	-- 时间步，位置矫正、速度矫正
	-- 矫正取值： 1 - 10，数值越高计算约精确，也约消耗性能
    world:Step(1/60, 1, 1)

    -- if node1 then
    -- 	node1:tongbu()
    -- end
    for i,bub in ipairs(self.bubs) do
    	if bub.tongbu then
	    	bub:tongbu()
	    end
    end

    local contacts = world:GetContactList()

	while contacts do 
		local fa = contacts:GetFixtureA()
		local fb = contacts:GetFixtureB()
		if fa and fb then
			self:destroyMySelf(fa)
			self:destroyMySelf(fb)
		end
		contacts = contacts:GetNext()
	end
    
end

function M:destroyMySelf(fixture)
	local bub = tolua.cast(fixture:GetUserData(), "CCSprite")
	if bub and bub.deleteSelf and bub.cl then
		bub:deleteSelf()
	end
end



--加载节点
function M:loadNode1()
	local Node1 = import("app.vi_demo.node.Node1")
	node1 = Node1.new():to(self):p(100, 250)
end

function M:createBub()
	local Bub = import("app.vi_demo.node.Bub")
	local pos = ccp(RD.number(100, 200), RD.number(300, 350))
	local scNum = RD.number(7, 12)/10/2
	bubNum = bubNum + 1
  	local bub = Bub.new({pos = pos, scNum1 = scNum, no = bubNum}):to(self)
	:p(pos):scale(scNum)
	-- bub.pos    = pos
	-- bub.scNum  = scNum
	table.insert(self.bubs, bub)
end


--  function M:createCirle()
-- 	local bodyDef      = b2BodyDef()
-- 	bodyDef.position   = b2Vec2(RD.number(100, 200)/bl, RD.number(300, 350)/bl)
-- 	--动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
-- 	bodyDef.type       = b2_dynamicBody
-- 	--允许休眠
-- 	bodyDef.allowSleep = true
-- 	local body11         = world:CreateBody(bodyDef)
-- 	--创建夹具定义
-- 	local fixtureDef = b2FixtureDef()
-- 	local shape = b2CircleShape()
-- 	shape.m_radius = RD.number(100, 200)/200
-- 	--赋值给材质的属性
-- 	fixtureDef.shape       = shape
-- 	--摩擦
-- 	fixtureDef.friction    = .3
-- 	--恢复
-- 	fixtureDef.restitution = .1
-- 	--密度
-- 	fixtureDef.density     = .01
-- 	body11:CreateFixture(fixtureDef)
-- 	self:applyF(body11)
--  end

-- --施加力
-- function M:applyF(body11)
-- 	-- local force = b2Vec2(150,150)
-- 	--  bodyA:ApplyForce(force, bodyA:GetPosition())
-- 	local fany = RD.number(0.2, 0.5)
-- 	local impulse = b2Vec2(0.4, fany)
-- 	body11:ApplyLinearImpulse(impulse, body11:GetPosition())
-- end

--------------------------
-- 属性
--------------------------
                                                                                                                                                                                                                  

--------------------------
-- 父类重写
--------------------------




--------------------------
-- 析构
--------------------------




function M:onDestructor()
	-- [超类调用]
	M.super.onDestructor(self)
	-- [本类调用]
end


return M
