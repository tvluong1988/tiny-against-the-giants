//
//  GameSceneActiveState.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/20/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class GameSceneActiveState: GKState {
  // MARK: States
  
  override func update(deltaTime seconds: TimeInterval) {
    super.update(deltaTime: seconds)
    
    time += seconds
    gameScene.timerNode.text = "Still Alive \(timeString)"
    
    if let playerEntity = gameScene.entityManager.entitiesForTeam(team: .Team1).first,
      let percentageCharge = playerEntity.component(ofType: ChargeBarComponent.self)?.percentageCharge,
      percentageCharge.isZero
      {
      stateMachine?.enter(GameSceneFailState.self)
    }
  }
  
  // MARK: Lifecycle
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    super.init()
  }

  // MARK: Properties
  unowned let gameScene: GameScene
  var time: TimeInterval = 0.0
  
  let timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    
    return formatter
  }()
  
  var timeString: String {
    let components = NSDateComponents()
    components.second = Int(max(0.0, time))
    
    return timeFormatter.string(from: components as DateComponents)!
  }
}
