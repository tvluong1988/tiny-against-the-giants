//
//  TileMap.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 11/10/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import SpriteKit

func getLandBackground() -> SKTileMapNode? {
  var tileMap: SKTileMapNode?
  if let tileSet = SKTileSet(named: "BasicTile") {
    let tileSize = CGSize(width: 32, height: 32)
    tileMap = SKTileMapNode(tileSet: tileSet, columns: 42, rows: 32, tileSize: tileSize)
    tileMap?.enableAutomapping = true
    tileMap?.position = CGPoint.zero
    
    let noiseMap = getPerlinNoiseMap(frequency: 10)
    
    for column in stride(from: 0, to: 42, by: 1) {
      for row in stride(from: 0, to: 32, by: 1) {
        if noiseMap.value(at: vector_int2(Int32(column), Int32(row))) > 0.65 {
          tileMap?.setTileGroup(tileSet.tileGroups.first!, forColumn: column, row: row)
        }
      }
    }
    
    for column in [0, 41] {
      for row in stride(from: 0, to: 32, by: 1) {
        tileMap?.setTileGroup(tileSet.tileGroups.first!, forColumn: column, row: row)
      }
    }
  }
  
  return tileMap
}

func getTileMapFilled() -> SKTileMapNode? {
  var tileMap: SKTileMapNode?
  if let tileSet = SKTileSet(named: "BasicTile") {
    let tileSize = CGSize(width: 32, height: 32)
    tileMap = SKTileMapNode(tileSet: tileSet, columns: 42, rows: 32, tileSize: tileSize)
    tileMap?.position = CGPoint.zero
    tileMap?.fill(with: tileSet.tileGroups.first!)
  }
  
  return tileMap
}
