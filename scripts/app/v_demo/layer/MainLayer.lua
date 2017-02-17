--[[
	xx场景xx层类
--]]


local M    = classLayer("Main")




--------------------------
-- 构造函数
--------------------------

function M:ctor(params)
    -- [超类调用]
    M.super.ctor(self, params)
    -- [本类调用]

    self.bodys = {}
    self.bodyPos = {b2Vec2(100/32, 100/32), b2Vec2(300/32, 100/32)}
end

--------------------------
-- 渲染
--------------------------

function M:onRender()
    -- [超类调用]
    M.super.onRender(self)

    -- [本类调用]
    -- 加载节点
    self:loadNodes()

    self:createWorld()
    -- self:createGround()
    self:createEdge()

    -- self:createCircle()
    -- self:loadTestNode()

    --测试距离关节
    -- self:createBodyB()
    -- self:createBodyCircle(1)
    -- self:createBodyCircle(2)
    -- self:createDistanceJoint(self.bodys[1], self.bodyA, 1)
    -- self:createDistanceJoint(self.bodys[2], self.bodyA, 1)
    -- self:createDistanceJoint(self.bodys[1],self.bodys[2], 1)

    self:createBodyA()
    self:createBodyB()
    -- 加载渲染以外的其他操作
    self:loadRenderOtherwise()
end 

-- 加载节点
function M:loadNodes()
   -- 
end 

-- 加载渲染以外的其他操作
function M:loadRenderOtherwise()
    self:bindTouch()

end




--------------------------
-- 析构
--------------------------

function M:onDestructor()
    -- [超类调用]
 M.super.onDestructor(self)

  -- [本类调用]
end








--------------------------
-- 触控
-------------------------- 

function M:onTouchBegan(x, y, touches)
  --  触控有效
return true 
end

function M:onTouchMoved(x, y, touches)
 --   
end

function M:onTouchEnded(x, y, touches)
  --  
end








--------------------------
-- 功能函数
--------------------------


-- 游戏分游戏世界(负责渲染、加载数据等)
-- 物理世界：box2d中由b2world来表示物理世界，所有的刚体、关节都是由b2world创建和销毁，
-- 并且所有刚体的运动、碰撞模拟也都是在b2world里进行的

-- 步骤：
--     1、设置一个矢量，表示当前世界的重力，有大小和方向的，在box2d中 力、坐标等都通过b2Vec2对象来表示
--     2、开始创建世界
--     3、初始化世界的一些方法
--     4、调试信息，将刚体绘制到游戏场景上
--     5、将物理世界动起来

-- 注：
--     计算单位mks 米 千克 秒 
--     两个属性 SetAllowSleeping SetContinuousPhysics 
-- Box2D在0.1米到10米的范围内工作是最优化的，因为它针对这个范围做过专门优化，
-- 把创建的Box2D世界中的刚体的大小限定在越接近1米越好，太小或者太大的刚体很可能会在游戏运行过程中产生错误和奇怪的行为。 
-- 32个像素在Box2D世界中等同于1米。一个有32像素宽和高的盒子形状的刚体等同于1米宽和高的物体。 

--創建物理世界
function M:createWorld( )

    local gravity = b2Vec2(10, -10)
    world         = b2World(gravity)

    -- 为物理世界设置两个属性
    -- 进行模拟时快速跳过不需要处理的刚体,可以提高物理世界中物体的处理效率，
    -- 只有在发生碰撞时才唤醒该对象。当动态物体静止时使它休眠，减少性能开销
    world:SetAllowSleeping(true)
    -- 开启物理世界的连续检测，了物理模拟的更加真实，（虽然这会消耗一定性能）速度较快的两个物体碰撞时就可能会产生“穿透”现象，启用特殊的算法来避免该现象。
    world:SetContinuousPhysics(true)

    -- box2d引擎没有渲染的功能功能，通过调试绘制可以让我们更加直观的看到刚体形状和模拟的情况
    local debugDraw = GB2DebugDrawLayer:create(world, 32)
    self:add(debugDraw, 9999)

    --开始模拟
    self.runAct =
    A.cycle({
        {"fn", function()
            --开始模拟
            world:Step(1/60, 1, 1)
            if self.tNode then
                self.tNode:synchronizationFn()
            end
        end},
        {"delay", 1/60},
    })
    self:runAction(self.runAct)

    -- 注：将刚体添加到b2world的刚体清单m_bodyList中，在每次调用step方法进行物理模拟的时候，
    -- 都会遍历整个清单，更新刚体对象相应的属性                                           
