//
//  CreatePathViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/4/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit
import Spring
import THCalendarDatePicker

class CreatePathViewController: UIViewController, THDatePickerDelegate, UITableViewDelegate, UITableViewDataSource, PathPlaceTableViewCellDelegate {
    
    var currentLocation: String?
    
    // Date selection variables
    var startDate = NSDate() // Default: today
    @IBOutlet weak var startDateButton: UIButton!
    
    @IBOutlet weak var createPathTableView: UITableView!

    var pathPlaces = [0]
    
    // Keeps track of selected place details being shown
    var selectedPlace: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    func configureView() {
        if let location = currentLocation {
            navigationItem.title = location
        }
        
        startDateButton.setTitle("Today", forState: UIControlState.Normal)
        
        //Set table attributes
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
            (cell as! PathPlaceTableViewCell).pathPlaceDelegate = self
            // We need to set the index path for the collection view inside the table view cell (which both have their own index path)
            (cell as! PathPlaceTableViewCell).tableViewCellIndexPath = indexPath
        }
            
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("AddPathPlaceCell", forIndexPath: indexPath) as! AddPathPlaceTableViewCell
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let aspectRatioHeight = tableView.frame.width * 9 / 16
        if indexPath.section == 0 {
            return aspectRatioHeight + 30
        }
        else {
            return aspectRatioHeight
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 && selectedPlace != nil {
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            let frame = tableView.rectForRowAtIndexPath(indexPath)
            let superFrame = tableView.convertRect(frame, toView: self.view)
            let aspectRatioHeight = tableView.frame.width * 9 / 16
            
            // Create a background mask to hide other view elements and allow image view to animate above it
            let maskFrame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            let maskView = UIView(frame: maskFrame)
            maskView.backgroundColor = UIColor.whiteColor()
            maskView.layer.zPosition = 1
            self.view.addSubview(maskView)
            
            // Create a "fake" image to scale and display which is then replaced by the actual image in showPlaceDetails (PlaceDetailsViewController)
            let imageFrame = CGRectMake(superFrame.origin.x, superFrame.origin.y, tableView.frame.width, aspectRatioHeight)
            let imageView = UIImageView(frame: imageFrame)
            imageView.contentMode = .ScaleAspectFill
            imageView.image = UIImage(named: "newyork.jpg")
            imageView.layer.zPosition = 2
            self.view.addSubview(imageView)
            
            SpringAnimation.springWithCompletion(0.7, animations: {
                
                imageView.frame = CGRectMake(0, 0, imageFrame.width, imageFrame.height)
                
                }, completion: { finished in
                    self.performSegueWithIdentifier("showPlaceDetails", sender: self)
            })
        }
    }
    
    // MARK: - PathPlaceTableViewCellDelegate
    
    func didPressOnPathPlace(place: Place) {
        selectedPlace = place
        let indexPath = place.orderInPath!
        self.tableView(createPathTableView, didSelectRowAtIndexPath: indexPath)
    }
    
    // MARK: - Actions (UITableViewDataSource)
    
    @IBAction func addPathPlaces(sender: AnyObject) {
        pathPlaces.append(0)
        let newIndexPath = NSIndexPath(forRow: pathPlaces.count - 1 , inSection: 0)
        createPathTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        createPathTableView.scrollToRowAtIndexPath(newIndexPath, atScrollPosition: .Top, animated: true)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showPlaceDetails" {
            (segue.destinationViewController as! PlaceDetailsViewController).currentPlace = selectedPlace
        }
    }
}