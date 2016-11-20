//
//  Tiny.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/13/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class Tiny: GKEntity {
  // MARK: Lifecycle
  init(node: SKSpriteNode, team: Team, entityManager: EntityManager) {
    self.team = team
    super.init()
    let renderComponent = RenderComponent()
    addComponent(renderComponent)
    
    let spriteComponent = SpriteComponent(node: node)
    renderComponent.node.addChild(spriteComponent.node)
    addComponent(spriteComponent)
    
    let physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
    physicsBody.allowsRotation = false
    ColliderType.definedCollisions = [.Player: [.Enemy, .Obstacle]]
    ColliderType.requestedContactNotifications = [.Player: [.Enemy]]
    let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .Player)
    renderComponent.node.physicsBody = physicsComponent.physicsBody
    addComponent(physicsComponent)
    
    addComponent(chargeBarComponent)
    
    addComponent(TeamComponent(team: team))
    addComponent(MoveComponent(maxSpeed: 150, maxAcceleration: 5, radius: Float(node.size.width * 0.3), entityManager: entityManager))
    addComponent(ParticleComponent(particleEffect: SKEmitterNode(fileNamed: "Magic")!))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let chargeBarComponent = ChargeBarComponent(charge: 100, maxCharge: 100, displayChargeBar: true)
  let team: Team
}

extension Tiny: ContactNotifiable {
  func contactWithEntityDidBegin(_ entity: GKEntity) {
    if entity.component(ofType: TeamComponent.self)?.team == team.oppositeTeam() {
      chargeBarComponent.loseCharge(chargeToLose: 5)
    }
  }
  
  func contactWithEntityDidEnd(_ entity: GKEntity) {
    
  }
}
