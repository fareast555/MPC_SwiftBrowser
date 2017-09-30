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
 
  1. Create an instance of the browser passing the urlString of the page you wish to view. This urlString is the only required parameter in the init method. All others can be left out if not using. 

  So the simplest use case would be MPC_SwiftBrowserViewController(urlString:"http://myURL.com")

  Other parameters are:
  * coversTabBar (will push the view above the tab bar)
  * pageTitle (set this is you want your own web page title. Else, the downloaded page will be used)
  * embeddedInFrame  Pass the CGRect frame of the container if you are showing the browser in a container view

  If embedded in a container, there is no need to pass the tab bar or title arguments. See the secondViewController file if you need to see how to create a container view programmatically
  MPC_SwiftBrowserViewController(urlString:"http://myURL.com", embeddedInFrame:myContainer.frame)

  If pushing the view, the most complex use case might be something like
  MPC_SwiftBrowserViewController(urlString:"http://myURL.com", coversTabBar:true, pageTitle:"My page title")
  
 
  2. Push the browser onto your navigation stack (if not the embedded case)

  For example navigationController?.pushViewController(browswer, animated: true)


<h3>Version Update History:</h3>
  ~> 1.0.1 Working version pushed to git 30 Sept 2017. 
  ~> 1.0.1 Navigation tool bar, custom title, embedded form pushed 1 Oct 2017.
