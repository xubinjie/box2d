--[[--------------------------
[csu]Box2D物理引擎工具类

     Copyright (c) 2011-2016 Baby-Bus.com

    - Desc:   工具类[Physics - Box2D]  
    - Author: zengbinsi
    - Date:   2015-06-29  

--]]--------------------------  







--[[
    Box2D物理引擎工具类(单例对象)
--]]


local M     = {}
M.TAG       = "ZBox2D"





--[[
    定义刚体类型枚举
--]]
if not EBodyType then 
    EBodyType   = {
        -- 静态刚体(不会移动)
        STATIC      = b2_staticBody or 0,
        -- 动态刚体(默认值)
        DYNAMIC     = b2_dynamicBody or 1,
        -- 平台刚体
        KINEMATIC   = b2_kinematicBody or 2,
    }
    EBodyType.TAG       = "EBodyType"

    --------------------------
    -- 转成字符串
    --------------------------
    function EBodyType.toString(enumValue)
        local result    = "Dynamic"

        if enumValue == EBodyType.STATIC then 
            result  = "Static"
        elseif enumValue == EBodyType.KINEMATIC then 
            result  = "Kinematic"
        end

        return result 
    end

    --------------------------
    -- 转成枚举
    --------------------------

    function EBodyType.toEnumByString(enumString)
        enumString      = string.lower(enumString)
        local result    = EBodyType.DYNAMIC

        if enumString == "static" then 
            result  = EBodyType.STATIC
        elseif enumString == "kinematic" then 
            result  = EBodyType.KINEMATIC
        end

        return result 
    end
end

--[[
    定义形状枚举
--]]
if not EShape then 
    EShape     = {
        -- 点
        DOT         = 0,
        -- 圆
        CIRCLE      = 1,
        -- 线
        LINE        = 2,
        -- 边 
        EDGE        = 3,
        -- 三角形
        TRIANGLE    = 4,
        -- 矩形 
        RECTANGLE   = 5,
        -- 多边形
        POLYGON     = 6,
        -- 链条
        CHAIN       = 7,
        -- ...      
        -- 默认
        DEFAULT     = -1,
    }
    EShape.TAG       = "EShape"

    --------------------------
    -- 转成字符串
    --------------------------
    function EShape.toString(enumValue)
        local result    = "Default"

        if enumValue == EShape.DOT then 
            result  = "Dot"
        elseif enumValue == EShape.CIRCLE then 
            result  = "Circle"
        elseif enumValue == EShape.LINE then 
            result  = "Line"
        elseif enumValue == EShape.EDGE then 
            result  = "Edge"
        elseif enumValue == EShape.TRIANGLE then 
            result  = "Triangle"
        elseif enumValue == EShape.RECTANGLE then 
            result  = "Rectangle"
        elseif enumValue == EShape.POLYGON then 
            result  = "Polygon"
        elseif enumValue == EShape.CHAIN then 
            result  = "Chain"
        end

        return result 
    end

    --------------------------
    -- 转成枚举
    --------------------------

    function EShape.toEnumByString(enumString)
        enumString      = string.lower(enumString)
        local result    = EShape.DEFAULT

        if enumString == "dot" then 
            result  = EShape.DOT
        elseif enumString == "circle" then 
            result  = EShape.CIRCLE
        elseif enumString == "line" then 
            result  = EShape.LINE
        elseif enumString == "edge" then 
            result  = EShape.EDGE
        elseif enumString == "triangle" then 
            result  = EShape.TRIANGLE
        elseif enumString == "rectangle" then 
            result  = EShape.RECTANGLE
        elseif enumString == "polygon" then 
            result  = EShape.POLYGON
        elseif enumString == "chain" then 
            result  = EShape.CHAIN 
        end

        return result 
    end
end



---
-- 像素/米（用于将opengl坐标转换成box2D坐标的比例尺）
---
PTM_RATIO               = 32                

---
-- 圆周率
---
M.PI                    = math.pi     -- 3.1415926                    

---
-- 角度换算成弧度[math.rad(angle)]
---
TO_PI                   = M.PI / 180.0       

---
-- 弧度换算成角度[math.deg(radian)]
---
TO_D                    = 180.0 / M.PI    


---
-- 时间步
---
M.timeStep              = 1.0 / 60

---
-- 速度迭代
---
M.velocityIterations    = 32

---
-- 位置迭代
---
M.positionIterations    = 32
                         







---
-- 物理世界
---
currentPhysicsWorld     = nil 

             









--========================================================================
-- 构造型函数 
--========================================================================




--[[--
创建物理世界

<br/>  
### Useage:
    local world = ZBox2D.createWorld(重力矢量, 是否允许静止的物体休眠, 是否开启连续物理检测, 世界的边界点的集合)
    
### Aliases:

### Notice:
    box2D的力一般以b2Vec2类型表示。
    这里创建的物理世界会保存在一个全局变量里面，以方便访问。所以当这个世界不需要存在的时候记得一定要进行销毁。

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    
### Parameters:
-   b2Vec2  **gravity**                 [可选] 重力矢量  
-   boolean **isAllowSleeping**         [可选] 是否允许静止的物体休眠  
-   boolean **isContinuousPhysics**     [可选] 是否开启连续物理检测  
-   table   **edgePoints**              [可选] 世界边缘坐标集合   

### OptionParameters

### Returns: 
-   b2World                             物理世界对象

--]]--
function M.createWorld(gravity, isAllowSleeping, isContinuousPhysics, edgePoints)
    -- 数据验证 
    isAllowSleeping     = ifnil(isAllowSleeping, true)
    isContinuousPhysics = ifnil(isContinuousPhysics, true)

    -- 创建世界
    local world     = b2World(gravity or b2Vec2(0.0, -9.8))

    -- 允许静止的物体休眠
    world:SetAllowSleeping(isAllowSleeping)
    -- 开启连续物理检测，使模拟更加的真实
    world:SetContinuousPhysics(isContinuousPhysics)

    -- 保留引用
    currentPhysicsWorld     = world 

    -- 创建边沿
    if edgePoints then M.createWorldEdge(edgePoints) end 

    return world
end 

--[[--
创建物理世界

<br/>  
### Useage:
    local world = ZBox2D.createWorldAndEdge(重力矢量, 是否允许静止的物体休眠, 是否开启连续物理检测, 世界的边界点的集合)
    
### Aliases:

### Notice:
    box2D的力一般以b2Vec2类型表示。
    这里创建的物理世界会保存在一个全局变量里面，以方便访问。所以当这个世界不需要存在的时候记得一定要进行销毁。

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    
### Parameters:
-   b2Vec2  **gravity**                 [可选] 重力矢量  
-   boolean **isAllowSleeping**         [可选] 是否允许静止的物体休眠  
-   boolean **isContinuousPhysics**     [可选] 是否开启连续物理检测  
-   table   **edgePoints**              [可选] 世界边缘坐标  

### OptionParameters

### Returns: 
-   b2World                             物理世界对象

--]]--
function M.createWorldAndEdge(gravity, isAllowSleeping, isContinuousPhysics, edgePoints)
    -- 数据验证 
    isAllowSleeping     = ifnil(isAllowSleeping, true)
    isContinuousPhysics = ifnil(isContinuousPhysics, true)

    -- 创建世界
    local world     = b2World(gravity or b2Vec2(0.0, -9.8))

    -- 允许静止的物体休眠
    world:SetAllowSleeping(isAllowSleeping)
    -- 开启连续物理检测，使模拟更加的真实
    world:SetContinuousPhysics(isContinuousPhysics)

    -- 保留引用
    currentPhysicsWorld     = world 

    -- 创建边沿
    M.createWorldEdge(edgePoints)

    return world
end 

