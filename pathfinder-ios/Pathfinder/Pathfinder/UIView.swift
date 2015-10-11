//
//  UIView.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/5/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class DefaultView: UIView {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        backgroundColor = AppTheme.Color.BackgroundDefault
    }
    
}

class BrandView: UIView {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        backgroundColor = AppTheme.Color.Brand
    }
    
}