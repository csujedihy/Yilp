//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {

    var searchBar: UISearchBar?
    var businesses = [Business]()
    var filteredData = [Business]()
    var currentFilterStates = [Int: Bool]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        searchBar?.resignFirstResponder()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if searchBar!.isFirstResponder() {
            return true
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Should figure this out what does it exactly mean
        tableView.rowHeight = UITableViewAutomaticDimension        
        tableView.estimatedRowHeight = 120
        searchBar = UISearchBar()
        searchBar?.sizeToFit()
        searchBar?.delegate = self
        let onTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        onTapGesture.delegate = self
        self.view.addGestureRecognizer(onTapGesture)
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        self.navigationItem.titleView = searchBar
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = self.businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = businesses
        } else {
            filteredData = businesses.filter({(business: Business) -> Bool in
                if business.name?.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = filteredData[indexPath.row]
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "filterSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.delegate = self
            filtersViewController.switchStates = currentFilterStates
        } else if segue.identifier == "detailSegue" {
            // sender
            let cell: BusinessCell = sender as! BusinessCell
            let detailPageController = segue.destinationViewController as! DetailPage
            detailPageController.businessId = cell.businessId
            detailPageController.business = cell.business
            print(cell.businessId)

        
        }
        
    }
    
    func filtersView(filtersView: FiltersViewController, didUpdateFilters filters: [String : AnyObject], rawFiltersStates: [Int: Bool]) {
        let categories = filters["categories"] as? [String]
        currentFilterStates = rawFiltersStates
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            
            self.filteredData = businesses
            self.tableView.reloadData()
        }
    }


}
