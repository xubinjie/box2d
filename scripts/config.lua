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

游戏配置类，定义游戏配置及各种参数定义。

-   参考bbframework/config.lua文件，进行参数覆写，达到游戏定制目的
-   定制调试配置。
-   定制基本配置。
-   定制路径配置。
-   定制网络配置。
-   其他。

]]

----------------------
-- 发布设置
----------------------
-- 设置是否为发布模式
RELEASE_MODE = false
-- 设置版本（此处的版本与game.lua中的版本不同，此处版本为游戏的发布版本，game.lua中的版本为游戏实际版本(可能已经增量更新)）
APP_VERSION = "9.9.9"








----------------------
-- 载入默认配置
----------------------
require("bbframework.config")









----------------------
-- 载入游戏配置
----------------------
-- [调试配置]
-- 显示FPS
DEBUG_FPS 					= true
-- 显示内存
DEBUG_MEM 					= false
-- 调试等级[DEBUG] 	(0:禁用调试信息, 1:少量调试信息, 2:详细调试信息)
DEBUG 						= 0
-- 日志等级[LOG] 		(0:e, 1:e|i, 2:e|i|w, 3: e|i|w|d, 4:e|d)
LOG_LEVEL 					= 0








----------------------
-- 基础配置
----------------------
-- 配置读取zip包
ENABLED_LUA_ZIP_SOURCE 		= false
-- 配置启用热更新
ENABLED_HOT_UPDATE 			= false
-- 配置启用资源加载优化
RESOURCE_LOAD_OPTIMIZE 		= false
-- 开启多点触控
ENABLED_MULTI_TOUCH 		= false
-- 配置启用异常检查(是否让try()方法有效，为true时有效，为false时忽略try-catch-finally)
ENABLED_TRY_CATCH 			= false



-- 游戏入口模块
GAME_ENTRY_MODULE  			= "gameplay"
-- 游戏欢迎场景
GAME_PLAY_SCENE_NAME 		= "gameplay"


-- 休息调试时间设置
REST_TIME_FOR_DEBUG = nil



----------------------
-- 事件配置
----------------------
-- 事件[广告]
ENABLED_EI_AD					= false
-- 事件[盒子]
ENABLED_EI_BOX 					= false
-- 事件[大数据]
ENABLED_EI_BIGDATA 				= false
-- 事件[休息]
ENABLED_EI_REST 				= false
-- 事件[通用数据]
ENABLED_EI_BASIC 				= true

-- 事件[TV-视频]
ENABLED_EI_TV_VIDEO 			= false

-- 事件[大数据] - 调试
ENABLED_EI_BIGDATA_DEBUG 		= false
-- 事件[大数据] - 内部测试
ENABLED_EI_BIGDATA_ITLTEST 		= false
-- 事件[大数据] - 上传域名
ENABLED_EI_BIGDATA_UPLOAD_DOMAIN = "http://data.baby-bus.com"
-- 事件[大数据] - 设备域名
ENABLED_EI_BIGDATA_DEVICE_DOMAIN = "http://account.baby-bus.com"








----------------------
-- 界面配置
----------------------
-- 配置横竖屏
SCREEN_ORIENTATION 			= ORIENTATION_LANDSCAPE
CONFIG_SCREEN_WIDTH  		= 960
CONFIG_SCREEN_HEIGHT 		= 540
-- 配置横竖屏
-- SCREEN_ORIENTATION 			= ORIENTATION_PORTRAIT
-- 配置开启界面辅助
ENABLED_AUXILIARY_INTERFACE	= false
-- 配置触控轨迹显示
ENABLED_TOUCH_TRACE			= false


--设置全屏
IS_FULL_SCREEN 				= true





----------------------
-- 渠道
----------------------
-- 渠道[当前平台]
CHANNEL_PLATFORM 			= CHANNEL_NONE -- others: CHANNEL_360, CHANNEL_91








----------------------
-- 发布语言
----------------------
-- 限制发布语言[中文]
LANG_LIMIT_CHINESE 			= false
-- 允许发布的语言集(最后一个语言为默认语言)
LANG_ALLOWS 				= { "zh", "zht", "ja", "de", "fr", "ko", "ru", "es", "en" }








----------------------
-- 日志重定向
----------------------
-- ECHO_REDIRECT 				= "10.1.2.125"