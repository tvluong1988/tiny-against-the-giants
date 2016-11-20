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
    if let playerEntity = gameScene.entityManager.entitiesForTeam(team: .Team1).first,
      let physicBody = playerEntity.component(ofType: PhysicsComponent.self)?.physicsBody {
        physicBody.isDynamic = false
    }
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    if let playerEntity = gameScene.entityManager.entitiesForTeam(team: .Team1).first,
      let physicBody = playerEntity.component(ofType: PhysicsComponent.self)?.physicsBody {
      physicBody.isDynamic = true
    }
  }
  
  // MARK: Lifecycle
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    super.init()
  }
  
  // MARK: Properties
  unowned let gameScene: GameScene}
