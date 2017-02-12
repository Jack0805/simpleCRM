//
//  PieChartViewController.swift
//  simpleCRM
//
//  Created by jack on 7/2/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import CSPieChart
import Firebase

struct allproducts{
    var name:String!
    var totalqun:Int!

    
    init(name:String!,totalqun:Int!) {
        self.name = name
        self.totalqun = totalqun
   
    }
}

class PieChartViewController: UIViewController {

    @IBOutlet weak var pieChart: CSPieChart!
    
    @IBOutlet weak var percentage: UILabel!
    let myref = FIRDatabase.database().reference().child("orders")
    let myproref = FIRDatabase.database().reference().child("products")
    var users = FIRAuth.auth()?.currentUser
    //var pp = [allproducts]()
    var pp:Dictionary<String,allproducts> = Dictionary()
    var to = 0
    
    var dataList = [
        CSPieChartData(title: "test1", value: 20)
      
    ]
    
    //var dataList = [CSPieChartData]()
    
    //var dataList:Dictionary<String,CSPieChartData> = Dictionary()
    
    var colorList: [UIColor] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .magenta
    ]
    
    var subViewList: [UIView] = []
    
    func setdata(){
        
        for each in pp{
            if (each.value.totalqun != 0){
            let i = each.value.totalqun
            dataList.append(CSPieChartData(title: each.value.name, value: Double(i!)))
            print(dataList)
            }
            
        }
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myproref.observe(.value,with: { (snapshot) in
            
            
            if !snapshot.exists(){return}
            
            if let ConctactDict = snapshot.value as? NSDictionary {
                
                for each in ConctactDict{
                    
                    let key = each.key as! String
                    
                    let proref = self.myproref.child(key)
                    
                    proref.observe(.value,with: { (snapshot) in
                        
                        
                        if !snapshot.exists(){return}
                        
                        if let ConctactDict = snapshot.value as? NSDictionary {
                            
                            if (ConctactDict.value(forKey: "belong") as? String == self.users?.uid){
                                
                                let expample = allproducts(name:ConctactDict.value(forKey: "productname") as? String,totalqun:0)
                                
                                self.pp[key] = expample
                                
                                print(self.pp)
                                
                                self.myref.observe(.value,with: { (snapshot) in
                                    
                                    
                                    //if !snapshot.exists(){return}
                                    
                                    if let ConctactDict = snapshot.value as? NSDictionary {
                                        
                                        //print("here")
                                        
                                        for each in ConctactDict{
                                            
                                            let orderkey = each.key as! String
                                            
                                            let orderref = self.myref.child(orderkey)
                                            
                                            orderref.observe(.value,with: { (snapshot) in
                                                
                                                
                                                if !snapshot.exists(){return}
                                                
                                                if let ConctactDict = snapshot.value as? NSDictionary {
                                                    
                                                    //print("here")
                                                    
                                                    if (ConctactDict.value(forKey: "belong") as? String == self.users?.uid){
                                                        
                                                        //print("here")
                                                        
                                                        orderref.child("products").observe(.value,with: { (snapshot) in
                                                            
                                                            
                                                            if !snapshot.exists(){return}
                                                      
                                                            if let aConctactDict = snapshot.value as? NSDictionary {
                                                                
                                                                
                                                                for each in aConctactDict {
                                                                    
                                                                    let akey = each.key as! String
                                                                    
                                                                    orderref.child("products").child(akey).observe(.value,with: { (snapshot) in
                                                                        
                                                                        
                                                                        if !snapshot.exists(){return}
                                                                        
                                                                        if let bConctactDict = snapshot.value as? NSDictionary {
                                                                            
                                                                            if (bConctactDict.value(forKey: "productname") as? String == expample.name){
                                                                             //print("here")
                                                                             let a = self.pp[key]?.totalqun
                                                                             let b = bConctactDict.value(forKey: "productquntity") as? Int
                                                                             
                                                                             self.pp[key]?.totalqun = a! + b!
                                                                             self.to = self.to + a!
                                                                             //print(self.pp)
                                                                                
                                                                             self.setdata()
                                                                             print(self.pp)

                                                                             }
                                                                            
                                                                        }
                                                                        //self.setdata()
                                                                    })
                                                                    
                                                                }
                                                                
                                                                /*if (aConctactDict.value(forKey: "productname") as? String == expample.name){
                                                                    //print("here")
                                                                    let a = self.pp[key]?.totalqun
                                                                    let b = aConctactDict.value(forKey: "productquntity") as? Int
                                                                    
                                                                    self.pp[key]?.totalqun = a! + b!
                                                                    //print("here")
                                                                    //self.pp[key]?.totalqun = self.pp[key]?.totalqun as Int! + aConctactDict.value(forKey: "productquntity") as! Int!
                                                                }*/
                                                            }
                                                        })
                                                    }
                                                }
                                            })

                                            
                                        }
                                        
                                    }
                                })

                                
                            }
                            
                        }
                        
                    })

                    
                }
                
            }
            
        })
            


        // Do any additional setup after loading the view, typically from a nib.
        pieChart?.dataSource = self
        pieChart?.delegate = self
        
        pieChart?.pieChartRadiusRate = 0.6
        pieChart?.pieChartLineLength = 10
        pieChart?.seletingAnimationType = .scaleUp
        
        for each in dataList{
            
            let view = UILabel()
            view.text = each.title
            view.textAlignment = .center
            view.sizeToFit()
            subViewList.append(view)
            
        }
        


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

extension PieChartViewController: CSPieChartDataSource {
    func numberOfComponentData() -> Int {
        return dataList.count
    }
    
    func pieChartComponentData(at index: Int) -> CSPieChartData {
        return dataList[index]
    }
    
    func numberOfComponentColors() -> Int {
        return colorList.count
    }
    
    func pieChartComponentColor(at index: Int) -> UIColor {
        return colorList[index]
    }
    
    func numberOfLineColors() -> Int {
        return colorList.count
    }
    
    func pieChartLineColor(at index: Int) -> UIColor {
        return colorList[index]
    }
    
    func numberOfComponentSubViews() -> Int {
        return subViewList.count
    }
    
    func pieChartComponentSubView(at index: Int) -> UIView {
        return subViewList[index]
    }
}

extension PieChartViewController: CSPieChartDelegate {
    func didSelectedPieChartComponent(at index: Int) {
        let data = dataList[index]
        print(data.title)
        self.percentage.text = "\(data.value)%"
    }
}
