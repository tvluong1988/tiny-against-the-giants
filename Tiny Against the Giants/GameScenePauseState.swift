//
//  GameScenePauseState.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/27/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class GameScenePauseState: GKState {
  // MARK: State
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    if let entity = gameScene.entityManager.getPlayerEntity(),
      let node = entity.component(ofType: RenderComponent.self)?.node {
      let pauseButton = buildPauseButton()
      pauseButton.position = node.position.applying(CGAffineTransform(translationX: 0, y: 100))
      gameScene.addChild(pauseButton)
    }

    gameScene.gamePause()
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    let pauseButton = gameScene.childNode(withName: ButtonIdentifier.resume.rawValue) as? ButtonNode
    pauseButton?.removeFromParent()
    
    gameScene.gameResume()
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameSceneActiveState.Type
  }

  // MARK: Lifecycle
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    super.init()
  }
  
  // MARK: Properties
  unowned let gameScene: GameScene
}

extension GameScenePauseState {
  func buildPauseButton() -> ButtonNode {
    let pauseButton = ButtonNode(color: UIColor.purple, size: CGSize(width: 50, height: 50))
    pauseButton.name = "resume"
    pauseButton.isUserInteractionEnabled = true
    return pauseButton
  }
}
