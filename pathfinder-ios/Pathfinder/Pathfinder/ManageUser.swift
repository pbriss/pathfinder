//
//  ManageUser.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 11/1/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import Parse
import ParseFacebookUtilsV4

class ManageUser {
    
    func isUserLoggedIntoFacebook() {
        
        //Check if logged into facebook
        if let accessToken = FBSDKAccessToken.currentAccessToken() {
            let user = PFUser.currentUser()!
            // Link PFUser with FBSDKAccessToken
            PFFacebookUtils.linkUserInBackground(user, withAccessToken: accessToken, block: {
                (succeeded: Bool?, error: NSError?) -> Void in
                if (succeeded != nil) {
                    print("Woohoo, the user is linked with Facebook!")
                }
            })
        }
    }
}
