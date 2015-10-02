//
//  LoginBackgroundView
//  Pathfinder
//
//  Created by Pascal Brisset on 9/30/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class LoginBackgroundView: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Background View
        
        //// Color Declarations
        let lightRed: UIColor = UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.000)
        let darkRed: UIColor = UIColor(red: 192/255.0, green: 57/255.0, blue: 43/255.0, alpha: 1.000)
        
        let context = UIGraphicsGetCurrentContext()
        
        //// Gradient Declarations
        let redGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [lightRed.CGColor, darkRed.CGColor], [0, 1])
        
        //// Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRectMake(0, 0, self.frame.width, self.frame.height))
        CGContextSaveGState(context)
        backgroundPath.addClip()
        CGContextDrawLinearGradient(context, redGradient,
            CGPointMake(160, 0),
            CGPointMake(160, 568),
            [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        CGContextRestoreGState(context)
    }
    
}

