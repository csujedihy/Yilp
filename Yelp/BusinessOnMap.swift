//
//  Artwork.swift
//  Yelp
//
//  Created by YiHuang on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import MapKit

class BusinessOnMap: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func openMapForPlace() {
        
        let latitute: CLLocationDegrees =  self.coordinate.latitude
        let longitute: CLLocationDegrees =  self.coordinate.longitude
        
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        if let name = self.title {
            mapItem.name = "\(name)"
        } else {
            mapItem.name = "Name Unknown"
        }
        
        mapItem.openInMapsWithLaunchOptions(options)
        
    }
}