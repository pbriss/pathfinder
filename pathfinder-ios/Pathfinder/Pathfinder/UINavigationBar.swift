//
//  UINavigationBar.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/20/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class DefaultNavigationBar: UINavigationBar {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        barTintColor = UIColor.whiteColor()
        tintColor = AppTheme.Color.Brand
        translucent = false
    }
    
}
