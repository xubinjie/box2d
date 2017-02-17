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

游戏初始化类，辅助游戏类定义相关操作方法及逻辑实现。

-   引入游戏配置文件。
-   处理游戏更新逻辑。
-   覆盖游戏配置项。
-   定义快捷命名。
-   定义游戏相关方法。
-   其他。

]]


----------------------
-- 事件覆盖
----------------------
-- 处理事件[启动]
function bb.GameBase:doEventStartup()
	-- 日志消息
	Log.d("GAME_EVENT", "GameBase - startup!")
end

-- 处理事件[恢复]
function bb.GameBase:doEventResume()
	-- 日志消息
	Log.d("GAME_EVENT", "GameBase - resume!")
end

-- 处理事件[暂停]
function bb.GameBase:doEventPause()
	-- 日志消息
	Log.d("GAME_EVENT", "GameBase - pause!")
end

-- 处理事件[声音-开启]
function bb.GameBase:onAudioOn()
	-- 日志消息
	Log.d("GAME_EVENT", "GameBase - audio:on!")
end

-- 处理事件[声音-关闭]
function bb.GameBase:onAudioOff()
	-- 日志消息
	Log.d("GAME_EVENT", "GameBase - audio:off!")
end

-- 处理事件[平台差异]
function bb.GameBase:onPlatformDifferences()
	-- 日志消息
	Log.d("GAME_EVENT", "GameBase - platform differences!")
end








----------------------
-- 游戏初始化
----------------------
-- 类初始化
game        = class("game", bb.GameBase).new()
-- 日志标识
game.TAG    = "game"











----------------------
-- 定义公共方法
----------------------
-- 自定义方法
function game:doSomething()

end








----------------------
-- 加载游戏依赖类
----------------------
-- 声音
sound = require("com.sound")
-- 视频
-- movie = require("com.movie")

MBox2d = require("app.common.box2d.MBox2d")






----------------------
-- 游戏配置
----------------------
-- R.loadFrames("common/frame")