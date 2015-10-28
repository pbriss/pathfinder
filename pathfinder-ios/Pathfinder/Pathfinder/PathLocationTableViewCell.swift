//
//  PathLocationTableViewCell.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/24/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class PathLocationTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var pathLocationSelectionCollectionView: UICollectionView!
    
    let locations = Locations().items
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pathLocationSelectionCollectionView.showsHorizontalScrollIndicator = false
        pathLocationSelectionCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PathLocationSelectionCell", forIndexPath: indexPath) as! PathLocationSelectionCollectionViewCell
   
        //Set cell content
        let location = Location(locationDict: locations[indexPath.row])
        
        cell.placeLabel.text = location.name
        
        //Set cell background
        let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = location.picture
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

