//
//  SettingsViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/2/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class SettingsViewController: UIViewController {

    @IBOutlet weak var facebookProfilePic: UIImageView!
    @IBOutlet weak var facebookUsername: UILabel!
    @IBOutlet weak var facebookLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
  
        //Check if logged into facebook
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            setFacebookUserDetails()
        }
        else {
            setLoggedOutDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLoggedInDisplay(firstName: String, profilePic: PFFile) {
        //Set facebook username
        self.facebookUsername.text = firstName
        
        //Set facebook profile picture
        setFacebookPic(profilePic)
        
        //Set logout button text
        facebookLoginButton.setTitle("Logout", forState: .Normal)
    }
    
    func setLoggedOutDisplay() {
        //Set facebook username
        facebookUsername.text = ""
        
        //Set facebook profile picture
        self.facebookProfilePic.image = UIImage(named: "logo-light.png")
        self.facebookProfilePic.layer.borderWidth = 0
        
        //Set login button text
        facebookLoginButton.setTitle("Sign in to Facebook", forState: .Normal)
    }
    
    func setFacebookUserDetails() {
        //Check if user already exists in Parse
        if let currentUser = PFUser.currentUser() {
            
            setLoggedInDisplay(currentUser["first_name"] as! String, profilePic: currentUser["profile_picture"] as! PFFile)
        }
        else {

            let requestParameters = ["fields": "id, email, first_name, last_name"]
            let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)

            userDetails.startWithCompletionHandler {
                (connection, result, error: NSError!) -> Void in

                if (error != nil) {
                    print("\(error.localizedDescription)")
                    return
                }
                let currentUser = PFUser.currentUser()!

                if (result != nil) {
                    let userId: String = result["id"] as! String
                    let userFirstName: String? = result["first_name"] as? String
                    let userLastName: String? = result["last_name"] as? String
                    let userEmail: String? = result["email"] as? String

                    // Save first name
                    if (userFirstName != nil) {
                        currentUser.setObject(userFirstName!, forKey: "first_name")
                    }

                    //Save last name
                    if (userLastName != nil) {
                        currentUser.setObject(userLastName!, forKey: "last_name")
                    }

                    // Save email address
                    if (userEmail != nil) {
                        currentUser.setObject(userEmail!, forKey: "email")
                    }

                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

                        // Get Facebook profile picture
                        let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"

                        let profilePictureUrl = NSURL(string: userProfile)

                        let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)

                        if (profilePictureData != nil) {
                            let profileFileObject = PFFile(data: profilePictureData!)
                            currentUser.setObject(profileFileObject!, forKey: "profile_picture")
                            
                            self.setLoggedInDisplay(userFirstName!, profilePic: currentUser["profile_picture"] as! PFFile)
                        }

                        currentUser.saveInBackgroundWithBlock({
                            (success: Bool, error: NSError?) -> Void in

                            if (success) {
                                print("User details are now updated")
                            }

                        })
                    }
                }
            }
        }
    }
    
    func setFacebookPic(userPicture: PFFile) {
        userPicture.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                //Set facebook profile pic
                self.facebookProfilePic.image = UIImage(data: imageData!)
                //Circular silhouette
                self.facebookProfilePic.clipsToBounds = true
                self.facebookProfilePic.layer.cornerRadius = self.facebookProfilePic.frame.height / 2
                self.facebookProfilePic.layer.borderWidth = 2
                self.facebookProfilePic.layer.borderColor = UIColor.whiteColor().CGColor
            }
        }
    }


    // MARK: - Actions

    @IBAction func closeSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signInToFacebook(sender: AnyObject) {
        
        //SIGN IN TO FACEBOOK
        if(FBSDKAccessToken.currentAccessToken() == nil) {
            
            // Log In (create/update currentUser) with FBSDKAccessToken
            PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email"], block: { (user:PFUser?, error:NSError?) -> Void in
                
                //Display an alert message if any login errors
                if(error != nil)
                {
                    let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                    let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                    
                    myAlert.addAction(okAction);
                    self.presentViewController(myAlert, animated:true, completion:nil);
                    
                    return
                }
                else if user != nil {
                    print("User logged in through Facebook!")
                    self.setFacebookUserDetails()
                }
                else {
                    print("Uh oh. The user cancelled the Facebook login.")
                }
                
                
            })
        }
        else { //LOGOUT
            PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
                print("User is logged out of Facebook Facebook!")
                self.setLoggedOutDisplay()
            }
        }
    }

}
