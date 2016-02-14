//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
    let id: String?
    let name: String?
    let address: String?
    let phoneNumber: String?
    let imageURL: NSURL?
    let categories: String?
    let distance: String?
    let ratingImageURL: NSURL?
    let ratingLargeImageURL: NSURL?
    let reviewCount: NSNumber?
    let location: NSDictionary?
    let locationDisplayAddress: [String]?
    let timeStart: Int?
    let timeEnd: Int?
    
    
    init(dictionary: NSDictionary) {
        if let phoneNumber = dictionary["phone"] as? String {
            self.phoneNumber = phoneNumber
        } else {
            self.phoneNumber = nil
        }
        
        self.location = dictionary["location"] as? NSDictionary
        if let dict = self.location {
            self.locationDisplayAddress = dict["display_address"] as? [String]
        } else {
            self.locationDisplayAddress = nil
        }
        if let dealsDict = dictionary["deals"] as? NSDictionary {
            self.timeStart = dealsDict["time_start"] as? Int
            self.timeEnd = dealsDict["time_end"] as? Int
        } else {
            self.timeStart = nil
            self.timeEnd = nil
        }

        let largeImageUrlString = dictionary["rating_img_url_large"] as? String
    
        if let url = largeImageUrlString {
            self.ratingLargeImageURL = NSURL(string: url)
        } else {
            self.ratingLargeImageURL = nil
        }
    
        self.name = dictionary["name"] as? String
        self.id = dictionary["id"] as? String
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = NSURL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        self.address = address
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joinWithSeparator(", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = NSURL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    class func businesses(array array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, offset: Int?, limit: Int?, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, offset: offset, limit: limit, sort: sort, categories: categories, deals: deals, completion: completion)
    }

    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
    }
}
