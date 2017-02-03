//
//  ProductTableViewController.swift
//  simpleCRM
//
//  Created by jack on 31/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import Firebase

struct ProductObject{
    
    var productname: String!
    var productprice: Double!
    var productquan: Int!
    var pid:String!
    
    init(productname:String!,productprice:Double!,productquan:Int!,pid:String!){
        
        self.productname = productname
        self.productprice = productprice
        self.productquan = productquan
        self.pid = pid
    }
    
}

class ProductTableViewController: UITableViewController {
    

    
    var productOB = [ProductObject]()
    
    let myref = FIRDatabase.database().reference().child("products")
    
    let addref = FIRDatabase.database().reference().child("orders")
    
    var users = FIRAuth.auth()?.currentUser
    
    var isfromaddproduct = false
    //var isfromorderview = false
    var orderid = ""
    var subtotla = 0.00
    
    @IBAction func AddPro(_ sender: Any) {
        
        
        var productname: UITextField?
        var productprice: UITextField?
        var productquan: UITextField?

        
        let dialogMessage = UIAlertController(title: "New Product", message: "Please enter following fields", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            let random = FIRDatabase.database().reference().childByAutoId().key
            
             let productnameinput = productname?.text

            
            let priceinput = Double((productprice?.text)!)
            

            let quaninput = Int((productquan?.text)!)

            //self.add?["belong"] = self.users?.uid
            //var random = self.ref.childByAutoId().key
            //print(self.add)
            self.myref.child(random).child("belong").setValue(self.users?.uid)
            self.myref.child(random).child("productname").setValue(productnameinput)
            self.myref.child(random).child("productprice").setValue(priceinput)
            self.myref.child(random).child("productquan").setValue(quaninput)
            
            //self.productOB.removeAll()
            //self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        dialogMessage.addTextField { (textField) -> Void in
            
            productname = textField
            productname?.placeholder = "Type in product name"
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            productprice = textField
            productprice?.placeholder = "Type in price"
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            productquan = textField
            productquan?.placeholder = "Type in inventory"
            
        }

        
        
        
        self.present(dialogMessage, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(isfromaddproduct)
        self.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "product")
        
        myref.observe(.value,with: { (snapshot) in
            
            if !snapshot.exists(){return}
            
            if let productDict = snapshot.value as? NSDictionary {
                
                var obj = [ProductObject]()
                
                for each in productDict{
                    
                    let key = each.key as! String
                    
                    let anotherref = self.myref.child(key)
                    
                    anotherref.observe(.value,with: { (snapshot) in
                        
                        if !snapshot.exists(){return}
                        
                        if let myproductDict = snapshot.value as? NSDictionary {
                            
                            if (myproductDict.value(forKey: "belong") as? String == self.users?.uid) {
                                
                                let temobject = ProductObject(productname:myproductDict.value(forKey: "productname") as! String!,productprice:myproductDict.value(forKey: "productprice") as! Double!,productquan:myproductDict.value(forKey: "productquan") as! Int!,pid: key)                       
                                obj.append(temobject)
                                self.productOB = obj
                                
                                //self.tableView.reloadData()
                                
                                //print(self.productOB)
                            }
                            
                            self.tableView.reloadData()
                            
                        }
                    })
                    
                }
            }
            
        })
        
                    
                


        /*let producta = ProductObject(productname:"ProductA",productprice:99.99,productquan:100)
        let productb = ProductObject(productname:"ProductB",productprice:87.87,productquan:99)
        
        productOB.append(producta)
        productOB.append(productb)*/
        
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productOB.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        let cell = Bundle.main.loadNibNamed("ProductTableViewCell", owner: self, options: nil)?.first as! ProductTableViewCell
        
        
        
        cell.ProductName.text = productOB[indexPath.row].productname
        cell.ProductPrice.text = "\(productOB[indexPath.row].productprice!)"
        cell.ProductQuan.text = "\(productOB[indexPath.row].productquan!)"
        if(productOB[indexPath.row].productquan! == 0){
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.ProductName.textColor = UIColor.gray
        cell.ProductPrice.textColor = UIColor.gray
        cell.ProductQuan.textColor = UIColor.gray
        cell.dollar.textColor = UIColor.gray
        //cell.selectionStyle = UITableViewCellSelectionStyle.gray
        }
        

        // Configure the cell...

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.isfromaddproduct == true && self.productOB[indexPath.row].productquan != 0) {
            

                
                var quan: UITextField?
              
                
                
                let dialogMessage = UIAlertController(title: "Add Product", message: "Please enter following fields", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    
                    //let random = FIRDatabase.database().reference().childByAutoId().key
                    
                    
                    let proid = self.productOB[indexPath.row].pid
                    let proto = self.productOB[indexPath.row].productquan
                    let quaninput = Int((quan?.text)!)
                    let productname = self.productOB[indexPath.row].productname
                    let productprice = self.productOB[indexPath.row].productprice
                    let total = Double(quaninput!) * productprice!
                    self.subtotla = self.subtotla + total
                    //self.add?["belong"] = self.users?.uid
                    let random = FIRDatabase.database().reference().childByAutoId().key
                    
                    self.addref.child(self.orderid).child("products").child(random).child("productname").setValue(productname)
                self.addref.child(self.orderid).child("products").child(random).child("productsingleprice").setValue(productprice)
                    self.addref.child(self.orderid).child("products").child(random).child("productquntity").setValue(quaninput)
                    //self.addref.child(self.orderid).child("products").child(random).child("productquntity").setValue(quaninput)
                    self.addref.child(self.orderid).child("products").child(random).child("productprice").setValue(total)
                    self.addref.child(self.orderid).child("subtotla").setValue(self.subtotla)
                    self.myref.child(proid!).child("productquan").setValue(proto! - quaninput!)
                    //self.tableView.reloadData()
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    print("Cancel button tapped")
                }
                
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                
                dialogMessage.addTextField { (textField) -> Void in
                    
                    quan = textField
                    quan?.text = "1"
                }
                
                
                
                self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let dialogMessage = UIAlertController(title: "Delete Product", message: "Are you sure ?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
                //print("Delete button tapped")
                
                
                    let uid = self.productOB[indexPath.row].pid
                    
                    self.myref.child(uid!).removeValue()
                    
                    
                    tableView.reloadData()
                
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
    }*/
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
       
        
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("more button tapped")
            
            var productname: UITextField?
            var productprice: UITextField?
            var productquan: UITextField?
            
            
            let dialogMessage = UIAlertController(title: "New Product", message: "Please enter following fields", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                
                //let random = FIRDatabase.database().reference().childByAutoId().key
                
                let productnameinput = productname?.text
                
                
                let priceinput = Double((productprice?.text)!)
                
                
                let quaninput = Int((productquan?.text)!)
                
                
                
                //self.add?["belong"] = self.users?.uid
                //var random = self.ref.childByAutoId().key
                
                let uid = self.productOB[indexPath.row].pid
                //print(self.add)
            //self.myref.child(self.productOB[indexPath.row].pid).child("belong").setValue(self.users?.uid)
                self.myref.child(uid!).child("productname").setValue(productnameinput)
                self.myref.child(uid!).child("productprice").setValue(priceinput)
                self.myref.child(uid!).child("productquan").setValue(quaninput)
                
                
                //self.productOB.removeAll()
                //self.tableView.reloadData()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            dialogMessage.addTextField { (textField) -> Void in
                
                productname = textField
                productname?.text = self.productOB[indexPath.row].productname
                
            }
            dialogMessage.addTextField { (textField) -> Void in
                
                productprice = textField
                productprice?.text = "\(self.productOB[indexPath.row].productprice!)"
                
            }
            dialogMessage.addTextField { (textField) -> Void in
                
                productquan = textField
                productquan?.text = "\(self.productOB[indexPath.row].productquan!)"
                
            }
            
            
            
            
            self.present(dialogMessage, animated: true, completion: nil)
            
            
        }
        edit.backgroundColor = UIColor.blue
        
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //print("favorite button tapped")
            
            let dialogMessage = UIAlertController(title: "Delete Product", message: "Are you sure ?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
                //print("Delete button tapped")
                
                
                let uid = self.productOB[indexPath.row].pid
                
                self.myref.child(uid!).removeValue()
                
                
                tableView.reloadData()
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                
                //print("Cancel button tapped")
            }
            
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)

        }
        delete.backgroundColor = UIColor.red
        
        /*let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blue*/
        
 
        return [edit, delete]
        
    
        
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
