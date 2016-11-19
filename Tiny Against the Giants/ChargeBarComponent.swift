//
//  ChargeBarComponent.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/17/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

class ChargeBarComponent: GKComponent {
  // MARK: Functions
  func loseCharge(chargeToLose: Double) {
    var newCharge = charge - chargeToLose
    
    newCharge = min(maxCharge, newCharge)
    newCharge = max(0.0, newCharge)
    
    if newCharge < charge {
      charge = newCharge
      chargeBarNode?.level = percentageCharge
    }
  }
  
  func addCharge(chargeToAdd: Double) {
    var newCharge = charge + chargeToAdd
    
    newCharge = min(maxCharge, newCharge)
    newCharge = max(0.0, newCharge)
    
    if newCharge > charge {
      charge = newCharge
      chargeBarNode?.level = percentageCharge
    }
  }
  
  
  // MARK: Lifecycle
  init(charge: Double, maxCharge: Double, displayChargeBar: Bool = false) {
    self.charge = charge
    self.maxCharge = maxCharge
    
    if displayChargeBar {
      chargeBarNode = ChargeBarNode()
    } else {
      chargeBarNode = nil
    }
    
    super.init()
    
    chargeBarNode?.level = percentageCharge
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Properties
  var charge: Double
  let maxCharge: Double
  
  var percentageCharge: Double {
    if maxCharge.isZero {
      return 0.0
    }
    
    return charge / maxCharge
  }
  
  let chargeBarNode: ChargeBarNode?
}
