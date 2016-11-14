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
  
  var entityManager: EntityManager!
  
  var previousLandBackground: SKTileMapNode!
  var nextLandBackground: SKTileMapNode!
  var currentLandBackground: SKTileMapNode!
  var cam: SKCameraNode!
  
  private var lastUpdateTime : TimeInterval = 0
  
  override func sceneDidLoad() {
    entityManager = EntityManager(scene: self)
    physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    addTileMap()
    addNextTileMap()
    addBall()
    addGiant()
    addCamera()
    
    lastUpdateTime = 0
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let touchLocation = touch.location(in: self.view)
      let previousTouchLocation = touch.previousLocation(in: self.view)
      
      if let ball = entityManager.entitiesForTeam(team: .Team1).first, let spriteComponent = ball.component(ofType: SpriteComponent.self)?.node {
        let xDirection = touchLocation.x - previousTouchLocation.x
        if xDirection < 0 {
          spriteComponent.physicsBody?.applyForce(CGVector(dx: -50, dy: -30))
        } else {
          spriteComponent.physicsBody?.applyForce(CGVector(dx: 50, dy: -30))
        }
      }
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    if let ball = entityManager.entitiesForTeam(team: .Team1).first, let spriteComponent = ball.component(ofType: SpriteComponent.self)?.node {
      cam.position = spriteComponent.position
    }
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
    let deltaTime = currentTime - lastUpdateTime
    
    // Update entities
    entityManager.update(deltaTime: deltaTime)
    
    lastUpdateTime = currentTime

  }
}

fileprivate extension GameScene {
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
    if let ball = entityManager.entitiesForTeam(team: .Team1).first, let spriteComponent = ball.component(ofType: SpriteComponent.self)?.node {
      cam.position = spriteComponent.position
    }
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
    let ball = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30))
    ball.position = getRandomPositionInTileMap(tileMap: currentLandBackground)
    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height * 0.5)
    ball.physicsBody?.isDynamic = true
    entityManager.add(entity: Tiny(node: ball, team: .Team1, entityManager: entityManager))
  }
  
  func addGiant() {
    let giant = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 100, height: 100))
    giant.position = getRandomPositionInTileMap(tileMap: currentLandBackground)
    giant.physicsBody = SKPhysicsBody(circleOfRadius: giant.size.height * 0.5)
    giant.physicsBody?.isDynamic = true
    entityManager.add(entity: Giant(node: giant, team: .Team2, entityManager: entityManager))
  }
}
