--[[--------------------------
[csu]全局配置和一些常量变量定义

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	全局配置和一些常量变量定义
	- Author: 	zengbinsi
	- Date: 	2016-01-11  

--]]--------------------------  






---
-- 配置文件
---
local M = {}
M.TAG  	= "ZConfig"








--------------------------
--  常量
-------------------------- 

--[适配]
---
-- 是否全屏 	
---
IS_FULL_SCREEN 					= true 

--[坐标]

---
-- 全屏的屏幕宽度
---
V.fW 							= V.w
V.fw  							= V.w

---
-- 全屏的屏幕高度
---
V.fH 							= display.height / (display.width / 960)
V.fh  							= V.H 

---
-- 左上角按钮
---
P_BTN_LEFT_TOP 			 		= ccp(60, V.fH - 60)

---
-- 右上角按钮
---
P_BTN_RIGHT_TOP 		 		= ccp(V.w - 60, V.fH - 60)

---
-- 右下角按钮
---
P_BTN_RIGHT_BOTTOM 		 		= ccp(V.w - 60, 60) 










--------------------------
--  变量
--------------------------














return M 









