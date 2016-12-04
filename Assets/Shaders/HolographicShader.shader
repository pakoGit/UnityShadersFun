﻿Shader "PavlikShaders/HolographicShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Main Texture", 2D) = "white" {}
		_DotProduct ("Rim effect", Range(-1,1)) = 0.25
	}
	SubShader {
		Tags { 
			"Queue"="Transparent" 
			"IngnoreProjector"="True" 
			"RenderType"="Transparent" 
		}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert alpha:fade nolighting

		sampler2D _MainTex;
		float _DotProduct;

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
		};

		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;

			float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
			float alpha = (border * (1 - _DotProduct) + _DotProduct);
			o.Alpha = c.a * alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
