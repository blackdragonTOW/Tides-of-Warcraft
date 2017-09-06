Samplers = {
	DiffuseMap = {
		Index = 0;
		MinFilter = "Anisotropic";
		MagFilter = "Linear";
		MipFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
		MipMapLodBias = -1;
		MaxAnisotropy = 4;
	},	
	SpecularMap = {
		Index = 1;
		MinFilter = "Linear";
		MagFilter = "Linear";
		MipFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
		MipMapLodBias = -1;
		
	},	
	
	NormalMap = {
		Index = 2;
		MinFilter = "Linear";
		MagFilter = "Linear";
		MipFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
		MipMapLodBias = -1;
	},	

	FlagMap = {
		Index = 3;
		MinFilter = "Linear";
		MagFilter = "Linear";
		MipFilter = "None";
		AddressU = "Clamp";
		AddressV = "Clamp";
		MipMapLodBias = -1;
	},	
	
	FoWTexture = {
		Index = 4;
		MinFilter = "Linear";
		MagFilter = "Linear";
		MipFilter = "Linear";
		AddressU = "Clamp";
		AddressV = "Clamp";
	},	
	
	FoWDiffuse = {
		Index = 5;
		MinFilter = "Linear";
		MagFilter = "Linear";
		MipFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
	},	
}

AddSamplers()

BlendState = {
	BlendEnable = false;
	AlphaTest = false;
}

BlendStateAlphaBlend = {
	BlendEnable = true;
	AlphaTest = false;
	SourceBlend = "SRC_ALPHA";
	DestBlend = "INV_SRC_ALPHA";
}

BlendStateAlphaAdditive = {
	BlendEnable = true;
	AlphaTest = false;
	SourceBlend = "SRC_ALPHA";
	DestBlend = "one";
}

DepthStencilNoZWrite = {
	DepthEnable = true;
	DepthWriteMask = "DEPTH_WRITE_ZERO";
}

RasterizerState =
{
	FillMode = "FILL_SOLID";
	CullMode = "CULL_BACK";
	FrontCCW = false;
}

Includes = {
	"constants.fxh",
	"standardfuncsgfx.fxh"
}

Defines = { }

DeclareVertex( [[
struct VS_INPUT_PDXMESHSTANDARD
{
    float3 vPosition	: POSITION;
	float3 vNormal      : TEXCOORD0;
	float4 vTangent		: TEXCOORD1;
	float2 vUV0			: TEXCOORD2;
	float2 vUV1			: TEXCOORD3;
	float4 vBoneIndex	: TEXCOORD4;
	float3 vBoneWeight	: TEXCOORD5;
};

]] )

DeclareVertex( [[

struct VS_OUTPUT_PDXMESHSTANDARD
{
    float4 vPosition	: POSITION;
	float3 vNormal		: TEXCOORD0;
	float3 vTangent		: TEXCOORD1;
	float3 vBitangent	: TEXCOORD2;
	float2 vUV0			: TEXCOORD3;
	float2 vUV1			: TEXCOORD4;
	float4 vPos			: TEXCOORD5;
};

]] )

DeclareVertex( [[
struct VS_INPUT_DEBUGNORMAL
{
    float3 vPosition	: POSITION;
	float3 vNormal      : TEXCOORD0;
	float4 vTangent		: TEXCOORD1;
	float2 vUV0			: TEXCOORD2;
	float2 vUV1			: TEXCOORD3;
	float4 vBoneIndex	: TEXCOORD4;
	float3 vBoneWeight	: TEXCOORD5;
	float  vOffset      : TEXCOORD6;
};

]] )

DeclareVertex( [[

struct VS_OUTPUT_DEBUGNORMAL
{
    float4 vPosition : POSITION;
	float2 vUV0		 : TEXCOORD0;
};

]] )

DeclareVertex( [[

struct VS_OUTPUT_PDXMESHSHADOW
{
    float4 vPosition	: POSITION;
	float4 vDepthUV0	: TEXCOORD0;
};

]] )


