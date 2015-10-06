//
//  AppTheme.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/5/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import Foundation

struct AppTheme {
    struct Color {
        //This allows us to use expose hex values if needed (ex: UIColor(hex, alpha))
        struct Hex {
            static let Brand = "#FF1744"
            static let TextDefault = "#58595D"
            static let BackgroundDefault = "#F0F0F0"
        }
        
        static let Brand = UIColor(hex: Hex.Brand)
        static let TextDefault = UIColor(hex: Hex.TextDefault)
        static let BackgroundDefault = UIColor(hex: Hex.BackgroundDefault)
    }
}