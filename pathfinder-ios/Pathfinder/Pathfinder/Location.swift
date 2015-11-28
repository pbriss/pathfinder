//
//  Location.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 11/27/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class Location: PFObject, PFSubclassing {
    
    @NSManaged var name: String!
    @NSManaged var pictures: [PFFile]!
    @NSManaged var city: String!
    @NSManaged var state: String!
    @NSManaged var country: String!
    
    class func parseClassName() -> String {
        return "Location"
    }
}

struct HomeLocation {
    var name: String?
    var picture: UIImage?
    
    init(dict: [String: AnyObject]) {
        
        if let name = dict["name"] as? String {
            self.name = name
        }
        
        if let picture = dict["picture"] as? NSData {
            self.picture = UIImage(data: picture)
        }
    }
}

