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
  
  weak var gameSceneDelegate: GameSceneDelegate?
  
  var entityManager: EntityManager!
  lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
    GameSceneActiveState(gameScene: self),
    GameSceneFailState(gameScene: self),
    GameScenePauseState(gameScene: self)
  ])
  
  var worldNode = SKNode()
  var previousLandBackground: SKTileMapNode!
  var nextLandBackground: SKTileMapNode!
  var currentLandBackground: SKTileMapNode!
  var previousSandBackground: SKTileMapNode!
  var currentSandBackground: SKTileMapNode!
  var nextSandBackground: SKTileMapNode!

  var cam: SKCameraNode!
  let timerNode = SKLabelNode()
  let pauseButton = ButtonNode(imageNamed: "Pause")
  
  private var lastUpdateTime: TimeInterval = 0
  private let giantSpawnCooldown: TimeInterval = 2
  private var giantSpawnTime: TimeInterval = 0
  private let maxGiantCount = 10
  var currentGiantCount = 0
  
  override func sceneDidLoad() {
    super.sceneDidLoad()
    
    physicsWorld.contactDelegate = self
    
    entityManager = EntityManager(scene: self)
    
    worldNode.name = "world"
    addChild(worldNode)
    physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    addSandTileMaps()
    addNextSandTileMap()
    addTileMaps()
    addNextTileMap()
    addBall()
    addCamera()
    
    lastUpdateTime = 0
    ColliderType.definedCollisions = [.Obstacle: []]
  }
  
  override func didMove(to view: SKView) {
    constraintCameraToPlayer()

    timerNode.horizontalAlignmentMode = .center
    timerNode.verticalAlignmentMode = .top
    timerNode.fontSize = 50
    timerNode.position.y = size.height / 2 - timerNode.frame.size.height / 2
    cam.addChild(timerNode)
    
    addPauseButton(view: view)
    
    stateMachine.enter(GameSceneActiveState.self)
  }
  
  override func didChangeSize(_ oldSize: CGSize) {
    super.didChangeSize(oldSize)
    timerNode.position.y = size.height / 2 - timerNode.frame.size.height / 2
    
    pauseButton.position.x = -size.width / 2
    pauseButton.position.y = size.height / 2
  }
  
  func newGame() {
    currentGiantCount = 0
    addBall()
    addGiant()
    constraintCameraToPlayer()
    stateMachine.enter(GameSceneActiveState.self)
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
    super.update(currentTime)
    
    if !cam.contains(currentLandBackground) {
      previousSandBackground.removeFromParent()
      previousSandBackground = currentSandBackground
      currentSandBackground = nextSandBackground
      addNextSandTileMap()
      
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
    lastUpdateTime = currentTime
    
    if worldNode.isPaused {
      return
    }
    
    giantSpawnTime -= deltaTime
    if giantSpawnTime < 0 && currentGiantCount < maxGiantCount {
      addGiant()
      giantSpawnTime = giantSpawnCooldown
    }
    
    // Update entities
    entityManager.update(deltaTime: deltaTime)
    
    stateMachine.update(deltaTime: deltaTime)
  }
}

extension GameScene {
  func gamePause() {
    worldNode.isPaused = true
    physicsWorld.speed = 0
  }
  
  func gameResume() {
    worldNode.isPaused = false
    physicsWorld.speed = 1.0
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
    worldNode.addChild(nextLandBackground)
    
    nextLandBackground.position.y = currentLandBackground.frame.minY
  }
  
  func addNextSandTileMap() {
    nextSandBackground = getSandTileMap()
    worldNode.addChild(nextSandBackground)
    
    nextSandBackground.position.y = currentSandBackground.frame.minY
  }
  
  func addCamera() {
    cam = SKCameraNode()
    camera = cam
    addChild(cam)
  }
  
  func constraintCameraToPlayer() {
    if let camera = camera, let ball = entityManager.getPlayerEntity(), let spriteNode = ball.component(ofType: SpriteComponent.self)?.node {
      let constraint = SKConstraint.distance(SKRange(constantValue: 0), to: spriteNode)
      
      let scaledSize = CGSize(width: size.width * camera.xScale, height: size.height * camera.yScale)
      let inset: CGFloat = 100.0
      let xLowerLimit = scaledSize.width / 2 - inset
      let xUpperLimit = currentSandBackground.mapSize.width - scaledSize.width / 2 + inset
      let xRange = SKRange(lowerLimit: xLowerLimit, upperLimit: xUpperLimit)
      
      let yUpperLimit = -scaledSize.height / 2 + inset
      let yRange = SKRange(upperLimit: yUpperLimit)
      let edgeContraint = SKConstraint.positionX(xRange, y: yRange)
      camera.constraints = [constraint, edgeContraint]
    }
  }
  
  func addTileMaps() {
    previousLandBackground = getTileMap()
    worldNode.addChild(previousLandBackground)
    currentLandBackground = getTileMap()
    worldNode.addChild(currentLandBackground)
  }
  
  func addSandTileMaps() {
    previousSandBackground = getSandTileMap()
    worldNode.addChild(previousSandBackground)
    currentSandBackground = getSandTileMap()
    worldNode.addChild(currentSandBackground)
  }
  
  func getTileMap() -> SKTileMapNode? {
    var tileMap: SKTileMapNode!
    tileMap = getLandBackground()
    tileMap.anchorPoint = CGPoint(x: 0, y: 1)
    tileMap.position = CGPoint.zero
    tileMap.physicsBody = SKPhysicsBody(bodies: getPhysicsBodiesFromTileMapNode(tileMapNode: tileMap))
    tileMap.physicsBody?.categoryBitMask = ColliderType.Obstacle.categoryMask
    tileMap.physicsBody?.collisionBitMask = ColliderType.Obstacle.collisionMask
    tileMap.physicsBody?.isDynamic = false
  
    return tileMap
  }
  
  func getSandTileMap() -> SKTileMapNode? {
    var tileMap: SKTileMapNode!
    tileMap = getSandTileMapFilled()
    tileMap.anchorPoint = CGPoint(x: 0, y: 1)
    tileMap.position = CGPoint.zero
    
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
  
  func addPauseButton(view: SKView) {
    pauseButton.isUserInteractionEnabled = true
    pauseButton.name = ButtonIdentifier.pause.rawValue
    pauseButton.anchorPoint = CGPoint(x: 0, y: 1)
    cam.addChild(pauseButton)
  }
}
