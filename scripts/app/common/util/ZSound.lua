--[[--------------------------
[csu]定义声音操作

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	定义声音操作
	- Author: 	zengbinsi
	- Date: 	2015-07-28  

--]]--------------------------  







--[[
	全局类
--]]


local M 	= {}

M.TAG 		= "ZSound"

-- 指定继承关系
setmetatable(M, { __index = function(table, key)
    return bb.SoundBase[key]
end})



--------------------------
--  重写父类
--------------------------

--[[-
停止背景音乐  

<br/>  
### Useage:
  	由于背景应用在停止后按home键回到桌面再进入游戏后背景应用会重新播放，所以这里使用空音频来代替停止背景音乐的实现。  

### Notice:
	需要在项目的音频路径下的“common“文件夹中添加一个名为“stop.mp3”的无声的音频文件。

--]]
function M.stopMusic()
 	M.playMusic("common/stop.mp3")
end




return M 



