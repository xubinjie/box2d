--[[--------------------------
[csu]内存管理

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	内存管理
	- Author: 	zengbinsi
	- Date: 	2016-04-26 

--]]--------------------------  







--[[
	类
--]]


local M 	= {}
M.TAG 		= "ZMemory"




--========================
-- 功能方法
--========================  

--[[--
打印缓存纹理数据

<br/>  
### Useage:
	ZMemory.dumpCachedTextureInfo()

### Notice:
	用于显示当前显存中的图片资源信息。

--]]--
function M.dumpCachedTextureInfo()
 	CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
end

--[[--
设置默认的纹理像素格式

<br/>  
### Useage:

### Aliases:

### Notice:

	最快速地减少纹理内存占用的办法就是把它们作为16位颜色深度的纹理来加载。cocos2d默认的纹理像素格
		式是32位颜色深度。如果把颜色深度减半，那么内存消耗也就可以减少一半。并且这还会带来渲染效率
		的提升，大约提高10%。

	首先，纹理像素格式的改变会影响后面加载的所有纹理。因此，如果你想后面加载纹理使用不同的像素格式的
		话，必须再调用此方法，并且重新设置一遍像素格式。
	其次，如果你的CCTexture2D设置的像素格式与图片本身的像素格式不匹配的话，就会导致显示严重失真。比
		如颜色不对，或者透明度不对等等。



### Example:

	ZTools.setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)

### Parameters:
- 	类型 	**pixelFormat** 			[必选] 像素格式  

### OptionParameters

	pixelFormat: 
		generate 32-bit textures: kCCTexture2DPixelFormat_RGBA8888 (default)
		generate 16-bit textures: kCCTexture2DPixelFormat_RGBA4444
		generate 16-bit textures: kCCTexture2DPixelFormat_RGB5A1
		generate 16-bit textures: kCCTexture2DPixelFormat_RGB565 (no alpha)

### Returns: 
-   nil 							无返回值

--]]--
function M.setDefaultAlphaPixelFormat(pixelFormat)
 	CCTexture2D:setDefaultAlphaPixelFormat(pixelFormat or kCCTexture2DPixelFormat_RGBA4444)
end

--[[--
移除纹理缓存和帧缓存

<br/>  
### Useage:
	ZMemory.removeUnusedTexturesAndFrames()

### Notice:
	说明

--]]--
function M.removeUnusedTexturesAndFrames()
 	-- 先移除帧缓存，消除对图片纹理的引用
	R.removeUnusedFrames()
	-- 移除纹理缓存最好在移除帧缓存之后执行，中间空一两帧来保证帧缓存被释放
	F.delayCall(2 / 60, function()
		-- 再移除未使用的纹理对象
		R.removeUnusedTextures()
	end)

	-- CCTextureCache:sharedTextureCache():removeUnusedTextures()
	-- CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
end

--[[--
回收lua内存

<br/>  
### Useage:

### Notice:
	在适当的时候进行显式的回收

--]]--
function M.collect()
 	collectgarbage("collect")
end

--[[--
统计lua内存

<br/>  
### Useage:

### Notice:
	用于打印lua虚拟机占用的内存。

--]]--
function M.count()
 	collectgarbage("count")
end

--[[--
回收lua内存

<br/>  
### Useage:

### Notice:
	进行一次显式的内存回收

--]]--
function M:step()
 	collectgarbage("step")
end








return M 