--[[--
创建世界边沿

<br/>  
### Useage:
    local edge = ZBox2D.createWorldEdge(世界边缘坐标点集合)
    
### Aliases:

### Notice:
    世界的边缘一般是使用四条线（刚体）首尾相连而成。
    因为屏幕的缘故，边缘一般用顺时针或者逆时针顺序的四个点围成。

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    
### Parameters:
-   table   **points**              [可选] 世界边缘坐标点集合  

### OptionParameters

### Returns: 
-   b2Body                          世界边沿对象

--]]--
function M.createWorldEdge(points)
    -- 边沿构造器[创建一条边]
    local function edgeMacker(body, fromPoint, toPoint, id)
        local shape         = b2EdgeShape()
        local fixtureDef    = b2FixtureDef()

        shape:Set(b2Vec2(fromPoint.x / PTM_RATIO, fromPoint.y / PTM_RATIO), 
                b2Vec2(toPoint.x / PTM_RATIO, toPoint.y / PTM_RATIO))
        fixtureDef.shape    = shape
        fixtureDef.id       = id

        body:CreateFixture(fixtureDef)
    end

    -- 边沿定义，创建边沿
    local edgeBodyDef   = b2BodyDef()
    local edgeBody      = currentPhysicsWorld:CreateBody(edgeBodyDef)

    -- 生成上下左右四条边沿
    if true then
        points      = points or {ccp(0, 0), ccp(V.w, 0), ccp(V.w, V.h), ccp(0, V.h),}
        local len   = #points 

        for i = 1, len do
            local fromPos   = points[i]
            local toPos     = points[i + 1] or points[1]

            edgeMacker(edgeBody, fromPos, toPos, i)
        end
       
        -- edgeMacker(edgeBody, points[1], points[2], 1)
        -- edgeMacker(edgeBody, points[1], points[4], 2)
        -- edgeMacker(edgeBody, points[3], points[4], 3)
        -- edgeMacker(edgeBody, points[3], points[2], 4)
    end

    -- 保留引用
    currentPhysicsWorld.edgeBody = edgeBody

    return edgeBody
end 









--[[--
创建刚体

<br/>  
### Useage:
    local bodyDef = ZBox2D.createBody(刚体信息, 包含形状信息的.plist文件, 物理形状图片名称)
    
### Aliases:

### Notice:
    形状主要用于碰撞。

### Example:
    ----------------------
    -- 示例1: 
    ----------------------
    
### Parameters:
-   table   **bodyInfo**    [必选] 刚体信息   
-   String  **plistPath**   [必选] PhysicsEditor导出的.plist文件  
-   String  **key**         [必选] plist文件中物理形状图片名称  

### OptionParameters

### Returns: 
-   b2Body                  刚体对象

--]]--
function M.createBody(bodyInfo, plistPath, key)    
    bodyInfo            = bodyInfo or {}
    -- 创建一个刚体的定义，里面保存要创建的所有信息（位置、角度、类型等）。
    local bodyDef       = M.createDef(bodyInfo) 
    -- 创建一个刚体对象，根据刚体定义创建
    local body          = currentPhysicsWorld:CreateBody(bodyDef)
    -- 设置刚体的用户数据（Lua是动态数据类型语言，这里自动增加一个属性，不是box2d刚体的做法）。
    body.userData       = ifnil(bodyInfo.userData, nil)

    -- 如果用户数据存在，将刚体保存位用户数据的一个属性，方便使用用户数据访问刚体，不是box2d刚体的做法。
    if body.userData then 
        body.userData.body  = body 
    end

    -- 创建简单或复杂的纹理（形状）
    if plistPath then
        M.addComplexFixture(body, plistPath, key)
    else
        M.addSimpleFixture(body, bodyInfo)
    end
    
    return body
end 

--[[--
创建刚体描述

<br/>  
### Useage:
    local bodyDef = ZBox2D.createDef(刚体信息)
    
### Aliases:

### Notice:
    形状主要用于碰撞。

### Example:
    ----------------------
    -- 示例1: 
    ----------------------
    
### Parameters:
-   table   **params**      [必选] 刚体信息   

### OptionParameters

### Returns: 
-   b2BodyDef               刚体描述

--]]--
function M.createDef(params)
    -- b2BodyDef：物体定义。是一个结构体，定义body的类型，位置，角度(弧度)
    local bodyDef           = b2BodyDef()

    -- 类型：静态(b2_staticBody),动态(b2_dynamicBody),平台(b2_kinematicBody)
    bodyDef.type            = params.bodyType or (EBodyType.DYNAMIC or b2_staticBody)
    -- 位置，是一个矢量b2Vec2
    bodyDef.position        = M.ccpToVecRatio(params.point)
    -- 旋转角度：单位为弧度制，所以进行了乘以“TO_PI”的操作，外部传进来的必须是角度（而不是弧度）。
    bodyDef.angle           = params.angle and params.angle * TO_PI or 0.0
    -- 用户数据：存储用户的数据，可以是任何类型的数据。一般要求存储的数据的类型是一致的
    bodyDef.userData        = params.userData
    -- 是否是传感器：是否只检测碰撞，不产生碰撞效果
    bodyDef.isSensor        = params.isSensor or false 
    -- 角度阻尼：阻碍刚体旋转的系数，让刚体旋转更容易停下来。
    bodyDef.angularDamping  = params.angularDamping or 0
    -- 线性阻尼：阻碍刚体移动的系数，让刚体移动更容易停下来。
    bodyDef.linearDamping   = params.linearDamping or 0 
    -- 固定旋转：开启后刚体运动无法进行旋转，只能以创建时的角度存在。
    bodyDef.fixedRotation   = params.fixedRotation 

    return bodyDef 
end

--[[--
添加复杂的纹理

<br/>  
### Useage:
    ZBox2D.addComplexFixture(刚体对象, 包含形状信息的.plist文件, 物理形状图片名称)
    
### Aliases:

### Notice:
    用于给刚体绑定物理形状、质量、摩擦力、弹性系数等物理属性。

### Example:
    ----------------------
    -- 示例1: 
    ----------------------
    
### Parameters:
-   b2Body  **body**        [必选] 刚体对象  
-   String  **plistPath**   [必选] PhysicsEditor导出的.plist文件  
-   String  **key**         [必选] plist文件中物理形状图片名称  

### OptionParameters

### Returns: 

--]]--
function M.addComplexFixture(body, plistPath, key)
    -- 加载physicsDesigner的.plist格式文件
    GB2ShapeCache:sharedGB2ShapeCache():addShapesWithFile(plistPath)
    -- 把生成的刚体和形状绑在一起，key即图片名
    GB2ShapeCache:sharedGB2ShapeCache():addFixturesToBody(body, key)

    -- 获取plist里面的锚点信息
    local anchor    = GB2ShapeCache:sharedGB2ShapeCache():anchorPointForShape(key)
    -- 获取刚体的用户数据，并转换为CCSprite类型
    local userData  = tolua.cast(body:GetUserData(), "CCSprite")

    -- 如果用户数据存在并且是精灵类型，设置精灵锚点为plist文件里面的刚体锚点位置（同步锚点）。
    if userData then userData:setAnchorPoint(anchor) end
end 

--[[--
添加简单的纹理

<br/>  
### Useage:
    ZBox2D.addSimpleFixture(刚体对象, 形状信息)
    
### Aliases:

### Notice:
    用于给刚体绑定物理形状、质量、摩擦力、弹性系数等物理属性。

### Example:
    ----------------------
    -- 示例1: 
    ----------------------
    
### Parameters:
-   b2Body  **body**        [必选] 刚体对象  
-   table   **bodyInfo**    [必选] 刚体信息   

### OptionParameters

### Returns: 

--]]--
function M.addSimpleFixture(body, bodyInfo)
    -- -- 创建一个刚体的纹理（夹具/材质）
    -- local fixtureDef                = b2FixtureDef()
    -- -- 密度：影响刚体的惯性、重量等
    -- fixtureDef.density              = bodyInfo.density or 0.0
    -- -- 摩擦系数：物体存在接触时影响相对位移的系数
    -- fixtureDef.friction             = bodyInfo.friction or 0.2
    -- -- 弹性系数：表示能量损失的系数，1表示完全弹性碰撞，0表示完全非弹性碰撞，0～1之间表示有能量损失的弹性碰撞 
    -- fixtureDef.restitution          = bodyInfo.restitution or 0.0 
    -- -- 分组编号：用于标记和处理是否产生碰撞 
    -- fixtureDef.filter.groupIndex    = bodyInfo.groupIndex or 0

    -- 创建刚体的材质
    local fixtureDef = M.createFixtureDef(bodyInfo)
    
    -- 创建一个或多个形状
    if bodyInfo.shape then
        for _, v in pairs(bodyInfo.shape) do
            local function shapeMaker(body, shape)
                -- 根据形状信息创建一个形状
                local shapeObj      = M.createShape(shape)
                -- 将形状和材质绑定（只是简单的保存了引用）
                fixtureDef.shape    = shapeObj 
                -- 将刚体和材质绑定（只是简单的保存了引用）
                body.fixtureDef     = fixtureDef 
                -- 创建刚体的材质（这里才是真正的绑定了）
                local fixture       = body:CreateFixture(fixtureDef)
            end

            -- 如果bodyInfo.shape里面保存的是表，说明bodyInfo.shape里面是多个形状的信息，应该使用bodyInfo.shapes才对。 
            if type(v) == "table" then
                shapeMaker(body, v)
            else
                -- 如果bodyInfo.shape里面保存的不是表，说明bodyInfo.shape就是一个形状信息 
                shapeMaker(body, bodyInfo.shape)
                break
            end
        end
    end
