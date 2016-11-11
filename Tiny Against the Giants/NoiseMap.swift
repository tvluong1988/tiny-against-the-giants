//
//  NoiseMap.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/10/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

func getPerlinNoiseMap(frequency: Double) -> GKNoiseMap {
  let noise = getPerlinNoise(frequency: frequency)
  return GKNoiseMap(noise)
}

func getPerlinNoise(frequency: Double, octaveCount: Int = 6, persistence: Double = 0.5, lacunarity: Double = 2.0) -> GKNoise {
  let seed: Int32 = Int32(GKRandomSource.sharedRandom().nextInt())
  let noiseSource = GKPerlinNoiseSource(frequency: frequency, octaveCount: octaveCount, persistence: persistence, lacunarity: lacunarity, seed: seed)
  return GKNoise(noiseSource)
}

func getCheckerboardNoiseMap(squareSize: Double) -> GKNoiseMap {
  let noise = getCheckerboardNoise(squareSize: squareSize)
  return GKNoiseMap(noise)
}

func getCheckerboardNoise(squareSize: Double) -> GKNoise {
  let noiseSource = GKCheckerboardNoiseSource(squareSize: squareSize)
  return GKNoise(noiseSource)
}

func getCheckerboardPerlinNoiseMap(squareSize: Double, frequency: Double) -> GKNoiseMap {
  let checkerboardNoise = getCheckerboardNoise(squareSize: squareSize)
  let perlinNoise = getPerlinNoise(frequency: frequency)
  let combinedNoise = GKNoise(componentNoises: [checkerboardNoise, perlinNoise], selectionNoise: perlinNoise)
  return GKNoiseMap(combinedNoise)
}

