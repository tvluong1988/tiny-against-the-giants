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
    
    lastUpdateTime = 0
    landBackground = getLandBackground()
    landBackground.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: landBackground))
    landBackground.physicsBody?.isDynamic = false
    addChild(landBackground)
  }
  
  func getPhysicsBodiesFromTileMapNode(tileMapNode: SKTileMapNode) -> [SKPhysicsBody] {
    var physicsBodies = [SKPhysicsBody]()
    
    for column in 0..<tileMapNode.numberOfColumns {
      for row in 0..<tileMapNode.numberOfRows {
        if let tileDefinition = tileMapNode.tileDefinition(atColumn: column, row: row) {
          var tileDefinitionPhysicsBody: SKPhysicsBody?
          
          switch tileDefinition.name! {
          case "BottomCenter":
            tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 1, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: 0, y: tileDefinition.size.height * 0.25)))
          case "TopCenter":
            tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 1, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: 0, y: -tileDefinition.size.height * 0.25)))
          case "CenterLeft":
            tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 1)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: tileDefinition.size.height * 0.25, y: 0)))
          case "CenterRight":
            tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 1)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: -tileDefinition.size.height * 0.25, y: 0)))
          case "TopLeft":
            tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: tileDefinition.size.height * 0.25, y: -tileDefinition.size.height * 0.25)))
          case "TopRight":
            tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: -tileDefinition.size.height * 0.25, y: -tileDefinition.size.height * 0.25)))
          case "BottomLeft":
            tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: tileDefinition.size.height * 0.25, y: tileDefinition.size.height * 0.25)))
          case "BottomRight":
            tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: -tileDefinition.size.height * 0.25, y: tileDefinition.size.height * 0.25)))
          case "BottomRightCorner":
            let rightPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: tileDefinition.size.height * 0.25, y: tileDefinition.size.height * 0.25)))
            let bottomPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: -tileDefinition.size.height * 0.25, y: -tileDefinition.size.height * 0.25)))
            tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [rightPhysicsBody, bottomPhysicsBody])
          case "BottomLeftCorner":
            let leftPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: -tileDefinition.size.height * 0.25, y: tileDefinition.size.height * 0.25)))
            let bottomPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: tileDefinition.size.height * 0.25, y: -tileDefinition.size.height * 0.25)))
            tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [leftPhysicsBody, bottomPhysicsBody])
          case "TopLeftCorner":
            let leftPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: -tileDefinition.size.height * 0.25, y: -tileDefinition.size.height * 0.25)))
            let topPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: tileDefinition.size.height * 0.25, y: tileDefinition.size.height * 0.25)))
            tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [leftPhysicsBody, topPhysicsBody])
          case "TopRightCorner":
            let rightPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: tileDefinition.size.height * 0.25, y: -tileDefinition.size.height * 0.25)))
            let topPhysicsBody = SKPhysicsBody(rectangleOf: tileDefinition.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)), center: tileMapNode.centerOfTile(atColumn: column, row: row).applying(CGAffineTransform(translationX: -tileDefinition.size.height * 0.25, y: tileDefinition.size.height * 0.25)))
            tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [rightPhysicsBody, topPhysicsBody])
          default:
            break
          }
          
          if let physicsBody = tileDefinitionPhysicsBody {
            physicsBodies.append(physicsBody)
          }
        }
      }
    }
    
    return physicsBodies
  }
  
  
  func getPerlinNoiseMap(frequency: Double, octaveCount: Int = 6, persistence: Double = 0.5, lacunarity: Double = 2.0) -> GKNoiseMap {
    let seed: Int32 = Int32(GKRandomSource.sharedRandom().nextInt())
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

      let noiseMap = getPerlinNoiseMap(frequency: 10)
      
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    landBackground.removeFromParent()
    landBackground = getLandBackground()
    landBackground.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: landBackground))
    landBackground.physicsBody?.isDynamic = false
    addChild(landBackground)
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
