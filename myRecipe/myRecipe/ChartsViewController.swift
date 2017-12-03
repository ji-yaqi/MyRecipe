//
//  ChartsViewController.swift
//  myRecipe
//
//  Created by zhiwei cheng on 11/19/17.
//  Copyright © 2017 Recipe. All rights reserved.
//

import UIKit
import ScrollableGraphView
import JTAppleCalendar

class ChartsViewController: UIViewController,ScrollableGraphViewDataSource {
    
    @IBOutlet weak var sege: UISegmentedControl!
    var graphConstraints = [NSLayoutConstraint]()
    var graphView: ScrollableGraphView!
    @IBOutlet weak var canvas: UIView!
    var numberOfDataItems = 7
    let date = Date()
    let formatter = DateFormatter()
    func daily()->[Double]{
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        formatter.dateFormat = "yyyyMMdd"
        var res = [Double]()
        var check = false
        let thisDate = formatter.string(from: date)
        print(thisDate)
        res.append(0)
        res.append(0)

        for(day,meals) in dailyMealCaloriesStorage{
            if(day == thisDate){
                check = true
                print("break")
                res.append(Double(meals.Breakfast))
                res.append(Double(meals.Lunch))
                res.append(Double(meals.Dinner))
            }
        }
        if(check==false){
            res.append(0)
            res.append(0)
            res.append(0)
        }
        res.append(0)
        res.append(0)
        return res
        
    }
    func week() ->[Double]{
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        formatter.dateFormat = "yyyyMMdd"
        var res : [Double] = [0,0,0,0,0,0,0]
        let week6 = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let week5 = Calendar.current.date(byAdding: .day, value: -2, to: Date())
        let week4 = Calendar.current.date(byAdding: .day, value: -3, to: Date())
        let week3 = Calendar.current.date(byAdding: .day, value: -4, to: Date())
        let week2 = Calendar.current.date(byAdding: .day, value: -5, to: Date())
        let week1 = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        let w7 = formatter.string(from: date)
        let w6 = formatter.string(from: week6!)
        let w5 = formatter.string(from: week5!)
        let w4 = formatter.string(from: week4!)
        let w3 = formatter.string(from: week3!)
        let w2 = formatter.string(from: week2!)
        let w1 = formatter.string(from: week1!)

        for(day,meals) in dailyMealCaloriesStorage{
            if(day == w7){
                res[6] = Double(meals.Breakfast)+Double(meals.Lunch)+Double(meals.Dinner)
                print("gothere")
                print(res[6])
                //res.insert(Double(meals.Breakfast)+Double(meals.Lunch)+Double(meals.Dinner), at:6)
            }
            if(day == w6){
                res[5] = Double(meals.Breakfast)+Double(meals.Lunch)+Double(meals.Dinner)
            }
            if(day == w5){
               res[4] = Double(meals.Breakfast)+Double(meals.Lunch)+Double(meals.Dinner)
            }
            if(day == w4){
                res[3] = Double(meals.Breakfast)+Double(meals.Lunch)+Double(meals.Dinner)
            }
            if(day == w3){
                res[2] = Double(meals.Breakfast)+Double(meals.Lunch)+Double(meals.Dinner)
            }
            if(day == w2){
               res[1] = Double(meals.Breakfast)+Double(meals.Lunch)+Double(meals.Dinner)
            }
            if(day == w1){
                res[0] = Double(meals.Breakfast)+Double(meals.Lunch)+Double(meals.Dinner)
            }
        }
        /*
        if(check7==false){
            res.insert(0,at:6)
        }
        if(check6==false){
            res.insert(0,at:5)
        }
        if(check5==false){
            res.insert(0,at:4)
        }
        if(check4==false){
            res.insert(0,at:3)
        }
        if(check3==false){
            res.insert(0,at:2)
        }
        if(check2==false){
            res.insert(0,at:1)
        }
        if(check1==false){
            res.insert(0,at:0)
        }
 */
        print("add")
        print(res[6])
        return res
    }
    
