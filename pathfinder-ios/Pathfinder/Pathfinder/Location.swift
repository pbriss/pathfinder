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
    @NSManaged var pictures: [PFObject]!
    @NSManaged var city: String!
    @NSManaged var state: String!
    @NSManaged var country: String!
    var cachedImage: UIImage?
    
    class func parseClassName() -> String {
        return "Location"
    }
}