//
//  ParticleComponent.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/15/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class ParticleComponent: GKComponent {
  // MARK: Functions
  override func update(deltaTime seconds: TimeInterval) {
    super.update(deltaTime: seconds)
    
    if let spriteComponent = entity?.component(ofType: SpriteComponent.self)?.node, !entityHasParticleEffect {
      spriteComponent.addChild(particleEffect)
      entityHasParticleEffect = true
    }
    
  }
  // MARK: Lifecycle
  init(particleEffect: SKEmitterNode) {
    self.particleEffect = particleEffect
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Properties
  var entityHasParticleEffect = false
  let particleEffect: SKEmitterNode
}
