//
//  OrderTableViewController.swift
//  simpleCRM
//
//  Created by jack on 18/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import Firebase
import ESPullToRefresh


var dic : Dictionary<String,Bool> = Dictionary()



struct orderDetail{
    
    var productname:String!
    var productquntity:Int!
    var productprice:Double!
    var productsingleprice:Double!
    var proid:String!
    
    init(productname:String!,productquntity:Int!,productprice:Double!,productsingleprice:Double!,proid:String!) {
        
        self.productname = productname
        self.productquntity = productquntity
        self.productprice = productprice
        self.productsingleprice = productsingleprice
        self.proid = proid
        
    }
    
}

struct orderObject{
    
    var customer:String!
    
    var payment:String!
    var subtotla:Double!
    var time:String!
    var complete:Bool!
    var customerid:String!
    //var orderid:String!
    
    //var products = [orderDetail]()
    
    init(customer:String!,payment:String!,subtotla:Double!,time:String!,complete:Bool!,customerid:String!) {
        
        self.customer = customer
        self.payment = payment
        self.subtotla = subtotla
        self.time = time
        self.complete = complete
        self.customerid = customerid
        //self.products = products
    }
    
    
}

//var displayfinishedorder = false

class OrderTableViewController: UITableViewController {
    

   
    
    @IBOutlet weak var myseg: UISegmentedControl!
    
    var add : Dictionary<String,String>? = Dictionary()
    
    var orders : Dictionary<String,orderObject> = Dictionary()
    var finishedorders: Dictionary<String,orderObject> = Dictionary()
    var customerkey = ""
    var customername = ""
    var orderid = ""
    var ordertotal = 0.00
    var finished = true
    var displayfinishedorder = false
    var celldic : Dictionary<String,Bool> = Dictionary()
    //var model = ModelData()
    //var test:Dictionary<String,[String]> = Dictionary()
    
    @IBAction func mysegClicked(_ sender: Any) {
        
        switch myseg.selectedSegmentIndex
        {
        case 0:
            
            self.displayfinishedorder = false
            print(self.displayfinishedorder)
            
            self.tableView.reloadData()
            
            //self.title = "123"
            
            
        case 1:
            
            //self.title = "321"
            self.displayfinishedorder = true
            print(self.displayfinishedorder)
            
            self.tableView.reloadData()
            
        default:
            //self.displayfinishedorder = false
            self.displayfinishedorder = false
            self.tableView.reloadData()
            break
        }
    }
    
    

    @IBAction func addorderaction(_ sender: Any) {
        
        performSegue(withIdentifier: "addorder", sender: self)
        
        /*var customer: UITextField?
        //var customerid: UITextField?
        var payment: UITextField?
        //var subtotla: UITextField?
        //var email: UITextField?
        
        
        let dialogMessage = UIAlertController(title: "New Order", message: "Please enter following fields", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            let fullnameinput = customer?.text
                
            let payment = payment?.text
            //let subtotla = subtotla?.text
            
            //let tempobject = orderObject(customer:fullnameinput,payment:payment,subtotla:0,time:"\(FIRServerValue.timestamp())",complete:false,customerid:"-KagZYlVPjAmeOxmjKup")
            
            let random = FIRDatabase.database().reference().childByAutoId().key
            //print(self.add)
            FIRDatabase.database().reference().child("orders").child(random).child("customer").setValue(fullnameinput)
            
            FIRDatabase.database().reference().child("orders").child(random).child("payment").setValue(payment)
            
            FIRDatabase.database().reference().child("orders").child(random).child("subtotla").setValue(0.00)
            
        FIRDatabase.database().reference().child("orders").child(random).child("time").setValue("January,05,2016")
            
            FIRDatabase.database().reference().child("orders").child(random).child("complete").setValue(false)
            
          FIRDatabase.database().reference().child("orders").child(random).child("customerid").setValue("-KagZYlVPjAmeOxmjKup")
            
            FIRDatabase.database().reference().child("orders").child(random).child("belong").setValue(FIRAuth.auth()?.currentUser?.uid)

            //self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        dialogMessage.addTextField { (textField) -> Void in
            
            customer = textField
            customer?.placeholder = "Type in customer name"
            
        }
        dialogMessage.addTextField { (textField) -> Void in
            
            payment = textField
            payment?.placeholder = "Type in payment method"
            
        }
        
        
        
        self.present(dialogMessage, animated: true, completion: nil)*/
        
    }
    
