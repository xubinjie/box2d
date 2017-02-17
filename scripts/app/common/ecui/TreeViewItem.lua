--[[--------------------------
[ecui]树形控件节点

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	树形控件节点
	- Author: 	zengbinsi
	- Date: 	2016-0-0  

--]]-------------------------- 




--========================
-- 引入命名空间
--========================
-- local BaseLayer = import("app.common.layer.BaseLayer")





--[[

	self:bindTouch() 

	local TreeViewItem 	= import("app.common.cs.ecui.TreeViewItem")
	local t1 	= TreeViewItem.new({text = "item1", level = 0}):to(self, 1000):pc()

	F.delayCall(2, function()
		 t11 	= TreeViewItem.new({text = "item11", level = 1})
		t1:addItem(t11)
	end)

	F.delayCall(4, function()
		 t12 	= TreeViewItem.new({text = "item12", level = 1})
		t1:addItem(t12)
	end)

	F.delayCall(6, function()
		 t111 	= TreeViewItem.new({text = "item111", level = 2})
		t11:addItem(t111)
	end)
	F.delayCall(8, function()
		 t1111 	= TreeViewItem.new({text = "item1111", level = 3})
		t111:addItem(t1111)
	end)

	F.delayCall(10, function()
		 t112 	= TreeViewItem.new({text = "item112", level = 2})
		t11:addItem(t112)
	end)	
	




]]



--[[
	类
--]]


local M 	= class("TreeView", function(params)
	params = params or {}

	local lable = U.loadLabelTTF({
 		text 		= params.text or "unname", 
 		}):anchor(ccp(0, .5))
	local item = U.loadNode()

	item:anchor(ccp(ccp(0, 1))):setContentSize(CCSize(300, lable:ch()))
	lable:to(item):p((params.level or 0) * 20, item:ch() / 2)

	return item
end)




--========================
-- 构造函数
--========================

function M:ctor(params)
	--[超类调用]
	-- M.super.ctor(self, params)
	params 				= params or {}  

 	--[本类调用]
 	-- 标题（用于显示）
 	self.text 			= params.text or "unname"
 	-- 子级是否处于展开状态
 	self.isOpenCascade 	= true  
 	-- 子级对象
 	self.items 			= {} 
 	-- 级别
 	self.level 			= params.level or 0 
 	-- 缩进
 	self.tabLen 		= 20 


 	-- 事件回调
 	self.touchBegan 	= params.touchBegan
 	self.touchMoved 	= params.touchMoved
 	self.touchEnded 	= params.touchEnded
 	self.touchCancelled = params.touchCancelled

 	self:bindTouch() 
end

--========================
-- 渲染
--========================

function M:onRender()
	M.super.onRender(self)

 	--[本类调用]
	-- 加载节点
	self:loadDisplay() 
	-- 加载渲染以外的其他操作
	self:loadRenderOtherwise()
end 

-- 加载节点
function M:loadDisplay()
	
end 

-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
	
end




--========================
-- 析构
--========================

function M:onDestructor()
	--[超类调用]
	-- M.super.onDestructor(self)
 	--[本类调用]

end








--========================
-- 触控
--======================== 

function M:onTouchBegan(x, y, touches)
	print("touch ".. self.text)

	self.preTouch 	= ccp(x, y)

	if self.touchBegan then 
		self.touchBegan({target = self.text, x = x, y = y, touches = touches, })
	end
	--  触控有效
	return true  
end

function M:onTouchMoved(x, y, touches)
	if self.touchMoved then 
		self.touchMoved({target = self.text, x = x, y = y, touches = touches, })
	end
end

function M:onTouchEnded(x, y, touches)
	if self.touchEnded then 
		self.touchEnded({target = self.text, x = x, y = y, touches = touches, })
	end

	if ccpDistance(self.preTouch, ccp(x, y)) > 50 then 
		return 
	end

	if self.isOpenCascade then 
		self:closeItems()
	else
		self:openItems()
	end
end








--========================
-- 功能函数
--======================== 

--[[-
更新子级坐标  

<br/>  
### Useage:
  	用途  

### Notice:
	注意   

--]]
function M:updateItemsPosition()
 	local y 	= 0
	
	for i, item in ipairs(self.items) do
		item:py(y)
		y = y - item:getItemSize().height 
	end

	local parent = self:getParent()

	if parent and parent.updateItemsPosition then 
		return parent:updateItemsPosition()
	end
end

--[[-
添加子级  

<br/>  
### Useage:
  	添加子级目录。  

### Notice:
	注意   

### Parameters:
- 	TreeViewItem 	**newItem** 				[必选] 子级对象  

### Returns: 
-   TreeViewItem  

--]]
function M:addItem(newItem)
	if self.isOpenCascade then 
		newItem:show()
	else
		newItem:hide()
	end
	newItem:to(self)
	table.insert(self.items, newItem)

	self:updateItemsPosition()

 	return newItem 
end 

--[[-
展开子级  

<br/>  
### Useage:
  	用途  

### Notice:
	注意   

### Returns: 
-   返回值类型 							返回值说明  

--]]
function M:openItems()
 	self.isOpenCascade = true 

 	for i, item in ipairs(self.items) do
 		item:openItems()
 		item:show()
 	end

 	self:updateItemsPosition()
end

--[[-
关闭子级  

<br/>  
### Useage:
  	用途  

### Notice:
	注意   

### Returns: 
-   返回值类型 							返回值说明  

--]]
function M:closeItems()
 	self.isOpenCascade = nil  

 	for i, item in ipairs(self.items) do
 		item:hide()
 		item:closeItems()
 	end

 	self:updateItemsPosition()
end




--========================
-- 属性
--======================== 

--[[-
设置文字内容  

<br/>  
### Useage:
  	设置显示的文字内容  

### Notice:
	注意   

### Parameters:
- 	string 	**text** 				[必选] 文字内容  

### Returns: 
-   返回值类型 							返回值说明  

--]]
function M:setString(text)
 	self.contextLabel:setString(text)
end
M.setText 	= M.setString 


--[[-
获取选项尺寸  

<br/>  
### Useage:
  	获取选项的大小。  

### Notice:
	注意   

### Parameters:
- 	类型 	**参数名** 				[必/可选] 参数说明  

### Returns: 
-   CCSize  

--]]
function M:getItemSize()
	local w, h 	= self:cw(), self: ch() 

 	if self.isOpenCascade then 
 		for i, item in ipairs(self.items) do
 			h 	= h + item:getItemSize().height 
 		end
 	end

 	return CCSize(w, h)
end




--========================
-- 父类重写
--======================== 




return M






