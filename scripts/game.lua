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

游戏类，定义游戏相关操作方法及逻辑实现。

-   引入游戏配置文件。
-   处理游戏更新逻辑。
-   覆盖游戏配置项。
-   定义快捷命名。
-   定义游戏相关方法。
-   其他。

]]

----------------------
-- 游戏版本定义
----------------------
-- 设置版本（此处的版本与config.lua中的版本不同，此处版本为游戏实际版本(可能已经增量更新)，config.lua中的版本为游戏的发布版本）
CUR_VERSION = "9.9.9"








----------------------
-- 强制覆写定义
----------------------
-- 设置发布驱动模型
if isandroid() then 
	DEVICE_MODEL = "x2"
end

-- FIXME: 在此处可以覆盖定义config.lua中声明的变量，因为在进行打包时config.lua文件锁定不受增量包影响
-- 设置驱动模型(注：开发状态下请取消注释下一行代码)
DEVICE_MODEL    = "x4"
-- 设置语言
device.language = "zh"








----------------------
-- 模块[game]定义 
----------------------
-- [游戏初始化]
require("game_init")









----------------------
-- 模块[game]方法定义 
----------------------
-- 启动游戏
-- 包含内容：(1)配置游戏启动相关参数 (2)重置游戏缓存数据 (3)预加载资源 (4)..
function game:startup()
    -- 方式一：App
    -- self:run()
    -- 方式二：Ccb
    -- CCBCenter.replaceScene("MSG_T1_MODEL", "ccb.c.ue.T1Controller")
    -- game:enterScene("I_HelloBox2d")
    -- game:enterScene("Ii_JointDemo")
    
    -- game:enterScene("Iii_JointDemo")
    -- game:enterScene("Iv_JointDemo")
    -- game:enterScene("V_demo")
    -- game:enterScene("Box2dDemo")
    -- game:enterScene("Vi_demo")
    game:enterScene("Vii_demo")
end
