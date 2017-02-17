--[[--------------------------
[csu]Umeng操作【废弃模块】

 	Copyright (c) 2011-2016 Baby-Bus.com

	- Desc: 	定义Umeng操作
	- Author: 	zengbinsi
	- Date: 	2015-07-28  

--]]--------------------------  







-- --------------------------
-- -- 引入命名空间
-- --------------------------
-- -- local KUmengEvents 	= import("app.common.enum.KUmengEvents")
-- local umengEvents 	= KUmengEvents or {}



--[[
    class 
--]]


-- local M     = {}

-- M.TAG       = "ZUmeng"





--========================
--  基础封装
--========================


--[[--

发送Umeng

### Parameters:
-     类型     **参数名**                 [可选性] 参数说明

--]]--
-- function M.sendEventUmeng( ... )
--     DA.sendEvent( ... )
-- end 












-- --------------------------
-- --  场景代入
-- --------------------------


-- -- 进入-门口
-- function M.sendUmeng_cj01() 
-- 	M.sendEventUmeng(umengEvents[1].key)
-- end 

-- -- 进入-年夜饭
-- function M.sendUmeng_cj02() 
-- 	M.sendEventUmeng(umengEvents[2].key)
-- end 

-- -- 进入-烟花
-- function M.sendUmeng_cj03() 
-- 	M.sendEventUmeng(umengEvents[3].key)
-- end 

-- -- 进入-红包
-- function M.sendUmeng_cj04() 
-- 	M.sendEventUmeng(umengEvents[4].key)
-- end 

-- -- 动画mv-进入
-- function M.sendUmeng_cj05() 
-- 	M.sendEventUmeng(umengEvents[5].key)
-- end 

-- -- 动画mv-播放完毕
-- function M.sendUmeng_cj06() 
-- 	M.sendEventUmeng(umengEvents[6].key)
-- end 









-- --------------------------
-- --  门口放鞭炮
-- --------------------------


-- -- 门口-鞭炮
-- function M.sendUmeng_cj07() 
-- 	M.sendEventUmeng(umengEvents[7].key)
-- end 

-- -- 门口-妙妙
-- function M.sendUmeng_cj08() 
-- 	M.sendEventUmeng(umengEvents[8].key)
-- end 

-- -- 门口-奇奇
-- function M.sendUmeng_cj09() 
-- 	M.sendEventUmeng(umengEvents[9].key)
-- end 

-- -- 门口-灯笼
-- function M.sendUmeng_cj10() 
-- 	M.sendEventUmeng(umengEvents[10].key)
-- end 

-- -- 门口-春联
-- function M.sendUmeng_cj11() 
-- 	M.sendEventUmeng(umengEvents[11].key)
-- end 

-- -- 门口-雪人
-- function M.sendUmeng_cj12() 
-- 	M.sendEventUmeng(umengEvents[12].key)
-- end 

-- -- 门口-开门
-- function M.sendUmeng_cj13() 
-- 	M.sendEventUmeng(umengEvents[13].key)
-- end 








-- --------------------------
-- --  年夜饭
-- --------------------------

-- -- 年夜饭-吃
-- function M.sendUmeng_cj14() 
-- 	M.sendEventUmeng(umengEvents[14].key)
-- end 

-- -- 年夜饭-吃完鱼
-- function M.sendUmeng_cj15() 
-- 	M.sendEventUmeng(umengEvents[15].key)
-- end 

-- -- 年夜饭-吃完糕
-- function M.sendUmeng_cj16() 
-- 	M.sendEventUmeng(umengEvents[16].key)
-- end 

-- -- 年夜饭-吃完鸡
-- function M.sendUmeng_cj17() 
-- 	M.sendEventUmeng(umengEvents[17].key)
-- end 

-- -- 年夜饭-吃完火锅
-- function M.sendUmeng_cj18() 
-- 	M.sendEventUmeng(umengEvents[18].key)
-- end 

-- -- 年夜饭-吃完饺子
-- function M.sendUmeng_cj19() 
-- 	M.sendEventUmeng(umengEvents[19].key)
-- end 

-- -- 年夜饭-吃完辣椒
-- function M.sendUmeng_cj20() 
-- 	M.sendEventUmeng(umengEvents[20].key)
-- end 

-- -- 年夜饭-吃完水果
-- function M.sendUmeng_cj21() 
-- 	M.sendEventUmeng(umengEvents[21].key)
-- end 








-- --------------------------
-- --  放烟花
-- --------------------------


-- -- 烟花-放普通烟花
-- function M.sendUmeng_cj22() 
-- 	M.sendEventUmeng(umengEvents[22].key)
-- end 

-- -- 烟花-放飞行器烟花
-- function M.sendUmeng_cj23() 
-- 	M.sendEventUmeng(umengEvents[23].key)
-- end 

-- -- 烟花-放2016烟花
-- function M.sendUmeng_cj24() 
-- 	M.sendEventUmeng(umengEvents[24].key)
-- end 

-- -- 烟花-放熊猫头烟花
-- function M.sendUmeng_cj25() 
-- 	M.sendEventUmeng(umengEvents[25].key)
-- end 

