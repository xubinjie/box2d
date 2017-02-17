--[[
	类
--]]


local M 	= classSprite("Bubble")




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
	self:display("bub/1.png")
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
return SIGN_TOUCH_BEGAN_SWALLOWS 
end

function M:onTouchMoved(x, y, touches)
	--   
end

function M:onTouchEnded(x, y, touches)
	
end








--------------------------
-- 功能函数
--------------------------




--------------------------
-- 属性
--------------------------




--------------------------
-- 父类重写
-------------------------- 




return M






