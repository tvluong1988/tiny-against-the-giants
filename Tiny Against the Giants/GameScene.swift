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
  let timerNode = SKLabelNode(text: "Still Alive?")
  
  private var lastUpdateTime: TimeInterval = 0
  private let giantSpawnCooldown: TimeInterval = 3
  private var giantSpawnTime: TimeInterval = 0
  private var oneSecondTimer: TimeInterval = 1
  private var aliveTime: Int = 0
  private let maxGiantCount = 5
  var currentGiantCount = 0
  
  override func sceneDidLoad() {
    super.sceneDidLoad()
    
    physicsWorld.contactDelegate = self
    
    entityManager = EntityManager(scene: self)
    physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    addTileMaps()
    addNextTileMap()
    addBall()
    addCamera()
    
    lastUpdateTime = 0
  }
  
  override func didMove(to view: SKView) {
    timerNode.horizontalAlignmentMode = .center
    timerNode.verticalAlignmentMode = .top
    timerNode.position.y = size.height / 2
    timerNode.fontSize = 50
    cam.addChild(timerNode)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let touchLocation = touch.location(in: self.view)
      let previousTouchLocation = touch.previousLocation(in: self.view)
      
      if let ball = entityManager.entitiesForTeam(team: .Team1).first, let node = ball.component(ofType: RenderComponent.self)?.node {
        let change = touchLocation - previousTouchLocation
        let changeNormalized = change.normalized()
        let vector = CGVector(dx: 30 * changeNormalized.x, dy: -30 * changeNormalized.y)
        node.physicsBody?.applyForce(vector)
      }
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    if !cam.contains(currentLandBackground) {
      previousLandBackground.removeFromParent()
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
    
    giantSpawnTime -= deltaTime
    if giantSpawnTime < 0 && currentGiantCount < maxGiantCount {
      addGiant()
      giantSpawnTime = giantSpawnCooldown
    }
    
    oneSecondTimer -= deltaTime
    if oneSecondTimer < 0 {
      aliveTime += 1
      timerNode.text = "Still Alive: \(aliveTime) seconds"
      oneSecondTimer = 1
    }
    
    // Update entities
    entityManager.update(deltaTime: deltaTime)
    
    lastUpdateTime = currentTime

  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    handleContact(contact: contact) {contactNotifiable, otherEntity in
      contactNotifiable.contactWithEntityDidBegin(otherEntity)
    }
  }
  
  func didEnd(_ contact: SKPhysicsContact) {
    handleContact(contact: contact) {contactNotifiable, otherEntity in
      contactNotifiable.contactWithEntityDidEnd(otherEntity)
    }
  }
  
  private func handleContact(contact: SKPhysicsContact, contactCallBack: (ContactNotifiable, GKEntity) -> Void) {
    let colliderTypeA = ColliderType(rawValue: contact.bodyA.categoryBitMask)
    let colliderTypeB = ColliderType(rawValue: contact.bodyB.categoryBitMask)
    
    let aWantsCallBack = colliderTypeA.notifyOnContactWith(colliderTypeB)
    let bWantsCallBack = colliderTypeB.notifyOnContactWith(colliderTypeA)
    
    let entityA = contact.bodyA.node?.entity
    let entityB = contact.bodyB.node?.entity
    
    if let notifiableEntity = entityA as? ContactNotifiable, let otherEntity = entityB, aWantsCallBack {
      contactCallBack(notifiableEntity, otherEntity)
    }
    
    if let notifiableEntity = entityB as? ContactNotifiable, let otherEntity = entityA, bWantsCallBack {
      contactCallBack(notifiableEntity, otherEntity)
    }

  }
}

fileprivate extension GameScene {
  func addNextTileMap() {
    nextLandBackground = getTileMap()
    addChild(nextLandBackground)
    
    nextLandBackground.position.y = currentLandBackground.frame.minY
  }
  
  func addCamera() {
    cam = SKCameraNode()
    
    if let ball = entityManager.entitiesForTeam(team: .Team1).first, let spriteNode = ball.component(ofType: SpriteComponent.self)?.node {
      let constraint = SKConstraint.distance(SKRange(constantValue: 0), to: spriteNode)
      cam.constraints = [constraint]
    }
    
    self.camera = cam
    addChild(cam)
  }
  
  func addTileMaps() {
    previousLandBackground = getTileMap()
    addChild(previousLandBackground)
    currentLandBackground = getTileMap()
    addChild(currentLandBackground)
  }
  
  func getTileMap() -> SKTileMapNode? {
    var tileMap: SKTileMapNode!
    tileMap = getLandBackground()
    tileMap.anchorPoint = CGPoint(x: 0, y: 1)
    tileMap.position = CGPoint.zero
    tileMap.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: tileMap))
    ColliderType.definedCollisions = [.Obstacle: []]
    tileMap.physicsBody?.categoryBitMask = ColliderType.Obstacle.categoryMask
    tileMap.physicsBody?.collisionBitMask = ColliderType.Obstacle.collisionMask
    tileMap.physicsBody?.isDynamic = false
  
    return tileMap
  }
  
  func addBall() {
    let ball = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 30, height: 30))
    let tiny = Tiny(node: ball, team: .Team1, entityManager: entityManager)
    if let node  = tiny.component(ofType: RenderComponent.self)?.node {
      node.position = getRandomPositionNotOnTileGroupInTileMap(tileMap: currentLandBackground, scene: self)
    }
    entityManager.add(entity: tiny)
  }
  
  func addGiant() {
    let giantNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 60, height: 60))
    let giant = Giant(node: giantNode, team: .Team2, entityManager: entityManager)
    if let node  = giant.component(ofType: RenderComponent.self)?.node {
      node.position = getRandomPositionNotOnTileGroupInTileMap(tileMap: currentLandBackground, scene: self)
    }
    entityManager.add(entity: giant)
    
    currentGiantCount += 1
  }
}
