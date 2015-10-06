//
//  UINavigationItem.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/6/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class DefaultNavigationItem: UINavigationItem {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "logo-light")
        
        titleView = imageView
    }
    
}
