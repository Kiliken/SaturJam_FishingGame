Shader "Custom/VoronoiTest" {
    Properties {
		_CellSize ("Cell Size", Range(0, 2)) = 2
		_BorderColor ("Border Color", Color) = (0,0,0,1)
		_TimeScale ("Scrolling Speed", Range(0, 2)) = 1
	}
	SubShader {
		Tags{ "RenderType"="Opaque" "Queue"="Geometry"}

		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		#include "UnityCG.cginc"

		float _CellSize;
		float _TimeScale;
		float3 _BorderColor;

		struct Input {
			float3 worldPos;
		};

        float rand3dTo1d(float3 p) {
            return frac(sin(dot(p, float3(12.9898, 78.233, 37.719))) * 43758.5453);
        }

        float3 rand1dTo3d(float x) {
            float3 seed = float3(
                dot(float2(x, x), float2(127.1, 311.7)),
                dot(float2(x, x), float2(269.5, 183.3)),
                dot(float2(x, x), float2(419.2, 371.9))
            );
            return frac(sin(seed) * 43758.5453);
        }

        float3 rand3dTo3d(float3 p) {
            float3 seed = float3(
                dot(p, float3(127.1, 311.7, 74.7)),
                dot(p, float3(269.5, 183.3, 246.1)),
                dot(p, float3(113.5, 271.9, 124.6))
            );
            return frac(sin(seed) * 43758.5453);
        }

		float3 voronoiNoise(float3 value){
			float3 baseCell = floor(value);

			//first pass to find the closest cell
			float minDistToCell = 10;
			float3 toClosestCell;
			float3 closestCell;
			[unroll]
			for(int x1=-1; x1<=1; x1++){
				[unroll]
				for(int y1=-1; y1<=1; y1++){
					[unroll]
					for(int z1=-1; z1<=1; z1++){
						float3 cell = baseCell + float3(x1, y1, z1);
						float3 cellPosition = cell + rand3dTo3d(cell);
						float3 toCell = cellPosition - value;
						float distToCell = length(toCell);
						if(distToCell < minDistToCell){
							minDistToCell = distToCell;
							closestCell = cell;
							toClosestCell = toCell;
						}
					}
				}
			}

			//second pass to find the distance to the closest edge
			float minEdgeDistance = 10;
			[unroll]
			for(int x2=-1; x2<=1; x2++){
				[unroll]
				for(int y2=-1; y2<=1; y2++){
					[unroll]
					for(int z2=-1; z2<=1; z2++){
						float3 cell = baseCell + float3(x2, y2, z2);
						float3 cellPosition = cell + rand3dTo3d(cell);
						float3 toCell = cellPosition - value;

						float3 diffToClosestCell = abs(closestCell - cell);
						bool isClosestCell = diffToClosestCell.x + diffToClosestCell.y + diffToClosestCell.z < 0.1;
						if(!isClosestCell){
							float3 toCenter = (toClosestCell + toCell) * 0.5;
							float3 cellDifference = normalize(toCell - toClosestCell);
							float edgeDistance = dot(toCenter, cellDifference);
							minEdgeDistance = min(minEdgeDistance, edgeDistance);
						}
					}
				}
			}

			float random = rand3dTo1d(closestCell);
    		return float3(minDistToCell, random, minEdgeDistance);
		}

		void surf (Input i, inout SurfaceOutputStandard o) {
			float3 value = i.worldPos.xyz / _CellSize;
			value.y += _Time.y * _TimeScale;
			float3 noise = voronoiNoise(value);

			float3 cellColor = rand1dTo3d(noise.y); 
			float valueChange = fwidth(value.z) * 0.5;
			float isBorder = 1 - smoothstep(0.05 - valueChange, 0.05 + valueChange, noise.z);
			float3 color = lerp(cellColor, _BorderColor, isBorder);
			o.Albedo = color;
		}
		ENDCG
	}
	FallBack "Standard"
}