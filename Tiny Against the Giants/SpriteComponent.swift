//
//  SpriteComponent.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/13/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class SpriteComponent: GKComponent {
  // MARK: Lifecycle
  init(node: SKSpriteNode) {
    self.node = node
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let node: SKSpriteNode
}
