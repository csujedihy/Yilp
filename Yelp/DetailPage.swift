//
//  DetailPage.swift
//  Yelp
//
//  Created by YiHuang on 2/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DetailPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var business: Business!
    var businessId: String = ""
    var functionList: [String] = ["Directions", "Call"]
    var imageList: [String] = ["direction", "phone"]
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var rateImageView: UIImageView!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var hoursLabel: UILabel!
    
    
    @IBOutlet weak var functionTableView: UITableView!
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functionList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FunctionCell", forIndexPath: indexPath) as! FunctionCell
        cell.functionNameLabel.text = functionList[indexPath.row]
        cell.functionIconView.image = UIImage(named: imageList[indexPath.row])
        if indexPath.row == functionList.count - 1 {
            let seperator = UIView(frame: CGRect(x: 0.0, y: 0.0, width: functionTableView.bounds.size.width, height: 0.5))
            seperator.backgroundColor = UIColor.lightGrayColor()
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
        functionTableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: functionTableView.bounds.size.width, height: 0.01))


        functionTableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: functionTableView.bounds.size.width, height: 0.01))
        
        
        
        
        
//        if let thumbViewUrl = business.imageURL {
//            thumbView.setImageWithURL(thumbViewUrl)
//        }
//        addressLabel.text = business.address


        // Do any additional setup after loading the view.
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
