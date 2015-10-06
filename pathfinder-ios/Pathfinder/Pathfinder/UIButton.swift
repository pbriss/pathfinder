//
//  UIButton.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/5/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit
import QuartzCore

class DefaultButton: UIButton {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        backgroundColor = UIColor.whiteColor()
        tintColor = AppTheme.Color.Brand
        layer.masksToBounds = true
        layer.cornerRadius = 2.0
    }
    
    override func drawRect(rect: CGRect) {
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
    }
    
}