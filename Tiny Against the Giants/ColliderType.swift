//
//  ColliderType.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/18/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

struct ColliderType: OptionSet {
  // MARK: Sets
  static var requestedContactNotifications = [ColliderType: [ColliderType]]()
  static var definedCollisions = [ColliderType: [ColliderType]]()
  
  // MARK: Options
  static var Obstacle: ColliderType { return self.init(rawValue: 1 << 0) }
  static var Player: ColliderType { return self.init(rawValue: 1 << 1) }
  static var Enemy: ColliderType { return self.init(rawValue: 1 << 2) }

  // MARK: Properties
  let rawValue: UInt32
}

extension ColliderType {
  var categoryMask: UInt32 {
    return rawValue
  }
  
  var collisionMask: UInt32 {
    let mask = ColliderType.definedCollisions[self]?.reduce(ColliderType()) { initial, colliderType in
      return initial.union(colliderType)
    }
    
    return mask?.rawValue ?? 0
  }
  
  var contactMask: UInt32 {
    let mask = ColliderType.requestedContactNotifications[self]?.reduce(ColliderType()) { initial, colliderType in
      return initial.union(colliderType)
    }
    
    return mask?.rawValue ?? 0
  }
  
  func notifyOnContactWith(_ colliderType: ColliderType) -> Bool {
    if let requestedContacts = ColliderType.requestedContactNotifications[self] {
      return requestedContacts.contains(colliderType)
    }
    
    return false
  }
}

extension ColliderType: CustomDebugStringConvertible {
  var debugDescription: String {
    switch self.rawValue {
    case ColliderType.Obstacle.rawValue:
      return "ColliderType.Obstacle"
    case ColliderType.Player.rawValue:
      return "ColliderType.Player"
    case ColliderType.Enemy.rawValue:
      return "ColliderType.Enemy"
    default:
      return "UnknownColliderType(\(self.rawValue))"
    }
  }
}

extension ColliderType: Hashable {
  var hashValue: Int {
    return Int(rawValue)
  }
}
