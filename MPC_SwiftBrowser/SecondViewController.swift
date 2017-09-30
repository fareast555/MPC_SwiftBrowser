//
//  SecondViewController.swift
//  MPC_SwiftBrowser
//
//  Created by Michael Critchley on 2017/09/30.
//  Copyright © 2017 Michael Critchley. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

  //This is the outlet to the view that will serve as a container
  @IBOutlet weak var containter:UIView!
  
  //The browser is not loaded until viewDidAppear
  //This ensures the container's frame is sized and layed out
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    //Instantiate the browser with a urlString and the CGRect (frame) of the container view
    //coversTabBar:, pageTitle: can be omitted in the custom init as they are not needed
    let browser = MPC_SwiftBrowserViewController(urlString: "https://asiatravelbug.net", embeddedInFrame:self.containter.frame)
    
    //Also set the frame of the overall view here
    browser.view.frame = self.containter.frame
    
    //Add this controller as a child, the view as a subview, and infom the browser this is the parent view
    addChildViewController(browser)
    self.view.addSubview(browser.view)
    browser.didMove(toParentViewController: self)
    
  }
}

