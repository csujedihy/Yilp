//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
    var pageOffset: Int = 0
    let pageLimit: Int = 10
    var filteredCategories = [String]()
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height + 50
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                Business.searchWithTerm("Restaurants", offset: pageOffset, limit: pageLimit, sort: nil, categories: filteredCategories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
                    if let businesses = businesses {
                        self.filteredData += businesses
                        self.pageOffset += businesses.count

                    }
                    self.tableView.reloadData()
                    self.isMoreDataLoading = false
                    self.loadingMoreView!.stopAnimating()
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
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
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    
        
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        self.navigationItem.titleView = searchBar
        
        
        Business.searchWithTerm("Restaurants", offset: pageOffset, limit: pageLimit, sort: nil, categories: filteredCategories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            if let businesses = businesses {
                self.businesses = businesses
                self.filteredData += self.businesses
                self.tableView.reloadData()
                self.pageOffset += self.filteredData.count
            }
            
        }
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = filteredData[indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
        
        } else if segue.identifier == "showMapSegue" {
            let mapViewController = segue.destinationViewController as! MapViewController
            mapViewController.businesses = self.filteredData
            
            
        
        }
        
    }
    
    func filtersView(filtersView: FiltersViewController, didUpdateFilters filters: [String : AnyObject], rawFiltersStates: [Int: Bool]) {
        if let categories = filters["categories"] as? [String] {
            self.pageOffset = 0
            filteredCategories = categories
            currentFilterStates = rawFiltersStates
            // since this is filter, we should clear the the array that stores all business object first and then inject all filtered data here
            Business.searchWithTerm("Restaurants", offset: pageOffset, limit: pageLimit, sort: nil, categories: categories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
                if let businesses = businesses {
                    self.filteredData = [Business]()
                    self.businesses = businesses
                    self.filteredData += businesses
                    self.pageOffset += businesses.count
                } else {
                    self.filteredData = [Business]()
                }
                self.tableView.reloadData()

                
            }
        }

    }


}
