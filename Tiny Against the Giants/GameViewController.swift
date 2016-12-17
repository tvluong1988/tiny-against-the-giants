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
    let scene = GameScene(size: ipadLandscape)
    scene.scaleMode = .aspectFill
        
    if let view = self.view as! SKView? {
      view.presentScene(scene)
          
      view.ignoresSiblingOrder = true
          
      view.showsFPS = true
      view.showsNodeCount = true
      view.showsPhysics = true
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
  var interstitialAd: GADInterstitial!
  let adUnitID = "ca-app-pub-9051260803045362/9130377939"
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
    interstitialAd = createAndLoadInterstititial()
  }
  
  func interstitialDidReceiveAd(_ ad: GADInterstitial) {
    print("Did received ad successfully!")
    interstitialAd.present(fromRootViewController: self)
  }
  
  func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
    print("Failed to receive ad...")
  }
}
