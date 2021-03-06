﻿Shader "Custom/Kaelido" {
	Properties {
	}
	SubShader {
   		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
   		Pass {
		    Cull off
	    	Blend SrcAlpha OneMinusSrcAlpha     
		    ZWrite Off
			LOD 200
			
			CGPROGRAM
			#pragma target 3.0
		    #pragma vertex vert
		    #pragma fragment frag   
	    	#include "UnityCG.cginc"   
	    	#define PI 3.141592653589
			#define PI2 6.283185307179
			#define PIHalf 1.570796327
			#define RADTier 2.094395102
			#define RAD2Tier 4.188790205

		    struct v2f {
		        float4 pos : SV_POSITION;
		        float2 uv : TEXCOORD0;
                float4 screenUV : TEXCOORD1;
		    };   

			sampler2D _SamplerVideo;
			sampler2D _SamplerRenderTarget;
	    	float4 _SamplerVideo_ST; 
			float _TimeElapsed;

	    	float _SamplesTotal;
	    	float _SamplesElapsed;
			sampler2D _SamplerSound;

			v2f vert (appdata_full v)
			{
		        v2f o;
		        o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		        o.uv = TRANSFORM_TEX (v.texcoord, _SamplerVideo);
		        o.screenUV = ComputeScreenPos(o.pos);
		        return o;

		    }

		    half4 frag (v2f i) : COLOR
		    {
		    	float2 uv = i.screenUV.xy / i.screenUV.w * 2.0 - 1.0;
		    	uv.x *= _ScreenParams.x / _ScreenParams.y;

			    float dist = length(uv);
			    float angle = atan2(uv.y, uv.x) - PIHalf;
			    float t = 0.01 * _SamplesElapsed;

			    float a = abs(angle) / PI * 3.0;
			    a += t * lerp(-1.0, 1.0,  fmod(floor(a), 2.0));
			    float aMod = fmod(abs(a), 1.0);
			    a = lerp(1.0 - aMod, aMod, fmod(floor(abs(a)), 2.0));

			    float d = log(dist);
			    d += t * lerp(-1.0, 1.0, fmod(floor(abs(d)), 2.0));
			    float dMod = fmod(abs(d), 1.0);
			    d = lerp(1.0 - dMod, dMod, fmod(floor(abs(d)), 2.0));

			    uv = fmod(float2(a, d), 1.0);

		        return tex2D(_SamplerVideo, uv);
		    }
			ENDCG
		} 
	}
	FallBack "Unlit/Transparent"
}
