//
//  ContactTableViewController.swift
//  simpleCRM
//
//  Created by jack on 12/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import Firebase

struct nameobject {
    var name:String!
    
    init(name:String) {
        self.name = name
    }
}

struct object{
    var name: String!
    var uid:String!
}

struct contactInfo{
    var address:String!
    var email:String!
    var phone:String!
    var other:String!
    var key:String!
}

/*struct tempname{
    var name:String!
    var downloaded:Bool!
    
    init(name:String,dowloaded:Bool = false){
        self.name = name
        self.downloaded = dowloaded
    }
}*/

var pretitle = ""
//var array = ["irue","maife jfieow"]

class ContactTableViewController: UITableViewController,UITextFieldDelegate{
    
    @IBOutlet weak var AddContactBT: UIBarButtonItem!
    
    let myref = FIRDatabase.database().reference().child("users")
    
    var users = FIRAuth.auth()?.currentUser
    
    //var tempInfo : Dictionary<String,contactInfo>? = Dictionary()
    
    var redraw = true
    
    //var array = [String]()
    //var array : Dictionary<String,String>? = Dictionary()
    
    var complete = false
    
    var isfromaddorder = false
 
    let wordIndexTitles = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    //var content : Dictionary<String,[String]>? = Dictionary()
    var content : Dictionary<String,[object]>? = Dictionary()
    var array : Dictionary<String,String>? = Dictionary()
    var tempInfo : Dictionary<String,contactInfo>? = Dictionary()
    var key = ""
    var contentkeys = [String]()
    var add : Dictionary<String,String>? = Dictionary()
    
