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
      let resumeButton = buildResumeButton()
      resumeButton.position = node.position.applying(CGAffineTransform(translationX: 0, y: 100))
      gameScene.addChild(resumeButton)
    }

    gameScene.gamePause()
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    let resumeButton = gameScene.childNode(withName: ButtonIdentifier.resume.rawValue) as? ButtonNode
    resumeButton?.removeFromParent()
    
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
  func buildResumeButton() -> ButtonNode {
    let resumeButton = ButtonNode(imageNamed: "Resume")
    resumeButton.name = ButtonIdentifier.resume.rawValue
    resumeButton.isUserInteractionEnabled = true
    return resumeButton
  }
}
