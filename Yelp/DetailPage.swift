//
//  DetailPage.swift
//  Yelp
//
//  Created by YiHuang on 2/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var business: Business!
    var businessId: String = ""
    var functionList: [String] = ["Directions", "Call"]
    var imageList: [String] = ["direction", "phone"]
    let regionRadius: CLLocationDistance = 1000
    weak var mapObj: BusinessOnMap?
    
    @IBOutlet weak var panalBelowMapContainAddress: UIView!
    @IBOutlet weak var addressBelowMap: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var functionTableView: UITableView!
        
    @IBOutlet weak var mapView: MKMapView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functionList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FunctionCell", forIndexPath: indexPath) as! FunctionCell
        cell.functionNameLabel.text = functionList[indexPath.row]
        print("row num \(indexPath.row) text \(cell.functionNameLabel.text)")
        cell.functionIconView.image = UIImage(named: imageList[indexPath.row])
        
        if true {
            let seperator = UIView(frame: CGRect(x: 0.0, y: 0.0, width: functionTableView.bounds.size.width, height: 1))
            seperator.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 243/255, alpha: 1.0)
            cell.addSubview(seperator)
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("businessId \(businessId)")
        nameLabel.text = business.name
        distanceLabel.text = business.distance
        reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        categoryLabel.text = business.categories
        rateImageView.setImageWithURL(business.ratingImageURL!)
        functionTableView.estimatedRowHeight = 42
        functionTableView.rowHeight = UITableViewAutomaticDimension
        functionTableView.dataSource = self
        functionTableView.delegate = self
        if #available(iOS 9, *) {
            functionTableView.cellLayoutMarginsFollowReadableWidth = false
        }
        let seperator = UIView(frame: CGRect(x: 0.0, y: 0.0, width: functionTableView.bounds.size.width, height: 1))
        seperator.backgroundColor = UIColor.lightGrayColor()
        functionTableView.tableFooterView = seperator
        functionTableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: functionTableView.bounds.size.width, height: 0.01))

        let location = business?.location
        if let coordinate = business?.location?["coordinate"] {
            let name: String = business.name! as String
            let displayAddress: String = (location!["display_address"] as! [String]).joinWithSeparator(", ")
            addressBelowMap.text = displayAddress
            let annotation = BusinessOnMap(title: name,
                locationName: displayAddress,
                discipline: "Restuarant",
                coordinate: CLLocationCoordinate2D(latitude: coordinate["latitude"] as! Double, longitude: coordinate["longitude"] as! Double))
            
            mapObj = annotation
            let initialLocatoin = CLLocation(latitude: coordinate["latitude"] as! Double, longitude: coordinate["longitude"] as! Double)
            centerMapOnLocation(initialLocatoin)
            mapView.addAnnotation(annotation)
        
        }
        
        
    }
    
//    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        let cell: FunctionCell = tableView.cellForRowAtIndexPath(indexPath) as! FunctionCell
//        print("delegate should hightlight")
////        cell.selectedBackgroundView = 
//        cell.backgroundColor = UIColor.blackColor()
//        return true
//    }
//    
//    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
//        let cell: FunctionCell = tableView.cellForRowAtIndexPath(indexPath) as! FunctionCell
//        cell.backgroundColor = UIColor.whiteColor()
//    
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: FunctionCell = tableView.cellForRowAtIndexPath(indexPath) as! FunctionCell
        cell.selected = false
        cell.backgroundColor = UIColor.whiteColor()
        if indexPath.row == 0 {
            mapObj?.openMapForPlace()
        } else if indexPath.row == 1 {
            if let phoneNumber = business?.phoneNumber {
                let url: NSURL = NSURL(string: "telprompt://\(phoneNumber)")!
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }

    
    func centerMapOnLocation(location: CLLocation) {
        let coordinaterRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinaterRegion, animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
