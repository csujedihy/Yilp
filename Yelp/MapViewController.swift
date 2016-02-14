//
//  MapViewController.swift
//  Yelp
//
//  Created by YiHuang on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var businesses = [Business]()
    let regionRadius: CLLocationDistance = 1000

    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func closeOnTap(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var index = 0
        for business in businesses {
            if let coordinate = business.location?["coordinate"] {
                let name: String = business.name! as String
                let location = business.location
                let displayAddress: String = (location!["display_address"] as! [String]).joinWithSeparator(", ")
                let annotation = BusinessOnMap(title: name,
                    locationName: displayAddress,
                    discipline: "Restuarant",
                    coordinate: CLLocationCoordinate2D(latitude: coordinate["latitude"] as! Double, longitude: coordinate["longitude"] as! Double))
                let initialLocatoin = CLLocation(latitude: coordinate["latitude"] as! Double, longitude: coordinate["longitude"] as! Double)
                if index == 0 {
                    centerMapOnLocation(initialLocatoin)
                }
                mapView.addAnnotation(annotation)
                index += 1
                
            }

        
        }
        // Do any additional setup after loading the view.
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
