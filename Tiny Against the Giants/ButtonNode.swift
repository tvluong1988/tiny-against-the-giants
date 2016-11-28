//
//  ButtonNode.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/24/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import SpriteKit

protocol ButtonRespondable {
  func buttonTriggered(button: ButtonNode)
}

enum ButtonIdentifier: String {
  case retry = "retry"
  case pause = "pause"
  case resume = "resume"
  
  static let all: [ButtonIdentifier] = [.retry, .pause, .resume]
}

class ButtonNode: SKSpriteNode {

  // MARK: Functions
  func buttonTriggered() {
    if isUserInteractionEnabled {
      responder.buttonTriggered(button: self)
    }
  }
  
  // MARK: Properties
  var buttonIdentifier: ButtonIdentifier? {
    var identifier: ButtonIdentifier?
    if let nodeName = self.name {
      identifier = ButtonIdentifier(rawValue: nodeName)
    }
    return identifier
  }
  
  var responder: ButtonRespondable {
    guard let responder = scene as? ButtonRespondable else {
      fatalError("ButtonNode may only be used within a `ButtonRespondable` scene.")
    }
    return responder
  }
}

// MARK: Touch handling
extension ButtonNode {
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    
    if containsTouches(touches: touches) {
      buttonTriggered()
    }
  }
  
  private func containsTouches(touches: Set<UITouch>) -> Bool {
    guard let scene = scene else {
      fatalError("Button must be used within a SKScene")
    }
    
    return touches.contains { touch in
      let touchPoint = touch.location(in: scene)
      let touchNode = scene.atPoint(touchPoint)
      return touchNode === self || touchNode.inParentHierarchy(self)
    }
  }
}