    func sortArray(){
        
        print(dic)
        
        for each in dic {
            
            FIRDatabase.database().reference().child("orders").child(each.key).child("complete").setValue(each.value)
            
            if each.value == true{
                orders.removeValue(forKey: each.key)
            } else {
                finishedorders.removeValue(forKey: each.key)
            }
            
            self.tableView.reloadData()
            
        }
        
        refreshControl?.endRefreshing()
        
    }
    override func viewDidLoad() {
        
        
        /*self.tableView.es_addPullToRefresh {
            
            [weak self] in
            
            for each in dic {
                
            FIRDatabase.database().reference().child("orders").child(each.key).child("complete").setValue(!each.value)
                
            self?.tableView.reloadData()
                
            }
            
            
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            //self?.tableView.es_stopPullToRefresh(ignoreDate: true)
            /// Set ignore footer or not
            self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }*/
        
        
        let myref = FIRDatabase.database().reference().child("orders")
        
        let users = FIRAuth.auth()?.currentUser
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(OrderTableViewController.sortArray), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
       
        //orders["first"] = nil as AnyObject? as! orderObject?
        //test["first"] = ["1","2"]
        self.tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "ordercell")
        
        myref.observe(.value,with: { (snapshot) in
            
            print(snapshot.exists())
            
            if !snapshot.exists(){
                return
            }
            else {
                print(snapshot)
            }
            
            if let ConctactDict = snapshot.value as? NSDictionary {
                
                for each in ConctactDict {
                    
                    let eachkey = each.key as! String
                    
                    let myref1 = FIRDatabase.database().reference().child("orders").child(eachkey)
                    
                    myref1.observe(.value,with: { (snapshot1) in
                        
                        if !snapshot1.exists(){return}
                        
                        if let OrderDetailDict = snapshot1.value as? NSDictionary {
                            
                           
                            
                            if (OrderDetailDict.value(forKey: "belong") as? String == users?.uid){
                                
                                if(OrderDetailDict.value(forKey: "complete") as! Bool == true) {
                                    
                                self.finishedorders[eachkey] = orderObject(customer:OrderDetailDict.value(forKey: "customer") as! String!,payment:OrderDetailDict.value(forKey: "payment") as! String!,subtotla:OrderDetailDict.value(forKey: "subtotla") as! Double,time:OrderDetailDict.value(forKey: "time") as! String!,complete:true,customerid:OrderDetailDict.value(forKey: "customerid") as! String!)
                                    self.tableView.reloadData()
                                }
                                
                                else{
                                    
                                self.orders[eachkey] = orderObject(customer:OrderDetailDict.value(forKey: "customer") as! String!,payment:OrderDetailDict.value(forKey: "payment") as! String!,subtotla:OrderDetailDict.value(forKey: "subtotla") as! Double,time:OrderDetailDict.value(forKey: "time") as! String!,complete:false,customerid:OrderDetailDict.value(forKey: "customerid") as! String!)
                                    print(self.orders)
                                    self.tableView.reloadData()
                                }
                                
                            }
                            
                        }
                        
                    })
                }
                
            }
            
        })
            
        //self.tableView.reloadData()
        

       
        //orders["first"]?.products = [orderDetail(productname: "produt1",productquntity: 2,productprice: 200.00,productsingleprice: 100.00)]
        

        //orders["first"] = orderObject(customer:"jackk",payment:"Alipay",subtotla:1000.00,time:"January,05,2016",complete:false,customerid:"asdadwd")

        //orders["second"] = orderObject(customer:"Mia",payment:"Paypel",subtotla:1220.00,time:"January,05,2016",complete:false,customerid:"asdadwd")
        
        //finishedorders["third"] = orderObject(customer:"Mark",payment:"Paypel",subtotla:1220.00,time:"January,05,2016",complete:false,customerid:"asdadwd")
        
        
        //orders["first"]?.products.append(orderDetail(productname:"produt1",productquntity:2,productprice:200.00,productsingleprice:100.00))
        

        
        //print("\(orders)")
        //print(test)
        //orders["first"] = orderObject(customer:"jack",payment:"Paypel",subtotla:1000.00,time:"2016",products:(orders["first"]?.products)!)
        
