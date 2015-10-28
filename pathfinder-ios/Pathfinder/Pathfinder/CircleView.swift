//
//  CircleView.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/19/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    override func drawRect(rect: CGRect) {
        // Get the Graphics Context
        let context = UIGraphicsGetCurrentContext()
        
        // Set the circle outerline-width
        CGContextSetLineWidth(context, 1.0)
        
        // Set the circle outerline-colour
        AppTheme.Color.Brand.set()
        
        // Create Circle
        CGContextAddArc(context, (frame.size.width)/2, frame.size.height/2, (frame.size.width - 10)/2, 0.0, CGFloat(M_PI * 2.0), 1)
        
        // Draw
        CGContextStrokePath(context)
    }
}
