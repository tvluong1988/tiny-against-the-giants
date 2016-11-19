//
//  RenderComponent.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/18/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class RenderComponent: GKComponent {
  // MARK: Functions
  override func didAddToEntity() {
    node.entity = entity
  }
  
  override func willRemoveFromEntity() {
    node.entity = nil
  }
  
  // MARK: Properties
  let node = SKNode()
}
