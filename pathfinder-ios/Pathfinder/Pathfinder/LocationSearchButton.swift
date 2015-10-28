//
//  LocationSearchButton.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/11/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit
import Spring

class LocationSearchButton: SpringButton {

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        backgroundColor = UIColor.whiteColor()
        tintColor = UIColor(hexa: AppTheme.Color.Hex.TextDefault, alpha: 0.6)
        layer.masksToBounds = false
        layer.cornerRadius = 2.0
        
        layer.shadowColor = UIColor(hexa: "#000000", alpha: 0.2).CGColor
        layer.shadowOffset = CGSizeMake(0, 0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 2.0
    }

}