DeclareShared( [[

CONSTANT_BUFFER( 1, 32 )
{
	float4x4 WorldMatrix;
	float4 PrimaryColor;
	float4 SecondaryColor;
	float4 TertiaryColor; 
	float4 TextureAtlasCoords;
	float4 AtlasHalfColor;
	float4 AtlasCutoff;
}

CONSTANT_BUFFER( 2, 41 )
{
	float4x4 matBones[50]; // : Bones :register( c41 ); // 50 * 4 registers 41 - 241 (never push above 256)
}

static const int PDXMESH_MAX_INFLUENCE = 4;

float2 GetTexCoordsInAtlas(float2 TexCoord)
{
	return float2( (TexCoord.x / TextureAtlasCoords.x) + TextureAtlasCoords.z,
	               (TexCoord.y / TextureAtlasCoords.y) + TextureAtlasCoords.w );
}

]] )


-- PdxMeshStandard variations
PdxMeshStandard = {
	VertexShader = "VertexPdxMeshStandard";
	PixelShader = "PixelPdxMeshStandard";
	ShaderModel = 3;
}

PdxMeshAnimateUVAdditiveBlending = {
	VertexShader = "VertexPdxMeshStandard";
	PixelShader = "PixelPdxMeshAnimateUV";
	ShaderModel = 3;
	
	BlendState = "BlendStateAlphaAdditive";
}

PdxMeshAnimateUVAlphaBlending = {
	VertexShader = "VertexPdxMeshStandard";
	PixelShader = "PixelPdxMeshAnimateUV";
	ShaderModel = 3;
	
	BlendState = "BlendStateAlphaBlend";
	DepthStencil = "DepthStencilNoZWrite"
}

PdxMeshAnimateUVAdditiveBlendingSkinned = {
	VertexShader = "VertexPdxMeshStandardSkinned";
	PixelShader = "PixelPdxMeshAnimateUV";
	ShaderModel = 3;
	
	BlendState = "BlendStateAlphaAdditive";
	DepthStencil = "DepthStencilNoZWrite"
}

PdxMeshAnimateUVAlphaBlendingSkinned = {
	VertexShader = "VertexPdxMeshStandardSkinned";
	PixelShader = "PixelPdxMeshAnimateUV";
	ShaderModel = 3;
	
	BlendState = "BlendStateAlphaBlend";
	DepthStencil = "DepthStencilNoZWrite"
}

PdxMeshStandardSkinned = {
	VertexShader = "VertexPdxMeshStandardSkinned";
	PixelShader = "PixelPdxMeshStandard";
	ShaderModel = 3;
}

-- PdxMeshColor variations
PdxMeshColor = {
	VertexShader = "VertexPdxMeshStandard";
	PixelShader = "PixelPdxMeshColor";
	ShaderModel = 3;
}

PdxMeshColorSkinned = {
	VertexShader = "VertexPdxMeshStandardSkinned";
	PixelShader = "PixelPdxMeshColor";
	ShaderModel = 3;
}

-- PdxMeshTextureAtlas variations
PdxMeshTextureAtlas = {
 VertexShader = "VertexPdxMeshStandard";
 PixelShader = "PixelPdxMeshTextureAtlas";
 ShaderModel = 3;
}

PdxMeshTextureAtlasSkinned = {
 VertexShader = "VertexPdxMeshStandardSkinned";
 PixelShader = "PixelPdxMeshTextureAtlas";
 ShaderModel = 3;
}

--[[
------------------------------------------------------------
-- Vertex shaders
------------------------------------------------------------
--]]

