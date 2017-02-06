//
//  DetailViewController.swift
//  simpleCRM
//
//  Created by jack on 16/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController,UITextFieldDelegate {
    
    var Detailtitle = ""
    var key = ""
    var tempInfo : Dictionary<String,contactInfo>? = Dictionary()
    
    let myref = FIRDatabase.database().reference().child("users")
    
    var users = FIRAuth.auth()?.currentUser

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
    
    var add : Dictionary<String,String>? = Dictionary()
    
    @IBAction func personalorder(_ sender: Any) {
        
        
        
    }
    @IBAction func editClicked(_ sender: Any) {
        
        var fullname: UITextField?
        
        var postition: UITextField?
        var address: UITextField?
        var phone: UITextField?
        var email: UITextField?
        
        let dialogMessage = UIAlertController(title: "Edit", message: "Please enter following fields", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Update", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            if let fullnameinput = fullname?.text {
                //print("User entered \(fullnameinput)")
                self.add?["name"] = fullnameinput
            }
            
            if let positioninput = postition?.text {
                //print("User entered \(positioninput)")
                self.add?["position"] = positioninput
            }
            if let addressinput = address?.text {
                //print("User entered \(addressinput)")
                self.add?["address"] = addressinput
            }
            if let phoneinput = phone?.text {
                //print("User entered \(phoneinput)")
                self.add?["phone"] = phoneinput
            }
            if let emailinput = email?.text {
                //print("User entered \(emailinput)")
                self.add?["email"] = emailinput
            }
            
            self.add?["belong"] = self.users?.uid
            //var random = self.ref.childByAutoId().key
            //print(self.add)
            self.myref.child(self.key).setValue(self.add)
            
            //self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        dialogMessage.addTextField { (textField) -> Void in
            
            fullname = textField
            fullname?.text = self.DetailName.text
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            postition = textField
            postition?.text = self.DetailPosition.text
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            address = textField
            address?.text = self.DetailAddress.text
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            phone = textField
            phone?.text = self.DetailPhone.text
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            
            email = textField
            email?.text = self.DetailEmail.text
            
        }
        
        
        
        self.present(dialogMessage, animated: true, completion: nil)
        

        
    }
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "personalorder"{
            let controller = segue.destination as! OrderTableViewController
            controller.isfromcontact = true
            controller.contactkey = self.key
        }
    }
    

}
