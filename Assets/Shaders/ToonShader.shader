Shader "Custom/ToonShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CelShadingLevel ("Toon level", Float) = 1.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf CelShading
		#pragma target 3.0

		sampler2D _MainTex;
		float _CelShadingLevel;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}

		fixed4 LightingCelShading(SurfaceOutput o, fixed3 lightDir, fixed atten){
			half NdotL = dot(o.Normal, lightDir);
			half cel = floor(NdotL * _CelShadingLevel) / (_CelShadingLevel - 0.5);

			fixed4 c;
			c.rgb = o.Albedo * _LightColor0.rgb * cel * atten;
			c.a = o.Alpha;

			return c;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