end 

--[[--
创建材质定义

<br/>  
### Parameters:
-     类型     **参数名**                 [可选性] 参数说明

### OptionParameters

### Returns: 
-   返回值类型                             返回值说明

--]]--
function M.createFixtureDef(fixtureInfo)
    fixtureInfo     = fixtureInfo or {}

    -- 创建一个刚体的纹理（夹具/材质）
    local fixtureDef                = b2FixtureDef()
    -- 密度：影响刚体的惯性、重量等
    fixtureDef.density              = fixtureInfo.density or 1.0
    -- 摩擦系数：物体存在接触时影响相对位移的系数
    fixtureDef.friction             = fixtureInfo.friction or 0.2
    -- 弹性系数：表示能量损失的系数，1表示完全弹性碰撞，0表示完全非弹性碰撞，0～1之间表示有能量损失的弹性碰撞 
    fixtureDef.restitution          = fixtureInfo.restitution or 0.01 
    -- 分组编号：用于标记和处理是否产生碰撞 
    fixtureDef.filter.groupIndex    = fixtureInfo.groupIndex or 0
    -- 用户数据
    fixtureDef.userData             = fixtureInfo.userData or nil 
    -- 是否是传感器【传感器可以接收到碰撞信号，但是不发生碰撞反应，直接穿透。】
    fixtureDef.isSensor             = fixtureInfo.isSensor or false 

    return fixtureDef
end


--[[--
添加线段夹具

<br/>  
### Notice:
    给刚体添加一个边线夹具，用于碰撞

### Parameters:
-   b2Body      **body**            [必选] 刚体对象  
-   CCPoint     **starPoint**       [必选] 起点  
-   CCPoint     **endPoint**        [必选] 终点  
-   table       **fixtureInfo**     [必选] 夹具信息  

### OptionParameters
    ## fixtureInfo 
    -   number      **density**     [可选] 密度  
    -   number      **friction**    [可选] 摩擦系数  
    -   number      **restitution** [可选] 弹性系数  
    -   number      **groupIndex**  [可选] 碰撞分组  
    -   boolean     **isSensor**    [可选] 是否是传感器  
    -   任意类型     **userData**    [可选] 用户数据  

### Returns: 
-   b2Fixture                        刚体夹具

--]]--
function M.addSimpleFixtureLine(body, startPoint, endPoint, fixtureInfo)
    -- 创建刚体的材质
    local fixtureDef    = M.createFixtureDef(fixtureInfo)
    -- 创建一条线段
    local shape         = b2EdgeShape()

    -- 设置线段的起点和终点
    shape:Set(M.ccpToVecRatio(startPoint), M.ccpToVecRatio(endPoint))

    -- 将形状和材质绑定（只是简单的保存了引用）
    fixtureDef.shape    = shape 
    -- 创建刚体的材质（这里才是真正的绑定了）
    local fixture       = body:CreateFixture(fixtureDef)

    return fixture
end



--[[--
创建形状

<br/>  
### Useage:
    local shape = ZBox2D.createShape(形状信息)
    
### Aliases:

### Notice:
    形状主要用于碰撞。

### Example:
    ----------------------
    -- 示例1: 
    ----------------------
    
### Parameters:
-   table   **shapeInfo**       [必选] 形状信息   



### OptionParameters

### Returns: 
-   b2Shape                     物理形状对象

--]]--
function M.createShape(shapeInfo)
    local shapeType     = shapeInfo.shapeType
    local shape         = nil

    if shapeType == EShape.CIRCLE then
        shape   = M.createShapeCircle(shapeInfo)
    elseif shapeType == EShape.POLYGON then
        shape   = M.createShapePolygon(shapeInfo)
    elseif shapeType == EShape.EDGE then
        shape   = M.createShapeEdge(shapeInfo)
    elseif shapeType == EShape.CHAIN then 
        -- TODO 
    end

    return shape
end 

--[[--
创建形状[圆]

<br/>  
### Useage:
    local shape = ZBox2D.createShapeCircle(形状信息)
    
### Aliases:

### Notice:
    形状主要用于碰撞。

### Example:
    ----------------------
    -- 示例1: 
    ----------------------
    
### Parameters:
-   table   **shapeInfo**       [必选] 形状信息   



### OptionParameters

### Returns: 
-   b2CircleShape               多边形

--]]--
function M.createShapeCircle(shapeInfo)
    -- 创建一个圆形
    local shape         = b2CircleShape() 
    -- 设置半径
    shape.m_radius      = shapeInfo.radius and shapeInfo.radius / PTM_RATIO or 0.5

    return shape 
end 