DeclareShader( "VertexPdxMeshStandard", [[

VS_OUTPUT_PDXMESHSTANDARD main( const VS_INPUT_PDXMESHSTANDARD v )
{
  	VS_OUTPUT_PDXMESHSTANDARD Out;
			
	float4 vPosition = float4( v.vPosition.xyz, 1.0f );
	Out.vNormal = normalize( mul( v.vNormal, CastTo3x3( WorldMatrix ) ) );
	Out.vTangent = normalize( mul( v.vTangent.xyz, CastTo3x3( WorldMatrix ) ) );
	Out.vBitangent = normalize( cross( Out.vNormal, Out.vTangent ) * v.vTangent.w );

	Out.vPosition = mul( vPosition, WorldMatrix );
	Out.vPos = Out.vPosition;
	Out.vPosition = mul( Out.vPosition, ViewProjectionMatrix );
	
	Out.vUV0 = v.vUV0;
	Out.vUV1 = v.vUV1;
	return Out;
}

]] )

DeclareShader( "VertexPdxMeshStandardSkinned", [[

VS_OUTPUT_PDXMESHSTANDARD main( const VS_INPUT_PDXMESHSTANDARD v )
{
  	VS_OUTPUT_PDXMESHSTANDARD Out;
			
	float4 vPosition = float4( v.vPosition.xyz, 1.0f );
	float4 vSkinnedPosition = float4( 0, 0, 0, 0 );
	float3 vSkinnedNormal = float3( 0, 0, 0 );
	float3 vSkinnedTangent = float3( 0, 0, 0 );
	float3 vSkinnedBitangent = float3( 0, 0, 0 );

	float4 vWeight = float4( v.vBoneWeight.xyz, 1.0f - v.vBoneWeight.x - v.vBoneWeight.y - v.vBoneWeight.z );

	for( int i = 0; i < PDXMESH_MAX_INFLUENCE; ++i )
    {
		int nIndex = int( v.vBoneIndex[i] );
		float4x4 mat = matBones[nIndex];
		vSkinnedPosition += mul( vPosition, mat ) * vWeight[i];

		float3 vNormal = mul( v.vNormal, CastTo3x3(mat) );
		float3 vTangent = mul( v.vTangent.xyz, CastTo3x3(mat) );
		float3 vBitangent = cross( vNormal, vTangent ) * v.vTangent.w;

		vSkinnedNormal += vNormal * vWeight[i];
		vSkinnedTangent += vTangent * vWeight[i];
		vSkinnedBitangent += vBitangent * vWeight[i];
	}

	Out.vPosition = mul( vSkinnedPosition, WorldMatrix );
	Out.vPos = Out.vPosition;
	Out.vPosition = mul( Out.vPosition, ViewProjectionMatrix );

	Out.vNormal = normalize( mul( normalize( vSkinnedNormal ), CastTo3x3(WorldMatrix) ) );
	Out.vTangent = normalize( mul( normalize( vSkinnedTangent ), CastTo3x3(WorldMatrix) ) );
	Out.vBitangent = normalize( mul( normalize( vSkinnedBitangent ), CastTo3x3(WorldMatrix) ) );

	Out.vUV0 = v.vUV0;
	Out.vUV1 = v.vUV1;

	return Out;
}

]] )



--[[
------------------------------------------------------------
-- Pixel shaders
------------------------------------------------------------
--]]


DeclareShader( "PixelPdxMeshStandard", [[
	
float4 main( VS_OUTPUT_PDXMESHSTANDARD In ) : COLOR
{
	float3 vPos = In.vPos.xyz / In.vPos.w;

	float4 vFoWColor = GetFoWColor( vPos, FoWTexture);

	float4 vColor = tex2D( DiffuseMap, In.vUV0 );
	float4 vSpecColor = tex2D( SpecularMap, In.vUV0 );
	
	/*float3 vNormalSample = UnpackNormal( NormalMap, In.vUV0 );
	float3x3 TBN = Create3x3( normalize( In.vTangent ), normalize( In.vBitangent ), normalize( In.vNormal ) );
	float3 vNormal = mul( vNormalSample, TBN );*/
	float3 vNormal = normalize( In.vNormal );

	vColor.rgb = CalculateLighting( vColor.rgb, vNormal );
	float vFoW = GetFoW( vPos, FoWTexture, FoWDiffuse );
	vColor.rgb = ApplyDistanceFog( vColor.rgb, vPos ) * vFoW;
	vColor.rgb = ComposeSpecular( vColor.rgb, CalculateSpecular( vPos, vNormal, (vSpecColor.a * 2.0 ) ) * vFoW );
	
	return vColor;
}
	
]] )