        //print(orders)

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
        if (!self.displayfinishedorder){

        
        return orders.count
            
        } else{
            
        return finishedorders.count
            
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! OrderTableViewCell
        
        let cell = Bundle.main.loadNibNamed("OrderTableViewCell", owner: self, options: nil)?.first as! OrderTableViewCell
        if (!self.displayfinishedorder){
            
        cell.CNLable.text = orders[Array(orders.keys)[indexPath.row]]?.customer
        cell.PMLable.text = orders[Array(orders.keys)[indexPath.row]]?.payment
        cell.SBLable.text = "\((orders[Array(orders.keys)[indexPath.row]]?.subtotla)!)"
        cell.TimeLable.text = orders[Array(orders.keys)[indexPath.row]]?.time
        cell.cellkey = Array(orders.keys)[indexPath.row]
        cell.completeswitch.setOn(true, animated: true)
        cell.isfinishe = false
        
        } else {
        cell.CNLable.text = finishedorders[Array(finishedorders.keys)[indexPath.row]]?.customer
        cell.PMLable.text = finishedorders[Array(finishedorders.keys)[indexPath.row]]?.payment
        cell.SBLable.text = "\((finishedorders[Array(finishedorders.keys)[indexPath.row]]?.subtotla)!)"
        cell.TimeLable.text = finishedorders[Array(finishedorders.keys)[indexPath.row]]?.time
        cell.cellkey = Array(finishedorders.keys)[indexPath.row]
        cell.completeswitch.setOn(false, animated: true)
        cell.isfinishe = true
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(!self.displayfinishedorder){
        
        self.customername = (orders[Array(orders.keys)[indexPath.row]]?.customer)!
        self.customerkey = (orders[Array(orders.keys)[indexPath.row]]?.customerid)!
        self.orderid = Array(orders.keys)[indexPath.row]
        self.ordertotal = (orders[Array(orders.keys)[indexPath.row]]?.subtotla)!
        self.finished = false
            
        } else {
            
        self.customerkey = (finishedorders[Array(finishedorders.keys)[indexPath.row]]?.customerid)!
        self.customername = (finishedorders[Array(finishedorders.keys)[indexPath.row]]?.customer)!
        self.orderid = Array(finishedorders.keys)[indexPath.row]
        self.ordertotal = (finishedorders[Array(finishedorders.keys)[indexPath.row]]?.subtotla)!
        self.finished = true

        }
        
        performSegue(withIdentifier: "Orderdetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Orderdetail"{
            
            //let controller = segue.destination as! DetailTableViewController
            let controller = segue.destination as! OrderDetailTableViewController
            
            /*let wordkey = contentkeys[(self.tableView.indexPathForSelectedRow?.section)!]
            
            if let wordvalue = content?[wordkey.lowercased()]{
                
                controller.Detailtitle = wordvalue[(self.tableView.indexPathForSelectedRow?.row)!].name // some issue here
                
                controller.tempInfo = self.tempInfo
                controller.key = wordvalue[(self.tableView.indexPathForSelectedRow?.row)!].uid
            }*/
            
            //controller.Detailtitle = pretitle
            
            controller.customerid = self.customerkey
            controller.customername = self.customername
            controller.orderkey = self.orderid
            controller.finished = self.finished
            controller.subtotal = self.ordertotal
            
            
        } else if segue.identifier == "addorder"{
            
            let controller = segue.destination as! ContactTableViewController
            controller.isfromaddorder = true
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
            
            let dialogMessage = UIAlertController(title: "Delete Order", message: "Are you sure ?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
                //print("Delete button tapped")
                var uid = ""
                if(!self.displayfinishedorder){
                    
                    uid = Array(self.orders.keys)[indexPath.row]

                    
                } else {
                    
                    
                    uid = Array(self.finishedorders.keys)[indexPath.row]

                    
                }
                
                
                 FIRDatabase.database().reference().child("orders").child(uid).removeValue()
                
                if(!self.displayfinishedorder){
                
                self.orders.removeValue(forKey: uid)
                } else {
                    self.finishedorders.removeValue(forKey: uid)

                }
                
                    
                 self.tableView.reloadData()
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                
                //print("Cancel button tapped")
            }
            
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
            
            
            
            
        } else if editingStyle == .insert {
            print("something")
        }
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
