//
//  UserOrdersTableViewCell.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/18/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit

class UserOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var sellerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if langFlag == 1{
            sellerTitle.text = "Seller:"
        }else if langFlag == 2{
            sellerTitle.text = "Праќач:"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