end


-- 在世界創建完畢后，此時這個世界的範圍是無窮無盡的，
-- 我們需要為我們的物理世界限定一快區域，好讓我們的遊戲在此區域內進行數據模擬
-- 所以我們會用到一個叫做剛體的東西來建立我們的世界邊界
-- 什麼是剛體
-- 刚体是用来在box2d中模拟现实世界中的所有物体，物理世界中的任何碰撞、反弹、运动轨迹等物理现象模拟都是
-- 基于刚体来实现的。所以刚体包含了很多信息：坐标、角度、等等
-- 夹具包含了刚体材料的一些属性，比如摩擦力、密度、恢复系数、形状等等    
-- 形状（shape）这是一个依附于刚体上的碰撞几何结构，用来进行碰撞模拟,没有形状的刚体不能进行碰撞模拟
-- 边缘形状b2EdgeShape  两个点
-- 多边形b2PolygonShape 边数：3-8
-- 圆形(近视圆形):多边形


-- 步骤：
-- 1、创建刚体定义
-- 2、创建刚体
-- 3、创建夹具定义
-- 4、创建形状(多边形、圆形、边缘形状、)
-- 5、设置夹具形状、摩擦、恢复等属性
-- 6、创建夹具
-- 7、通过物理编辑器创建复杂形状刚体


-- 注：静态刚体（绿色）：静止不动，碰撞后不进行反弹等模拟，不受外力影响，不能调节速度，bullet默认为true
--     可动刚体（紫色）：与静态刚体类似，但是给它一个速度可以让它动起来
--     动态刚体（粉色）：就是可以一直运动的刚体。bullet只对动态刚体有效(连续碰撞检测)

--     一个刚体可以包含多个夹具, 而一个夹具只包含一个形状，一个密度、摩擦力恢复等参数
--     举例：菜刀，有木制的刀柄和铁的刀身体组成

--創建地面
function M:createGround( )
    local bodyDef    = b2BodyDef()
    bodyDef.position = b2Vec2(480/32, 1/32)
    bodyDef.type     = b2_staticBody
    local body       = world:CreateBody(bodyDef)

    --创建夹具定义
    local fixtureDef = b2FixtureDef()
    --创建一个多边形
    local shape      = b2PolygonShape()
    shape:SetAsBox(960/32, 1/32)
    --赋值给材质的属性
    fixtureDef.shape       = shape
    --摩擦
    fixtureDef.friction    = .01
    --恢复
    fixtureDef.restitution = .01
    --密度
    fixtureDef.density     = .01
    --用户数据
    -- userData               = NULL
    body:CreateFixture(fixtureDef)
end

--创建一个圆形刚体
function M:createCircle( )
    local bodyDef      = b2BodyDef()
    bodyDef.position   = b2Vec2(480/32, 400/32)
    --动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
    bodyDef.type       = b2_dynamicBody
    --允许休眠
    bodyDef.allowSleep = true
    -- userData           = NULL
    local body         = world:CreateBody(bodyDef)
    --创建夹具定义
    local fixtureDef   = b2FixtureDef()
    --创建一个多边形
    local shape        = b2CircleShape()
    shape.m_radius     = 3
    --赋值给材质的属性
    fixtureDef.shape       = shape
    --摩擦
    fixtureDef.friction    = .3
    --恢复
    fixtureDef.restitution = .1
    --密度
    fixtureDef.density     = .1
    --用户数据
    -- userData               = NULL
    body:CreateFixture(fixtureDef)
end