--[[--
创建形状[多边形-矩形]

<br/>  
### Useage:
    local shape = ZBox2D.createShapePolygon(形状信息)
    
### Aliases:

### Notice:
    形状主要用于碰撞。

### Example:
    ----------------------
    -- 示例1: 
    ----------------------
    
### Parameters:
-   table   **shapeInfo**       [必选] 形状信息   



### OptionParameters

### Returns: 
-   b2PolygonShape              多边形

--]]--
function M.createShapePolygon(shapeInfo)
    -- 创建多边形
    local shape         = b2PolygonShape()
    -- 顶点集合
    local vertices      = {}
    -- 初始化顶点集合
    for i, point in ipairs(shapeInfo.points) do
        table.insert(vertices, M.ccpToVecRatio(point))
    end

    shape:Set(vertices, #point)

    return shape 
end 

--[[--
创建形状[线、边缘]

<br/>  
### Useage:
    local shape = ZBox2D.createShapeEdge(形状信息)
    
### Aliases:

### Notice:
    一条可以碰撞的线段。

### Example:
    ----------------------
    -- 示例1: 
    ----------------------
    
### Parameters:
-   table   **shapeInfo**       [必选] 形状信息  



### OptionParameters

### Returns: 
-   b2EdgeShape                 线段

--]]--
function M.createShapeEdge(shapeInfo)
    -- 线段起点
    local startPoint    = shapeInfo.startPoint
    -- 线段终点
    local endPoint      = shapeInfo.endPoint
    -- 创建一条线段
    local shape         = b2EdgeShape()

    -- 设置线段的起点和终点
    shape:Set(b2Vec2(startPoint.x / PTM_RATIO, startPoint.y / PTM_RATIO), 
                b2Vec2(endPoint.x / PTM_RATIO, endPoint.y / PTM_RATIO))
    
    return shape 
end









--[[--
创建鼠标关节

<br/>  
### Useage:
    local joint = ZBox2D.createMouseJoint(刚体对象A, 刚体对象B, 关节信息)
    
### Aliases:

### Notice:
    鼠标关节用于多拽刚体，实际作用的应该只有一个刚体，但是关节是用于连接两个刚体的结构。
    一般我们将关节连接的bodyA设置为世界的边界刚体。

### Example:
    ----------------------
    -- 示例1: 移动鼠标关节
    ----------------------
    -- 创建鼠标关节
    local joint = ZBox2D.createMouseJoint(self.edge,  touchBody, jointInfo)
    -- 设置关节的位置
    joint:SetTarget(b2Vec2(x / PTM_RATIO, y / PTM_RATIO))

    
    ----------------------
    -- 示例2: 移动鼠标关节
    ----------------------
    self.mouseJoint = ZBox2D.createMouseJoint(currentPhysicsWorld.edgeBody, self.body, {
            frequencyHz = 32,
            maxForce    = 10000, 
            target      = ccp(x, y), 
            }) 
    -- 设置关节的位置
    self.mouseJoint:SetTarget(b2Vec2(x / PTM_RATIO, y / PTM_RATIO))
    
### Parameters:
-   b2Body  **bodyA**           [必选] 要连接的刚体对象A  
-   b2Body  **bodyB**           [必选] 要连接的刚体对象B  
-   table   **jointInfo**       [必选] 关节信息  

### OptionParameters

### Returns: 
-   b2MouseJoint                鼠标关节对象

--]]--
function M.createMouseJoint(bodyA, bodyB, jointInfo) 
    if (not currentPhysicsWorld) then return end

    -- 创建一个鼠标关节定义
    local mouseJointDef             = b2MouseJointDef()
    -- 关节连接的刚体A
    mouseJointDef.bodyA             = bodyA 
    -- 关节连接的刚体B
    mouseJointDef.bodyB             = bodyB
    -- 频率：频率越高，关节越硬。影响关节的弹性（典型情况下，关节频率要小于一半的时间步(time step)频率。
    --  比如每秒执行60次时间步, 关节的频率就要小于30赫兹。这样做的理由可以参考Nyquist频率理论。）
    mouseJointDef.frequencyHz       = jointInfo.frequencyHz or (M.getTimeStep() / 2)
    -- 阻尼率：值越大，关节运动阻尼越大。影响关节的弹性（阻尼率无单位，典型是在0到1之间, 也可以更大。1是阻尼率的临界值, 当阻尼率为1时，没有振动。）
    mouseJointDef.dampingRatio      = jointInfo.dampingRatio or 0.7
    -- 是否连续碰撞
    mouseJointDef.collideConnected  = ifnil(jointInfo.collideConnected, true)
    -- 作用点
    mouseJointDef.target            = M.ccpToVecRatio(jointInfo.target)
    -- 限制关节上可以施加的最大的力
    mouseJointDef.maxForce          = jointInfo.maxForce or 0.0 
    
    -- 创建关节，并转换为b2MouseJoint类型
    return tolua.cast(currentPhysicsWorld:CreateJoint(mouseJointDef), "b2MouseJoint")
end

--[[--
创建焊接关节

<br/>  
### Useage:
    local joint = ZBox2D.createWeldJoint(刚体对象A, 刚体对象B, 关节信息)
    
### Aliases:

### Notice:

### Example:
    
### Parameters:
-   b2Body  **bodyA**           [必选] 要连接的刚体对象A  
-   b2Body  **bodyB**           [必选] 要连接的刚体对象B  
-   table   **jointInfo**       [必选] 关节信息  

### OptionParameters

### Returns: 
-   b2WeldJoint                 焊接关节对象

--]]--
function M.createWeldJoint(bodyA, bodyB, jointInfo)
    if (not currentPhysicsWorld) then return end

    -- 创建一个焊接关节定义
    local weldJointDef              = b2WeldJointDef()
    weldJointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter())
    -- 频率：频率越高，关节越硬。影响关节的弹性（典型情况下，关节频率要小于一半的时间步(time step)频率。
    --  比如每秒执行60次时间步, 关节的频率就要小于30赫兹。这样做的理由可以参考Nyquist频率理论。）
    weldJointDef.frequencyHz        = jointInfo.frequencyHz or 1.0
    -- 阻尼率：值越大，关节运动阻尼越大。影响关节的弹性（阻尼率无单位，典型是在0到1之间, 也可以更大。1是阻尼率的临界值, 当阻尼率为1时，没有振动。）
    weldJointDef.dampingRatio       = jointInfo.dampingRatio or 0.0
    -- 是否连续碰撞
    weldJointDef.collideConnected   = jointInfo.collideConnected or false

    -- 创建关节，并转换为b2WeldJoint类型
    return tolua.cast(currentPhysicsWorld:CreateJoint(weldJointDef), "b2WeldJoint")
end 

--[[--
创建距离关节

<br/>  
### Useage:
    local joint = ZBox2D.createDistanceJoint(刚体对象A, 刚体对象B, 关节信息)
    
### Aliases:

### Notice:

### Example:
    
### Parameters:
-   b2Body  **bodyA**           [必选] 要连接的刚体对象A  
-   b2Body  **bodyB**           [必选] 要连接的刚体对象B  
-   table   **jointInfo**       [必选] 关节信息  



### OptionParameters

### Returns: 
-   b2Joint                     距离关节对象

--]]--
function M.createDistanceJoint(bodyA, bodyB, jointInfo)
    if (not currentPhysicsWorld) then return end

    -- 创建一个距离关节定义
    local distanceJointDef              = b2DistanceJointDef()
    distanceJointDef:Initialize(bodyA, bodyB, bodyA:GetWorldCenter(), bodyB:GetWorldCenter())
    -- 关节连接的刚体A
    distanceJointDef.bodyA              = bodyA
    -- 关节连接的刚体B
    distanceJointDef.bodyB              = bodyB
    -- 距离关节的长度
    distanceJointDef.length             = jointInfo.length or 1.0
    -- 频率：频率越高，关节越硬。影响关节的弹性（典型情况下，关节频率要小于一半的时间步(time step)频率。
    --  比如每秒执行60次时间步, 关节的频率就要小于30赫兹。这样做的理由可以参考Nyquist频率理论。）
    distanceJointDef.frequencyHz        = jointInfo.frequencyHz or 0.0
    -- 阻尼率：值越大，关节运动阻尼越大。影响关节的弹性（阻尼率无单位，典型是在0到1之间, 也可以更大。1是阻尼率的临界值, 当阻尼率为1时，没有振动。）
    distanceJointDef.dampingRatio       = jointInfo.dampingRatio or  0.0
    -- 是否连续碰撞
    distanceJointDef.collideConnected   = ifnil(jointInfo.collideConnected, true)   

    -- 创建关节
    return currentPhysicsWorld:CreateJoint(distanceJointDef)
end 

--[[--
创建移动关节

<br/>  
### Useage:
    local joint = ZBox2D.createPrismaticJoint(刚体对象A, 刚体对象B, 关节信息)
    
### Aliases:

### Notice:

### Example:
    
### Parameters:
-   b2Body  **bodyA**           [必选] 要连接的刚体对象A  
-   b2Body  **bodyB**           [必选] 要连接的刚体对象B  
-   table   **jointInfo**       [必选] 关节信息  



### OptionParameters

### Returns: 
-   b2Joint                     移动关节对象

--]]--
function M.createPrismaticJoint(bodyA, bodyB, jointInfo)
    if (not currentPhysicsWorld) then return end

    -- 声明移动关节结构体，结构体里面存储的都是初始化关节所需的参数。dir是关节移动的方向
    -- 创建一个移动关节的定义
    local prismaticJointDef             = b2PrismaticJointDef()

    if true then 
        -- 移动的方向，用矢量来表示可以移动的方向，默认为任意方向（零向量）
        local directVec     = jointInfo.dir or b2Vec2(0, 0)
        -- 初始化关节
        prismaticJointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter(), directVec)
    end

    -- 移动的最小距离，与方向同向为正，反向为负。启用限制后才有效果。
    prismaticJointDef.lowerTranslation  = jointInfo.lowerTranslation and jointInfo.lowerTranslation / PTM_RATIO or -1.0
    -- 移动的最大距离，与方向同向为正，反向为负。启用限制后才有效果。
    prismaticJointDef.upperTranslation  = jointInfo.upperTranslation and jointInfo.upperTranslation / PTM_RATIO or 1.0
    -- 是否启用限制
    prismaticJointDef.enableLimit       = ifnil(jointInfo.enableLimit, true)
    -- 是否连续碰撞
    prismaticJointDef.collideConnected  = jointInfo.collideConnected or false 
    
    -- 创建关节
    return currentPhysicsWorld:CreateJoint(prismaticJointDef)
end 

