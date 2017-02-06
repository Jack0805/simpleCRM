//
//  SalesTrackViewController.swift
//  simpleCRM
//
//  Created by jack on 1/2/17.
//  Copyright © 2017 ke zhang. All rights reserved.
//

import UIKit
import ScrollableGraphView
import Firebase

class SalesTrackViewController: UIViewController {
    
    
    var graphView = ScrollableGraphView()
    var currentGraphType = GraphType.dark
    var graphConstraints = [NSLayoutConstraint]()
    
    var label = UILabel()
    var labelConstraints = [NSLayoutConstraint]()
    var month = ""
    // Data
    let numberOfDataItems = 29
    let myref = FIRDatabase.database().reference().child("orders")
    var users = FIRAuth.auth()?.currentUser
    
    lazy var data: [Double] = self.generateRandomData(self.numberOfDataItems, max: 10000)
    lazy var labels: [String] = self.generateSequentialLabels(self.numberOfDataItems, text: self.month)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let result = formatter.string(from: date)
        
        switch result {
        case "01":
            self.month = "Jan"
        case "02":
            self.month = "Feb"
        case "03":
            self.month = "Mar"
        case "04":
            self.month = "Ap"
        case "05":
            self.month = "May"
        case "06":
            self.month = "Jun"
        case "07":
            self.month = "July"
        case "08":
            self.month = "Aug"
        case "09":
            self.month = "Sep"
        case "10":
            self.month = "Oct"
        case "11":
            self.month = "Nov"
        default:
            self.month = "Dec"
        }
        graphView = ScrollableGraphView(frame: self.view.frame)
        graphView = createDarkGraph(self.view.frame)
        
        graphView.set(data: data, withLabels: labels)
        graphView.topMargin.add(50.54)
        graphView.bottomMargin.add(140.54)
        
        self.view.addSubview(graphView)
        //self.myview.addSubview(graphView)
        
        setupConstraints()
        