DeclareShader( "PixelPdxMeshColor", [[
	
float4 main( VS_OUTPUT_PDXMESHSTANDARD In ) : COLOR
{
	float3 vPos = In.vPos.xyz / In.vPos.w;
	
	float4 vFoWColor = GetFoWColor( vPos, FoWTexture);
	
	float4 vColor = tex2D( DiffuseMap, In.vUV0 );
	float4 vSpecColor = tex2D( SpecularMap, In.vUV0 );
	float3 vNormal = normalize( In.vNormal );

	float vIsColonial = saturate( ( AtlasCutoff.x - 0.1f ) * 1000.0f );
	float3 vTertiaryColor = TertiaryColor.rgb * ( 1.0f - vIsColonial ) + AtlasHalfColor.rgb * vIsColonial;
		
	vColor.rgb = lerp( vColor.rgb, 
	        vColor.rgb * ( vSpecColor.r * PrimaryColor.rgb ), 
		    vSpecColor.r );

	vColor.rgb = lerp( vColor.rgb, 
	        vColor.rgb * ( vSpecColor.g * SecondaryColor.rgb ), 
		    vSpecColor.g );

	vColor.rgb = lerp( vColor.rgb, 
	        vColor.rgb * ( vSpecColor.b * vTertiaryColor ), 
		    vSpecColor.b );	
	
	vColor.rgb = CalculateLighting( vColor.rgb, vNormal );
	float vFoW = GetFoW( vPos, FoWTexture, FoWDiffuse );
	vColor.rgb = ApplyDistanceFog( vColor.rgb, vPos ) * vFoW;
	vColor.rgb = ComposeSpecular( vColor.rgb, CalculateSpecular( vPos, vNormal, (vSpecColor.a * 2.0 ) ) * vFoW );

	return float4( vColor.rgb, 1.0f );
}
	
]] )

DeclareShader( "PixelPdxMeshAnimateUV", [[
	
float4 main( VS_OUTPUT_PDXMESHSTANDARD In ) : COLOR
{
	float3 vPos = In.vPos.xyz / In.vPos.w;

	float4 vFoWColor = GetFoWColor( vPos, FoWTexture);
	
	const float ANIMATION_SPEED = 1.0;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	////PrimaryColor.x below represents the UV animation speed. We can't have a constant buffer alias/////////
	////(to have a variable with a more reasonable name like _UVSpeed ) because the generated GLSL   /////////
	////file will fail to compile due to UNIFORM duplicates. There's no support for this  case in    /////////
	////our parser // Mohammed                                                                                   /////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	float t = frac( vFoWOpacity_Time.y * PrimaryColor.x * ANIMATION_SPEED );

	float4 vColor = tex2D( DiffuseMap, float2( In.vUV0.x, In.vUV0.y + t ) );
	vColor.a = tex2D( DiffuseMap, In.vUV0 ).a;
	float4 vSpecColor = tex2D( SpecularMap, In.vUV0 );
	
	/*float3 vNormalSample = UnpackNormal( NormalMap, In.vUV0 );
	float3x3 TBN = Create3x3( normalize( In.vTangent ), normalize( In.vBitangent ), normalize( In.vNormal ) );
	float3 vNormal = mul( vNormalSample, TBN );*/
	float3 vNormal = normalize( In.vNormal );

	vColor.rgb = CalculateLighting( vColor.rgb, vNormal );
	float vFoW = GetFoW( vPos, FoWTexture, FoWDiffuse );
	vColor.rgb = ApplyDistanceFog( vColor.rgb, vPos ) * vFoW;
	vColor.rgb = ComposeSpecular( vColor.rgb, CalculateSpecular( vPos, vNormal, (vSpecColor.a * 2.0 ) ) * vFoW );
	
	return vColor;
}

]] )