    func putcontent(){
        
        
        array?.values.sorted(by: {$0 < $1})
        
        print(array)
        
        
        
        for each in wordIndexTitles{
            content?[each] = []
        }
        
        for each in wordIndexTitles{
            
        
        for eachString in array! {
            
            let Fletter = "\(eachString.value[eachString.value.startIndex])"
            
   
                
                if Fletter.lowercased() == each{
                    
                    //content?[each]?.append(eachString)
                    //content?[each]? = [object(name:eachString.value,uid:eachString.key)]
                    content?[each]?.append(object(name:eachString.value,uid:eachString.key))
                }
    
        }
            
        }
        
        contentkeys = [String]((content?.keys)!)
        contentkeys.sort{$0 < $1 }
        //print(content)
        
        
    }
    
    
    @IBAction func add(_ sender: Any) {
        
        var fullname: UITextField?
        var postition: UITextField?
        var address: UITextField?
        var phone: UITextField?
        var email: UITextField?
        
        let dialogMessage = UIAlertController(title: "New Contact", message: "Please enter following fields", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
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
            self.myref.child(self.myref.childByAutoId().key).setValue(self.add)
            
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        dialogMessage.addTextField { (textField) -> Void in
            
            fullname = textField
            fullname?.placeholder = "Type in Full name"
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            postition = textField
            postition?.placeholder = "Type in short description"
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            address = textField
            address?.placeholder = "Type in address"
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            phone = textField
            phone?.placeholder = "Type in your phone number"
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            
            email = textField
            email?.placeholder = "Type in email"
            
        }
        
        
        
        self.present(dialogMessage, animated: true, completion: nil)
        
        

        
    }
    
    @IBAction func Logout(_ sender: Any) {
        
         self.dismiss(animated:true,completion:nil)
    }
    
    
    /*@IBAction func logoutClicked(_ sender: Any) {
        
        self.dismiss(animated:true,completion:nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        
    
        
        
    }*/
    
 
   


    override func viewDidLoad() {
        super.viewDidLoad()
        //array.sort { $0 < $1 }
       //generateWordsDict()
        
        //print(content)
        print(users?.uid)
        
      
        
        let ref = FIRDatabase.database().reference().child("users")
        
        
        ref.observe(.value,with: { (snapshot) in
            
            var tt: Dictionary<String,String>? = Dictionary()
            
            if !snapshot.exists(){return}
            
            if let ConctactDict = snapshot.value as? NSDictionary {
                
                for each in ConctactDict{
                    
                    let test = each.key as! String
                    //tempInfo?[test]? = contactInfo(address:"",email:"",phone:"",other:"")
                   
                    let rref = FIRDatabase.database().reference().child("users").child(test)
                    
                    rref.observe(.value,with: { (snapshot1) in
                        
                        if !snapshot1.exists(){return}
                        
                        if let ConctactDetailDict = snapshot1.value as? NSDictionary {
                            
                            if (ConctactDetailDict.value(forKey: "belong") as? String == self.users?.uid){
                                
                                self.tempInfo?[test] = contactInfo()
                                
                                tt?[test] = (ConctactDetailDict.value(forKey: "name") as? String)!
                                //tt.append((ConctactDetailDict.value(forKey: "name") as? String)!)
            
                                
                                self.tempInfo?[test]? = contactInfo(address:(ConctactDetailDict.value(forKey: "address") as? String)!,email:(ConctactDetailDict.value(forKey: "email") as? String)!,phone:(ConctactDetailDict.value(forKey: "phone") as? String)!,other:(ConctactDetailDict.value(forKey: "position") as? String)!,key:test)
                                self.key = test

                                
                                self.array = tt
                                self.putcontent()
                                self.tableView.reloadData()
                                print(self.array)
                                //print(self.tempInfo?[test])
                                
                            }
                        }
                    })
                }
                print("2")
            }
            print("3")
        })
        
        
        
   
        //putcontent()
        print("ViewDidLoad")
        
      
        



        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // numberOfSectionsInTableView returns number of sections in table. In will be count of our sections array.
        return content!.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contentkeys[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let wordkey = contentkeys[section]
        if let wordsValues = content?[wordkey]{
            return wordsValues.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        

        
        let wordkey = contentkeys[indexPath.section]
        if let wordvalue = content?[wordkey.lowercased()]{
            cell.textLabel?.text = wordvalue[indexPath.row].name // some issue here
        }
        
        return cell
    }
    
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contentkeys
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = contentkeys.index(of:title) else {
            return -1
        }
        return index
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
       
        let wordkey = contentkeys[indexPath.section]
        
        if let wordvalue = content?[wordkey.lowercased()]{
            
            pretitle = wordvalue[indexPath.row].name
            
            print(wordvalue[indexPath.row].uid)
            
            if (self.isfromaddorder == true){
                
                var payment: UITextField?
                
         
               
                
                let dialogMessage = UIAlertController(title: "New Order", message: "Please enter following fields", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Create", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    
                    if let paymentinput = payment?.text {
                        //print("User entered \(fullnameinput)")
                        let random = FIRDatabase.database().reference().childByAutoId().key
                        
                        FIRDatabase.database().reference().child("orders").child(random).child("customer").setValue(wordvalue[indexPath.row].name)
                        
                        FIRDatabase.database().reference().child("orders").child(random).child("payment").setValue(paymentinput)
                        
                        FIRDatabase.database().reference().child("orders").child(random).child("subtotla").setValue(0.00)
                        
                        FIRDatabase.database().reference().child("orders").child(random).child("time").setValue("January,05,2016")
                        
                        FIRDatabase.database().reference().child("orders").child(random).child("complete").setValue(false)
                        
                        FIRDatabase.database().reference().child("orders").child(random).child("customerid").setValue(wordvalue[indexPath.row].uid)
                        
                        FIRDatabase.database().reference().child("orders").child(random).child("belong").setValue(FIRAuth.auth()?.currentUser?.uid)
                        
                        
                    }
                    
                    
                    
                    self.tableView.reloadData()
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    print("Cancel button tapped")
                }
                
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                
                dialogMessage.addTextField { (textField) -> Void in
                    
                    payment = textField
                    payment?.placeholder = "Payment method"
                    
                }
                
                
                
                self.present(dialogMessage, animated: true, completion: nil)
            }
            
            
            // some issue here
        }
        
  
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "GotoDetail" && self.isfromaddorder == false){
            
        //let controller = segue.destination as! DetailTableViewController
        let controller = segue.destination as! DetailViewController
            
            
        let wordkey = contentkeys[(self.tableView.indexPathForSelectedRow?.section)!]
            
        if let wordvalue = content?[wordkey.lowercased()]{
                
                controller.Detailtitle = wordvalue[(self.tableView.indexPathForSelectedRow?.row)!].name // some issue here
            
                controller.tempInfo = self.tempInfo
                controller.key = wordvalue[(self.tableView.indexPathForSelectedRow?.row)!].uid
            }
        
        //controller.Detailtitle = pretitle
            
        }

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let dialogMessage = UIAlertController(title: "Delete Contact", message: "Are you sure ?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
                //print("Delete button tapped")
                
                let wordkey = self.contentkeys[indexPath.section]
                
                if let wordvalue = self.content?[wordkey.lowercased()]{
                    
                    let uid = wordvalue[indexPath.row].uid
                    
                    self.myref.child(uid!).removeValue()
                    
                    
                    tableView.reloadData()
                }
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                
                //print("Cancel button tapped")
            }
            
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)


            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier{
            if ident == "GotoDetail"{
                
                if (self.isfromaddorder == true){
                    return false
                }
            }
        }
        
        return true
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
