//
//  TeamComponent.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/13/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import GameplayKit

enum Team: Int {
  case Team1 = 1
  case Team2 = 2
  
  static let allvalues = [Team1, Team2]
  
  func oppositeTeam() -> Team {
    switch self {
    case .Team1:
      return .Team2
    case .Team2:
      return .Team1
    }
  }
}

class TeamComponent: GKComponent {
  // MARK: Lifecycle
  init(team: Team) {
    self.team = team
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let team: Team
}