        addLabel(withText: "DARK (TAP HERE)")
    }
    
    func didTap(_ gesture: UITapGestureRecognizer) {
        
        currentGraphType.next()
        
        self.view.removeConstraints(graphConstraints)
        graphView.removeFromSuperview()
        
        switch(currentGraphType) {
        case .dark:
            addLabel(withText: "DARK")
            graphView = createDarkGraph(self.view.frame)
        case .dot:
            addLabel(withText: "DOT")
            graphView = createDotGraph(self.view.frame)
        case .bar:
            addLabel(withText: "BAR")
            graphView = createBarGraph(self.view.frame)
        case .pink:
            addLabel(withText: "PINK")
            graphView = createPinkMountainGraph(self.view.frame)
        }
        
        graphView.set(data: data, withLabels: labels)
        self.view.insertSubview(graphView, belowSubview: label)
        
        setupConstraints()
    }
    
    fileprivate func createDarkGraph(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame)
        
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        graphView.lineWidth = 1
        graphView.lineColor = UIColor.colorFromHex(hexString: "#777777")
        graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        graphView.shouldFill = true
        graphView.fillType = ScrollableGraphViewFillType.gradient
        graphView.fillColor = UIColor.colorFromHex(hexString: "#555555")
        graphView.fillGradientType = ScrollableGraphViewGradientType.linear
        graphView.fillGradientStartColor = UIColor.colorFromHex(hexString: "#555555")
        graphView.fillGradientEndColor = UIColor.colorFromHex(hexString: "#444444")
        
        graphView.dataPointSpacing = 80
        graphView.dataPointSize = 2
        graphView.dataPointFillColor = UIColor.white
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.numberOfIntermediateReferenceLines = 5
        graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        graphView.animationDuration = 1.5
        graphView.rangeMax = 10000
        graphView.shouldRangeAlwaysStartAtZero = true
        
        return graphView
    }
    
    private func createBarGraph(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame:frame)
        
        graphView.dataPointType = ScrollableGraphViewDataPointType.circle
        graphView.shouldDrawBarLayer = true
        graphView.shouldDrawDataPoint = false
        
        graphView.lineColor = UIColor.clear
        graphView.barWidth = 25
        graphView.barLineWidth = 1
        graphView.barLineColor = UIColor.colorFromHex(hexString: "#777777")
        graphView.barColor = UIColor.colorFromHex(hexString: "#555555")
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.numberOfIntermediateReferenceLines = 5
        graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        graphView.animationDuration = 1.5
        graphView.rangeMax = 50
        graphView.shouldRangeAlwaysStartAtZero = true
        
        return graphView
    }
    
    private func createDotGraph(_ frame: CGRect) -> ScrollableGraphView {
        
        let graphView = ScrollableGraphView(frame:frame)
        
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#00BFFF")
        graphView.lineColor = UIColor.clear
        
        graphView.dataPointSize = 5
        graphView.dataPointSpacing = 80
        graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
        graphView.dataPointLabelColor = UIColor.white
        graphView.dataPointFillColor = UIColor.white
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
        
        graphView.numberOfIntermediateReferenceLines = 9
        
        graphView.rangeMax = 50
        
        return graphView
    }
    
    private func createPinkMountainGraph(_ frame: CGRect) -> ScrollableGraphView {
        
        let graphView = ScrollableGraphView(frame:frame)
        
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#222222")
        graphView.lineColor = UIColor.clear
        
        graphView.shouldFill = true
        graphView.fillColor = UIColor.colorFromHex(hexString: "#FF0080")
        
        graphView.shouldDrawDataPoint = false
        graphView.dataPointSpacing = 20
        graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
        graphView.dataPointLabelColor = UIColor.white
        
        graphView.dataPointLabelsSparsity = 3
        
        graphView.referenceLineThickness = 1
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
        
        graphView.numberOfIntermediateReferenceLines = 1
        
        graphView.shouldAdaptRange = true
        
        graphView.rangeMax = 50
        
        return graphView
    }
    
    private func setupConstraints() {
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()
        
        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        
        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)
        
        //graphConstraints.append(heightConstraint)
        
        self.view.addConstraints(graphConstraints)
    }
    
    // Adding and updating the graph switching label in the top right corner of the screen.
    private func addLabel(withText text: String) {
        
        label.removeFromSuperview()
        label = createLabel(withText: text)
        label.isUserInteractionEnabled = true
        
        let rightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -20)
        
        let topConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 20)
        
        let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: label.frame.width * 1.5)
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap))
        label.addGestureRecognizer(tapGestureRecogniser)
        
        self.view.insertSubview(label, aboveSubview: graphView)
        self.view.addConstraints([rightConstraint, topConstraint, heightConstraint, widthConstraint])
    }
    
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        label.text = text
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        
        return label
    }
    
    // Data Generation
    private func generateRandomData(_ numberOfItems: Int, max: Double) -> [Double] {
        let calendar = Calendar.current
        let date = Date()
        
        // Calculate start and end of the current year (or month with `.month`):
        let interval = calendar.dateInterval(of: .month, for: date)!
        
        // Compute difference in days:
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let result = formatter.string(from: date)

        
        var data = [Double]()
        
        for _ in 0...days{
            
            data.append(0.00)
        }
        
        myref.observe(.value,with: { (snapshot) in
            
            
            if !snapshot.exists(){return}
            
            if let ConctactDict = snapshot.value as? NSDictionary {
                
          
                for each in ConctactDict{
                    
                    let eachkey = each.key as! String
                    let myref1 = FIRDatabase.database().reference().child("orders").child(eachkey)
                    
                    myref1.observe(.value,with: { (snapshot1) in
                        
                        if !snapshot1.exists(){return}
                        
                        if let OrderDetailDict = snapshot1.value as? NSDictionary {
                            
                            if (OrderDetailDict.value(forKey: "belong") as? String == self.users?.uid){
                                
                                let mymonth = OrderDetailDict.value(forKey: "time") as? String
                             
                                let mm = mymonth?.subString(start: 3, end: -1)
                                
                                if (mm == result){
                                    
                                let day = mymonth?.subString(start: 0, end: 2)
                                var myday = 0
                                if (day == "01"){
                                    myday = 1
                                } else if (day == "02"){
                                    myday = 2
                                } else if (day == "03"){
                                    myday = 3
                                } else if (day == "04"){
                                    myday = 4
                                } else if (day == "05"){
                                    myday = 5
                                } else if (day == "06"){
                                    myday = 6
                                } else if (day == "07"){
                                    myday = 7
                                } else if (day == "08"){
                                    myday = 8
                                } else if (day == "09"){
                                    myday = 9
                                } else {
                                    myday = Int(myday)
                                }
                                
                                let mydouble = OrderDetailDict.value(forKey: "subtotla") as? Double

                                    
                                data[myday-1] = data[myday-1] + mydouble!
                                    
                       
                                self.graphView.set(data: data, withLabels: self.labels)
                                }
                                
                                
                                
                            }
                            
                        }
                    })

                }
            }
        })
        
        print(data)

        /*for _ in 0 ..< days {
            
            
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(arc4random() % 100 < 10) {
                randomNumber *= 3
            }
            
            data.append(randomNumber)
        }*/
        return data
    }
    
    private func generateSequentialLabels(_ numberOfItems: Int, text: String) -> [String] {
        let calendar = Calendar.current
        let date = Date()
        
        // Calculate start and end of the current year (or month with `.month`):
        let interval = calendar.dateInterval(of: .month, for: date)!
        
        // Compute difference in days:
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!

        var labels = [String]()
        for i in 0 ..< days {
            labels.append("\(text) \(i+1)")
        }
        return labels
    }
    
    // The type of the current graph we are showing.
    enum GraphType {
        case dark
        case bar
        case dot
        case pink
        
        mutating func next() {
            switch(self) {
            case .dark:
                self = GraphType.bar
            case .bar:
                self = GraphType.dot
            case .dot:
                self = GraphType.pink
            case .pink:
                self = GraphType.dark
            }
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }


}

extension String {
    func subString(start: Int, end: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: end)
        
        let finalString = self.substring(from: startIndex)
        return finalString.substring(to: endIndex)
    }
}
