--[[

Copyright (c) 2012-2013 baby-bus.com

http://www.baby-bus.com/LizardMan/

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

--[[!--

游戏角色类，定义游戏角色公用操作方法及逻辑实现。

-   定义游戏角色相关信息。

]]

----------------------
-- 类
----------------------
local M = classSpriteTouch("TouchSprite")


----------------------
-- 公共参数
----------------------
-- [常量]
-- ..

-- [操作变量]
-- ..








----------------------
-- 构造方法
----------------------
--[[--

构造方法，定义结点实例初始化逻辑

### Parameters:
-   table **params**    参数集合

### Return: 
-   object              对象实例

]]
function M:ctor(params)
    -- [超类调用]
    M.super.ctor(self, params)
end








----------------------
-- 结点渲染 
----------------------
--[[--

实体渲染，处理实体结点加载、事件绑定等相关操作

]]
function M:onRender()
    -- [超类调用]
    M.super.onRender(self)

    -- [本类调用]
    -- 加载显示
    self:loadDisplay()
end

-- 加载显示
function M:loadDisplay()
    self:display("gameplay/node.png")
end








----------------------
-- 结点析构
----------------------
--[[--

实体析构，处理实体结点卸载、事件解除绑定等相关操作

]]
function M:onDestructor()
    -- [超类调用]
    M.super.onDestructor(self)
end








----------------------
-- 点击
----------------------
--[[--

处理触控事件[可用性]

### Example:

### Parameters:
-   string **event**    事件名称
-   number **x**        点击位置x(相对于屏幕)
-   number **y**        点击位置y(相对于屏幕)

]]
function M:onTouchEnabled()
    return true
end

--[[--

处理触控事件[处理]

### Example:

### Parameters:
-   string **event**    事件名称
-   number **x**        点击位置x(相对于屏幕)
-   number **y**        点击位置y(相对于屏幕)

]]
function M:onTouchHandled(x, y, touches)
    print("tap!", getLogName(self))
end









----------------------
-- 验证
----------------------
-- 验证合法性[构造函数参数]
function M:assertParameters(params)
    
end



return M