--[[--
创建绳索关节

<br/>  
### Useage:
    local joint = ZBox2D.createRopeJoint(刚体对象A, 刚体对象B, 关节信息)
    
### Aliases:

### Notice:

### Example:
    
### Parameters:
-   b2Body  **bodyA**           [必选] 要连接的刚体对象A  
-   b2Body  **bodyB**           [必选] 要连接的刚体对象B  
-   table   **jointInfo**       [必选] 关节信息  



### OptionParameters

### Returns: 
-   b2Joint                     绳索关节对象

--]]--
function M.createRopeJoint(bodyA, bodyB, jointInfo)
    if (not currentPhysicsWorld) then return end
    
    -- 创建一个绳索关节的定义
    local ropeJointDef          = b2RopeJointDef()
    -- ropeJointDef:Initialize(bodyA, bodyB, bodyA:GetWorldCenter(), bodyB:GetWorldCenter())
    -- 绳索的最大长度
    ropeJointDef.maxLength      = ifnil(jointInfo.maxLength, 4)
    -- 关节连接的刚体A
    ropeJointDef.bodyA          = bodyA
    -- 关节连接的刚体B
    ropeJointDef.bodyB          = bodyB
    -- 关节连接在刚体A上的锚点，其他关节应该也有，默认在中央
    ropeJointDef.localAnchorA   = ifnil(jointInfo.localAnchorA or b2Vec2(0.5, 0.5))
    -- 关节连接在刚体B上的锚点，其他关节应该也有，默认在中央
    ropeJointDef.localAnchorB   = ifnil(jointInfo.localAnchorB or b2Vec2(0.5, 0.5))
    -- 是否连续碰撞 
    ropeJointDef.collideConnected = true

    -- 创建关节
    return currentPhysicsWorld:CreateJoint(ropeJointDef)
end 

--[[--
创建旋转关节

<br/>  
### Useage:
    local joint = ZBox2D.createRevoluteJoint(刚体对象A, 刚体对象B, 关节信息)
    
### Aliases:

### Notice:

### Example:
    
### Parameters:
-   b2Body  **bodyA**           [必选] 要连接的刚体对象A  
-   b2Body  **bodyB**           [必选] 要连接的刚体对象B  
-   table   **jointInfo**       [必选] 关节信息  

### OptionParameters

### Returns: 
-   b2RevoluteJoint             旋转关节对象

--]]--
function M.createRevoluteJoint(bodyA, bodyB, jointInfo)
    if (not currentPhysicsWorld) then return end

    -- 创建一个旋转关节定义
    local revoluteJointDef              = b2RevoluteJointDef()
    revoluteJointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter())
    -- 关节连接的刚体A
    revoluteJointDef.bodyA              = bodyA
    -- 关节连接的刚体B
    revoluteJointDef.bodyB              = bodyB
    -- 限制可转动的最小角度，启用角度限制后才有效果 
    revoluteJointDef.lowerAngle         = jointInfo.lowerAngle and jointInfo.lowerAngle * TO_PI or 0
    -- 限制可转动的最大角度，启用角度限制后才有效果 
    revoluteJointDef.upperAngle         = jointInfo.upperAngle and jointInfo.upperAngle * TO_PI or 0
    -- 是否启用角度限制，类似手臂只能在一定角度内旋转一样。
    revoluteJointDef.enableLimit        = jointInfo.enableLimit or false   
    -- 马达的速度 
    revoluteJointDef.motorSpeed         = jointInfo.motorSpeed or 0.0       
    -- 马达的最大扭矩
    revoluteJointDef.maxMotorTorque     = jointInfo.maxMotorTorque or 11110.0
    -- 是否启用旋转马达，启用后关节会自动转动
    revoluteJointDef.enableMotor        = ifnil(jointInfo.enableMotor, true)
    -- 频率：频率越高，关节越硬。影响关节的弹性（典型情况下，关节频率要小于一半的时间步(time step)频率。
    --  比如每秒执行60次时间步, 关节的频率就要小于30赫兹。这样做的理由可以参考Nyquist频率理论。）
    revoluteJointDef.frequencyHz        = jointInfo.frequencyHz or 32
    -- 是否连续碰撞
    revoluteJointDef.collideConnected   = jointInfo.collideConnected or false 
    -- 关节长度 
    revoluteJointDef.length             = jointInfo.length or 0.1
    -- 是否连续碰撞
    revoluteJointDef.localAnchorA       = M.ccpToVec(jointInfo.localAnchorA) or b2Vec2(0, 0) 
    -- 关节长度 
    revoluteJointDef.localAnchorB       = M.ccpToVec(jointInfo.localAnchorB) or b2Vec2(0, 0)

    -- 创建关节，并转换为b2RevoluteJoint类型
    return tolua.cast(currentPhysicsWorld:CreateJoint(revoluteJointDef), "b2RevoluteJoint")
end 

--[[--
创建滑轮关节

<br/>  
### Useage:
    local joint = ZBox2D.createPulleyJoint(刚体对象A, 刚体对象B, 关节信息)
    
### Aliases:

### Notice:

### Example:
    
### Parameters:
-   b2Body  **bodyA**           [必选] 要连接的刚体对象A  
-   b2Body  **bodyB**           [必选] 要连接的刚体对象B  
-   table   **jointInfo**       [必选] 关节信息  



### OptionParameters

### Returns: 
-   b2Joint                     滑轮关节对象

--]]--
function M.createPulleyJoint(bodyA, bodyB, jointInfo)
    if (not currentPhysicsWorld) then return end

    -- 创建一个滑轮关节定义
    local pulleyJointDef    = b2PulleyJointDef() 
    if true then 
        local function ccpToVecRatioIfnil(point, defaultVec2, offset)
            point   = point and M.ccpToVecRatio(point) or b2Vec2(default.x + offset.x, default.y + offset.y) 

            return point 
        end

        -- 滑轮绳子拉动的点
        local bodyWorldPointA   = bodyA:GetWorldCenter()
        -- 滑轮绳子拉动的点
        local bodyWorldPointB   = bodyB:GetWorldCenter()
        -- 刚体A对应的那个滑轮的位置
        local groundPointA      = ccpToVecRatioIfnil(jointInfo.groundAnchorA, bodyWorldPointA, b2Vec2(0, 10))
        -- 刚体B对应的那个滑轮的位置
        local groundPointB      = ccpToVecRatioIfnil(jointInfo.groundAnchorB, bodyWorldPointB, b2Vec2(0, 10))
        -- 比例(关节传动时，滑轮上升和下降的两头的位移比例)
        local ratio             = jointInfo.ratio or 1
        -- 初始化关节
        pulleyJointDef.Initialize(bodyA, bodyB, groundPointA, groundPointB, 
            bodyWorldPointA, bodyWorldPointB, ratio)
    end
    -- 绳子可拉动的最大长度
    pulleyJointDef.maxLengthA = jointInfo.maxLengthA or 5  
    -- 绳子可拉动的最大长度
    pulleyJointDef.maxLengthB = jointInfo.maxLengthB or 5

    return currentPhysicsWorld:CreateJoint(pulleyJointDef) 
end

--[[--
创建齿轮关节

<br/>  
### Useage:
    local joint = ZBox2D.createGearJoint(刚体对象A, 刚体对象B, 关节信息)
    
### Aliases:

### Notice:

### Example:
    
### Parameters:
-   b2Body  **bodyA**           [必选] 要连接的刚体对象A  
-   b2Body  **bodyB**           [必选] 要连接的刚体对象B  
-   table   **jointInfo**       [必选] 关节信息  



### OptionParameters

### Returns: 
-   b2Joint                     齿轮关节对象

--]]--
function M.createGearJoint(bodyA, bodyB, jointInfo)
    if (not currentPhysicsWorld) then return end

    -- 创建一个齿轮关节
    local gearJointDef  = b2GearJointDef() 
    -- 齿轮关节关联的关节1，释放这两个关节时需要先释放齿轮关节，否则会引起空指针错误。
    gearJointDef.joint1 = jointInfo.joint1
    -- 齿轮关节关联的关节2，释放这两个关节时需要先释放齿轮关节，否则会引起空指针错误。 
    gearJointDef.joint2 = jointInfo.joint2
    -- 关节连接的刚体A
    gearJointDef.bodyA  = bodyA
    -- 关节连接的刚体B
    gearJointDef.bodyB  = bodyB
    -- 关节比例（齿轮系数）
    gearJointDef.ratio  = jointInfo.ratio or 1 

    return currentPhysicsWorld:CreateJoint(gearJointDef) 
end

