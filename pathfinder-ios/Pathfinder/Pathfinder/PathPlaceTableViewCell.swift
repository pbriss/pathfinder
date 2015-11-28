//
//  PathPlaceTableViewCell.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/24/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class PathPlaceTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var pathPlaceSelectionCollectionView: UICollectionView!
    
    let places = [
        ["name": "Barcelona", "picture": "barcelona.jpg"],
        ["name": "Berlin", "picture": "berlin.jpg"],
        ["name": "Hong Kong", "picture": "hongkong.jpg"],
        ["name": "Montreal", "picture": "montreal.jpg"],
        ["name": "New York", "picture": "newyork"],
        ["name": "Paris", "picture": "paris.jpg"],
        ["name": "San Francisco", "picture": "sanfrancisco"],
        ["name": "Venice", "picture": "venice.jpg"]
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pathPlaceSelectionCollectionView.showsHorizontalScrollIndicator = false
        pathPlaceSelectionCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PathPlaceSelectionCell", forIndexPath: indexPath) as! PathPlaceSelectionCollectionViewCell
   
        //Set cell content
        let place = places[indexPath.row]
        
        cell.placeLabel.text = place["name"]
        
        //Set cell background
        let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
        imageView.contentMode = .ScaleAspectFill
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

