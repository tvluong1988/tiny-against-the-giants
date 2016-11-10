//
//  TileMapPhysics.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/10/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import SpriteKit

func getPhysicsBodyFromTileDefinition(tileDefinition: SKTileDefinition, center: CGPoint) -> SKPhysicsBody? {
  var tileDefinitionPhysicsBody: SKPhysicsBody?
  
  let tileSize = tileDefinition.size
  let tileTranslation = tileSize.height * 0.25
  let scaleYHalfTransform = CGAffineTransform(scaleX: 1.0, y: 0.5)
  let scaleXHalfTransform = CGAffineTransform(scaleX: 0.5, y: 1.0)
  let scaleByHalfTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
  
  
  switch tileDefinition.name! {
  case "CenterCenter":
    tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize, center: center)
  case "BottomCenter":
    tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleYHalfTransform), center: center.applying(CGAffineTransform(translationX: 0, y: tileTranslation)))
  case "TopCenter":
    tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleYHalfTransform), center: center.applying(CGAffineTransform(translationX: 0, y: -tileTranslation)))
  case "CenterLeft":
    tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleXHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: 0)))
  case "CenterRight":
    tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleXHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: 0)))
  case "TopLeft":
    tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: -tileTranslation)))
  case "TopRight":
    tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: -tileTranslation)))
  case "BottomLeft":
    tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: tileTranslation)))
  case "BottomRight":
    tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: tileTranslation)))
  case "BottomRightCorner":
    let rightPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: tileTranslation)))
    let bottomPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: -tileTranslation)))
    tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [rightPhysicsBody, bottomPhysicsBody])
  case "BottomLeftCorner":
    let leftPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: tileTranslation)))
    let bottomPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: -tileTranslation)))
    tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [leftPhysicsBody, bottomPhysicsBody])
  case "TopLeftCorner":
    let leftPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: -tileTranslation)))
    let topPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: tileTranslation)))
    tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [leftPhysicsBody, topPhysicsBody])
  case "TopRightCorner":
    let rightPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: tileTranslation, y: -tileTranslation)))
    let topPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleByHalfTransform), center: center.applying(CGAffineTransform(translationX: -tileTranslation, y: tileTranslation)))
    tileDefinitionPhysicsBody = SKPhysicsBody(bodies: [rightPhysicsBody, topPhysicsBody])
  default:
    break
  }
  
  return tileDefinitionPhysicsBody
}

func getPhysicsBodiesFromTileMapNode(tileMapNode: SKTileMapNode) -> [SKPhysicsBody] {
  var physicsBodies = [SKPhysicsBody]()
  
  for column in 0..<tileMapNode.numberOfColumns {
    for row in 0..<tileMapNode.numberOfRows {
      if let tileDefinition = tileMapNode.tileDefinition(atColumn: column, row: row) {
        if let physicsBody = getPhysicsBodyFromTileDefinition(tileDefinition: tileDefinition, center: tileMapNode.centerOfTile(atColumn: column, row: row)) {
          physicsBodies.append(physicsBody)
        }
      }
    }
  }
  
  return physicsBodies
}
