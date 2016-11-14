//
//  EntityManager.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/13/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class EntityManager {
  // MARK Functions
  func update(deltaTime: TimeInterval) {
    for componentSystem in componentSystems {
      componentSystem.update(deltaTime: deltaTime)
    }
    
    for entity in entitiesToRemove {
      for componentSystem in componentSystems {
        componentSystem.removeComponent(foundIn: entity)
      }
    }
    
    entitiesToRemove.removeAll()
  }
  
  // MARK: Lifecycle
  init(scene: SKScene) {
    self.scene = scene
  }
  
  // MARK: Properties
  var entities = Set<GKEntity>()
  let scene: SKScene
  var entitiesToRemove = Set<GKEntity>()
  
  lazy var componentSystems: [GKComponentSystem] = {
    let moveSystems = GKComponentSystem(componentClass: MoveComponent.self)
    return [moveSystems]
  }()
}

extension EntityManager {  
  func add(entity: GKEntity) {
    entities.insert(entity)
    
    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      scene.addChild(spriteNode)
    }
    
    for componentSystem in componentSystems {
      componentSystem.addComponent(foundIn: entity)
    }
  }
  
  func remove(entity: GKEntity) {
    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      spriteNode.removeFromParent()
    }
    
    entities.remove(entity)
    entitiesToRemove.insert(entity)
  }
  
  func entitiesForTeam(team: Team) -> [GKEntity] {
    return entities.flatMap { entity in
      if let teamComponent = entity.component(ofType: TeamComponent.self) {
        if teamComponent.team == team {
          return entity
        }
      }
      
      return nil
    }
  }
  
  func moveComponentsForTeam(team: Team) -> [MoveComponent] {
    var moveComponents = [MoveComponent]()
    
    let entities = entitiesForTeam(team: team)
    for entity in entities {
      if let moveComponent = entity.component(ofType: MoveComponent.self) {
        moveComponents.append(moveComponent)
      }
    }
    
    return moveComponents
  }
}
