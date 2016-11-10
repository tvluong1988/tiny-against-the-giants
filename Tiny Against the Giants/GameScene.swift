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
  var landBackground2: SKTileMapNode!
  var landBackground3: SKTileMapNode!

  var ball: SKSpriteNode!
  var cam: SKCameraNode!
  
  override func sceneDidLoad() {
    physicsWorld.gravity = CGVector(dx: 0, dy: -1.0)
    lastUpdateTime = 0
    landBackground = getLandBackground()
    landBackground.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: landBackground))
    landBackground.physicsBody?.isDynamic = false
    addChild(landBackground)
    
    landBackground2 = getLandBackground()
    landBackground2.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: landBackground2))
    landBackground2.physicsBody?.isDynamic = false
    landBackground2.position = CGPoint(x: landBackground.frame.midX, y: landBackground.frame.midY - landBackground.frame.height)
    addChild(landBackground2)
    
    ball = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30))
    ball.position = CGPoint.zero
    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height * 0.5)
    ball.physicsBody?.isDynamic = true
    addChild(ball)
    ball.physicsBody?.applyForce(CGVector(dx: 100, dy: -100))
    
    cam = SKCameraNode()
    cam.position = ball.position
    self.camera = cam
    addChild(cam)
  }
  
  func getPhysicsBodyFromTileDefinition(tileDefinition: SKTileDefinition, center: CGPoint) -> SKPhysicsBody? {
    var tileDefinitionPhysicsBody: SKPhysicsBody?
    
    let tileSize = tileDefinition.size
    let tileTranslation = tileSize.height * 0.25
    let scaleYHalfTransform = CGAffineTransform(scaleX: 1.0, y: 0.5)
    let scaleXHalfTransform = CGAffineTransform(scaleX: 0.5, y: 1.0)
    let scaleByHalfTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)

    
    switch tileDefinition.name! {
    case "CenterCenter":
      tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize, center: center)
    case "BottomCenter":
      tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleYHalfTransform), center: center.applying(CGAffineTransform(translationX: 0, y: tileTranslation)))
    case "TopCenter":
      tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleYHalfTransform), center: center.applying(CGAffineTransform(translationX: 0, y: -tileTranslation)))
    case "CenterLeft":
      tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleXHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: 0)))
    case "CenterRight":
      tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleXHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: 0)))
    case "TopLeft":
      tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: -tileTranslation)))
    case "TopRight":
      tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: -tileTranslation)))
    case "BottomLeft":
      tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: tileTranslation)))
    case "BottomRight":
      tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: tileTranslation)))
    case "BottomRightCorner":
      let rightPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: tileTranslation)))
      let bottomPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: -tileTranslation)))
      tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [rightPhysicsBody, bottomPhysicsBody])
    case "BottomLeftCorner":
      let leftPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: tileTranslation)))
      let bottomPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: -tileTranslation)))
      tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [leftPhysicsBody, bottomPhysicsBody])
    case "TopLeftCorner":
      let leftPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: -tileTranslation)))
      let topPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: tileTranslation)))
      tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [leftPhysicsBody, topPhysicsBody])
    case "TopRightCorner":
      let rightPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: -tileTranslation)))
      let topPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: tileTranslation)))
      tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [rightPhysicsBody, topPhysicsBody])
    default:
      break
    }
    
    return tileDefinitionPhysicsBody
  }
  
  func getPhysicsBodiesFromTileMapNode(tileMapNode: SKTileMapNode) -> [SKPhysicsBody] {
    var physicsBodies = [SKPhysicsBody]()
    
    for column in 0..<tileMapNode.numberOfColumns {
      for row in 0..<tileMapNode.numberOfRows {
        if let tileDefinition = tileMapNode.tileDefinition(atColumn: column, row: row) {
          if let physicsBody = getPhysicsBodyFromTileDefinition(tileDefinition: tileDefinition, center: tileMapNode.centerOfTile(atColumn: column, row: row)) {
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
    landBackground = nil
    landBackground = getLandBackground()
    landBackground.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: landBackground))
    landBackground.physicsBody?.isDynamic = false
    addChild(landBackground)
    
    landBackground2.removeFromParent()
    landBackground2 = nil
    landBackground2 = getLandBackground()
    landBackground2.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: landBackground2))
    landBackground2.physicsBody?.isDynamic = false
    landBackground2.position = CGPoint(x: landBackground.frame.midX, y: landBackground.frame.midY - landBackground.frame.height)
    addChild(landBackground2)
    
    ball.removeFromParent()
    ball = nil
    ball = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30))
    
    let column = GKRandomSource.sharedRandom().nextInt(upperBound: landBackground.numberOfColumns)
    let row = GKRandomSource.sharedRandom().nextInt(upperBound: landBackground.numberOfRows)
    ball.position = landBackground.centerOfTile(atColumn: column, row: row)
    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height * 0.5)
    ball.physicsBody?.isDynamic = true
    addChild(ball)
    ball.physicsBody?.applyForce(CGVector(dx: 100, dy: -100))
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    
    cam.position = ball.position
    
    // Initialize _lastUpdateTime if it has not already been
    if lastUpdateTime == 0 {
      lastUpdateTime = currentTime
    }
    
    // Calculate time since last update
    let dt = currentTime - lastUpdateTime
    
    // Update entities
    for entity in entities {
      entity.update(deltaTime: dt)
    }
    
    lastUpdateTime = currentTime
  }
}
