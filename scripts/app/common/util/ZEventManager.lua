--[[--------------------------
[csu]事件管理器

     Copyright (c) 2011-2016 Baby-Bus.com

    - Desc:   事件管理器
    - Author: zengbinsi
    - Date:   2016-03-01 

--]]--------------------------  








--[[
	类
--]]
local M 		= class("ZEventManager", {})
M.TAG    		= "ZEventManager"

---
-- 单例对象
---
M.eventManager  = nil 







--------------------------
--  模板
--------------------------
function M:ctor(params)
	self.listeners 			= {}
	self.listenerHandleIndex = 0
end


function M:onDestructor()
	M.eventManager = nil 
end






--========================
-- 功能方法
--========================
--[[--
获取事件管理器的单例

<br/>  
### Useage:
    获取事件管理器的实例化对象。

### Notice:
    该对象是一个单例对象。

### Example:
    -- 获取实例
    local eventManager = ZEventManager.getInstance()
    -- 添加事件
    eventManager:addEventListener("TestEve", function(event, a)
        print(event, a, 1)
    end)
    eventManager:addEventListener("TestEve2", function(event, a)
        print(event, a, 2)
    end)
    eventManager:addEventListener("TestEve", function(event, a)
        print(event, a, 3)
    end)
    -- 触发事件
    eventManager:dispatchEvent({name = "TestEve"})

### Returns: 
-   ZEventManager                        事件管理器的单例对象 

--]]--
function M.getInstance()
	M.eventManager = M.eventManager or M.new()

	return M.eventManager
end


--[[--
添加事件监听

<br/>  
### Useage:
    往事件监听器里面添加自定义事件。

### Notice:
    listener事件回调函数需携带一个event参数。

### Example:

    local function callback(event)
        print(event, event.name)
    end
    
    local eventManager = ZEventManager.getInstance()
    eventManager:addEventListener("MY_EVENT", callback)
    eventManager:dispatchEvent({name = "MY_EVENT"})

### Parameters:
-   string | number     **eventName**                   [必选] 事件名称  
-   function            **listener**                    [必选] 事件回调  

### Returns: 
-   string                             事件句柄

--]]--
function M:addEventListener(eventName, listener)
    assert(type(listener) == "function", eventName .. "事件回调必须是一个function类型，你传输的是'" .. type(listener) .. "'类型!")
    eventName = string.upper(eventName)
    
    if self.listeners[eventName] == nil then
        self.listeners[eventName] = {}
    end

    self.listenerHandleIndex = self.listenerHandleIndex + 1
    local handle = string.format("HANDLE_%d", self.listenerHandleIndex)
    self.listeners[eventName][handle] = listener
    
    return handle
end

--[[--
触发事件

<br/>  
### Useage:
    进行事件触发。

### Notice:
    说明：event事件对象是一个table，里面必须包含一个name属性，用于表示要触发的事件类型。

### Example:
    local eventManager = ZEventManager.getInstance()
    eventManager:dispatchEvent({name = "MY_EVENT"})

### Parameters:
-   table     **event**                 [必选] 事件对象  

--]]--
function M:dispatchEvent(event, ...)
    local gParams    = {...}

    xpcall(function()
        event.name      = string.upper(event.name)
        local params    = gParams or {}
        local eventName = event.name

        if self.listeners[eventName] == nil then return end

        event.target    = event.target or self

        for handle, listener in pairs(self.listeners[eventName]) do
            local ret = listener(event, unpack(params))
            if ret == false then
                break
            elseif ret == "__REMOVE__" then
                self.listeners[eventName][handle] = nil
            end
        end
    end, function(msg)
        -- body
    end)
end

--[[--
移除事件

<br/>  
### Useage:
    从事件管理器中移除一个事件。

### Parameters:
-   string | number       **eventName**       [必选] 事件名称  
-   string | function     **key**             [必选] 事件句柄 | 注册事件时的事件回调函数对象  

### Returns: 
-   nil                         返回一个空值，外部变量可以直接获取，置空。      

--]]--
function M:removeEventListener(eventName, key)
    eventName = string.upper(eventName)
    if self.listeners[eventName] == nil or (not key) then return end

    for handle, listener in pairs(self.listeners[eventName]) do
        if key == handle or key == listener then
            self.listeners[eventName][handle] = nil
            break
        end
    end

    -- 返回一个空值，外部变量可以直接获取，置空。
    return nil 
end

--[[--
移除事件

<br/>  
### Useage:
    根据事件名称移除事件。

### Notice:
    只能根据事件名称进行移除。

### Example:

### Parameters:
-   string | number        **eventName**       [必选] 事件名称  

### OptionParameters

### Returns: 
-   返回值类型                             返回值说明

--]]--
function M:removeAllEventListenersForEvent(eventName)
    self.listeners[string.upper(eventName)] = nil
end

--[[--
移除全部事件

<br/>  
### Useage:
    移除全部事件。

--]]--
function M:removeAllEventListeners()
    self.listeners = {}
end






--========================
-- 属性
--========================




--========================
-- 父类重写
--========================




return M






