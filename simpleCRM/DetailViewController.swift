//
//  DetailViewController.swift
//  simpleCRM
//
//  Created by jack on 16/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    var Detailtitle = ""
    var key = ""
    var tempInfo : Dictionary<String,contactInfo>? = Dictionary()

    @IBOutlet weak var DetailImage: UIImageView!
    
    @IBOutlet weak var DetailName: UILabel!
    
    @IBOutlet weak var DetailPosition: UILabel!
    
    @IBOutlet weak var DetailAddress: UILabel!
    
    @IBOutlet weak var DetailPhone: UILabel!
    
    @IBOutlet weak var DetailEmail: UILabel!
    
    @IBOutlet weak var MapBT: UIButton!
    
    @IBOutlet weak var SMSBT: UIButton!
    
    @IBOutlet weak var CallBT: UIButton!
    
    @IBOutlet weak var EmailBT: UIButton!
    
    @IBOutlet weak var OrderBT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference().child("users").child(self.key)
        
        ref.observe(.value,with: { (snapshot1) in
            
            if !snapshot1.exists(){return}
            
            if let DetailDic = snapshot1.value as? NSDictionary {
                
                print(DetailDic)
                
                self.DetailName.text = DetailDic.value(forKey: "name") as! String?
                self.DetailPosition.text = DetailDic.value(forKey: "position") as! String?
                self.DetailAddress.text = DetailDic.value(forKey: "address") as! String?
                self.DetailEmail.text = DetailDic.value(forKey: "email") as! String?
                self.DetailPhone.text = DetailDic.value(forKey: "phone") as! String?

            }
        })
        
        
        
        
        /*DetailName.text = Detailtitle
        DetailPosition.text = tempInfo?[self.key]?.other
        DetailAddress.text = tempInfo?[self.key]?.address
        DetailEmail.text = tempInfo?[self.key]?.email
        DetailPhone.text = tempInfo?[self.key]?.phone*/
        
        //print(tempInfo)
        //print(self.key)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
