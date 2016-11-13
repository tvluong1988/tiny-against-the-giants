//
//  EntityManager.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/13/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class EntityManager {
  // MARK: Lifecycle
  init(scene: SKScene) {
    self.scene = scene
  }
  
  // MARK: Properties
  var entities = Set<GKEntity>()
  let scene: SKScene
}

extension EntityManager {
  func entitiesForPlayer() -> [GKEntity] {
    return entities.flatMap { entity in
      if let teamComponent = entity.component(ofType: TeamComponent.self), teamComponent.team == .Team1 {
        return entity
      }
      
      return nil
    }
  }
  
  func add(entity: GKEntity) {
    entities.insert(entity)
    
    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      scene.addChild(spriteNode)
    }
  }
  
  func remove(entity: GKEntity) {
    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      spriteNode.removeFromParent()
    }
    
    entities.remove(entity)
  }
}
