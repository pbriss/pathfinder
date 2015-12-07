//
//  LocationTableViewCell.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/11/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: LocationCellLabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(location: Location, indexPath: NSIndexPath) {
        self.tag = indexPath.row
        self.titleLabel.text = location.name
        
        if location["pictures"].count > 0 {
            let locationPicture = location["pictures"][0]["file"] as! PFFile
            
            if location.cachedImage == nil {
                ImageLoader.sharedLoader.imageForUrl(locationPicture.url!, completionHandler: { (image, url) -> () in
                    if self.tag == indexPath.row {
                        location.cachedImage = image
                        self.backgroundImageView.image = image
                    }
                })
            }
            else {
                self.backgroundImageView.image = location.cachedImage
            }
        }
    }
}
