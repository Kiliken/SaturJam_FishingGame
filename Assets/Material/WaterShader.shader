Shader "Custom/WaterShader" {
	Properties {
		_CellSize ("Cell Size", Range(0, 2)) = 2
	}
	SubShader {
		Tags{ "RenderType"="Opaque" "Queue"="Geometry"}

		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

        #include "UnityCG.cginc"

		float _CellSize;

		struct Input {
			float3 worldPos;
		};

        float2 rand2dTo2d(float2 uv) {
            float2 seed = float2(
                dot(uv, float2(127.1, 311.7)),
                dot(uv, float2(269.5, 183.3))
            );
            return frac(sin(seed) * 43758.5453);
        }

		float voronoiNoise(float2 value){
            float2 baseCell = floor(value);

            float minDistToCell = 10;
            [unroll]
            for(int x=-1; x<=1; x++){
                [unroll]
                for(int y=-1; y<=1; y++){
                    float2 cell = baseCell + float2(x, y);
                    float2 cellPosition = cell + rand2dTo2d(cell);
                    float2 toCell = cellPosition - value;
                    float distToCell = length(toCell);
                    if(distToCell < minDistToCell){
                        minDistToCell = distToCell;
                    }
                }
            }
            return minDistToCell;
        }

		void surf (Input i, inout SurfaceOutputStandard o) {
			float2 value = i.worldPos.xz / _CellSize;
			float noise = voronoiNoise(value);

			o.Albedo = noise;
		}
        
        ENDCG
	}
	FallBack "Standard"
}