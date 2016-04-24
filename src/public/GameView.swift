//
//  GameView.swift
//  GameEngine
//
//  Created by Anthony Green on 1/10/16.
//  Copyright © 2016 Anthony Green. All rights reserved.
//

import Foundation
import Metal
import MetalKit

/**
 A `GameView` is a subclass of MTKView in order to tie into some of logic/delegate stuff provided for free by Apple. 
 */
public class GameView: MTKView {
  private weak var currentScene: Scene?

  /**
   Create a `GameView` with the current GPU device.
   
   - discussion: Anytime device is used it's forced unwrapped as the device will always exist or this program will terminate before getting this far, probably.
   
   - parameter frameRect: The frame to make the view.
   - parameter device:    The current device.

   - returns: A new instance of `GameView` for presenting scenes.
   */
  override init(frame frameRect: CGRect, device: MTLDevice?) {
    super.init(frame: frameRect, device: device)

    paused = true
  }
  
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public func presentScene(scene: Scene) {
    currentScene = scene

    scene.setupRenderer(self)

    paused = false
  }
  
//  var timestamp: CFTimeInterval = 0.0
//  func newFrame(displayLink: CADisplayLink) {
//    if timestamp == 0.0 {
//      timestamp = displayLink.timestamp
//    }
//
//    var elapsedTime = displayLink.timestamp - self.timestamp
//    //not sure how to deal with this if you hit a break point the timer gets off making it difficult to figure out what's going on
//    #if DEBUG
//    if showFPS {
//      let comeBackToThis = 1
//      //need to figure out how to "animate" text changes for this singular purpose
//
////      let time = elapsedTime > 0.0 ? elapsedTime : 1.0
////      currentScene.fpsText.text = "\(Int(1.0 / time))"
////      currentScene.fpsText.buildMesh(device!)
////      currentScene.fpsText.updateVertices(device!)
//    }
//
//    if elapsedTime >= 0.02 {
//      elapsedTime = 1.0 / 60.0
//    }
//    #endif
//    
//    self.timestamp = displayLink.timestamp
//
//    //self.currentScene.update(elapsedTime)
//  }
}