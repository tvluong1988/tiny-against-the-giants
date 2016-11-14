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
    
    addComponent(SpriteComponent(node: node))
    addComponent(TeamComponent(team: team))
    addComponent(MoveComponent(maxSpeed: 150, maxAcceleration: 50, radius: Float(node.size.width * 0.3), entityManager: entityManager))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
