//
//  FirstViewController.swift
//  MPC_SwiftBrowser
//
//  Created by Michael Critchley on 2017/09/30.
//  Copyright © 2017 Michael Critchley. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }


  @IBAction func pushPageCoverTabBar(_ sender: Any) {
    pushBrowser(coversTabBar: true)
  }
  
  @IBAction func pushPageUnderTabBar(_ sender:Any) {
    pushBrowser(coversTabBar: false)
  }
  
  
  func pushBrowser(coversTabBar:Bool)
  {
    navigationController?.navigationBar.isTranslucent = true
    
    print("BOOL check - Bool shows as \(navigationController!.navigationBar.isTranslucent ? "YES":"NO")")
    
    let browswer = MPC_SwiftBrowserViewController(urlString: "https://asiatravelbug.net", coversTabBar:coversTabBar)
    
    navigationController?.pushViewController(browswer, animated: true)
    
  }

}

