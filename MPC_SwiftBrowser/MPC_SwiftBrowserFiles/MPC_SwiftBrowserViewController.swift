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

class MPC_SwiftBrowserViewController: UIViewController, WKNavigationDelegate {

  //Outlets
  @IBOutlet weak var loadProgress: UIProgressView!
  @IBOutlet weak var toolBar: UIToolbar!
  @IBOutlet weak var backButton: UIBarButtonItem!
  @IBOutlet weak var forwardButton: UIBarButtonItem!
  
  //Instance variables
  var webView: WKWebView!
  var myURL:URL?
  var isLoading: Bool = false
  var navigationIsTranslucent: Bool = false
  var userSuppliedPageTitle: String = ""
  var frame:CGRect = .zero
  var embedded:Bool = false
  
  //********
  //Custom Initializer
  //********
  
  //Only the urlString is required
  convenience init(urlString:String, coversTabBar:Bool = false, pageTitle:String = "", embeddedInFrame:CGRect = CGRect.zero) {
    self.init()
    
    //Set the NSURL from the passed string
    self.myURL = URL(string:urlString)
    
    //Set the hides tab bar property
    hidesBottomBarWhenPushed = coversTabBar
    
    //Keep a convenience flag to know if this is an embedded view
    self.embedded = embeddedInFrame == .zero ? false : true
    
    //Set embedded frame for later (set to CGRectzero if not an embedded view)
    self.frame = embeddedInFrame == .zero ? .zero : _zeroOriginFrameFromFrame(frame: embeddedInFrame)
    
    //Set the global title override if user gave title and this is not an embedded view
    userSuppliedPageTitle = pageTitle
    if !userSuppliedPageTitle.isEmpty && !self.embedded {
      self.title = userSuppliedPageTitle
    }
  }
  
  //********
  //Convenience helper. Shifts frame to a zero origin
  //********
  func _zeroOriginFrameFromFrame(frame:CGRect) -> CGRect {
    return CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
  }
 
  //********
  //View Life Cycle
  //********
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //If navigation embedded, make the bar NOT translucent to progress bar displays correctly
    if navigationController?.navigationBar != nil {
      
      //Keep a record of initial translucency state
      self.navigationIsTranslucent = navigationController?.navigationBar.isTranslucent ?? false
      
      //Set nav bar to opaque for this instance
      navigationController?.navigationBar.isTranslucent = false
    }
    
    //Hide toolbar if not required (ie, if it's going to be under a tab bar)
    self.toolBar!.isHidden = !hidesBottomBarWhenPushed
    
    //Hide the nav buttons to start with
    self.backButton.isEnabled = false
    self.forwardButton.isEnabled = false
    
    //Increase size of buttons
    let attributesDictionary = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)]
    self.backButton.setTitleTextAttributes(attributesDictionary, for: UIControlState.normal)
    self.forwardButton.setTitleTextAttributes(attributesDictionary, for: .normal)
    
    //Add a webview to the hierarchy if the result of the URL conversion was not nil
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
  
  //********
  //Web view creation
  //********
  func _createMyWebView(urlToLoad:URL) {
    
    //1. Create web configuration object
    let webConfiguration = WKWebViewConfiguration()
    
    //2. Prepare frame.
    let mainViewFrame = self.frame == .zero ? UIScreen.main.bounds : self.frame
 
    //3. Create web view and add to main view
    webView = WKWebView(frame:mainViewFrame, configuration: webConfiguration)
    self.view.addSubview(webView)
    
    //4. Move subview on the nib in front of the webview
    self.view.bringSubview(toFront: loadProgress)
    self.view.bringSubview(toFront: toolBar)
    
    webView.navigationDelegate = self
    let myRequest = URLRequest(url: myURL!)
    webView.load(myRequest)
 
  }
  
  //********
  //Tracking and Loading Helpers. (WKNavDelegate follows this section)
  //********
  
  func _beginTrackingLoadingProgress() {
    loadProgress.progress = 0.2
    loadProgress.alpha = 1.0
    isLoading = true
    _checkPageLoadingProgress()
  }
  
  
  func _checkPageLoadingProgress()
  {
    if isLoading {
      
      //Check if a title was detected on the downloading page
      if let title = webView.title {
        
        //Set the web page title to the navigation bar If the user did not pass a custom title
        if self.userSuppliedPageTitle.isEmpty && !self.embedded {
          self.title = title
        }
        
      }
      
      //Update the progress bar
      self.loadProgress.progress = Float(self.webView.estimatedProgress)
      
      //If page is still downloading, run this check again in 0.3s
      if self.loadProgress.progress < 0.99 {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
          self._checkPageLoadingProgress()
          })
      }
    }
  }
  
  //Called when the MKNavigationDelegate detects
  //the page is fully loaded (or an error)
  func _endTrackingLoadingProgress()
  {
    self.isLoading = false
    
    //Fade out progress bar
    UIView.animate(withDuration: 1.0, animations: {
      self.loadProgress.alpha = 0
      })
  }
  
  //********
  //Back and forward navigation
  //********
  
  @IBAction func goBack(_ sender:Any) {
    
    if self.webView.canGoBack { self.webView.goBack() }
  }
  
  @IBAction func goForward(_ sender:Any) {
    
    if self.webView.canGoForward { self.webView.goForward() }
  }
  
  //Sets the buttons as blue or grey depending if back or forward pages are available
  func _checkNavigationButtons() {
    
    self.backButton.isEnabled = self.webView.canGoBack ? true : false
    self.forwardButton.isEnabled = self.webView.canGoForward ? true : false
  }

  //********
  //WKWebNavigationDelegate
  //********
  
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    _beginTrackingLoadingProgress()
    _checkNavigationButtons()
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    _endTrackingLoadingProgress()
  }
  
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    _endTrackingLoadingProgress()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    _endTrackingLoadingProgress()
  }
  
  func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    _endTrackingLoadingProgress()
  }
  
  
} //END


