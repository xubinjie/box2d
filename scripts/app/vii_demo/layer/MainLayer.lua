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
	self.tt = 1
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
	-- 加载节点
	self:loadBubbles()
	-- 加载渲染以外的其他操作
	self:loadRenderOtherwise()
-- -- 剛體類型
-- BDTYPE = { ST = b2_staticBody, DC = b2_dynamicBody, KT = b2_kinematicBody}
end

-- 加载节点
function M:loadBubbles()
	local Bubble = import("app.vii_demo.node.Bubble")
	local bubble = Bubble.new():to(self):p(100, 100)
end

-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
	self:bindTouch()
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
--创建世界
function M:createWorld( )
	world = MBox2d:createWorld()
	--绘制调试物理世界
	local layer = MBox2d:createDebugDraw()
	self:add(layer)
	self:openStep(true)
end

--开启或关闭世界模拟
function M:openStep(isOpen)
	if isOpen then
		self.worldRun = MBox2d:openWorldStep(nil, nil, nil)
	else
		self.worldRun = MBox2d:closeWorldStep(self.worldRun)
	end
end

--世界模拟运行的时候的一些操作
function M:tick()

end

--创建边界
function M:createEdge()
	local pos = {ccp(0,0), ccp(960,0), ccp(960, 540), ccp(0,540)}
	local pc = ccp(0, 0)
	self.edgeBody = MBox2d:createEdge(pos)
end



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
