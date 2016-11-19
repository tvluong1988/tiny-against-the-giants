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
    let particleSystems = GKComponentSystem(componentClass: ParticleComponent.self)
    return [moveSystems, particleSystems]
  }()
}

extension EntityManager {  
  func add(entity: GKEntity) {
    entities.insert(entity)
    
    if let renderNode = entity.component(ofType: RenderComponent.self)?.node {
      let constraint = SKConstraint.zRotation(SKRange.init(constantValue: 0))
      constraint.referenceNode = scene
      renderNode.constraints = [constraint]
      
      if let chargeBarNode = entity.component(ofType: ChargeBarComponent.self)?.chargeBarNode {
        let xRange = SKRange(constantValue: 0)
        let yRange = SKRange(constantValue: 50)
        
        let constraint = SKConstraint.positionX(xRange, y: yRange)
        constraint.referenceNode = renderNode
        
        chargeBarNode.constraints = [constraint]
        scene.addChild(chargeBarNode)
      }
      scene.addChild(renderNode)
    }
    
    for componentSystem in componentSystems {
      componentSystem.addComponent(foundIn: entity)
    }
  }
  
  func remove(entity: GKEntity) {
    if let node = entity.component(ofType: RenderComponent.self)?.node {
      node.removeFromParent()
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
