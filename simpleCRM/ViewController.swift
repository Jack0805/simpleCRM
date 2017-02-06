//
//  ViewController.swift
//  simpleCRM
//
//  Created by jack on 12/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    //let sugeID = "login"
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        FIRAuth.auth()!.addStateDidChangeListener(){
            
            auth,user in
            
            if user != nil {
                
                
                
                self.performSegue(withIdentifier: "mylogin", sender: nil)
                
                print("log in!")
                
            }
            else{
                print("Not log in!")
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func RegBt(_ sender: Any) {

        FIRAuth.auth()!.createUser(withEmail: username.text!, password: password.text!)
        { (user, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                print("user created fail!")
            }
            else{
                
                //self.performSegue(withIdentifier: "mylogin", sender: nil)
                
                
                print("user created!")
            }
        }
    }
    @IBAction func DidLogTouched(_ sender: Any) {

        FIRAuth.auth()!.signIn(withEmail: username.text!, password: password.text!)
        
        /*FIRAuth.auth()?.signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                print("Not log in!")
            }
            else{
                
                self.performSegue(withIdentifier: "mylogin", sender: nil)
                
                
                print("log in!")
                
            }
            
        }*/


    }
//FIRAuth.auth()!.signIn(withEmail: username.text!, password: password.text!)
}

/*extension ViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username{
            password.becomeFirstResponder()
        }
        
        if textField == password{
            textField.resignFirstResponder()
        }
        return true
    }
}*/

