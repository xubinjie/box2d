--[[
	泡泡类
--]]


local M 	= classSprite("Bub")




--------------------------
-- 构造函数
--------------------------

function M:ctor(params)
	-- [超类调用]
	M.super.ctor(self, params)
 	-- [本类调用]
 	self.isTouch = true
 	self.pos1 = params.pos
 	self.scNum1 = params.scNum1
 	self.mNo = no

 	--自定义：是否开启碰撞条件
 	self.cl = false

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
	self:display("bub/1.png")
end 

-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
	-- 
	-- print(self.pos.x)
	self:bindTouch()
	self:createmBody()
	local time = RD.number(2, 3)
	A.line({
		{"delay", time},
		{"fn", function()
		 	self.cl = true
		end},
	}):at(self) 
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
return SIGN_TOUCH_BEGAN_SWALLOWS 
end

function M:onTouchMoved(x, y, touches)
	--   
end

function M:onTouchEnded(x, y, touches)
	self:boom()
end








--------------------------
-- 功能函数
--------------------------
function M:boom()
	self.isTouch = false
	self:deleteSelf(1)
	A.line({
		{"image", "bub/", 3, .12},
		{"remove"},
	}):at(self)
end

function M:createmBody()


	local bodyDef      = b2BodyDef()
	local pos1 = b2Vec2(self.pos1.x/bl, self.pos1.y/bl)
	bodyDef.position   = pos1
	--动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
	bodyDef.type       = b2_dynamicBody
	--允许休眠
	bodyDef.allowSleep = true
	local body11         = world:CreateBody(bodyDef)
	--创建夹具定义
	local fixtureDef = b2FixtureDef()
	local shape = b2CircleShape()
	shape.m_radius = 2*self.scNum1
	--赋值给材质的属性
	fixtureDef.shape       = shape
	--摩擦
	fixtureDef.friction    = .01
	--恢复
	fixtureDef.restitution = .01
	--密度
	fixtureDef.density     = 0.006/self.scNum1
	-- 
	print("========", self.scNum1,fixtureDef.density)

	fixtureDef.userData = self

	fixtureDef.filter.categoryBits = 2
	fixtureDef.filter.maskBits = 2


	-- fixtureDef.isSensor = true

	self.ft =  body11:CreateFixture(fixtureDef)
	self:applyF(body11)
	self.body = body11
	
end

--施加力
function M:applyF(body11)
	-- local force = b2Vec2(8,4)
	 -- body11:ApplyForce(force, body11:GetPosition())
	local fany = RD.number(0.2, 0.5)
	local xfany = RD.number(3, 1)/10
	local impulse = b2Vec2(xfany, fany)
	body11:ApplyLinearImpulse(impulse, body11:GetPosition())
end

function M:tongbu()
	if self.body then
	local pos = self.body:GetPosition()
		self:p(pos.x*32, pos.y*32)
	end
end

--销毁自身
function M:deleteSelf(isRemove)
	local isDelete = isRemove or 2

	if not self.body then return end
	self.body:DestroyFixture(self.ft)
	self.ft = nil
	world:DestroyBody(self.body)
	self.body = nil
	for i,bub in ipairs(self:getParent().bubs) do
		if bub == self.mNo then
			table.insert(self:getParent().bubs, i)
		end
	end
	if isDelete == 2 then
		self:remove()
	end
end

--------------------------
-- 属性
--------------------------




--------------------------
-- 父类重写
-------------------------- 




return M






