--[[--------------------------
[csu]定义Shader操作  

     Copyright (c) 2011-2016 Baby-Bus.com

    - Desc:   定义Shader操作  
    - Author: zengbinsi
    - Date:   2015-05-15  

--]]--------------------------  







--[[
	全局类
--]]


local M 	= {}

M.TAG 		= "ZShader"











--------------------------
-- 必备常量
--------------------------
----------
-- OpenGL
----------
kCCShader_PositionTextureColor              = "ShaderPositionTextureColor"
kCCShader_PositionTextureGray               = "ShaderPositionTextureGray"
kCCShader_PositionTextureColorAlphaTest     = "ShaderPositionTextureColorAlphaTest"
kCCShader_PositionColor                     = "ShaderPositionColor"
kCCShader_PositionTexture                   = "ShaderPositionTexture"
kCCShader_PositionTexture_uColor            = "ShaderPositionTexture_uColor"
kCCShader_PositionTextureA8Color            = "ShaderPositionTextureA8Color"
kCCShader_Position_uColor                   = "ShaderPosition_uColor"
kCCShader_PositionLengthTexureColor         = "ShaderPositionLengthTextureColor"
kCCShader_ControlSwitch                     = "Shader_ControlSwitch"

-- uniform names
kCCUniformPMatrix_s                         = "CC_PMatrix"
kCCUniformMVMatrix_s                        = "CC_MVMatrix"
kCCUniformMVPMatrix_s                       = "CC_MVPMatrix"
kCCUniformTime_s                            = "CC_Time"
kCCUniformSinTime_s                         = "CC_SinTime"
kCCUniformCosTime_s                         = "CC_CosTime"
kCCUniformRandom01_s                        = "CC_Random01"
kCCUniformSampler_s                         = "CC_Texture0"
kCCUniformAlphaTestValue                    = "CC_alpha_value"

-- Attribute names
kCCAttributeNameColor                       = "a_color"
kCCAttributeNamePosition                    = "a_position"
kCCAttributeNameTexCoord                    = "a_texCoord"


kCCVertexAttrib_Position                    = 0
kCCVertexAttrib_Color                       = 1
kCCVertexAttrib_TexCoords                   = 2

kCCUniformPMatrix                           = 0
kCCUniformMVMatrix                          = 1
kCCUniformMVPMatrix                         = 2
kCCUniformTime                              = 3
kCCUniformSinTime                           = 4
kCCUniformCosTime                           = 5
kCCUniformRandom01                          = 6
kCCUniformSampler                           = 7
-- TextureUnit
GL_TEXTURE0                                 = 0x84C0
GL_TEXTURE1                                 = 0x84C1
GL_TEXTURE2                                 = 0x84C2
GL_TEXTURE3                                 = 0x84C3
GL_TEXTURE4                                 = 0x84C4
GL_TEXTURE5                                 = 0x84C5
GL_TEXTURE6                                 = 0x84C6
GL_TEXTURE7                                 = 0x84C7
GL_TEXTURE8                                 = 0x84C8
GL_TEXTURE9                                 = 0x84C9
GL_TEXTURE10                                = 0x84CA
GL_TEXTURE11                                = 0x84CB
GL_TEXTURE12                                = 0x84CC
GL_TEXTURE13                                = 0x84CD
GL_TEXTURE14                                = 0x84CE
GL_TEXTURE15                                = 0x84CF
GL_TEXTURE16                                = 0x84D0
GL_TEXTURE17                                = 0x84D1
GL_TEXTURE18                                = 0x84D2
GL_TEXTURE19                                = 0x84D3
GL_TEXTURE20                                = 0x84D4
GL_TEXTURE21                                = 0x84D5
GL_TEXTURE22                                = 0x84D6
GL_TEXTURE23                                = 0x84D7
GL_TEXTURE24                                = 0x84D8
GL_TEXTURE25                                = 0x84D9
GL_TEXTURE26                                = 0x84DA
GL_TEXTURE27                                = 0x84DB
GL_TEXTURE28                                = 0x84DC
GL_TEXTURE29                                = 0x84DD
GL_TEXTURE30                                = 0x84DE
GL_TEXTURE31                                = 0x84DF
GL_ACTIVE_TEXTURE                           = 0x84E0
-- EnableCap
GL_TEXTURE_2D                               = 0x0DE1
GL_CULL_FACE                                = 0x0B44
GL_BLEND                                    = 0x0BE2
GL_DITHER                                   = 0x0BD0
GL_STENCIL_TEST                             = 0x0B90
GL_DEPTH_TEST                               = 0x0B71
GL_SCISSOR_TEST                             = 0x0C11
GL_POLYGON_OFFSET_FILL                      = 0x8037
GL_SAMPLE_ALPHA_TO_COVERAGE                 = 0x809E
GL_SAMPLE_COVERAGE                          = 0x80A0









