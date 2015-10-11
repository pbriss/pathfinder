//
//  SettingsViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/2/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit
import Spring

class SettingsViewController: UIViewController {

    @IBOutlet weak var facebookProfilePic: UIImageView!
    @IBOutlet weak var facebookUsername: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Actions

    @IBAction func closeSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
