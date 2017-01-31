//
//  OrderDetailTableViewCell.swift
//  simpleCRM
//
//  Created by jack on 19/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var productname: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var dollar: UILabel!
    
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