DeclareShader( "PixelPdxMeshTextureAtlas", [[
	
float4 main( VS_OUTPUT_PDXMESHSTANDARD In ) : COLOR
{
	float3 vPos = In.vPos.xyz / In.vPos.w;
	
	float4 vFoWColor = GetFoWColor( vPos, FoWTexture);
	
	float4 vColor = tex2D( DiffuseMap, In.vUV0 );
	float4 vSpecColor = tex2D( SpecularMap, In.vUV0 );
	float3 vTabardColor = tex2D( FlagMap, GetTexCoordsInAtlas( In.vUV1 ) ).rgb;
	float3 vNormal = normalize( In.vNormal );

	float3 vFinal = vColor.rgb * ( 1 - vColor.a ) + vColor.rgb * vColor.a * vTabardColor;
	
	vFinal.rgb = CalculateLighting( vFinal.rgb, vNormal );
	float vFoW = GetFoW( vPos, FoWTexture, FoWDiffuse );
	vFinal.rgb = ApplyDistanceFog( vFinal.rgb, vPos ) * vFoW;
	vFinal.rgb = ComposeSpecular( vFinal.rgb, CalculateSpecular( vPos, vNormal, (vSpecColor.a * 2.0 ) ) * vFoW );

	return float4( vFinal.rgb, 1.0f );
}

]] )



DebugNormal = {
	VertexShader = "VertexDebugNormal";
	PixelShader = "PixelDebugNormal";
	ShaderModel = 3;
}

DebugNormalSkinned = {
	VertexShader = "VertexDebugNormalSkinned";
	PixelShader = "PixelDebugNormal";
	ShaderModel = 3;
}


DeclareShader( "VertexDebugNormal", [[

VS_OUTPUT_DEBUGNORMAL main( const VS_INPUT_DEBUGNORMAL v )
{
  	VS_OUTPUT_DEBUGNORMAL Out;

	Out.vPosition = mul( WorldMatrix, float4( v.vPosition.xyz, 1.0 ) );
	Out.vPosition.xyz += mul( CastTo3x3(WorldMatrix), v.vNormal ) * v.vOffset * 0.3f;
	Out.vPosition = mul( ViewProjectionMatrix, Out.vPosition );	

	Out.vUV0 = v.vUV0;

	return Out;
}

]] )


DeclareShader( "VertexDebugNormalSkinned", [[

VS_OUTPUT_DEBUGNORMAL main( const VS_INPUT_DEBUGNORMAL v )
{
  	VS_OUTPUT_DEBUGNORMAL Out;
			
	float4 vPosition = float4( v.vPosition.xyz, 1.0 );
	float4 vSkinnedPosition = float4( 0, 0, 0, 0 );
	float3 vSkinnedNormal = float3( 0, 0, 0 );

	float4 vWeight = float4( v.vBoneWeight.xyz, 1.0f - v.vBoneWeight.x - v.vBoneWeight.y - v.vBoneWeight.z );

	for( int i = 0; i < PDXMESH_MAX_INFLUENCE; ++i )
    {
		int nIndex = int( v.vBoneIndex[i] );
		float4x4 mat = matBones[nIndex];
		vSkinnedPosition += mul( mat, vPosition ) * vWeight[i];	
		vSkinnedNormal += mul( CastTo3x3(mat), v.vNormal ) * vWeight[i];
	}

	Out.vPosition = mul( WorldMatrix, vSkinnedPosition );

	vSkinnedNormal = normalize( mul( CastTo3x3(WorldMatrix), vSkinnedNormal ) );
	Out.vPosition.xyz += vSkinnedNormal * v.vOffset * 0.3f;
	Out.vPosition = mul( ViewProjectionMatrix, Out.vPosition );	

	Out.vUV0 = v.vUV0;

	return Out;
}

]] )


DeclareShader( "PixelDebugNormal", [[
	
float4 main( VS_OUTPUT_DEBUGNORMAL In ) : COLOR
{
	float4 vColor = float4( 0.0f, 1.0f, 0.0f, 1.0f );
	return vColor;
}
	
]] )