--创建边界
function M:createEdge()
    local bodyDef      = b2BodyDef()
    bodyDef.position   = b2Vec2(0, 0)
    --动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
    bodyDef.type       = b2_staticBody
    --允许休眠
    -- bodyDef.allowSleep = true
    -- userData           = NULL
    local body         = world:CreateBody(bodyDef)
    
    local beganP = {b2Vec2(0/32, 0/32), b2Vec2(960/32, 0/32), b2Vec2(960/32, 540/32), b2Vec2(0/32, 540/32)}
    local endP   = {b2Vec2(960/32, 0/32), b2Vec2(960/32, 540/32), b2Vec2(0/32, 540/32), b2Vec2(0/32, 0/32)}
    for i=1,4 do
        --创建夹具定义
        local fixtureDef = b2FixtureDef()
        local shape      = b2EdgeShape()
        shape:Set(beganP[i], endP[i])
        --赋值给材质的属性
        fixtureDef.shape       = shape
        --摩擦
        fixtureDef.friction    = .05
        --恢复
        fixtureDef.restitution = .01
        --密度
        fixtureDef.density     = .01
        --用户数据
        body:CreateFixture(fixtureDef)
    end
end

--创建复杂形状刚体，通过物理编辑器导出的文件
function M:createBody()
    local bodyDef      = b2BodyDef()
    bodyDef.position   = b2Vec2(100/32, 270/32)
    --动态刚体 b2_dynamicBody,静态刚体 b2_staticBody,平台刚体 b2_kinematicBody
    bodyDef.type       = b2_dynamicBody
    --允许休眠
    bodyDef.allowSleep = true
    -- userData           = NULL
    local body         = world:CreateBody(bodyDef)

    -- self:addComplexFixture(body, "path", "key")
end

--创建测试精灵,将刚体数据同步到精灵身上
function M:loadTestNode()
    local TestNode = import("app.v_demo.node.TestNode")
    self.tNode = TestNode.new():to(self):p(100, 100)
end

--[[--
添加复杂的纹理
-   b2Body  **body**        [必选] 刚体对象
-   String  **plistPath**   [必选] PhysicsEditor导出的.plist文件
-   String  **key**         [必选] plist文件中物理形状图片名称

### Returns:
--]]--
function M:addComplexFixture(body, plistPath, key)
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



-- 关节就是约束两个刚体，让这两个刚体产生特殊或者有规律的运动
-- 介绍关节的属性
-- 创建关节的步骤
-- 1、创建关节定义，并设置关节属性：设置被约束的两个刚体、是否可以互相碰撞等
-- 2、通过world创建出刚体

-- 关节(b2Joint)
-- 鼠标关节（Mouse）    －点击物体上任意一个点可以在世界范围内进行拖动
-- 距离关节（Distance） －在每个物体上都有一个点以保持之间距离的关节
-- 旋转关节（Revolute） －一个允许物体围绕公共点旋转的铰链顶点的关节
-- 平移关节（Prismatic）－两个物体之间的相对旋转是固定的，它们可以沿着一个坐标轴进行平移
-- 线段关节（Line）     －由旋转和平移组合而成的关节，对于构建汽车悬架模型很有用
-- 焊接关节（Weld）     －可以把物体固定在相同方向上。
-- 滑轮关节（Pulley）   －每一个物体内部都有一个点，通过世界当中某个固定的点，让围绕这个点的物体之间保持一定的距离，物体之间总的距离是固定的，就像是（sheesh…貌似不太容易找到简明的解释来描述）
-- 摩擦关节（Friction） －降低两个物体之间的相对运动
-- 齿轮关节（Gear）     －控制其它两个关节（旋转关节或者平移关节），其中一个的运动会影响另一个
-- 滚轮关节（Wheel）    －重新定义了一下线性（Line）关节
-- 绳索关节（Rope）     －在最大的一个范围内强制约束每一个物体


-- --创建矩形刚体，车身
function M:createCarBody( )
    --创建车身
    local bodyDef          = b2BodyDef()
    bodyDef.position       = b2Vec2(200/32, 180/32)
    --设置为静态
    -- b2_dynamicBody
    -- b2_staticBody
    bodyDef.type           = b2_dynamicBody
    bodyDef.allowSleep     = true
    body                   = world:CreateBody(bodyDef)

    local fixtureDef = b2FixtureDef()
    local shape            = b2PolygonShape()
    shape:SetAsBox(120/32, 50/32)
    fixtureDef.shape       = shape
    fixtureDef.friction    = .0001
    fixtureDef.restitution = .1
    fixtureDef.density     = .8
    body:CreateFixture(fixtureDef)
    self.bodyA             = body