--[[--
创建轮子关节

<br/>  
### Useage:
    local joint = ZBox2D.createWheelJoint(刚体对象A, 刚体对象B, 关节信息)
    
### Aliases:

### Notice:

### Example:
    
### Parameters:
-   b2Body  **bodyA**           [必选] 要连接的刚体对象A  
-   b2Body  **bodyB**           [必选] 要连接的刚体对象B  
-   table   **jointInfo**       [必选] 关节信息  



### OptionParameters

### Returns: 
-   b2Joint                     轮子关节对象

--]]--
function M.createWheelJoint(bodyA, bodyB, jointInfo)
    if (not currentPhysicsWorld) then return end

    -- 创建一个轮子关节定义
    local wheelJointDef             = b2WheelJointDef()
    if true then 
        -- 用坐标表示轮子轴的位置
        local axis = jointInfo.axis or b2Vec2(1.0, 0.0)
        -- 初始化关节
        wheelJointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter(), axis)
    end
    -- 是否启用马达
    wheelJointDef.enableMotor       = jointInfo.enableMotor or false
    -- 马达速度
    wheelJointDef.motorSpeed        = jointInfo.motorSpeed or 0.0
    -- 马达的最大扭矩 
    wheelJointDef.maxMotorTorque    = jointInfo.maxMotorTorque or 0.0
    -- 频率：频率越高，关节越硬。影响关节的弹性（典型情况下，关节频率要小于一半的时间步(time step)频率。
    --  比如每秒执行60次时间步, 关节的频率就要小于30赫兹。这样做的理由可以参考Nyquist频率理论。）
    wheelJointDef.frequencyHz       = jointInfo.frequencyHz or 32
    -- 阻尼率：值越大，关节运动阻尼越大。影响关节的弹性（阻尼率无单位，典型是在0到1之间, 也可以更大。1是阻尼率的临界值, 当阻尼率为1时，没有振动。）
    wheelJointDef.dampingRatio      = jointInfo.dampingRatio or 0.2

    -- 创建关节 
    return tolua.cast(currentPhysicsWorld:CreateJoint(wheelJointDef), "b2WheelJoint")
end 

--[[--
创建摩擦关节

<br/>  
### Useage:
    local joint = ZBox2D.createFrictionJoint(刚体对象A, 刚体对象B, 关节信息)
    
### Aliases:

### Notice:
    摩擦关节用于阻碍两个刚体的相对运动。

### Example:
    
### Parameters:
-   b2Body  **bodyA**           [必选] 要连接的刚体对象A  
-   b2Body  **bodyB**           [必选] 要连接的刚体对象B  
-   table   **jointInfo**       [必选] 关节信息  



### OptionParameters

### Returns: 
-   b2Joint                     摩擦关节对象

--]]--
function M.createFrictionJoint(bodyA, bodyB, jointInfo)
    if (not currentPhysicsWorld) then return end

    -- 创建一个摩擦关节定义
    local frictionJointDef = b2FrictionJointDef()
    -- 初始化关节
    frictionJointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter())
    -- 频率：频率越高，关节越硬。影响关节的弹性（典型情况下，关节频率要小于一半的时间步(time step)频率。
    --  比如每秒执行60次时间步, 关节的频率就要小于30赫兹。这样做的理由可以参考Nyquist频率理论。）
    frictionJointDef.frequencyHz = jointInfo.frequencyHz or 0.0
    -- 阻尼率：值越大，关节运动阻尼越大。影响关节的弹性（阻尼率无单位，典型是在0到1之间, 也可以更大。1是阻尼率的临界值, 当阻尼率为1时，没有振动。）
    frictionJointDef.dampingRatio = jointInfo.dampingRatio or 0.0
    -- 限制关节上可以施加的最大的力
    frictionJointDef.maxForce = jointInfo.maxForce or 0.0

    return currentPhysicsWorld:CreateJoint(frictionJointDef)
end









--========================================================================
-- 析构型函数 
--======================================================================== 




--[[--
摧毁世界

<br/>  
### Useage:
    销毁物理世界对象，并返回一个空值。
    
### Notice:
    因为创建物理世界时会将其保存在一个全局变量里面，方便访问。所以当不需要时，一定要手动销毁。
    
### Example:

    ----------------------
    -- 示例1: 通用操作
    ----------------------
    local World = ZBox2D.createWorld(b2vec2(0, -10))
    World       = ZBox2D.destroyWorld(World)
    
### Parameters:
-   b2World     **body**            [必选] 要被销毁的物理世界对象  

### Returns: 
-   null                             空值

--]]--
function M.destroyWorld(world)
    if zbox2dPhysicsUpdateTimer then 
        zbox2dPhysicsUpdateTimer    = SC.close(zbox2dPhysicsUpdateTimer)
    end

    world = world or currentPhysicsWorld

    if world then 

        -- 同步物理世界和渲染世界
        local body = currentPhysicsWorld:GetBodyList()
        
        while body do 
            world:DestroyBody(body)
            -- 获得下一个body
            body = body:GetNext()
        end

        world = nil 
    end

    currentPhysicsWorld = nil 

    return nil 
end

--[[--
摧毁刚体

<br/>  
### Useage:
    销毁刚体对象，并返回一个空值。
    
### Example:

    ----------------------
    -- 示例1: 通用操作
    ----------------------
    local body  = ZBox2D.createBody(bodyInfo)
    body        = ZBox2D.destroyBody(body)
    
### Parameters:
-   b2Body      **body**            [必选] 要被销毁的刚体对象  
-   b2World     **world**           [可选] 物理世界对象  

### Returns: 
-   null                             空值

--]]--
function M.destroyBody(body, world)
    world = world or currentPhysicsWorld
    
    if body and body.SetTransform and world then 
        world:DestroyBody(body)
    end

    return nil 
end 

--[[--
摧毁关节

<br/>  
### Useage:
    销毁一个关节对象，并返回一个空值。  
    
### Example:

    ----------------------
    -- 示例1: 通用操作
    ----------------------
    local joint = ZBox2D.createMouseJoint(jointInfo)
    joint       = ZBox2D.destroyJoint(joint)
    
### Parameters:
-   b2Joint     **joint**           [必选] 要被销毁的关节对象  
-   b2World     **world**           [可选] 物理世界对象  

### Returns: 
-   null                             空值

--]]--
function M.destroyJoint(joint, world)
    world = world or currentPhysicsWorld

    if joint and joint.GetBodyA and world then 
        world:DestroyJoint(joint)
    end 

    return nil 
end










--========================================================================
-- 辅助型函数 
--======================================================================== 




--[[--
将CCPoint类型转换成b2Vec2类型。

<br/>  
### Useage:
    local vec = ZBox2D.ccpToVec(坐标)
    
### Aliases:

### Notice:
    只是进行了数据转换，坐标值没有变化。
    
### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    local vec = ZBox2D.ccpToVec(ccp(300, 400))
    
### Parameters:
-   CCPoint     **point**           [必选] opengl坐标  

### OptionParameters

### Returns: 
-   b2Vec2                           矢量坐标

--]]--
function M.ccpToVec(x, y)
    if not x then return end 

    local result = b2Vec2(0.0, 0.0)

    if type(x) ~= "number" and x.x then 
        result = b2Vec2(x.x, x.y)
    else
        result = b2Vec2(x, y)
    end

    return result 
end

--[[--
将opengl坐标转换成box2d矢量坐标。

<br/>  
### Useage:
    local vec = ZBox2D.ccpToVecRatio(坐标)
    
### Aliases:

### Notice:
    二者转换的时候进行了一定的比例缩放。
    
### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    local vec = ZBox2D.ccpToVecRatio(ccp(300, 400))
    
### Parameters:
-   CCPoint     **point**           [必选] opengl坐标  

### OptionParameters

### Returns: 
-   b2Vec2                           矢量坐标

--]]--
function M.ccpToVecRatio(point)
    return b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO)
end

--[[--
将box2d矢量坐标转换成opengl坐标。

<br/>  
### Useage:
    local point = ZBox2D.vecToCcpRatio(矢量)
    
### Aliases:

### Notice:
    二者转换的时候进行了一定的比例缩放。

### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    local point = ZBox2D.vecToCcpRatio(b2Vec2(30, 40))
    
### Parameters:
-   b2Vec2  **vec**                 [必选] 矢量坐标  

### OptionParameters

### Returns: 
-   CCPoint                         opengl坐标 

--]]--
function M.vecToCcpRatio(vec)
    return ccp(vec.x * PTM_RATIO, vec.y * PTM_RATIO)
end









--========================================================================
-- 功能型函数 
--======================================================================== 




