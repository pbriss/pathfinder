//
//  UILabel.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/5/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class DefaultLabel: UILabel {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        textColor = AppTheme.Color.TextDefault
    }
    
}

class MutedLabel: DefaultLabel {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        textColor = UIColor(hex: AppTheme.Color.Hex.TextDefault, alpha: 0.5)
    }
    
}