//
//  ChargeBar.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/17/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import SpriteKit

class ChargeBarNode: SKSpriteNode {

  // MARK: Lifecycle
  init() {
    super.init(texture: nil, color: Configuration.backgroundColor, size: Configuration.size)
    
    addChild(chargeLevelNode)
    
    let xRange = SKRange(constantValue: chargeLevelNode.size.width / -2.0)
    let yRange = SKRange(constantValue: 0.0)
    
    let constraint = SKConstraint.positionX(xRange, y: yRange)
    constraint.referenceNode = self
    
    chargeLevelNode.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    chargeLevelNode.constraints = [constraint]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Static Properties
  struct Configuration {
    static let size = CGSize(width: 74.0, height: 10.0)
    
    static let chargeLevelNodeSize = CGSize(width: 70.0, height: 6.0)
    
    static let levelUpdateDuration: TimeInterval = 0.1
    
    static let backgroundColor = SKColor.black
    
    static let chargeLevelColor = SKColor.green
  }
  
  // MARK: Properties
  var level: Double = 1.0 {
    didSet {
      let action = SKAction.scaleX(to: CGFloat(level), duration: Configuration.levelUpdateDuration)
      action.timingMode = .easeInEaseOut
      
      chargeLevelNode.run(action)
    }
  }
  
  let chargeLevelNode = SKSpriteNode(color: Configuration.chargeLevelColor, size: Configuration.chargeLevelNodeSize)
  
}
