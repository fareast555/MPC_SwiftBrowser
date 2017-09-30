//
//  FirstViewController.swift
//  MPC_SwiftBrowser
//
//  Created by Michael Critchley on 2017/09/30.
//  Copyright © 2017 Michael Critchley. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {


  @IBAction func pushPageCoverTabBar(_ sender: Any) {
    pushBrowser(coversTabBar: true)
  }
  
  @IBAction func pushPageUnderTabBar(_ sender:Any) {
    pushBrowser(coversTabBar: false)
  }
  
  @IBAction func pushPageWithTitle(_ sender:Any) {
    pushBrowser(coversTabBar: true, title: "My Web Page")
  }
  
  
  func pushBrowser(coversTabBar:Bool = false, title:String = "")
  {
    //Instantiate the browswer. The urlString is the only required argument. The others are optional.
    //If no page title is passed, the browswer will detect and present the title of the page
    //being downloaded
    
    let browswer = MPC_SwiftBrowserViewController(urlString: "https://asiatravelbug.net",
                                                  coversTabBar: coversTabBar,
                                                  pageTitle:title)
    //Push onto the existing stack
    navigationController?.pushViewController(browswer, animated: true)
  }

}