-- -- 烟花-放火箭烟花
-- function M.sendUmeng_cj26() 
-- 	M.sendEventUmeng(umengEvents[26].key)
-- end 

-- -- 烟花-拖动塞燃料
-- function M.sendUmeng_cj27() 
-- 	M.sendEventUmeng(umengEvents[27].key)
-- end 

-- -- 烟花-点击塞燃料
-- function M.sendUmeng_cj28() 
-- 	M.sendEventUmeng(umengEvents[28].key)
-- end 

-- -- 烟花-点击烟花筒
-- function M.sendUmeng_cj29() 
-- 	M.sendEventUmeng(umengEvents[29].key)
-- end 

-- -- 烟花-点击屏幕
-- function M.sendUmeng_cj30() 
-- 	M.sendEventUmeng(umengEvents[30].key)
-- end 









-- --------------------------
-- --  春节
-- --------------------------


-- -- 红包-动物作揖
-- function M.sendUmeng_cj31() 
-- 	M.sendEventUmeng(umengEvents[31].key)
-- end 

-- -- 红包-红包撒钱
-- function M.sendUmeng_cj32() 
-- 	M.sendEventUmeng(umengEvents[32].key)
-- end 








-- --------------------------
-- --  按钮
-- --------------------------


-- -- 门口-Home键
-- function M.sendUmeng_cj33() 
-- 	M.sendEventUmeng(umengEvents[33].key)
-- end 

-- -- 门口-下一关
-- function M.sendUmeng_cj34() 
-- 	M.sendEventUmeng(umengEvents[34].key)
-- end 

-- -- 年夜饭-上一关
-- function M.sendUmeng_cj35() 
-- 	M.sendEventUmeng(umengEvents[35].key)
-- end 

-- -- 年夜饭-下一关
-- function M.sendUmeng_cj36() 
-- 	M.sendEventUmeng(umengEvents[36].key)
-- end 

-- -- 烟花-上一关
-- function M.sendUmeng_cj37() 
-- 	M.sendEventUmeng(umengEvents[37].key)
-- end 

-- -- 烟花-下一关
-- function M.sendUmeng_cj38() 
-- 	M.sendEventUmeng(umengEvents[38].key)
-- end 

-- -- 红包-Home键
-- function M.sendUmeng_cj39() 
-- 	M.sendEventUmeng(umengEvents[39].key)
-- end 







-- --------------------------
-- --  场景使用时长采集点
-- --------------------------

-- -- 开始场景计时
-- function M.sendPageBegin( ... )
-- 	DA.sendPageBegin( ... )
-- end

-- -- 发送场景时长
-- function M.sendPageEnd( ... )
-- 	DA.sendPageEnd( ... )
-- end


-- -- DA.sendPageBegin(“Scene01”)
-- -- DA.sendPageEnd(“Scene01”) 

-- -- 阶段时长[场景时长-play页面]
-- function M.sendUmengPageBegin_GP()
-- 	M.sendPageBegin(umengEvents[40].key)
-- end

-- -- 阶段时长[场景时长-play页面]
-- function M.sendUmengPageEnded_GP()
-- 	M.sendPageEnd(umengEvents[40].key)
-- end




-- -- 阶段时长[场景时长-儿歌mv]
-- function M.sendUmengPageBegin_MV()
-- 	M.sendPageBegin(umengEvents[41].key)
-- end

-- -- 阶段时长[场景时长-儿歌mv]
-- function M.sendUmengPageEnded_MV()
-- 	M.sendPageEnd(umengEvents[41].key)
-- end




-- -- 阶段时长[场景时长-门口]
-- function M.sendUmengPageBegin_OD()
-- 	M.sendPageBegin(umengEvents[42].key)
-- end

-- -- 阶段时长[场景时长-门口]
-- function M.sendUmengPageEnded_OD()
-- 	M.sendPageEnd(umengEvents[42].key)
-- end




-- -- 阶段时长[场景时长-年夜饭]
-- function M.sendUmengPageBegin_BD()
-- 	M.sendPageBegin(umengEvents[43].key)
-- end

-- -- 阶段时长[场景时长-年夜饭]
-- function M.sendUmengPageEnded_BD()
-- 	M.sendPageEnd(umengEvents[43].key)
-- end




-- -- 阶段时长[场景时长-烟花]
-- function M.sendUmengPageBegin_KG()
-- 	M.sendPageBegin(umengEvents[44].key)
-- end

-- -- 阶段时长[场景时长-烟花]
-- function M.sendUmengPageEnded_KG()
-- 	M.sendPageEnd(umengEvents[44].key)
-- end





-- -- 阶段时长[场景时长-红包]
-- function M.sendUmengPageBegin_VS()
-- 	M.sendPageBegin(umengEvents[45].key)
-- end

-- -- 阶段时长[场景时长-红包]
-- function M.sendUmengPageEnded_VS()
-- 	M.sendPageEnd(umengEvents[45].key)
-- end








-- --------------------------
-- -- prototype
-- --------------------------




-- --------------------------
-- -- overread 
-- -------------------------- 




-- return M







