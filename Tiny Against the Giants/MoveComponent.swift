//
//  MoveComponent.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/13/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class MoveComponent: GKAgent2D {
  // MARK: Functions
  override func update(deltaTime seconds: TimeInterval) {
    super.update(deltaTime: seconds)
    
    guard let entity = entity, let teamComponent = entity.component(ofType: TeamComponent.self) else {
      return
    }
    
    let enemyTeam = teamComponent.team.oppositeTeam()
    guard let enemyMoveComponent = closestMoveComponentForTeam(team: enemyTeam), enemyTeam == .Team1 else {
      return
    }
    
    let alliedMoveComponents = entityManager.moveComponentsForTeam(team: teamComponent.team)
    
    behavior = MoveBehavior(targetSpeed: maxSpeed, seek: enemyMoveComponent, avoid: alliedMoveComponents)
  }
  
  // MARK: Lifecycle
  init(maxSpeed: Float, maxAcceleration: Float, radius: Float, entityManager: EntityManager) {
    self.entityManager = entityManager
    super.init()
    
    delegate = self
    
    self.maxSpeed = maxSpeed
    self.maxAcceleration = maxAcceleration
    self.radius = radius
    self.mass = 1.0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let entityManager: EntityManager
}

extension MoveComponent {
  func closestMoveComponentForTeam(team: Team) -> GKAgent2D? {
    var closestMoveComponent: MoveComponent?
    var closestDistance = CGFloat(0)
    
    let moveComponents = entityManager.moveComponentsForTeam(team: team)
    for moveComponent in moveComponents {
      let distance = (CGPoint(moveComponent.position) - CGPoint(position)).length()
      if closestMoveComponent == nil || distance < closestDistance {
        closestMoveComponent = moveComponent
        closestDistance = distance
      }
    }
    
    return closestMoveComponent
  }
}

extension MoveComponent: GKAgentDelegate {
  func agentWillUpdate(_ agent: GKAgent) {
    guard let node = entity?.component(ofType: RenderComponent.self)?.node else {
      return
    }
    
    self.position = float2(node.position)
  }
  
  func agentDidUpdate(_ agent: GKAgent) {
    guard let node = entity?.component(ofType: RenderComponent.self)?.node else {
      return
    }
    
    node.position = CGPoint(position)
  }
}
