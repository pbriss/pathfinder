//
//  AppTheme.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/5/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

struct AppTheme {
    struct Color {
        //This allows us to use expose hex values if needed (ex: UIColor(hex, alpha))
        struct Hex {
            static let Brand = "#FF1744"
            static let TextDefault = "#58595D"
            static let BackgroundDefault = "#F0F0F0"
        }
        
        static let Brand = UIColor(hexa: Hex.Brand)
        static let TextDefault = UIColor(hexa: Hex.TextDefault)
        static let BackgroundDefault = UIColor(hexa: Hex.BackgroundDefault)
    }
}