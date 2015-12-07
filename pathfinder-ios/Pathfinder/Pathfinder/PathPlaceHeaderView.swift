//
//  PathPlaceHeaderView.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 12/5/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import Spring
import UIKit

class PathPlaceHeaderView: UIView {
    
    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        insertBlurView(self, style: UIBlurEffectStyle.Light)
        
        placeLabel.textColor = UIColor.whiteColor()
        placeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
    }
}
