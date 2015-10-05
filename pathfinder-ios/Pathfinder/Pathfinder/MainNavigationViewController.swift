//
//  MainNavigationViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/3/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // If not logged in, show login modal
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            performSegueWithIdentifier("showLogin", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
