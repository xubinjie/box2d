--[[!--

box2d工具类，定义box2d相关操作方法及逻辑实现。

-   box2d的常用一些常用操作。如创建刚体、创建夹具、创建关节等

]]

----------------------
-- 类
----------------------
local M = {}
M.TAG   = "MBox2d"

--游戏世界像素单位和米单位的转换比例
M.PM = 32

--时间步
M.tStep = 1.0/60

-- 剛體類型
BDTYPE = { ST = b2_staticBody, DC = b2_dynamicBody, KT = b2_kinematicBody}

--形状类型
STYPE = { PY = e_polygon, CC = e_circle, EG = e_edge, CI = e_chain, TC = e_typeCount}





--[[--
	创建物理世界
### Useage:
	world = MBox2d:createWorld()
### Notice:
    参数集合说明:
    [必填项]
        无
    [关键项]
        b2Vec2      **gravity**               世界重力
    [选填项]
        bool        **allowSleep**            允许没有活动的刚体开启休眠，减少开支
        bool        **continuousPhysics**     连续的物理检测

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    --创建并返回一个物理世界
    world = MBox2d:createWorld()

### Returns: 
-   b2World              world
--]]--

function M:createWorld(gravity, allowSleep, continuousPhysics)
	local gravity             =   ifnil(gravity, b2Vec2(0, -9.8))
	local allowSleep          =   ifnil(allowSleep, true)
	local continuousPhysics   =   ifnil(continuousPhysics, true)

	local world               =   b2World(gravity)
	world:SetAllowSleeping(allowSleep)
	world:SetContinuousPhysics(continuousPhysics)
	mWorld                    = world
	return world
end

--[[--
			打开box2d绘制调试
### Useage:
	local debugDrawLayer = MBox2d:openDebugDraw(world)
### Notice:
    参数集合说明:
    [必填项]
        b2World      **world**               物理世界
    [关键项]
    	无
    [选填项]
		无
### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local debugDrawLayer = MBox2d:openDebugDraw()

	layer:add(debugDrawLayer)

### Returns: 
-   CCLayer              层layer
--]]--
function M:createDebugDraw(world)
	local drawWorld = ifnil(world, mWorld)
	local debugDraw = GB2DebugDrawLayer:create(drawWorld, M.PM)
	return debugDraw
end

--[[--
			开启物理世界模拟
### Useage:
	local handler = MBox2d:openWorldStep()
### Notice:
    参数集合说明:
    [必填项]
        无
    [关键项]
    	b2World      **world**                           物理世界
    	number       **velocityIteration**               速度矫正次数
    	number       **positionIteration**               位置矫正次数
    [选填项]
		无
### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local handler = MBox2d:openWorldStep()

	layer:add(debugDrawLayer)

### Returns: 
-   userdata              handler
--]]--
function M:openWorldStep(world, velocityIteration, positionIteration, listener)
	-- body

	local stepWorld =  ifnil(world, mWorld)
	local velocity  =  ifnil(velocityIteration, 8)
	local position  =  ifnil(positionIteration, 8)
	local time      =  isandroid() and 1.0 / 40 or M.tStep
	local handler	=  SC.open(
						function ( )
							stepWorld:Step(M.tStep, velocity, position)
							if listener then
								listener()
							end
						end, time)
	return handler
end

--[[--
				方法说明

### Notice:
    参数集合说明:
    [必填项]
          userdata              **handler**                 调度器开启后返回数据
    [关键项]
        无
    [选填项]
		无

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local handler = MBox2d:closeWorldStep(handler)

### Returns: 
-   nil              nil
--]]--
function M:closeWorldStep(handler)
	if handler then
		SC.close(handler)
		handler = nil
		return nil
	end
end

