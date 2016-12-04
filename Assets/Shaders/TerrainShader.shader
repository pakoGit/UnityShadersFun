Shader "PavlikShader/TerrainShader" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_ColorA ("Terrain Color A", Color) = (1,1,1,1)
		_ColorB ("Terrain Color B", Color) = (1,1,1,1)

		_RTexture ("Red channel Texture", 2D) = "" {}
		_GTexture ("Green channel Texture", 2D) = "" {}
		_BTexture ("Blue channel Texture", 2D) = "" {}
		_ATexture ("Alpha channel Texture", 2D) = "" {}

		_BlendTex ("Blend Texture", 2D) = "" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf Lambert
		#pragma target 3.0

		float4 _MainTint;
		float4 _ColorA;
		float4 _ColorB;
		sampler2D _RTexture;
		sampler2D _GTexture;
		sampler2D _BTexture;
		sampler2D _ATexture;
		sampler2D _BlendTexture;

		struct Input {
			float2 uv_RTexture;
			float2 uv_BlendTexture;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 blendData = tex2D(_BlendTexture, IN.uv_BlendTexture);

			float4 rTexData = tex2D(_RTexture, IN.uv_RTexture);
			float4 gTexData = tex2D(_GTexture, IN.uv_RTexture);
			float4 bTexData = tex2D(_BTexture, IN.uv_RTexture);
			float4 aTexData = tex2D(_ATexture, IN.uv_RTexture);

			float4 color;
			color = lerp(rTexData, gTexData, blendData.g);
			color = lerp(color, bTexData, blendData.b);
			color = lerp(color, aTexData, blendData.a);
			color.a = 1.0;

			float4 terrainLayers = lerp(_ColorA, _ColorB, blendData.r);
			color *= terrainLayers;
			color = saturate(color);

			o.Albedo = color.rgb * _MainTint.rgb;
			o.Alpha = color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
