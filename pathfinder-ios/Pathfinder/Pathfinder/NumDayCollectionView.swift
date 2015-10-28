//
//  NumDayCollectionView.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/21/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class NumDayCollectionView: UICollectionView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numDays
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCell", forIndexPath: indexPath) as! DayCollectionViewCell
        cell.numDayLabel.textColor = AppTheme.Color.TextDefault
        cell.numDayLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20.0)
        cell.numDayLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DayCollectionViewCell
        collectionView.setContentOffset(CGPointMake(cell.center.x - collectionView.frame.size.width * 0.5, cell.frame.origin.y), animated: true)
        
        
        cell.numDayLabel.textColor = AppTheme.Color.Brand
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DayCollectionViewCell
        cell.numDayLabel.textColor = AppTheme.Color.TextDefault
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 40, height: 50) // The size of one cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let frame : CGRect = self.view.frame
        let margin  = (frame.width / 2) - 36
        return UIEdgeInsetsMake(0, margin, 0, margin) // margin between cells
    }

    
}
