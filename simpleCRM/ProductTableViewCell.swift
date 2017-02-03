//
//  ProductTableViewCell.swift
//  simpleCRM
//
//  Created by jack on 31/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import Firebase



class ProductTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var ProductName: UILabel!
    
    @IBOutlet weak var ProductPrice: UILabel!
    
    
    @IBOutlet weak var ProductQuan: UILabel!
    
    @IBOutlet weak var dollar: UILabel!
    
   
    
  
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
