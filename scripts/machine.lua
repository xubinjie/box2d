--[[

Copyright (c) 2012-2013 baby-bus.com

http://www.babybus.com/superdo/

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

配置文件处理类，定义框架配置环境初始刷新及各种参数定义。

-   定义框架框架配置环境初始刷新
-   定义环境变量。
-   定义供framework.init读取的配置更新。
-   其他。

]]

----------------------
-- 分辨率及屏幕尺寸
----------------------
local w,h,bw,bh

-- 处理终端
if DEVICE_TERMINAL == TERMINAL_HANDHELD then 
	w = 960
	h = 640
elseif DEVICE_TERMINAL == TERMINAL_TV then 
	w = 960
	h = 540
end

-- 处理屏幕分辨率
if SCREEN_ORIENTATION ~= ORIENTATION_LANDSCAPE then 
	w = w + h
	h = w - h
	w = w - h
end

-- 处理默认分辨率
if true then
	-- 横屏
	if CONFIG_SCREEN_WIDTH  == 0 then CONFIG_SCREEN_WIDTH  = w end
	if CONFIG_SCREEN_HEIGHT == 0 then CONFIG_SCREEN_HEIGHT = h end

	if not RESOLUTIONS then
		bw,bh = math.floor(w*.5), math.floor(h*.5) 
		RESOLUTIONS = {
		    { model = "x1", width = bw * 1, height = bh * 1 },
		    { model = "x2", width = bw * 2, height = bh * 2 },
		    { model = "x4", width = bw * 4, height = bh * 4 },
		    { model = "x8", width = bw * 8, height = bh * 8 },
		}
	end
end

if false then 
	print("CONFIG_SCREEN_WIDTH:  ", CONFIG_SCREEN_WIDTH)
	print("CONFIG_SCREEN_HEIGHT: ", CONFIG_SCREEN_HEIGHT)
	for k,v in pairs(RESOLUTIONS) do
		print("========= k: =========", k)
		for kk,vv in pairs(v) do
			print(kk,vv)
		end
	end
end







----------------------
-- TV键值映射
----------------------
-- [键值]上
TV_KEY_UP 					= "19"
-- [键值]下
TV_KEY_DOWN 				= "20"
-- [键值]左
TV_KEY_LEFT 				= "21"
-- [键值]右
TV_KEY_RIGHT 				= "22"
-- [键值]OK
TV_KEY_OK 					= "23"
-- [键值]回退
TV_KEY_BACK 				= "back"







----------------------
-- SDK(推广平台)
----------------------
-- 无








----------------------
-- 发布模式校正
----------------------
-- [[下面N条不要动哈, 在发布模式时其会自动指配]]
if RELEASE_MODE then 
	DEBUG 		= 0
	DEBUG_FPS 	= false
	DEBUG_MEM 	= false
	LOG_LEVEL 	= 0
	ENABLED_LUA_ZIP_SOURCE 		= true
	ENABLED_DEVELOP_MOBDEBUG 	= false
	ENABLED_AUXILIARY_INTERFACE = false
	ENABLED_TERMINAL_DEBUG 		= false
	ENABLED_TRY_CATCH 			= true
end