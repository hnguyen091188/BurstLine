// Shader created with Shader Forge Beta 0.20 
// Shader Forge (c) Joachim 'Acegikmo' Holmer
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.20;sub:START;pass:START;ps:lgpr:1,nrmq:1,limd:1,blpr:3,bsrc:0,bdst:6,culm:2,dpts:2,wrdp:False,uamb:True,mssp:True,ufog:True,aust:True,igpj:True,qofs:0,lico:1,qpre:3,flbk:,rntp:2,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,hqsc:True,hqlp:False,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0;n:type:ShaderForge.SFN_Final,id:1,x:32719,y:32712|emission-90-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:6,x:34139,y:32229,ptlb:Texture,tex:9fe27008addbb1a4f87a9228580313bb;n:type:ShaderForge.SFN_Multiply,id:7,x:33361,y:32488|A-130-R,B-8-OUT;n:type:ShaderForge.SFN_Vector3,id:8,x:33615,y:32624,v1:1,v2:1,v3:1;n:type:ShaderForge.SFN_Tex2d,id:54,x:33645,y:32745,tex:9fe27008addbb1a4f87a9228580313bb,ntxv:0,isnm:False|TEX-6-TEX;n:type:ShaderForge.SFN_Multiply,id:56,x:33372,y:32760|A-54-G,B-58-OUT;n:type:ShaderForge.SFN_Vector3,id:58,x:33626,y:32896,v1:0.4852941,v2:1,v3:0.8509127;n:type:ShaderForge.SFN_Add,id:59,x:33176,y:32637|A-7-OUT,B-56-OUT;n:type:ShaderForge.SFN_Tex2d,id:85,x:33491,y:33002,tex:9fe27008addbb1a4f87a9228580313bb,ntxv:0,isnm:False|TEX-6-TEX;n:type:ShaderForge.SFN_Multiply,id:87,x:33218,y:33017|A-85-B,B-89-OUT;n:type:ShaderForge.SFN_Vector3,id:89,x:33472,y:33153,v1:0.4852941,v2:0.6592293,v3:1;n:type:ShaderForge.SFN_Add,id:90,x:33005,y:32816|A-59-OUT,B-87-OUT;n:type:ShaderForge.SFN_Tex2d,id:130,x:33677,y:32441,tex:9fe27008addbb1a4f87a9228580313bb,ntxv:0,isnm:False|TEX-6-TEX;n:type:ShaderForge.SFN_Panner,id:189,x:34017,y:32517,spu:0.5,spv:0|UVIN-198-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:198,x:34199,y:32477,uv:0;proporder:6;pass:END;sub:END;*/

Shader "Shader Forge/Rail_Shader_01" {
    Properties {
        _Texture ("Texture", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One OneMinusSrcColor
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform sampler2D _Texture; uniform float4 _Texture_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection =  i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
////// Lighting:
////// Emissive:
                float2 node_258 = i.uv0;
                float3 emissive = (((tex2D(_Texture,TRANSFORM_TEX(node_258.rg, _Texture)).r*float3(1,1,1))+(tex2D(_Texture,TRANSFORM_TEX(node_258.rg, _Texture)).g*float3(0.4852941,1,0.8509127)))+(tex2D(_Texture,TRANSFORM_TEX(node_258.rg, _Texture)).b*float3(0.4852941,0.6592293,1)));
                float3 finalColor = emissive;
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
