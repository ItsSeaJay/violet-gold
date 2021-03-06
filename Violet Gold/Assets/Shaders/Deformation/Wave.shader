﻿Shader "Deformation/Wave"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Magnitude ("Magnitude", Vector) = (1, 1, 0, 0)
		_Speed ("Speed", Vector) = (1, 1, 0, 0)
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Magnitude;
			float4 _Speed;
			
			v2f vert (appdata v)
			{
				// Convert the object to a series of floating-point values
				v2f o;

				// Obtain the object's world space as a float3
				float3 WorldSpace = mul(unity_ObjectToWorld, v.vertex).xyz;

				// Get the position of the vertex store it
				o.vertex = UnityObjectToClipPos(v.vertex);

				// Deform the mesh in a wave pattern on the XZ plane
				o.vertex.x += sin((_Time.w * _Speed.x)) * _Magnitude.x;
				o.vertex.y += sin(WorldSpace.x + (_Time.w * _Speed.y)) * _Magnitude.y;

				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);

				return col;
			}
			ENDCG
		}
	}
}
