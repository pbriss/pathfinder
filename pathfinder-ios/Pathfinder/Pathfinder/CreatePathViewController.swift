//
//  CreatePathViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/4/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit
import THCalendarDatePicker

class CreatePathViewController: UIViewController, THDatePickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var currentLocation: String?
    
    // Date selection variables
    var startDateIsBeingSet = false
    var startDate = NSDate() // Default: today
    var endDate = NSDate() // Default: today
    
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    
    // Num days selection variables
    var numDays = 1 // Default: 1 day
    @IBOutlet var numDaysSectionHeaderView: UIView!
    @IBOutlet weak var numDaysCollectionView: UICollectionView!
    
    @IBOutlet weak var createPathTableView: UITableView!
    var pathLocations = [0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    func configureView() {
        if let location = currentLocation {
            navigationItem.title = location
        }
        
        numDaysCollectionView.backgroundColor = UIColor.whiteColor()
        numDaysCollectionView.showsHorizontalScrollIndicator = false
        numDaysCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        startDateButton.setTitle("Today", forState: UIControlState.Normal)
        endDateButton.setTitle("Today", forState: UIControlState.Normal)
        
        //Set table attributes
        createPathTableView.rowHeight = 200
        createPathTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    lazy var formatter: NSDateFormatter = {
        // Format date -> MMM, D, YYYY
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter
    }()
    
    func getDatePickerDefaults() -> THDatePickerViewController {
        let dp = THDatePickerViewController.datePicker()
        dp.delegate = self
        dp.setAllowClearDate(false)
        dp.setClearAsToday(true)
        dp.setAutoCloseOnSelectDate(true)
        dp.setAllowSelectionOfSelectedDate(true)
        dp.setDisableHistorySelection(true)
        dp.setDisableFutureSelection(false)
        dp.setDisableYearSwitch(true)
        dp.selectedBackgroundColor = AppTheme.Color.Brand
        dp.currentDateColorSelected = UIColor.whiteColor()
        return dp
    }
    
    func getSemiViewDefaults() -> [String: Float] {
        return [
            convertCfTypeToString(KNSemiModalOptionKeys.parentScale) as String! : 0.75 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 0.4 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.parentAlpha) as String! : 0.8 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.2 as Float
        ]
    }
    
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        let value = Unmanaged<CFStringRef>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFStringRef
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    
    // MARK: - THDatePickerDelegate
    
    func datePickerDonePressed(datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func datePickerCancelPressed(datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func datePicker(datePicker: THDatePickerViewController!, selectedDate: NSDate!) {
        
        if startDateIsBeingSet {
            startDate = selectedDate
            
            startDateButton.setTitle(formatter.stringFromDate(startDate), forState: UIControlState.Normal)
            
            // If the selected start date is greater than the end date, we need to adjust and push the end date
            if startDate.isGreaterThanDate(endDate) {
                endDate = startDate
                endDateButton.setTitle(formatter.stringFromDate(endDate), forState: UIControlState.Normal)
            }
        }
        else {
            endDate = selectedDate
            endDateButton.setTitle(formatter.stringFromDate(endDate), forState: UIControlState.Normal)
        }
        
        // Update the num day collection view
        numDays = endDate.daysFrom(startDate) + 1 // +1 to include the selected end date
        numDaysCollectionView.reloadData()
    }
    
    
    // MARK: - Actions (THDatePickerDelegate)
    
    @IBAction func selectStartDate(sender: AnyObject) {
        let startDatePicker = getDatePickerDefaults()
        startDatePicker.date = startDate
        presentSemiViewController(startDatePicker, withOptions: getSemiViewDefaults())
        startDateIsBeingSet = true
    }
    
    @IBAction func selectEndDate(sender: AnyObject) {
        let endDatePicker = getDatePickerDefaults()
        endDatePicker.date = endDate
        
        endDatePicker.setDateRangeFrom(startDate.addDays(-1) , toDate: endDate)
        endDatePicker.setDateHasItemsCallback({(date:NSDate!) -> Bool in
            return date.isEqualToDate(self.startDate)
                || date.isEqualToDate(self.endDate)
                || (date.isGreaterThanDate(self.startDate) && date.isLessThanDate(self.endDate))
        })
        presentSemiViewController(endDatePicker, withOptions: getSemiViewDefaults())
        startDateIsBeingSet = false
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
        
        //collectionView.setContentOffset(CGPointMake(cell.center.x - collectionView.frame.size.width * 0.5, cell.frame.origin.y), animated: true)
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
        cell.numDayLabel.textColor = AppTheme.Color.Brand
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DayCollectionViewCell
        cell.numDayLabel.textColor = AppTheme.Color.TextDefault
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        let frame : CGRect = self.view.frame
//        let margin  = (frame.width / 2) - 40
        return UIEdgeInsetsMake(0, 0, 0, 200) // margin between cells
    }
    
    // MARK: - UIScrollViewDelegate

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        for uicell: UICollectionViewCell in numDaysCollectionView.visibleCells() {
            let cell = uicell as! DayCollectionViewCell
            if cell.selected {
                cell.numDayLabel.textColor = AppTheme.Color.TextDefault
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? pathLocations.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("PathLocationCell", forIndexPath: indexPath) as! PathLocationTableViewCell
        }
            
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("AddPathLocationCell", forIndexPath: indexPath) as! AddPathLocationTableViewCell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? numDaysSectionHeaderView.frame.height : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? numDaysSectionHeaderView : UIView()
    }
    
    
    // MARK: - Actions (UITableViewDataSource)
    
    @IBAction func addPathLocation(sender: AnyObject) {
        pathLocations.append(0)
//        createPathTableView.reloadData()
        let newIndexPath = NSIndexPath(forRow: pathLocations.count - 1 , inSection: 0)
        createPathTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        createPathTableView.scrollToRowAtIndexPath(newIndexPath, atScrollPosition: .Top, animated: true)
    }
}