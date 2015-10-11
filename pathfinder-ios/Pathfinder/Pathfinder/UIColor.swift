//
//  UIColor.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/4/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

//NOTE: a UIColor extension is also implemented in Spring/Misc.swfit although this one supports alpha values
extension UIColor {
    convenience init(hexa: String, alpha: CGFloat = 1) {
        assert(hexa[hexa.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = NSScanner(string: hexa)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}