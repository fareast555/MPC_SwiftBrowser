#MPC_SwiftBrowser 
The MPC_SwiftBrowser (Swift) is a drop-in class that includes a .swift file and a .xib file. This project demonstrates the browser in action. The actual files are in the MPC_SwiftBrowserFiles folder.  

This browser is meant to be pushed onto a navigation stack (i.e., your project should have a navigation bar). Currently working to make a version that will work as a container view.

The browswer will temporarily set your navigation bar to opague so that the progress bar shows correctly. It resets the bar back to the original translucency when the browser is dismissed.


## Requirements

* iOS 10.0+
* ARC

## Installation

Download this repo and copy the MPC_SwiftBrowserViewController.swift and MPC_SwiftBrowserViewController.xib files into your project.


 
<h3>To use:</h3>
 
  1. Create an instance of the browser passing the urlString of the page you wish to view, and setting the flag for whether the browser should hide the tab bar or not (Set to false if not using a tab bar controller)

  For example let browser = MPC_SwiftBrowserViewController(urlString:"http://myURL.com", coversTabBar:true)
 
  2. Push the browser onto your navigation stack

  For example navigationController?.pushViewController(browswer, animated: true)


<h3>Version Update History:</h3>
  ~> 1.0.1 Working version pushed to git 30 Sept 2017