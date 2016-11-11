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
  
  var previousLandBackground: SKTileMapNode!
  var nextLandBackground: SKTileMapNode!
  var currentLandBackground: SKTileMapNode!
  var ball: SKSpriteNode!
  var cam: SKCameraNode!
  
  override func sceneDidLoad() {
    physicsWorld.gravity = CGVector(dx: 0, dy: -1.0)
    lastUpdateTime = 0
    addTileMap()
    addNextTileMap()
    addBall()
    addCamera()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let touchLocation = touch.location(in: self.view)
      let previousTouchLocation = touch.previousLocation(in: self.view)
      
      let xDirection = touchLocation.x - previousTouchLocation.x
      if xDirection < 0 {
        ball.physicsBody?.applyForce(CGVector(dx: -50, dy: 0))
      } else {
        ball.physicsBody?.applyForce(CGVector(dx: 50, dy: 0))
      }
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    
    cam.position = ball.position
    
    if !cam.contains(currentLandBackground) {
      previousLandBackground = currentLandBackground
      currentLandBackground = nextLandBackground
      addNextTileMap()
    }
    
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
  func translateTileMap() {
    resetTileMap()
    currentLandBackground.position.y = -currentLandBackground.frame.height
  }
  
  func addNextTileMap() {
    nextLandBackground = getLandBackground()
    nextLandBackground.anchorPoint = CGPoint(x: 0, y: 1)
    nextLandBackground.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: nextLandBackground))
    nextLandBackground.physicsBody?.isDynamic = false
    addChild(nextLandBackground)
    
    nextLandBackground.position.y = currentLandBackground.frame.minY
  }
  
  func addCamera() {
    cam = SKCameraNode()
    cam.position = ball.position
    self.camera = cam
    addChild(cam)
  }
  
  func addTileMap() {
    currentLandBackground = getLandBackground()
    currentLandBackground.anchorPoint = CGPoint(x: 0, y: 1)
    currentLandBackground.position = CGPoint.zero
    currentLandBackground.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: currentLandBackground))
    currentLandBackground.physicsBody?.isDynamic = false
    addChild(currentLandBackground)
  }
  
  func addBall() {
    ball = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30))
    
    let column = GKRandomSource.sharedRandom().nextInt(upperBound: currentLandBackground.numberOfColumns)
    let row = GKRandomSource.sharedRandom().nextInt(upperBound: currentLandBackground.numberOfRows)
    ball.position = currentLandBackground.centerOfTile(atColumn: column, row: row)
    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height * 0.5)
    ball.physicsBody?.isDynamic = true
    addChild(ball)
    ball.physicsBody?.applyForce(CGVector(dx: 100, dy: -100))
  }
  
  func resetTileMap() {
    if currentLandBackground.parent != nil {
      currentLandBackground.removeFromParent()
      currentLandBackground = nil
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
