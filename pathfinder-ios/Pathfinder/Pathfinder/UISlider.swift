//
//  UISlider.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/5/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class DefaultSlider: UISlider {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        minimumTrackTintColor = AppTheme.Color.Brand
        maximumTrackTintColor = UIColor(hexa: AppTheme.Color.Hex.TextDefault, alpha: 0.3)
    }
    
}
