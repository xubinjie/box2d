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

视频播放类，定义视频播放相关操作方法及逻辑实现。

-   存储视频播放相关信息。

]]

----------------------
-- 类
----------------------
local M = {}
M.TAG   = "movie"


----------------------
-- 公共参数
----------------------
-- [公共参数]
-- 常量
-- ..

-- [操作变量]
-- ..





----------------------
-- 功能方法
----------------------
--[[--

播放视频动画

### Example:

### Parameters:

]]
function M.playMovie()
	if isandroid() then
		luaM.callStaticMethod(CLASS_PATH_ANDROID, "playMovie")
	else 
		luaM.callStaticMethod("CGMoviePlayViewController", "playMovie", {})
	end
end



return M