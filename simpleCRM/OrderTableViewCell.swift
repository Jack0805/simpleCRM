//
//  OrderTableViewCell.swift
//  simpleCRM
//
//  Created by jack on 19/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import Firebase

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var CNLable: UILabel!
    
    @IBOutlet weak var TimeLable: UILabel!
    @IBOutlet weak var SBLable: UILabel!
    @IBOutlet weak var PMLable: UILabel!
    
    @IBOutlet weak var completeswitch: UISwitch!
    
    
    
    var cellkey = ""
    var isfinishe = false
    
        //var cellDict: Dictionary<String,Bool> = Dictionary()
    
    /*@IBAction func switchclicked(_ sender: Any) {
        if completeswitch.isOn{
            print("\(cellkey) is on, \(isfinishe)")
        } else {
            print("\(cellkey) is off,\(isfinishe)")
        }
        
        FIRDatabase.database().reference().child("orders").child(cellkey).child("complete").setValue(!isfinishe)
        
        
        
    }*/
    @IBAction func `switch`(_ sender: Any) {
        
        if completeswitch.isOn{
            //print("\(cellkey) is on, \(isfinishe)")
            dic[cellkey] = false
      
            
        } else {
            //print("\(cellkey) is off,\(isfinishe)")
            dic[cellkey] = true

        }
        
        //cellDict[cellkey] = !isfinishe
        
        print(dic)
    }
    override func awakeFromNib() {
       
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    
        // Configure the view for the selected state
    }
    
}
