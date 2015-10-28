//
//  Location.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/11/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

struct Location {
    
    var name: String?
    var picture: UIImage?
    
    init(locationDict: [String: AnyObject]) {
        
        if let name = locationDict["name"] as? String {
            self.name = name
        }
        
        if let picture = locationDict["picture"] as? String {
            self.picture = UIImage(named: picture)
        }
    }
}
