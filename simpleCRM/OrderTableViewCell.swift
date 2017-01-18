//
//  OrderTableViewCell.swift
//  simpleCRM
//
//  Created by jack on 19/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var CNLable: UILabel!
    
    @IBOutlet weak var TimeLable: UILabel!
    @IBOutlet weak var SBLable: UILabel!
    @IBOutlet weak var PMLable: UILabel!
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
