//
//  FunctionCell.swift
//  Yelp
//
//  Created by YiHuang on 2/11/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FunctionCell: UITableViewCell {
    
    @IBOutlet weak var functionIconView: UIImageView!

    
    @IBOutlet weak var functionNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
