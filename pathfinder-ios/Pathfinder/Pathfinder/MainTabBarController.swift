//
//  MainTabBarController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/2/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var userModel = UserModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // If not logged in, show login modal
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            performSegueWithIdentifier("showLogin", sender: self)
        }
        // User is already logged in, go to home view controller.
        else {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if let username = userDefaults.objectForKey("username") as? String {
                userModel.userName = username
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
