//
//  GameViewController.swift
//  Tiny Against the Giants
//
//  Created by Thinh Luong on 10/30/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    interstitialAd = createAndLoadInterstititial()
    
    let ipadLandscape = CGSize(width: 1366, height: 1024)
    gameScene = GameScene(size: ipadLandscape)
    gameScene.gameSceneDelegate = self
    gameScene.scaleMode = .resizeFill
    
    let skView = view as! SKView
    skView.presentScene(gameScene)
    skView.ignoresSiblingOrder = true
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.showsPhysics = true
  }
  
  override func viewDidLayoutSubviews() {
    if gameScene.size != view.bounds.size {
      gameScene.size = view.bounds.size
    }
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: Properties
  var gameScene: GameScene!
  var interstitialAd: GADInterstitial!
  let adUnitID = "ca-app-pub-9051260803045362/9130377939"
}

extension GameViewController: GameSceneDelegate {
  func didEnteredFailState() {
    if interstitialAd.isReady {
      gameScene.gamePause()
      interstitialAd.present(fromRootViewController: self)
      print("Ad was shown!")
    } else {
      print("Ad was not ready...")
    }
  }
}

extension GameViewController: GADInterstitialDelegate {
  func createAndLoadInterstititial() -> GADInterstitial {
    let interstitial = GADInterstitial(adUnitID: adUnitID)
    interstitial.delegate = self
    let request = GADRequest()
    request.testDevices = [kGADSimulatorID]
    interstitial.load(request)
    return interstitial
  }
  
  func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    gameScene.gameResume()
    interstitialAd = createAndLoadInterstititial()
  }
  
  func interstitialDidReceiveAd(_ ad: GADInterstitial) {
    print("Did received ad successfully!")
  }
  
  func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
    print("Failed to receive ad...")
  }
}
