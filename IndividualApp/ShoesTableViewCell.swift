//
//  ShoesTableViewCell.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/15/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit

class ShoesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shoeBrandLabel: UILabel!
    @IBOutlet weak var shoeImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