   lazy var darkLinePlotData1: [Double] = daily()
   lazy var darkLinePlotData2: [Double] =  week()
    // Labels for the x-axis
    func month()->String{
        formatter.dateFormat = "MM"
        return formatter.string(from:date)
    }
    func day() -> String{
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    lazy var xAxisLabels: [String] =  self.generateSequentialLabels(self.numberOfDataItems, text: month())
    
    func label(atIndex pointIndex: Int) -> String {
        // Ensure that you have a label to return for the index
        return xAxisLabels[pointIndex]
    }
    private func generateSequentialLabels(_ numberOfItems: Int, text: String) -> [String] {
        var labels = [String]()
        for i in 0 ..< numberOfItems {
            labels.append(" ")
        }
        return labels
    }
    
    
    // Init
    override func viewDidLoad() {
        print("viewdid")
        super.viewDidLoad()
        graphView = setupGraph(self.view.frame)
        self.canvas.insertSubview(graphView, at:1)
        setupConstraints()
        self.reloadx()
        //self.reload()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("a")
    reloadx()
    }
    
    func reloadx(){
        print("inhere")
       darkLinePlotData1 = daily()
       darkLinePlotData2 = week()
      // self.canvas.insertSubview(graphView, at:1)
       //setupConstraints()
       print(darkLinePlotData1)
        print(darkLinePlotData2)
       graphView = setupGraph(self.view.frame)
       graphView.reload()
    }
    
    // Implementation for ScrollableGraphViewDataSource protocol
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        // Data for the graphs with a single plot
        case "one":
            return darkLinePlotData1[pointIndex]
        case "two":
            return darkLinePlotData2[pointIndex]
        default:
            return 0
        }
    }
    
    func numberOfPoints() -> Int {
        return numberOfDataItems
    }

    // Creating Dark Graphs
    func setupGraph(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        if(sege.selectedSegmentIndex == 0){
            let barPlot = BarPlot(identifier: "one")
            
            barPlot.barWidth = 25
            barPlot.barLineWidth = 1
            barPlot.barLineColor = UIColor.lightGray
            barPlot.barColor = UIColor.darkGray
            
            barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
            barPlot.animationDuration = 1.5
            
            // Setup the reference lines
            let referenceLines = ReferenceLines()
            
            referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
            referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
            referenceLines.referenceLineLabelColor = UIColor.white
            
            referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
            
            // Setup the graph
            graphView.backgroundFillColor = UIColor.gray
            
            graphView.shouldAnimateOnStartup = true
            
            graphView.rangeMax = 600
            graphView.rangeMin = 0
            
            // Add everything
            graphView.addPlot(plot: barPlot)
            graphView.addReferenceLines(referenceLines: referenceLines)
            return graphView
            /*
            // Setup the line plot.
            let linePlot = LinePlot(identifier: "one")
            linePlot.lineWidth = 1
            linePlot.lineColor = UIColor.black
            linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
            
            linePlot.shouldFill = true
            linePlot.fillType = ScrollableGraphViewFillType.gradient
            linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
            linePlot.fillGradientStartColor = UIColor.darkGray
            //linePlot.fillGradientStartColor = UIColor(red: 0x55, green: 0x55, blue: 0x55,alpha:1)
            linePlot.fillGradientEndColor = UIColor.gray
            
            linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
            
            let dotPlot = DotPlot(identifier: "one") // Add dots as well.
            dotPlot.dataPointSize = 2
            dotPlot.dataPointFillColor = UIColor.white
            
            dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
            
            // Setup the reference lines.
            let referenceLines = ReferenceLines()
            
            referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
            referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
            referenceLines.referenceLineLabelColor = UIColor.white
            
            referenceLines.positionType = .absolute
            // Reference lines will be shown at these values on the y-axis.
            referenceLines.absolutePositions = [100, 200, 300, 400, 500, 600]
            referenceLines.includeMinMax = false
            referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
            
            // Setup the graph
            graphView.backgroundFillColor = UIColor.lightGray
            graphView.dataPointSpacing = 80
            graphView.shouldAnimateOnStartup = true
            graphView.shouldAdaptRange = true
            graphView.shouldRangeAlwaysStartAtZero = true
            graphView.rangeMax = 50
            
            // Add everything to the graph.
            graphView.addReferenceLines(referenceLines: warningLine)
            graphView.addReferenceLines(referenceLines: referenceLines)
            graphView.addPlot(plot: linePlot)
            graphView.addPlot(plot: dotPlot)
            graphView.direction = ScrollableGraphViewDirection.rightToLeft
            //return graphView
 */
        }
        if(sege.selectedSegmentIndex == 1){
            // Setup the line plot.
            // Setup the line plot.
            let linePlot = LinePlot(identifier: "two")
            linePlot.lineWidth = 1
            linePlot.lineColor = UIColor.black
            linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
            
            linePlot.shouldFill = true
            linePlot.fillType = ScrollableGraphViewFillType.gradient
            linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
            linePlot.fillGradientStartColor = UIColor.darkGray
            //linePlot.fillGradientStartColor = UIColor(red: 0x55, green: 0x55, blue: 0x55,alpha:1)
            linePlot.fillGradientEndColor = UIColor.gray
            
            linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
            
            let dotPlot = DotPlot(identifier: "two") // Add dots as well.
            dotPlot.dataPointSize = 2
            dotPlot.dataPointFillColor = UIColor.white
            
            dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
            
            // Setup the reference lines.
            let referenceLines = ReferenceLines()
            
            referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
            referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
            referenceLines.referenceLineLabelColor = UIColor.white
            
            referenceLines.positionType = .absolute
            // Reference lines will be shown at these values on the y-axis.
            referenceLines.absolutePositions = [200, 400, 600, 800, 1000, 1200]
            referenceLines.includeMinMax = false
            referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
            
            // Setup the graph
            graphView.backgroundFillColor = UIColor.lightGray
            graphView.dataPointSpacing = 80
            graphView.shouldAnimateOnStartup = true
            graphView.shouldAdaptRange = true
            graphView.shouldRangeAlwaysStartAtZero = true
            graphView.rangeMax = 50
            
            // Add everything to the graph.
           // graphView.addReferenceLines(referenceLines: warningLine)
            graphView.addReferenceLines(referenceLines: referenceLines)
            graphView.addPlot(plot: linePlot)
            graphView.addPlot(plot: dotPlot)
            graphView.direction = ScrollableGraphViewDirection.rightToLeft
            //return graphView
        }
        return graphView
    }
    
    private func setupConstraints() {
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()
        
        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 150)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -100)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        
        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)
        
        //graphConstraints.append(heightConstraint)
        
        self.view.addConstraints(graphConstraints)
    }
    
    
    // Data Generation
    private func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(shouldIncludeOutliers) {
                if(arc4random() % 100 < 10) {
                    randomNumber *= 3
                }
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    @IBAction func segmentChanged(_ sender: Any) {
        print(sege.selectedSegmentIndex)
        graphView = setupGraph(self.view.frame)
        self.canvas.insertSubview(graphView, at:1000)
        setupConstraints()
    }
}



