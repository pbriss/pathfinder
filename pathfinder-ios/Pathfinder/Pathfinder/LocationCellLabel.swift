//
//  LocationCellLabel.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/11/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class LocationCellLabel: UILabel {
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        textColor = UIColor.whiteColor()
        font = UIFont(name: font.fontName, size: 32)
        layer.shadowColor = UIColor(hex: "#000000").CGColor
        layer.shadowOffset = CGSizeMake(0, 0)
        layer.shadowOpacity = 0.9
        layer.shadowRadius = 3.0
    }
}
