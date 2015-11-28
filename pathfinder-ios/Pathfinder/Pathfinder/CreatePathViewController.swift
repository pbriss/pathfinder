//
//  CreatePathViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/4/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit
import THCalendarDatePicker

class CreatePathViewController: UIViewController, THDatePickerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var currentLocation: String?
    
    // Date selection variables
    var startDate = NSDate() // Default: today
    @IBOutlet weak var startDateButton: UIButton!
    
    @IBOutlet weak var createPathTableView: UITableView!
    var pathPlaces = [0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    func configureView() {
        if let location = currentLocation {
            navigationItem.title = location
        }
        
        startDateButton.setTitle("Today", forState: UIControlState.Normal)
        
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
        startDateButton.setTitle(formatter.stringFromDate(startDate), forState: UIControlState.Normal)
    }
    
    // MARK: - Actions (THDatePickerDelegate)
    
    @IBAction func selectStartDate(sender: AnyObject) {
        let startDatePicker = getDatePickerDefaults()
        startDatePicker.date = startDate
        presentSemiViewController(startDatePicker, withOptions: getSemiViewDefaults())
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? pathPlaces.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("PathPlaceCell", forIndexPath: indexPath) as! PathPlaceTableViewCell
        }
            
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("AddPathPlaceCell", forIndexPath: indexPath) as! AddPathPlaceTableViewCell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Actions (UITableViewDataSource)
    
    @IBAction func addPathPlace(sender: AnyObject) {
        pathPlaces.append(0)
        let newIndexPath = NSIndexPath(forRow: pathPlaces.count - 1 , inSection: 0)
        createPathTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        createPathTableView.scrollToRowAtIndexPath(newIndexPath, atScrollPosition: .Top, animated: true)
    }
}