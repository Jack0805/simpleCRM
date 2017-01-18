//
//  OrderTableViewController.swift
//  simpleCRM
//
//  Created by jack on 18/1/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit

struct orderDetail{
    
    var productname:String!
    var productquntity:Int!
    var productprice:Double!
    var productsingleprice:Double!
    
    init(productname:String!,productquntity:Int!,productprice:Double!,productsingleprice:Double!) {
        
        self.productname = productname
        self.productquntity = productquntity
        self.productprice = productprice
        self.productsingleprice = productsingleprice
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
    
    var products = [orderDetail]()
    
    init(customer:String!,payment:String!,subtotla:Double!,time:String!,complete:Bool!,customerid:String!,products:[orderDetail]) {
        
        self.customer = customer
        self.payment = payment
        self.subtotla = subtotla
        self.time = time
        self.complete = complete
        self.customerid = customerid
        self.products = products
    }
    
    
}

class OrderTableViewController: UITableViewController {
    

   

    
    var orders : Dictionary<String,orderObject> = Dictionary()
    var test:Dictionary<String,[String]> = Dictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //orders["first"] = nil as AnyObject? as! orderObject?
        //test["first"] = ["1","2"]
        self.tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "ordercell")
       
        //orders["first"]?.products = [orderDetail(productname: "produt1",productquntity: 2,productprice: 200.00,productsingleprice: 100.00)]
        orders["first"] = orderObject(customer:"jackk",payment:"Alipay",subtotla:1000.00,time:"January,05,2016",complete:false,customerid:"asdadwd",products:[orderDetail(productname: "produt1",productquntity: 2,productprice: 200.00,productsingleprice: 100.00)])
        
        //orders["first"]?.products.append(orderDetail(productname:"produt1",productquntity:2,productprice:200.00,productsingleprice:100.00))
        
        print("\(orders)")
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
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! OrderTableViewCell
        
        let cell = Bundle.main.loadNibNamed("OrderTableViewCell", owner: self, options: nil)?.first as! OrderTableViewCell
        
        cell.CNLable.text = orders[Array(orders.keys)[indexPath.row]]?.customer
        cell.PMLable.text = orders[Array(orders.keys)[indexPath.row]]?.payment
        cell.SBLable.text = "\((orders[Array(orders.keys)[indexPath.row]]?.subtotla)!)"
        cell.TimeLable.text = orders[Array(orders.keys)[indexPath.row]]?.time
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
