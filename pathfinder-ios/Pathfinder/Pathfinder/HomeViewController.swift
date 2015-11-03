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
    
    var places: [Place] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        let query = PFQuery(className:"Place")
        query.orderByAscending("name")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    let placeName = object["name"] as! String
                    let placePicture = object["picture"] as! PFFile
                    placePicture.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            let place = Place(placeDict: ["name": placeName, "picture": imageData!])
                            self.places.append(place)
                            
                            self.locationTableView.reloadData()
                        }
                    }
                }
                
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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "logo-white")
        
        navigationItem.titleView = imageView
        
        //Set table attributes
        self.locationTableView.rowHeight = 200
        self.locationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as! LocationTableViewCell
        
        //Set cell content
        let place = places[indexPath.row]
        cell.titleLabel.text = place.name
        
        //Set cell background
        let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = place.picture
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        
        return cell
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
                let place = places[indexPath.row]
                (segue.destinationViewController as! CreatePathViewController).currentLocation = place.name
            }
        }
    }
    

}
