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

语言差异处理类，定义语言差异相关操作方法及逻辑实现。

-   提供语言差异的公共方法。

-   示例：
-- [注册模块]角色名框处理
-- 说明：针对韩国版本去除[注册模块]名称随机按钮，并同时将姓名框拉长显示
-- 方法史定义规则：[模块名]+[模块调整控件名]。示例：register+NameBox
function M.registerNameBox(node, nodeTable)
    -- [操作对象]
    local btnRandom  = CCBCenter.getNodeByTag(node, 101)            -- 随机按钮
    local sptNameBox = nodeTable["sptNameBox"]                      -- 姓名框
    local lang       = device.language                              -- 语言


    -- [语言差异判断]
    if lang == "kr" then 
    -- if true then 
        -- 隐藏按钮[随机姓名]
        btnRandom:setVisible(false)
        -- 拉长姓名框
        sptNameBox:setScale(1.19)
    end
end

]]

----------------------
-- 类
----------------------
local M = {}
M.TAG   = "LanguageDifference"


----------------------
-- 公共参数
----------------------
-- [常量]
-- ..

-- [操作变量]
-- ..








----------------------
-- 功能方法
----------------------
--[[--

[注册模块]角色名框处理

### Example:

### Parameters:
-   CCNode **node**         结点
-   table **nodeTable**     结点表

]]
function M.fightResult2Diamond(node, nodeTable)
    -- [操作对象]
    local iconDiamond = nodeTable["sptIconDiamond"]                 -- 钻石[图标]
    local lblDiamond  = nodeTable["lblDiamond"]                     -- 钻石[标签]
    local lang       = device.language                              -- 语言


    -- [语言差异判断]
    if lang == "kr" then 
        -- 隐藏按钮[钻石[图标]]
        iconDiamond:setVisible(false)
        -- 隐藏按钮[钻石[标签]]
        lblDiamond:setVisible(false)
    end
end



return M