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
  init(node: SKSpriteNode) {
    super.init()
    
    let spriteComponent = SpriteComponent(node: node)
    addComponent(spriteComponent)
    addComponent(PlayerComponent())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
