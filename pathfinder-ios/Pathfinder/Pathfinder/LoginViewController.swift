//
//  LoginViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 9/30/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Show login button
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        
    }
    
    // Facebook Delegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
            print("Error: \(error)")
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
            
            self.returnUserData()
        }
        
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let params = ["fields": "name, email, picture"]
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else {
                print("Result: \(result)")
                let userDefaults = NSUserDefaults.standardUserDefaults()
                if let userName = result.valueForKey("name") as? NSString {
                    userDefaults.setObject(userName, forKey: "name")
                }
                if let userEmail = result.valueForKey("email") as? NSString {
                    userDefaults.setObject(userEmail, forKey: "email")
                }

                // Get user profile pic
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let url = "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token=\(accessToken)"

                ImageLoader.sharedLoader.imageForUrl(url, completionHandler:{(image: UIImage?, url: String) in

                    //Store facebook profile pic
                    let imageData = UIImagePNGRepresentation(image!)

                    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                    let imagePath = documentsURL.URLByAppendingPathComponent("profile-pic_cached.png")

                    if !imageData!.writeToFile(imagePath.path!, atomically: false) {
                        print("Image NOT saved!")
                    } else {
                        print("Image saved!")
                        userDefaults.setObject(imagePath.path!, forKey: "profilepic")
                    }
                })

                userDefaults.synchronize()
                
                self.dismissViewControllerAnimated(false, completion: nil)

            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