--[[--
开启调试模式

<br/>  
### Useage:
    ZBox2D.openDebug(layer)
    
### Aliases:

### Notice:
    根据物理模拟的信息在场景内绘制刚体形状和关节。

### Example:
    
### Parameters:
-   CCNode  **delegateTick**        [必选] 用于显示绘制的刚体区域和关节的父节点。  

### OptionParameters

### Returns: 

--]]--
function M.openDebug(node)
    local debugDraw = GB2DebugDrawLayer:create(currentPhysicsWorld, PTM_RATIO)

    node:add(debugDraw, 99999)
end 

--[[--
开启物理世界更新

<br/>  
### Useage:
    ZBox2D.update(handler(self, self.tick), 1.0 / 60)
    
### Aliases:

### Notice:
    开启更新后才会进行物理模拟。

### Example:
    
### Parameters:
-   function    **delegateTick**        [必选] 进行物理模拟和数据更新的函数  
-   float       **intervalTime**        [可选] 进行物理模拟的时间间隔  


### OptionParameters

### Returns: 
-   CCScheduler                         物理侦听对象

--]]--
function M.update(delegateTick, intervalTime)
    M.setTimeStep(intervalTime)
    
    -- 开启延时器进行物理世界更新
    local timer              = SC.open(delegateTick or M.tick, intervalTime or M.getTimeStep())
    zbox2dPhysicsUpdateTimer = timer

    return timer 
end 

--[[-
更新[物理世界]  

<br/>  
### Useage:
    进行物理世界和渲染世界的同步。 

### Notice:
    物理世界的时间也是在这里进行更新的  

### Returns: 
-   无返回值

--]]
function M.tick()
    if not currentPhysicsWorld then return end 

    -- 物理引擎进行物理模拟，生成模拟后的数据(时间步、速度迭代device、位置迭代)
    currentPhysicsWorld:Step(M.timeStep, M.velocityIterations, M.positionIterations)

    -- 同步物理世界和渲染世界
    local body = currentPhysicsWorld:GetBodyList()
    while body do 
        local userData = body:GetUserData()

        if userData then
            local spr   = tolua.cast(userData, "CCSprite")
            local pos   = body:GetPosition()
            -- 更新位置、角度，同步物理世界和渲染世界
            spr:setPosition(pos.x * PTM_RATIO, pos.y * PTM_RATIO)
            spr:setRotation(-1 * math.deg(body:GetAngle()))
        end

        -- 获得下一个body
        body = body:GetNext()
    end
end 


--[[-
-- 更新[物理世界-组件化]  

<br/>  
### Useage:
    进行物理世界和渲染世界的同步。

### Notice:
    调用组件的fixedUpdate()生命周期，专用于组件化框架。   

### Returns: 
-   无返回值  

--]]
function tickForComponent()
    if not currentPhysicsWorld then return end 

    -- 物理引擎进行物理模拟，生成模拟后的数据(时间步、速度迭代device、位置迭代)
    currentPhysicsWorld:Step(M.timeStep, M.velocityIterations, M.positionIterations)

    -- 同步物理世界和渲染世界
    local body = currentPhysicsWorld:GetBodyList()
    while body do 
        local userData = body:GetUserData()

        if userData then
            local spr       = tolua.cast(userData, "CCSprite")
            local pos       = body:GetPosition()
            local rigidBody = spr:getComponent("RigidBody")

            -- 更新位置、角度，同步物理世界和渲染世界
            if rigidBody:isUpdateAngleByRotate() then 
                rigidBody:rotate(-spr:getRotation())
            else
                spr:setRotation(-1 * math.deg(body:GetAngle()))
            end
            
            spr:setPosition(pos.x * PTM_RATIO, pos.y * PTM_RATIO)
            
            -- 固定更新
            if type(spr.fixedUpdate) == "function" then 
                spr:fixedUpdate()
            end
        end
        -- 获得下一个body
        body = body:GetNext()
    end
end 

--[[--
开启物理接触侦听器

<br/>  
### Useage:
    ZBox2D.openContactListener(handler(self, self.onContact))
    
### Aliases:

### Notice:
    注册物理碰撞的回调函数，包含三个参数：
        碰撞事件的类型对象(分别是接触前、接触后、求解前和求解后)
        接触对象(里面包含接触信息，接触的刚体、接触点等等。)
        oldManifold对象

### Example:
    
### Parameters:
-   function    **delegateMethod**      [必选] 侦听器回调函数  

### OptionParameters

    接触类型：
        GB2_CONTACTTYPE_BEGIN_CONTACT   ：开始接触
        GB2_CONTACTTYPE_END_CONTACT     ：结束接触
        GB2_CONTACTTYPE_PRE_SOLVE       ：求解前
        GB2_CONTACTTYPE_POST_SOLVE      ：求解后 

### Returns: 
-   CCScheduler                         物理侦听对象[返回值【【【一定一定一定】】】要保存]

--]]--
function M.openContactListener(delegateMethod, target)
    -- 创建接触侦听器
    local listener = GB2ContactListener:new_local()

    -- 为接触注册侦听函数
    if target then 
        listener:registerScriptHandler(function(contactType, contact, oldManifold)
            delegateMethod(target, contactType, contact, oldManifold)
        end)
    else
        listener:registerScriptHandler(delegateMethod)
    end
    -- 设置物理世界的接触侦听
    currentPhysicsWorld:SetContactListener(listener) 

    -- 保存引用指针，防止对象被回收导致闪退
    -- 保存引用指针，防止对象被回收导致闪退
    -- 保存引用指针，防止对象被回收导致闪退
    currentPhysicsWorld.contactListener = listener

    return listener 
end

--[[--
关闭物理接触侦听器

<br/>  
### Useage:
    ZBox2D.closeContactListener()
    
### Aliases:

### Notice:
    box2D的力一般以b2Vec2类型表示。
    这里创建的物理世界会保存在一个全局变量里面，以方便访问。所以当这个世界不需要存在的时候记得一定要进行销毁。

### Example:
    
### Parameters:

### OptionParameters

### Returns: 

--]]--
function M.closeContactListener()
    currentPhysicsWorld:SetContactListener(nil)  
end 

--[[--
开启物理碰撞侦听器

<br/>  
### Useage:
    ZBox2D.openContactListener(handler(self, self.onContact))
    
### Aliases:

### Notice:
    注册物理碰撞的回调函数，包含三个参数：
        碰撞事件的类型对象(分别是接触前、接触后、求解前和求解后)
        接触对象(里面包含接触信息，接触的刚体、接触点等等。)
        oldManifold对象

### Example:
    
### Parameters:
-   CCNode      **node**                [必选] 层节点  
-   function    **delegateMethod**      [必选] 侦听器回调函数  

### OptionParameters

### Returns: 
-   CCScheduler                         物理侦听对象

--]]--
function M.openCollisionListener(node, delegateMethod)
    local scene = node:getScene()
    scene.actionCollisionListener = A.cycle({
        {"fn", delegateMethod},
        {"delay", 1.0 / 60},
        })

    scene:runAction(scene.actionCollisionListener)
end 

--[[--
关闭物理碰撞侦听器

<br/>  
### Useage:
    ZBox2D.closeContactListener()
    
### Aliases:

### Notice:
    box2D的力一般以b2Vec2类型表示。
    这里创建的物理世界会保存在一个全局变量里面，以方便访问。所以当这个世界不需要存在的时候记得一定要进行销毁。

### Example:
    
### Parameters:
-   CCNode      **node**                [必选] 层节点  

### OptionParameters

### Returns: 

--]]--
function M.closeCollisionListener(node)
    local scene = node:getScene()
    scene.actionCollisionListener = ZTools.stopAction(scene, scene.actionCollisionListener)
end 












--========================================================================
-- 属性 
--======================================================================== 




--[[--
获取物理世界

<br/>  
### Useage:
    local world = ZBox2D.getWorld()
    
### Aliases:

### Notice:
    返回最新创建的物理世界。

### Example:
    
### Parameters:

### OptionParameters

### Returns: 
-   b2World                 物理世界对象

--]]--
function M.getWorld()
    return currentPhysicsWorld
end

--[[--
设置物理世界

<br/>  
### Useage:
    ZBox2D.setWorld(物理世界对象)
    
### Aliases:

### Notice:
    有点时候获取到的点错误，会是b2Vec2(0, 0)，开启矫正后会它设置到屏幕外足够远的地方去。

### Example:
    
### Parameters:
-   b2World     **world**       [必选] 物理世界对象  

### OptionParameters

### Returns: 

--]]--
function M.setWorld(world)
    currentPhysicsWorld = world 
