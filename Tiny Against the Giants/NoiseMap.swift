//
//  NoiseMap.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/10/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

func getPerlinNoiseMap(frequency: Double, octaveCount: Int = 6, persistence: Double = 0.5, lacunarity: Double = 2.0) -> GKNoiseMap {
  let seed: Int32 = Int32(GKRandomSource.sharedRandom().nextInt())
  let noiseSource = GKPerlinNoiseSource(frequency: frequency, octaveCount: octaveCount, persistence: persistence, lacunarity: lacunarity, seed: seed)
  let noise = GKNoise(noiseSource)
  let noiseMap = GKNoiseMap(noise)
  
  return noiseMap
}
