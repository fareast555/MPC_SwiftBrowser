//
//  MPC_SwiftBrowserViewController.swift
//  BullsEye
//
//  Created by Michael Critchley on 2017/09/29.
//  Copyright © 2017 Michael Critchley. All rights reserved.
//

import UIKit
import WebKit
import QuartzCore

class MPC_SwiftBrowserViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

  //Outlets
  @IBOutlet weak var loadProgress: UIProgressView!
  
  var webView: WKWebView!
  var myURL:URL?
  var isLoading: Bool = false
  var navigationIsTranslucent: Bool = false
  
  convenience init(urlString:String, coversTabBar:Bool) {
    self.init()
    self.myURL = URL(string:urlString)
    hidesBottomBarWhenPushed = coversTabBar
  }
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //If navigation embedded, make the bar NOT translucent to progress bar displays correctly
    if navigationController?.navigationBar != nil {
      
      //1. Keep a record of initial translucency state
      self.navigationIsTranslucent = navigationController?.navigationBar.isTranslucent ?? false
      
      //2. Set nav bar to opaque for this instance
      navigationController?.navigationBar.isTranslucent = false
    }
    
    //Add a webview to the hierarchy
    if let myURL = self.myURL {
      _createMyWebView(urlToLoad: myURL)
    }
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //Reset the navbar translucency to the initial state
    if navigationController?.navigationBar != nil {
      navigationController?.navigationBar.isTranslucent = self.navigationIsTranslucent
    }
  }
  

  
  
 
  func _createMyWebView(urlToLoad:URL) {
    let webConfiguration = WKWebViewConfiguration()
    let mainViewFrame = UIScreen.main.bounds
 
    webView = WKWebView(frame:mainViewFrame, configuration: webConfiguration)
    self.view.addSubview(webView)
    self.view.bringSubview(toFront: loadProgress)
    
    webView.uiDelegate = self
    webView.navigationDelegate = self
    let myRequest = URLRequest(url: myURL!)
    // print("My URL is \(self.myURL!.description). My URL request is \(myRequest.description)")
    webView.load(myRequest)
    
   // let index = view.subviews.index(of: webView)
 
  }
  
  //Tracking and Loading Helpers (WKNavDelegate follows this section)
  func _beginTrackingProgress()
  {
    loadProgress.progress = 0.2
    loadProgress.alpha = 1.0
    isLoading = true
    _checkProgress()
    
  }
  
  func _checkProgress()
  {
    if isLoading {
      self.loadProgress.progress = Float(self.webView.estimatedProgress)
      
      if self.loadProgress.progress < 1.0
      {
        let dispatchTime = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
          self._checkProgress()
          })
      }
    }
  }
  
  func _endTrackingProgress()
  {
    self.isLoading = false
    
    //Fade out progress bar
    let transition = CATransition()
    transition.type = kCATransitionFade
    transition.duration = 1.0
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    self.view.layer.add(transition, forKey: nil)
    
    self.loadProgress.alpha = 0
    
  }

  //WKWebNavigationDelegate
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    _beginTrackingProgress()
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    _endTrackingProgress()
  }
  
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    _endTrackingProgress()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    _endTrackingProgress()
  }
  
  func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    _endTrackingProgress()
  }
  
} //END


