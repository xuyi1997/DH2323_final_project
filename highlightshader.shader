Shader "Unlit/highlightshader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}

	}
		SubShader
	{

		Pass
	{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#include "AutoLight.cginc"




		struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
		float3 normal : NORMAL;
	};

	struct v2f
	{
		float2 uv : TEXCOORD0;
		float4 vertex : SV_POSITION;
		float3 normalDir : TEXCOORD1;
	};

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		o.normalDir = UnityObjectToWorldNormal(v.normal);
		return o;
	}

	sampler2D _MainTex;

	fixed4 frag(v2f i) : SV_Target
	{
		float3 normalDirection = normalize(i.normalDir);
		float4 v = i.vertex;
		float s = 3;//"shininess" factor
		float3 r = reflect(normalize(WorldSpaceLightDir(v)), normalDirection);//reflection vector
		//The horizontal axis of the 2D texture derived from stanard lambertian shading computation n.l
		float f1 = max(dot(normalize(WorldSpaceLightDir(v)), normalDirection), 0.005);
		//dot product with the view vector and light reflection vector, with an exponent s
		float f2 = clamp(pow(abs(dot(r, normalize(-v.xyz))), s), 0.005, 0.995);
		//accoding to the axis, find the color of the point in the 2D texture image.
		float3 texColor = tex2D(_MainTex, float2(f1, 1. - f2)).rgb;
		float4 finalColor = float4(texColor,1);
		return finalColor;
	}
		ENDCG
	}
	}
}