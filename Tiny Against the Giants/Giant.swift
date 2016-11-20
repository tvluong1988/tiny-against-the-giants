//
//  Giant.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/13/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class Giant: GKEntity {
  // MARK: Lifecycle
  init(node: SKSpriteNode, team: Team, entityManager: EntityManager) {
    super.init()
    
    let renderComponent = RenderComponent()
    addComponent(renderComponent)
    
    let spriteComponent = SpriteComponent(node: node)
    renderComponent.node.addChild(spriteComponent.node)
    addComponent(spriteComponent)
    
    let physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
    ColliderType.definedCollisions = [.Enemy: [.Enemy, .Player]]
    let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .Enemy)
    renderComponent.node.physicsBody = physicsComponent.physicsBody
    addComponent(physicsComponent)
    
    addComponent(TeamComponent(team: team))
    addComponent(MoveComponent(maxSpeed: 200, maxAcceleration: 100, radius: Float(node.size.width * 0.3), entityManager: entityManager))
    addComponent(ParticleComponent(particleEffect: SKEmitterNode(fileNamed: "Fire")!))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
