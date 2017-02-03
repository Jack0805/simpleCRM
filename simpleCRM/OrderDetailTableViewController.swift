//
//  OrderDetailTableViewController.swift
//  simpleCRM
//
//  Created by jack on 19/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import Firebase


class OrderDetailTableViewController: UITableViewController {
    
    
    var customerid = ""
    var customername = ""
    var orderkey = ""
    var subtotal = 0.00
    var finished = false
    var products = [orderDetail]()
    
    
    
     func onClickMyButton(){
        
        performSegue(withIdentifier: "selectProduct", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let bt = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(onClickMyButton))
        if (finished == false){
        self.navigationItem.rightBarButtonItem = bt
        }
        //bt.isEnabled = false
        //bt.title = "+"
        let myref = FIRDatabase.database().reference().child("orders")
        
        let users = FIRAuth.auth()?.currentUser
        
        
        
        
        //self.tableView.tableFooterView = UIView()
        //self.tableView.tableFooterView?.addSubview(moveBT)
        //self.tableView.tableFooterView?.bringSubview(toFront: moveBT)
        //self.moveBT.clipsToBounds = true
        
        
        
        self.tableView.register(OrderDetailTableViewCell.self, forCellReuseIdentifier: "productlist")
        
        //self.title = customername
        self.title = orderkey
        
        print(customerid)
        
    
        
        myref.observe(.value,with: { (snapshot) in
            
            if !snapshot.exists(){return}
            
            if let Dict = snapshot.value as? NSDictionary {
                
                var pros = [orderDetail]()
                
                for each in Dict{
                    
                    if (each.key as! String == self.orderkey){
                        
                        myref.child(each.key as! String).child("products").observe(.value,with: { (snapshot) in
                            
                            if !snapshot.exists(){return}
                            
                            if let Dict1 = snapshot.value as? NSDictionary {
                                
                                for each1 in Dict1{
                                    
                                    let key = each1.key
                                    
                                    myref.child(each.key as! String).child("products").child(key as!String).observe(.value,with: { (snapshot2) in
                                        
                                        if !snapshot2.exists(){return}
                                        
                                        if let ProDict = snapshot2.value as? NSDictionary {
                                            
                                        /*self.products.append(orderDetail(productname: ProDict.value(forKey: "productname") as! String!,productquntity: ProDict.value(forKey: "productquntity") as! Int!,productprice: ProDict.value(forKey: "productprice") as! Double!,productsingleprice: ProDict.value(forKey: "productsingleprice") as! Double!))*/
                                            pros.append(orderDetail(productname: ProDict.value(forKey: "productname") as! String!,productquntity: ProDict.value(forKey: "productquntity") as! Int!,productprice: ProDict.value(forKey: "productprice") as! Double!,productsingleprice: ProDict.value(forKey: "productsingleprice") as! Double!, proid:key as! String))
                                            
                                            self.products = pros
                                            
                                            self.tableView.reloadData()
                                            print(self.products)
                                            
                                        }
                                    })
                                }


                                
                            }
                        })
                    }
                }
            }
        })

        
        //products.append(orderDetail(productname: "produt1",productquntity: 2,productprice: 200.00,productsingleprice: 100.00))
        
        //products.append(orderDetail(productname: "produt2",productquntity: 3,productprice: 300.00,productsingleprice: 100.00))
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
        return products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("OrderDetailTableViewCell", owner: self, options: nil)?.first as! OrderDetailTableViewCell
        
        cell.productname.text = products[indexPath.row].productname
        cell.quantity.text = String(products[indexPath.row].productquntity)
        cell.price.text = String(products[indexPath.row].productprice)

        // Configure the cell...

        return cell
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
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectProduct"{
        let controller = segue.destination as! ProductTableViewController
        controller.isfromaddproduct = true
        controller.orderid = orderkey
        controller.subtotla = subtotal
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("more button tapped")
           
            var productquan: UITextField?
            
            
            let dialogMessage = UIAlertController(title: "New Quantity", message: "Please enter following fields", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                
                //let random = FIRDatabase.database().reference().childByAutoId().key
                
           
                
                
                let quaninput = Int((productquan?.text)!)
                
                //self.add?["belong"] = self.users?.uid
                //var random = self.ref.childByAutoId().key
                
                let uid = self.products[indexPath.row].proid
                let newtotal = Double(quaninput!) * self.products[indexPath.row].productsingleprice
                self.subtotal = newtotal + self.subtotal
                //print(self.add)
                //self.myref.child(self.productOB[indexPath.row].pid).child("belong").setValue(self.users?.uid)
                FIRDatabase.database().reference().child("orders").child(self.orderkey).child("products").child(uid!).child("productquntity").setValue(quaninput)
                
             FIRDatabase.database().reference().child("orders").child(self.orderkey).child("products").child(uid!).child("productprice").setValue(newtotal)
                
                FIRDatabase.database().reference().child("orders").child(self.orderkey).child("subtotla").setValue(self.subtotal)
                
                
                
                
                //self.productOB.removeAll()
                //self.tableView.reloadData()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            dialogMessage.addTextField { (textField) -> Void in
                
                productquan = textField
                productquan?.text = "\(self.products[indexPath.row].productquntity!)"
                
            }
            
            
            
            
            self.present(dialogMessage, animated: true, completion: nil)
        }
        edit.backgroundColor = UIColor.blue
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("more button tapped")
            
            let dialogMessage = UIAlertController(title: "Delete Product", message: "Are you sure ?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
                //print("Delete button tapped")
                
                
                let deletekey = self.products[indexPath.row].proid
                let prototal = self.products[indexPath.row].productprice
                self.subtotal = self.subtotal - prototal!
                
                FIRDatabase.database().reference().child("orders").child(self.orderkey).child("products").child(deletekey!).removeValue()
                
                FIRDatabase.database().reference().child("orders").child(self.orderkey).child("subtotla").setValue(self.subtotal)
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
        
        return [edit, delete]
    }
    

}
