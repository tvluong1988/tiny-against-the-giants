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

  var ball: SKSpriteNode!
  var cam: SKCameraNode!
  
  override func sceneDidLoad() {
    physicsWorld.gravity = CGVector(dx: 0, dy: -1.0)
    lastUpdateTime = 0
    addTileMap()
    addBall()
    addCamera()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    resetTileMap()
    resetBall()
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

fileprivate extension GameScene {
  func addCamera() {
    cam = SKCameraNode()
    cam.position = ball.position
    self.camera = cam
    addChild(cam)
  }
  
  func addTileMap() {
    landBackground = getLandBackground()
    landBackground.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: landBackground))
    landBackground.physicsBody?.isDynamic = false
    addChild(landBackground)
  }
  
  func addBall() {
    ball = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30))
    
    let column = GKRandomSource.sharedRandom().nextInt(upperBound: landBackground.numberOfColumns)
    let row = GKRandomSource.sharedRandom().nextInt(upperBound: landBackground.numberOfRows)
    ball.position = landBackground.centerOfTile(atColumn: column, row: row)
    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height * 0.5)
    ball.physicsBody?.isDynamic = true
    addChild(ball)
    ball.physicsBody?.applyForce(CGVector(dx: 100, dy: -100))
  }
  
  func resetTileMap() {
    if landBackground.parent != nil {
      landBackground.removeFromParent()
      landBackground = nil
    }
    
    addTileMap()
  }
  
  func resetBall() {
    if ball.parent != nil {
      ball.removeFromParent()
      ball = nil
    }
    
    addBall()
  }
}