end

--[[--
获取时间步

<br/>  
### Useage:
    local timeStep = ZBox2D.getTimeStep()
    
### Notice:
    iPhone4 物理模拟比较卡，将物理模拟速率降低。固件名iPhone3,1即iPhone4，iPod4,即touch4。

### Returns: 
-   number                       时间步

--]]--
function M.getTimeStep()
    local deviceInfo    = NV.getDeviceInfo()
    local version       = deviceInfo.version 
    M.timeStep          = 1.0 / 60

    if isandroid() or version == "iPhone3,1" or version == "iPod4,1" or 
        -- iPod Touch
        version == "iPod1,1" or version == "iPod2,1" or version == "iPod3,1" or 
        version == "iPod4,1" or version == "iPod5,1" or 
        -- iPad mini 1
        version == "iPad2,5" or version == "iPad2,6" or version == "iPad2,7" then
        M.timeStep = 1.0 / 40
    end

    return M.timeStep
end 

--[[--
设置物理更新时间步

<br/>  
### Notice:
    说明

### Parameters:
-   number     **timeStep**                 [必选] 时间步  

--]]--
function M.setTimeStep(timeStep)
    if type(timeStep) == "number" then 
        M.timeStep = timeStep
    end
end

--[[--
设置速度迭代和位置迭代次数

<br/>  
### Notice:
    说明

### Example:

### Parameters:
-   number     **velocityIterations**    [可选] 速度迭代次数  
-   number     **positionIterations**    [可选] 位置迭代次数  

--]]--
function M.setIterations(velocityIterations, positionIterations)
    if velocityIterations then 
        M.velocityIterations = velocityIterations
    end

    if positionIterations then 
        M.positionIterations = positionIterations
    end
end

--[[--
获取速度迭代和位置迭代次数

<br/>  
### Notice:
    说明

### Example:

### Returns: 
-   number                         速度迭代次数
-   number                         位置迭代次数

--]]--
function M.getIterations()
    return M.velocityIterations, M.positionIterations
end

--[[--
根据接触对象获取碰撞接触点 

<br/>  
### Useage:
    local contactPoint, bodyA, bodyB = ZBox2D.getContactWorldPoint(接触对象, 是否矫正结果)
    
### Aliases:

### Notice:
    有点时候获取到的点错误，会是b2Vec2(0, 0)，开启矫正后会它设置到屏幕外足够远的地方去。

### Example:
    ----------------------
    -- 示例1: 获取接触点
    ----------------------
    local contactPoint = ZBox2D.getContactWorldPoint(接触对象, 是否矫正结果)
    print("contactPoint ＝ ", contactPoint.x, contactPoint.y)
    
### Parameters:
-   b2Contact   **contact**         [必选] 接触对象  
-   boolean     **isCorrection**    [可选] 是否矫正结果  

### OptionParameters

### Returns: 
-   CCPoint                         世界边沿对象
-   b2Body                          产生接触的刚体对象A
-   b2Body                          产生接触的刚体对象B

--]]--
function M.getContactWorldPoint(contact, isCorrection)
    -- 获取碰撞的刚体
    local bodyA     = contact:GetFixtureA() and contact:GetFixtureA():GetBody() or nil 
    local bodyB     = contact:GetFixtureB() and contact:GetFixtureB():GetBody() or nil 

    if bodyA and bodyB then 
        -- 定义一个b2WorldManifold对象，用来获取并存储碰撞点的全局坐标
        local manifold  = GB2Util:newWorldManifold()
        -- 通过GetWorldManifolde方法，计算出碰撞点的全局坐标，并存储到manifold变量中
        contact:GetWorldManifold(manifold)
        -- 获取碰撞点
        local point     = manifold.points[0]

        -- 容错[有点时候获取到的点会是b2Vec2(0, 0)，我把它设置到屏幕外足够远的地方去。]
        if ifnil(isCorrection, true) and point.x == 0 and point.y == 0 then 
            point = ccp(-1000, -1000)
        end

        -- 转成像素坐标返回
        return M.vecToCcpRatio(point)
    end

    return ccp(0, 0), bodyA, bodyB 
end 

--[[--
设置刚体类型

<br/>  
### Useage:
    ZBox2D.setBodyType(刚体, 刚体类型)
    
### Aliases:

### Notice:
    刚体类型有三种：静态（b2_staticBody）、动态（b2_dynamicBody）、平台（b2_kinematicBody）。

### Example:
    
### Parameters:
-   b2Body  **body**                [必选] 刚体对象  
-   int     **bodyType**            [必选] 刚体类型  

### OptionParameters

### Returns: 

--]]--
function M.setBodyType(body, bodyType)
    if body and bodyType then 
        body:SetType(bodyType)
    end
end

--[[--
设置刚体位置和旋转角度

<br/>  
### Useage:
    ZBox2D.setBodyPositionAndAngle(刚体对象, 坐标, 弧度)
    
### Aliases:

### Notice:
    box2d坐标使用b2Vec2类型，所以这边的坐标要先转换为b2Vec2类型。
    box2d坐标使用弧度制，所以这边的角度要先转换为弧度制。

### Example:
    
### Parameters:
-   b2Body  **body**        [必选] 刚体对象  
-   b2Vec2  **position**    [必选] box2d坐标  
-   float   **angle**       [必选] 刚体弧度  

### OptionParameters

### Returns: 

--]]--
function M.setBodyPositionAndAngle(body, position, angle)
    if body then
        -- b2Vec2矢量类型
        position    = position or body:GetPosition()
        -- box2d的角度都是以弧度形式表示
        angle       = angle or body:GetAngle()

        body:SetTransform(position, angle)
    end
end 
M.setTransform = M.setBodyPositionAndAngle

--[[--
设置刚体位置

<br/>  
### Useage:
    ZBox2D.setBodyPosition(刚体对象, opengl坐标)
    
### Aliases:

### Notice:
    box2d坐标和opengl坐标存在比例关系，所以这边传参的坐标会被转换成b2Vec2类型的box2d坐标。

### Example:
    
### Parameters:
-   b2Body  **body**        [必选] 刚体对象  
-   CCPoint **position**    [必选] opengl坐标  

### OptionParameters

### Returns: 

--]]--
function M.setBodyPosition(body, position)
    if body then
        -- b2Vec2矢量类型
        position    = position and M.ccpToVecRatio(position) or body:GetPosition()

        M.setBodyPositionAndAngle(body, position)
    end
end 

--[[--
设置刚体角度

<br/>  
### Useage:
    ZBox2D.setBodyAngle(刚体对象, 角度)
    
### Aliases:

### Notice:
    box2d使用的角度是弧度制，所以这边传参的角度会被转换成弧度。

### Example:
    
### Parameters:
-   b2Body  **body**        [必选] 刚体对象  
-   float   **angle**       [必选] 角度  

### OptionParameters

### Returns: 

--]]--
function M.setBodyAngle(body, angle)
    if body then
        -- box2d的角度都是以弧度形式表示
        angle   = angle and math.rad(angle) or body:GetAngle()

        M.setBodyPositionAndAngle(body, nil, angle)
    end
end 

--[[--
属性[获取刚体的碰撞种群索引]

<br/>  
### Parameters:
-   b2Body     **body**                 [必选] 刚体对象  

### OptionParameters

### Returns: 
-   number                             碰撞种群索引

--]]--
function M.getGroupIndex(body)
    if body then 
        local fixture = self.body:GetFixtureList()

        if fixture then 
            local filter = fixture:GetFilterData()

            if filter then 
                return filter.groupIndex
            end
        end
    end
    return body:GetFixtureList():GetFilterData().groupIndex
end 

--[[--
属性[设置刚体的碰撞种群索引]

<br/>  
### Useage:

### Aliases:

### Notice:
    box2D支持16种碰撞种群，用于做碰撞筛选。

### Parameters:
-   b2Body     **body**                 [必选] 刚体对象  
-   number     **groupIndex**           [必选] 碰撞种群索引(取值区间是[0,15])  

--]]--
function M.setGroupIndex(body, groupIndex)
    body:GetFixtureList():GetFilterData().groupIndex = groupIndex or 0 
end













return M






