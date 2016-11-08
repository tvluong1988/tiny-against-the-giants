//
//  GameScene.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 10/30/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  var entities = [GKEntity]()
  var graphs = [String : GKGraph]()
  
  private var lastUpdateTime : TimeInterval = 0
  
  var landBackground: SKTileMapNode!
  
  override func sceneDidLoad() {
    
    self.lastUpdateTime = 0
    self.landBackground = getLandBackground()
    self.addChild(landBackground)
  }
  
  func getPerlinNoiseMap(frequency: Double, octaveCount: Int = 6, persistence: Double = 0.5, lacunarity: Double = 2.0) -> GKNoiseMap {
    let seed: Int32 = 10
    let noiseSource = GKPerlinNoiseSource(frequency: frequency, octaveCount: octaveCount, persistence: persistence, lacunarity: lacunarity, seed: seed)
    let noise = GKNoise(noiseSource)
    let noiseMap = GKNoiseMap(noise)
    
    return noiseMap
  }
  
  func getLandBackground() -> SKTileMapNode? {
    var tileMap: SKTileMapNode?
    if let tileSet = SKTileSet(named: "BasicTile") {
      let tileSize = CGSize(width: 32, height: 32)
      tileMap = SKTileMapNode(tileSet: tileSet, columns: 42, rows: 32, tileSize: tileSize)
      tileMap?.enableAutomapping = true
      tileMap?.position = CGPoint.zero

      let noiseMap = getPerlinNoiseMap(frequency: 40)
      
      for column in stride(from: 0, to: 42, by: 1) {
        for row in stride(from: 0, to: 32, by: 1) {
          if noiseMap.value(at: vector_int2(Int32(column), Int32(row))) > 0.5 {
            tileMap?.setTileGroup(tileSet.tileGroups.first!, forColumn: column, row: row)
          }
        }
      }
    }

    return tileMap
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    
    // Initialize _lastUpdateTime if it has not already been
    if (self.lastUpdateTime == 0) {
      self.lastUpdateTime = currentTime
    }
    
    // Calculate time since last update
    let dt = currentTime - self.lastUpdateTime
    
    // Update entities
    for entity in self.entities {
      entity.update(deltaTime: dt)
    }
    
    self.lastUpdateTime = currentTime
  }
}
