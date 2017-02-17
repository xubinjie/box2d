-- [全局错误捕获函数]
-- for CCLuaEngine 
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end



-- [框架/增量包引入]
-- 引入BBFramework框架[框架自动引入]
CCLuaLoadChunksFromZIP("res/bb.bin")
-- 引入游戏基础包
CCLuaLoadChunksFromZIP("res/base.bin")
-- 引入游戏游戏包
CCLuaLoadChunksFromZIP("res/game.bin")



-- [游戏入口]
--[[  
	xpcall(调用函数, 错误捕获函数);  
	lua提供了xpcall来捕获异常  
	xpcall接受两个参数:调用函数、错误处理函数。  
	当错误发生时,Lua会在栈释放以前调用错误处理函数,因此可以使用debug库收集错误相关信息。  
	两个常用的debug处理函数:debug.debug和debug.traceback  
	前者给出Lua的提示符,你可以自己动手察看错误发生时的情况;  
	后者通过traceback创建更多的错误信息,也是控制台解释器用来构建错误信息的函数。  
--]]  
xpcall(function()
    -- Avoid memory leak 设置脚本内存回收参数 避免内存泄露 垃圾回收  
    -- collectgarbage("setpause", 100)  
    -- collectgarbage("setstepmul", 5000)  

    require("init")
    require("game")
    
    game:startup()
end, __G__TRACKBACK__)
