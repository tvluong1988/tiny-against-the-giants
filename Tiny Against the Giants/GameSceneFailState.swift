//
//  GameSceneFailState.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/20/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class GameSceneFailState: GKState {
  // MARK: State
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    
    gameScene.timerNode.text = "You Ded!!!!"
    if let playerEntity = gameScene.entityManager.getPlayerEntity(),
      let physicBody = playerEntity.component(ofType: PhysicsComponent.self)?.physicsBody {
        physicBody.isDynamic = false
    }
  
    
    if let entity = gameScene.entityManager.getPlayerEntity(),
      let node = entity.component(ofType: RenderComponent.self)?.node {
      let retryButton = buildRetryButton()
      retryButton.position = node.position.applying(CGAffineTransform(translationX: 0, y: 100))
      gameScene.addChild(retryButton)
    }

  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    let retryButton = gameScene.childNode(withName: ButtonIdentifier.retry.rawValue) as? ButtonNode
    retryButton?.removeFromParent()
  }
  
  // MARK: Lifecycle
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    super.init()
  }
  
  // MARK: Properties
  unowned let gameScene: GameScene
}

extension GameSceneFailState {
  func buildRetryButton() -> ButtonNode {
    let retryButton = ButtonNode(color: UIColor.blue, size: CGSize(width: 80, height: 80))
    retryButton.name = "retry"
    retryButton.isUserInteractionEnabled = true
    return retryButton
  }
}
