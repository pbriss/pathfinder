//
//  Place.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/11/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

struct Place {
    
    var name: String?
    var picture: UIImage?
    
    init(placeDict: [String: AnyObject]) {
        
        if let name = placeDict["name"] as? String {
            self.name = name
        }
        
        if let picture = placeDict["picture"] as? NSData {
            self.picture = UIImage(data: picture)
        }
    }
}
