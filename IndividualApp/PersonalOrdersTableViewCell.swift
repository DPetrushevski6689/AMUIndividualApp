//
//  PersonalOrdersTableViewCell.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/18/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit

class PersonalOrdersTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var recieverLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if langFlag == 1{
            statusTitleLabel.text = "Status:"
        }else if langFlag == 2{
            statusTitleLabel.text = "Статус:"
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
