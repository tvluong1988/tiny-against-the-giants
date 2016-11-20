//
//  PhysicsContactNotifiable.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/19/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

protocol ContactNotifiable {
  func contactWithEntityDidBegin(_ entity: GKEntity)
  func contactWithEntityDidEnd(_ entity: GKEntity)
}
