//
//  StartPathViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/4/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class StartPathViewController: UIViewController {

    @IBOutlet weak var dateButtonLabel: UIButton!
    @IBOutlet weak var radiusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New path"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showDatePicker(sender: AnyObject) {
        DatePickerDialog().show("Pick a start time?", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: UIDatePickerMode.DateAndTime) {
            (date) -> Void in
            
            // Format date/time -> MMM, D, YYYY, hh:mm AM|PM
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            formatter.timeStyle = .ShortStyle
            let dateString = formatter.stringFromDate(date)
            
            //Update button with selected date
            self.dateButtonLabel.setTitle("\(dateString)", forState: .Normal)
        }
    }

    @IBAction func updateRadius(sender: UISlider) {
        let currentValue = Int(sender.value)
        radiusLabel.text = "\(currentValue)mi."
    }
}
