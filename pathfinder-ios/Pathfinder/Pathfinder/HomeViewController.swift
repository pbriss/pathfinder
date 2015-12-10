//
//  HomeViewController.swift
//  Pathfinder
//
//  Created by Pascal Brisset on 10/2/15.
//  Copyright © 2015 Pascal Brisset. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var locationTableView: UITableView!
    
    var locations: [Location] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        let query = Location.query()!
        query.limit = 10
        query.whereKeyExists("pictures")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.locations.appendContentsOf(objects as! [Location])
                self.locationTableView.reloadData()
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureView() {
        
        //Set logo in nav
        navigationItem.title = String.icomoonWithName(Icomoon.Logo)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.icomoonOfSize(24),  NSForegroundColorAttributeName: AppTheme.Color.Brand]
//        
        //Set table attributes
        self.locationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as! LocationTableViewCell
        
        let location = locations[indexPath.row]
        cell.configureCell(location, indexPath: indexPath)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let aspectRatioHeight = tableView.frame.width * 9 / 16
        return aspectRatioHeight
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let highlightView = UIView()
        highlightView.backgroundColor = AppTheme.Color.Brand
        cell?.selectedBackgroundView = highlightView
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCreatePath" {
            if let indexPath = locationTableView.indexPathForSelectedRow {
                let location = locations[indexPath.row]
                (segue.destinationViewController as! CreatePathViewController).currentLocation = location.name
            }
        }
    }
    

}
