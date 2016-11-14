//
//  MoveBehavior.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/13/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class MoveBehavior: GKBehavior {
  // MARK: Lifecycle
  init(targetSpeed: Float, seek: GKAgent, avoid: [GKAgent]) {
    super.init()
    
    if targetSpeed > 0 {
      setWeight(0.1, for: GKGoal(toReachTargetSpeed: targetSpeed))
      setWeight(0.5, for: GKGoal(toSeekAgent: seek))
      setWeight(1.0, for: GKGoal(toAvoid: avoid, maxPredictionTime: 1.0))
    }
  }
}
