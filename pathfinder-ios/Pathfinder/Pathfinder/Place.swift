//
//  Place.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/11/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class Place: PFObject, PFSubclassing {
    
    @NSManaged var name: String!
    @NSManaged var picture: PFFile!
    var orderInPath: NSIndexPath?
    
    class func parseClassName() -> String {
        return "Place"
    }
}