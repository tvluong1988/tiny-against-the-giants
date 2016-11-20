//
//  PhysicsComponent.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/18/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class PhysicsComponent: GKComponent {
  // MARK: Lifecycle
  init(physicsBody: SKPhysicsBody, colliderType: ColliderType) {
    self.physicsBody = physicsBody
    self.physicsBody.categoryBitMask = colliderType.categoryMask
    self.physicsBody.contactTestBitMask = colliderType.contactMask
    self.physicsBody.collisionBitMask = colliderType.collisionMask
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  var physicsBody: SKPhysicsBody
}
