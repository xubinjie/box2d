--[[--

方法

### Useage:

### Aliases:

### Notice:
	说明

### Example:

### Parameters:
- 	类型 	**参数名** 				[可选性] 参数说明

### OptionParameters

### Returns: 
-   返回值类型 							返回值说明

--]]--[[

Copyright (c) 2012-2013 Baby-Bus.com

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

场景类，定义场景相关操作方法及逻辑实现。

-   定义场景功能方法。

]]

----------------------
-- 类
----------------------
local M = classScene("V_demo")


----------------------
-- 公共参数
----------------------
-- [常量]
-- ..

-- [操作变量]
-- ..








----------------------
-- 构造方法
----------------------
--[[--

构造方法，定义视图实例初始化逻辑

### Parameters:
-   table **params**    参数集合

### Return: 
-   object              对象实例

]]
function M:ctor(params)
	-- [超类调用]
	self:assertParameters(params)
end








----------------------
-- 视图渲染
----------------------
--[[--

视图渲染，处理视图结点加载、事件绑定等相关操作

]]
function M:onRender()
	print("Hello Guy!")
end








----------------------
-- 结点析构
----------------------
--[[--

视图析构，处理视图结点卸载、事件解除绑定等相关操作

]]
function M:onDestructor()

end








----------------------
-- 模板方法
----------------------
--[[--

获得层名称集合, 用于动态定义该场景需要加载的层

### Returns: 
-   string...       	层名称1, 层名称2, ...

]]
function M:getLayerNames()
    return "main"
end

--[[--

获得获得信息集合, 用于动态定义该场景需要加载的资源(纹理, 帧等)

### Returns: 
-   string|table...    	帧名称1|{资源名称,类型,自动清理,图片后缀(包含.)}, ...

]]
-- function M:getResourceNames()
--     return 
-- end

--[[--

获得广告布局枚举

### Links:
	UNative@addAd 参看ADLayout枚举

### Returns: 
-   number   			广告布局枚举

]]
-- function M:getAdLayout()
--     return AD_LAYOUT_TOP_CENTER
-- end

--[[--

判断是否是欢迎场景

### Useage:
	local yn = FScene:isWelcomeScene()

### Aliases:
    
### Notice:

### Example:

### Parameters:

### Returns: 
-   bool         	是否是指定场景的标识

--]]--
-- function M:isWelcomeScene()
-- 	return true
-- end

--[[--

判断是否是欢迎场景需要添加评分

### Useage:
	local yn = FScene:isWelcomeSceneShowScore()

### Aliases:
    
### Notice:

### Example:

### Parameters:

### Returns: 
-   bool         	是否是指定场景的标识

--]]--
-- function M:isWelcomeSceneShowScore()
-- 	return true
-- end

--[[--

判断是否是欢迎场景需要添加设置

### Useage:
	local yn = FScene:isWelcomeSceneShowSettings()

### Aliases:
    
### Notice:

### Example:

### Parameters:

### Returns: 
-   bool         	是否是指定场景的标识

--]]--
-- function M:isWelcomeSceneShowSettings()
-- 	return false
-- end








----------------------
-- 验证
----------------------
-- 验证参数
function M:assertParameters(params)

end



return M