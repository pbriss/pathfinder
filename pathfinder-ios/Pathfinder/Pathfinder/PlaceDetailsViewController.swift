//
//  PlaceDetailsViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 11/28/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: BrandLabel!
    @IBOutlet weak var backButton: UIButton!
    
    var currentPlace: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let place = currentPlace {
            placeNameLabel.text = place.name
            placeImageView.image = UIImage(named: "newyork.jpg")//place.picture
        }
        
        backButton.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        backButton.alpha = 1
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
