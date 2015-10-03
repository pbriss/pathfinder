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
                print("Error: Email permission not granted")
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
                let userDefaults = NSUserDefaults.standardUserDefaults()
                if let userName = NSString = result.valueForKey("name") as! NSString {
                    userDefaults.setObject(userName, forKey: "username")
                }
                if let userEmail = NSString = result.valueForKey("email") as! NSString {
                    userDefaults.setObject(userEmail, forKey: "email")
                }
                userDefaults.synchronize()
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