end

--创建圆形刚体
function M:createBodyCircle(i)
    local bodyDef          = b2BodyDef()
    
    bodyDef.position       = self.bodyPos[i]
    --动态刚体
    bodyDef.type           = b2_dynamicBody
    --允许休眠
    bodyDef.allowSleep     = true
    local body             = world:CreateBody(bodyDef)
    --创建夹具定义
    local fixtureDef       = b2FixtureDef()
    
    --创建形状
    local shape            = b2CircleShape()
    shape.m_radius         = 1
    --赋值给材质的属性
    fixtureDef.shape       = shape
    fixtureDef.friction    = .5
    fixtureDef.restitution = .3
    fixtureDef.density     = .7
    body:CreateFixture(fixtureDef)
    table.insert(self.bodys, body)
end

--距离关节
function M:createDistanceJoint(bodyA, bodyB, dis)
    local jointDef              = b2DistanceJointDef()
    
    jointDef.bodyA              = bodyA
    jointDef.bodyB              = bodyB
    jointDef.lenght             = dis
    -- jointDef.frequencyHz        = 0.1
    -- 是否连续碰撞
    jointDef.collideConnected   = true
    jointDef:Initialize(bodyA, bodyB, bodyA:GetWorldCenter(), bodyB:GetWorldCenter())
    world:CreateJoint(jointDef)
end

--矩形刚体
function M:createBodyA()
    --创建一个底座
    local testBodyDef = b2BodyDef()
    testBodyDef.position = b2Vec2(480/32, 170/32)
    --设置为静态
    -- b2_dynamicBody
    -- b2_staticBody
    testBodyDef.type = b2_staticBody
    testBodyDef.allowSleep = true
    testBody = world:CreateBody(testBodyDef)

    local testFixtureDef = b2FixtureDef()
    local testShape = b2PolygonShape()
    testShape:SetAsBox(80/32, 20/32)
    testFixtureDef.shape = testShape
    testFixtureDef.friction = .5
    testFixtureDef.restitution = .1
    testFixtureDef.density = .6

    testBody:CreateFixture(testFixtureDef)

    self.bodyA = testBody
end

--十字形刚体
function M:createBodyB( )
    --创建一个底座
    local testBodyDef    = b2BodyDef()
    testBodyDef.position = b2Vec2(480/32, 300/32)
    --设置为静态
    -- b2_dynamicBody
    testBodyDef.type     = b2_dynamicBody
    -- testBodyDef.allowSleep = true
    testBody             = world:CreateBody(testBodyDef)
    local testFixtureDef = b2FixtureDef()
    local testShape      = b2PolygonShape()
    testShape:SetAsBox(80/32, 10/32)
    testFixtureDef.shape       = testShape
    testFixtureDef.friction    = .5
    testFixtureDef.restitution = .1
    testFixtureDef.density     = 5
    testBody:CreateFixture(testFixtureDef)

    local testFixtureDef2      = b2FixtureDef()
    local testShape            = b2PolygonShape()
    testShape:SetAsBox(10/32, 80/32)
    testFixtureDef2.shape      = testShape
    testFixtureDef2.friction   = .5
    testFixtureDef2.restitution = .1
    testFixtureDef2.density    = 5
    testBody:CreateFixture(testFixtureDef2)
    self.bodyB = testBody
    self:createRevoluteJoint(self.bodyA, self.bodyB)
end

--创建旋转关节
function M:createRevoluteJoint(bodyA, bodyB)
    local jointDef            = b2RevoluteJointDef()
    --是否连续碰撞
    jointDef.collideConnected = true
    -- 马达速度
    jointDef.motorSpeed       = -5
    -- 马达最大扭力
    jointDef.maxMotorTorque   = 400
    -- 是否启动马达
    jointDef.enableMotor      =true
    --初始化关节，第一个是需要旋转的刚体，第三个是围绕的是哪个刚体旋转
    jointDef:Initialize(bodyA, bodyB, bodyB:GetWorldCenter())
    world:CreateJoint(jointDef)
end

--------------------------
-- 属性
--------------------------




--------------------------
-- 父类重写
-------------------------- 




return M






