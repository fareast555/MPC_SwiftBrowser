## MPC_SwiftBrowser 

The MPC_SwiftBrowser (Swift) is a drop-in class that includes a .swift file and a .xib file. Clone or download this project to see the various use cases of the browser in action. The actual browser files are in the MPC_SwiftBrowserFiles folder.  

For best results, push this browser onto your navigation stack (i.e., your project should have a navigation bar). If you are not using a navigation bar, you can create one using this browser as a root view, handling the dismiss as required. It is also possible to add it as a container view to another view controller.

The browser will temporarily set your navigation bar to opaque so that the progress bar shows correctly. It resets the bar back to the original translucency when the browser is dismissed.

When I get around to it, I'll add an optional share button etc to the toolbar. 


## Requirements

* iOS 10.0+
* ARC

## Installation

Copy the MPC_SwiftBrowserViewController.swift and MPC_SwiftBrowserViewController.xib files into your project.


 
<h3>To use:</h3>
 
  1. Create an instance of the browser, passing the urlString of the page you wish to view as an argument in the custom initializer. This urlString is the only required parameter in the init method. All others can be left out if not needed. 

  So the simplest use case would be:
  * let browser = MPC_SwiftBrowserViewController(urlString:"http://myURL.com")


  Other parameters are:
  * coversTabBar    (Will push the view above the tab bar)
  * pageTitle       (Set this if you want your own web page title. Else, the downloaded page title will be used)
  * embeddedInFrame (Pass the frame of the container if showing the browser in a container view)


  If embedded in a container, there is no need to pass the tab bar or title arguments. See the secondViewController file of this repo if you need to see how to create a container view programmatically. The embedded use case would be:
  * let browser = MPC_SwiftBrowserViewController(urlString:"http://myURL.com", embeddedInFrame:myContainer.frame)


  If pushing the view, the most complex use case might be something like:
  * let browser = MPC_SwiftBrowserViewController(urlString:"http://myURL.com", coversTabBar:true, pageTitle:"My page title")
  
 
  2. Push the browser onto your navigation stack (if not the embedded case)

  * navigationController?.pushViewController(browswer, animated: true)

## Extending Functionality
This brower class is a final class, and is not meant to be subclassed. Feel free, however, to extend it. At the end of the class is an extension with a sample public func that would change the navBar tint color if called.

<h3>Version Update History:</h3>
  ~> 1.0.1 Working version pushed to git 30 Sept 2017. 
  
  ~> 1.0.1 Navigation tool bar, custom title, embedded form pushed 1 Oct 2017.
  
  ~> 1.0.1 Class extension stub pushed 1 Oct 2017.
