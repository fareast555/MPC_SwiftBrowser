//
//  MPC_SwiftBrowserViewController.swift
//
//  Created by Michael Critchley on 2017/09/29.
/*
 Copyright © 2017 Michael Critchley. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


import UIKit
import WebKit
import QuartzCore

final class MPC_SwiftBrowserViewController: UIViewController, WKNavigationDelegate {

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

extension MPC_SwiftBrowserViewController {
  
  //Add any extending functions here. For example, uncomment the following code
  //and call it AFTER you have pushed the browerer onto your navigation stack to
  //change the tint color of the nav bar (the back button color etc)
  
  /*
  public func changeNavBarTintColorTo(_ color:UIColor)
  {
      if navigationController?.navigationBar != nil {
        navigationController?.navigationBar.tintColor = color
      }
  }
  */
}