--[[--
					创建刚体定义
### Useage:

### Notice:
    参数集合说明:
    [必填项]
		ccpoint       **position**          位置
    [关键项]
        userdata      **type**              剛體類型
        bool          **bullet**            是否為子彈, 模拟高速子弹，开启ccd碰撞检测
        bool          **angle**      		角度
        bool          **userData**      	用户数据
    [选填项]
		bool          **fixedRotation**     是否禁止刚体旋转
		bool          **allowSleep**        是否允许睡眠
		bool          **awake**      		是否活动
		bool          **active**      		是否刚体可用
		
		bool          **linearVelocity**    线性速度
		bool          **angularVelocity**   旋转角速度
		bool          **linearDamping**     线性速度阻尼
		bool          **angularDamping**    角速度阻尼
		bool          **gravityScale**      受重力影响的系数

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local def = MBox2d:createBodyDef()

### Returns: 
-   CCNode              屏幕结点NodeScreen
--]]--
function M:createBodyDef(arr)
	local def      		 = b2BodyDef()
    -- print("=======", #BDTYPE)
	def.type       		 = ifnil(arr.type, BDTYPE.ST)
	def.position   		 = ifnil(M:toPM(arr.point), M:toPM(ccp(480, 270)))
	def.angle 			 = M:toRad(arr.angle)
	def.fixedRotation    = ifnil(arr.fixedRotation, false)
	def.bullet           = ifnil(arr.bullet, false)
	def.allowSleep 		 = ifnil(arr.allowSleep, true)
	def.awake            = ifnil(arr.awake, true)
	def.active 			 = ifnil(arr.active, true)
	def.userData 		 = ifnil(arr.userData, nil)
	
	def.linearVelocity   = ifnil(arr.linearVelocity, b2Vec2(0, 0))
	def.angularVelocity  = ifnil(arr.angularVelocity, 0)
	def.linearDamping    = ifnil(arr.linearDamping, 0)
	def.angularDamping   = ifnil(arr.angularDamping, 0)
	def.gravityScale     = ifnil(arr.gravityScale, 1)
	return def
end

--[[--
			创建刚体
### Useage:

### Notice:
    参数集合说明:
    [必填项]
        userdate    **bodyDef**         刚体定义
    [关键项]
        number      **world**           物理世界对象
    [选填项]
        无

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local body = MBox2d:createBody(def)

### Returns: 
-       b2body              body刚体
--]]--
function M:createBody(bodyDef, world)
	local body = nil
	if world then
		body       = world:CreateBody(bodyDef)
	else
		body       = mWorld:CreateBody(bodyDef)
	end
    return body
end

--[[--
            传入一个点坐标创建刚体
### Useage:

### Notice:
    参数集合说明:
    [必填项]
        ccpoint     **point**           坐标
    [关键项]
        无
    [选填项]
        无

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local body = MBox2d:createBodyForPoint(ccp(480, 270))

### Returns: 
-       b2body           body刚体
--]]--
function M:createBodyForPoint(point, world)
    local body   = nil
    local arr    = { point = point}
    local def    = M:createBodyDef(arr)
    if world then
        body     = world:CreateBody(def)
    else
        body     = mWorld:CreateBody(def)
    end
    return body
end

--[[--
                创建夹具定义
### Useage:

### Notice:
    参数集合说明:
    [必填项]
        无
    [关键项]
        b2Shape       **shape**          形状
        userdata      **userData**       用户数据
        float         **friction**       摩擦力系数
        float         **restitution**    恢复系数
        float         **density**        密度系数
        bool          **isSensor**       是否为传感器
    [选填项]
        无

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local def = MBox2d:createFixtureDef(arr)

### Returns: 
-   b2FixtureDef          夹具定义
--]]--
function M:createFixtureDef(arr)
    local def          = b2FixtureDef()
    def.shape          = ifnil(arr.shape, nil)
    def.userData       = ifnil(arr.userData, nil)
    def.friction       = ifnil(arr.friction, 0.01)
    def.restitution    = ifnil(arr.restitution, 0.01)
    def.density        = ifnil(arr.density, 0.01)
    def.isSensor       = ifnil(arr.isSensor, false)
    return def
end

--[[--
                创建夹具
### Useage:

### Notice:
    参数集合说明:
    [必填项]
        b2body         **body**    刚体
        b2fixtureFef   **def**     夹具
    [关键项]
        无
    [选填项]
        无

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local fixture = MBox2d:createFixture(body, def)

### Returns: 
-   b2Fixture         fix夹具
--]]--
function M:createFixture(body, def)
    local fix   =  body:CreateFixture(def)
    return fix
end

--[[--
                    方法说明
### Useage:

### Notice:
    参数集合说明:
    [必填项]
        无
    [关键项]
        number      **type**            形状类型
    [选填项]
        number      **w**               四边形的宽
        number      **h**               四边形的高
        number      **r**               圆形半径
        ccpoint     **point1**          边缘形状的起点
        ccpoint     **point2**          边缘形状的终点

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local node = MBox2d:createShape()

### Returns: 
-   CCNode              屏幕结点NodeScreen
--]]--
function M:createShape(arr)
    arr.type        = ifnil(type, STYPE.PY)
    local shape     = nil
    if  arr.type == STYPE.PY then
       shape        = M:createPolygonShape(arr)
    end

    if  arr.type == STYPE.EG then
       shape        =  M:createEdgeShape(arr)
    end

    if  arr.type == STYPE.CC then
       shape        =  M:createCircleShape(arr)
    end
end

--创建多边形
function M:createPolygonShape(arr)
    local shape = b2PolygonShape()
    if arr.w and arr.h then
        shape:SetAsBox(arr.w/M.PM, arr.h/M.PM)
    end
end

--创建边缘形状
function M:createEdgeShape(arr)
   local shape = b2EdgeShape()
   shape:Set(M:toPM(arr.point1), M:toPM(arr.point2))
   return shape
end

--创建圆形状
function M:createCircleShape(arr)
    local shape = b2CircleShape()
    shape.m_radius = arr.r
    return shape
end



--[[--
            创建边界
### Useage:

### Notice:
    参数集合说明:
    [必填项]
        ccpoint     **points**          点集合
    [关键项]
        无
    [选填项]
        无

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local body = MBox2d:createEdge()

### Returns: 
-       b2body          刚体
--]]--
function M:createEdge(points)
    local arr         = {point = points[1]}
    local body        = M:createBodyForPoint(points[1])
    local len         = #points
    for i = 1, len do
        local p1      = nil
        local p2      = nil
        if i~= len then
            p1        = points[i]
            p2        = points[i+1]
        else
            p1        = points[i]
            p2        = points[1]
        end
        local shape   = M:createEdgeShape({ point1 = p1, point2 = p2})
        local arr2    = { shape = shape }
        local fDef    = M:createFixtureDef(arr2)
        local fix     = M:createFixture(body, fDef)
    end
    return body
end

--[[--
			坐标单位在物理和游戏世界中互相转换
### Useage:

### Notice:
    参数集合说明:
    [必填项]
        ccp         **point**           point值类型是ccp,放回值类型b2Vec2
        b2Vec2      **point**           point值类型是b2Vec2,回值类型bccp
    [关键项]
        无
    [选填项]
		无

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    -- 测试环境
    local scene, layer = game:enterDemoScene()
    -- 添加结点[屏幕]
    local node = U.loadNodeScreen():to(layer)

### Returns: 
-   ccp or b2Vec2        point
--]]--
function M:toPM(point)
	if tolua.type(point) == "CCPoint" then 
		local pos = b2Vec2(point.x/M.PM, point.y/M.PM)
		return pos
	else
		local pos = ccp(point.x*M.PM, point.y*M.PM)
		return pos
	end	
end

--角度轉弧度
function M:toRad(ang)
	if ang then
		return math.rad(ang)
	else
		return 0
	end
end

--弧度轉角度
function M:toDeg(rad)
	if rad then
		return  -math.deg(rad)
	else
		return 0
	end
end





return M













