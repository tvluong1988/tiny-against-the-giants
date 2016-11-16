//
//  HudNode.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/15/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import SpriteKit

class HudNode: SKNode {
  
  init(size: CGSize) {
    self.size = size
    super.init()
    
    topHud.anchorPoint = CGPoint(x: 1, y: 1)
    topHud.position = CGPoint(x: size.width, y: size.height)
    topHud.addChild(timeLabel)
    
    addChild(topHud)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let topHud = SKSpriteNode(texture: nil, color: UIColor.cyan, size: CGSize(width: 500, height: 100))
  let timeLabel = SKLabelNode(text: "Still alive?")
  let size: CGSize
}
