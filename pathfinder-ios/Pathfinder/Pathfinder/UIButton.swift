//
//  UIButton.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/5/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit
import QuartzCore
import Spring

class DefaultButton: UIButton {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
//        backgroundColor = UIColor.whiteColor()
        tintColor = AppTheme.Color.Brand
        layer.masksToBounds = true
        layer.cornerRadius = 2.0
        titleLabel?.font = UIFont.systemFontOfSize(14)
    }
}


class FloatingBackButton: SpringButton {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        tintColor = UIColor.whiteColor()
        backgroundColor = AppTheme.Color.Brand
        layer.cornerRadius = 0.5 * frame.width
        self.setTitle(String.icomoonWithName(Icomoon.Back), forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.icomoonOfSize(0.5 * frame.width)
    }
}