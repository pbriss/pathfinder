//
//  SettingsViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/2/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookProfilePic: UIImageView!
    @IBOutlet weak var facebookUsername: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        //User is logged in, show home view and set user defaults
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let userDefaults = NSUserDefaults.standardUserDefaults()

            //Set facebook user name
            if let username = userDefaults.objectForKey("name") as? String {
                facebookUsername.text = username
            }

            //Set facebook profile pic
            if let profilepic = userDefaults.objectForKey("profilepic") as? String {
                facebookProfilePic.image = UIImage(contentsOfFile: profilepic)
                //Circular silhouette
                facebookProfilePic.clipsToBounds = true
                facebookProfilePic.layer.cornerRadius = self.facebookProfilePic.frame.height/2
                facebookProfilePic.layer.borderWidth = 2
                facebookProfilePic.layer.borderColor = UIColor.whiteColor().CGColor
            }
        }
        
        // Show logout button
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
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")

        //Make sure to empty user defaults
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("name")
        userDefaults.removeObjectForKey("email")
        userDefaults.removeObjectForKey("profilepic")

        //Dismiss current settings modal
        self.dismissViewControllerAnimated(true, completion: nil)

        //Show login screen modal after logout
        self.tabBarController?.performSegueWithIdentifier("showLogin", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Actions

    @IBAction func closeSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