--========================
-- 功能方法
--======================== 

--[[--
创建GLProgram[默认创建]

<br/>  
### Useage:
    用于创建一个GL程序

### Parameters:
- 	string 	**vsh** 				[必选] 顶点着色器程序的文件路径  
- 	string 	**fsh** 				[必选] 片元着色器程序的文件路径  

### Returns: 
-   GLuint 							GL程序对象

--]]--
function M.createGLProgram(vsh, fsh)
	assert(type(vsh) == "string", "error in function 'createGLProgram'. argument #1 is '".. 
		type(vsh) .."'; 'string' expected.")
	assert(type(fsh) == "string", "error in function 'createGLProgram'. argument #2 is '".. 
		type(fsh) .."'; 'string' expected.")

	local program 	= GlUtils:createProgram(vsh, fsh)

    GlUtils:programRetain(program)
    GlUtils:programAddAttribute(program, kCCAttributeNamePosition, kCCVertexAttrib_Position)
    GlUtils:programAddAttribute(program, kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords)
    GlUtils:programAddAttribute(program, kCCAttributeNameColor, kCCVertexAttrib_Color)

    GlUtils:programLink(program)
    GlUtils:programUpdateUniforms(program)

    GlUtils:programUse(program)
    GlUtils:checkErrorDebug()

    return program
end

--[[--
创建GLProgram[创建带鼠标位置的处理程序]

<br/>  
### Useage:
    用于创建一个带鼠标位置的GL程序。
    
### Parameters:
- 	string 	**vsh** 				[必选] 顶点着色器程序的文件路径  
- 	string 	**fsh** 				[必选] 片元着色器程序的文件路径  

### Returns: 
-   GLuint 							GL程序对象

--]]--
function M.createGLProgramWithMouse(vsh, fsh, x, y)
	assert(type(vsh) == "string", "error in function 'createGLProgram'. argument #1 is '".. 
		type(vsh) .."'; 'string' expected.")
	assert(type(fsh) == "string", "error in function 'createGLProgram'. argument #2 is '".. 
		type(fsh) .."'; 'string' expected.")

	local program 	= GlUtils:createProgram(vsh, fsh)
    GlUtils:programRetain(program)

    -- 添加属性
    GlUtils:programAddAttribute(program, kCCAttributeNamePosition, kCCVertexAttrib_Position)
    GlUtils:programAddAttribute(program, kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords)
    GlUtils:programAddAttribute(program, kCCAttributeNameColor, kCCVertexAttrib_Color)

    GlUtils:programLink(program)
    GlUtils:programUpdateUniforms(program)
    GlUtils:programUse(program)
    GlUtils:checkErrorDebug()


    local posX     = GlUtils:programGetUniformLocationForName(program, "posX")
    GlUtils:programSetUniformLocationWith1f(program, posX, 480.0 / 960.0) 
    local posY     = GlUtils:programGetUniformLocationForName(program, "posY")
    GlUtils:programSetUniformLocationWith1f(program, posY, 640.0 / 640.0) 


    -- 传参数
    -- local PosX     = GlUtils:programGetUniformLocationForName(program, "PosX")
    -- GlUtils:programSetUniformLocationWith1f(program, PosX , 480.0/960.0) 
    -- local PosY     = GlUtils:programGetUniformLocationForName(program, "PosY")
    -- GlUtils:programSetUniformLocationWith1f(program, PosY , 640.0/640.0) 
    -- local width    = GlUtils:programGetUniformLocationForName(program, "width")
    -- GlUtils:programSetUniformLocationWith1f(program, width , display.width) 
    -- local height   = GlUtils:programGetUniformLocationForName(program, "height")
    -- GlUtils:programSetUniformLocationWith1f(program, height, display.height) 
    -- local ScaleNum = self:CountOffsetAndScale()
    -- local fscale   = GlUtils:programGetUniformLocationForName(program, "ScaleNum")
    -- GlUtils:programSetUniformLocationWith1f(program, fscale,ScaleNum)

    
    return program
end








return M








