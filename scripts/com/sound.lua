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

游戏声音管理类，定义声音管理相关操作方法及逻辑实现。

-   实现声音管理常用操作。

]]

----------------------
-- 类
----------------------
local M = {}
M.TAG   = "sound"

-- 指定继承关系
setmetatable(M, { __index = function(table, key)
    return bb.SoundBase[key]
end})


----------------------
-- 公共参数
----------------------
-- [公共参数]
-- 常量
-- ..

-- [操作变量]
-- ..








----------------------
-- 预加载方法
----------------------
-- [工具方法][预加载]
local function preloadMusicBackground(fileName)
    M.preloadMusic("music/" .. fileName)
end
-- 预加载背景音乐[001]
function M:preloadMusicBackground001() 
    preloadMusicBackground("bg001.mp3")
end

-- 预加载背景音乐[002]
function M:preloadMusicBackground002() 
    preloadMusicBackground("bg002.mp3")
end


---------


-- [工具方法][背景音乐]
local function playMusicBackground(fileName)
    return M.playMusic("music/" .. fileName)
end
-- 播放背景音乐[001]
function M:playMusicBackground001()
    return playMusicBackground("bg001.mp3")
end
-- 播放背景音乐[002]
function M:playMusicBackground002()
    return playMusicBackground("bg002.mp3")
end


---------


-- [工具方法][音效]
local function playEffectButton(fileName)
    return M.playEffect("effect/button/" .. fileName)
end
-- 播放按钮音效[001]
function M:playEffectButton001()
    return playEffectButton("btn001.mp3")
end

-- 播放按钮音效[001]
function M:playEffectButton001()
    return playEffectButton("btn001.mp3")
end



return M