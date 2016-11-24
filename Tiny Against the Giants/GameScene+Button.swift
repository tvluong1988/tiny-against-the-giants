//
//  GameScene+Button.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/24/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import SpriteKit

extension GameScene: ButtonRespondable {
  func buttonTriggered(button: ButtonNode) {
    guard let buttonIdentifier = button.buttonIdentifier else {
      return
    }
    
    switch buttonIdentifier {
    case .retry:
      print("You pressed the retry button!")
      entityManager.removeAll()
      newGame()
    }
  }
}
