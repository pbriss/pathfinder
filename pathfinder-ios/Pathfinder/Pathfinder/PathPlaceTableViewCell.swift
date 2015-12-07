//
//  PathPlaceTableViewCell.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/24/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

// Delegate used to set selected place once collection view cell was pressed
protocol PathPlaceTableViewCellDelegate {
    func didPressOnPathPlace(place: Place)
}

class PathPlaceTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var pathPlaceSelectionCollectionView: UICollectionView!
    var pathPlaceDelegate: PathPlaceTableViewCellDelegate?

    var places: [Place] = []
    
    // This is used to keep track for the index path of the selected table view cell which isn't the same as the index path of the selected collection view cell
    var tableViewCellIndexPath: NSIndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pathPlaceSelectionCollectionView.showsHorizontalScrollIndicator = false
        pathPlaceSelectionCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        // Do any additional setup after loading the view, typically from a nib
        let query = Place.query()!
        query.limit = 10
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    let place = object as! Place
                    place.orderInPath = self.tableViewCellIndexPath
                    self.places.append(place)
                }
                self.pathPlaceSelectionCollectionView.reloadData()
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
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
        
        cell.pathPlaceHeaderView.placeLabel.text = place.name
        
        //Set cell background
        let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "newyork.jpg")
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let place = self.places[indexPath.row]
        // Set the place to be passed back to the CreatePathViewController (or to whoever implements the protocol)
        self.pathPlaceDelegate?.didPressOnPathPlace(place)
    }
}

