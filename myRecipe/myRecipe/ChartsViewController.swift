//
//  ChartsViewController.swift
//  myRecipe
//
//  Created by zhiwei cheng on 11/19/17.
//  Copyright © 2017 Recipe. All rights reserved.
//

import UIKit
import ScrollableGraphView
class ChartsViewController: UIViewController,ScrollableGraphViewDataSource {
    
    @IBOutlet weak var sege: UISegmentedControl!
    var graphConstraints = [NSLayoutConstraint]()
    var graphView: ScrollableGraphView!
    @IBOutlet weak var canvas: UIView!
    var numberOfDataItems = 29
    
    lazy var darkLinePlotData1: [Double] = self.generateRandomData(self.numberOfDataItems, max: 12, shouldIncludeOutliers: false)
    lazy var darkLinePlotData2: [Double] =  self.generateRandomData(self.numberOfDataItems, max: 4, shouldIncludeOutliers: false)
    lazy var darkLinePlotData3: [Double] =  self.generateRandomData(self.numberOfDataItems, max: 65, shouldIncludeOutliers: false)
    
    
    // Labels for the x-axis
    lazy var xAxisLabels: [String] =  self.generateSequentialLabels(self.numberOfDataItems, text: "OCT")
    
    func label(atIndex pointIndex: Int) -> String {
        // Ensure that you have a label to return for the index
        return xAxisLabels[pointIndex]
    }
    private func generateSequentialLabels(_ numberOfItems: Int, text: String) -> [String] {
        var labels = [String]()
        for i in 0 ..< numberOfItems {
            labels.append("\(text) \(i+1)")
        }
        return labels
    }
    
    
    // Init
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView = setupGraph(self.view.frame)
        self.canvas.insertSubview(graphView, at:1)
        setupConstraints()
    }
    
    // Implementation for ScrollableGraphViewDataSource protocol
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        // Data for the graphs with a single plot
        case "one":
            return darkLinePlotData1[pointIndex]
        case "two":
            return darkLinePlotData2[pointIndex]
        case "three":
            return darkLinePlotData3[pointIndex]
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
            // Setup the line plot.
            let linePlot = LinePlot(identifier: "one")
            linePlot.lineWidth = 1
            linePlot.lineColor = UIColor.black
            linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
            
            linePlot.shouldFill = true
            linePlot.fillType = ScrollableGraphViewFillType.gradient
            linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
            linePlot.fillGradientStartColor = UIColor(red: 0x55, green: 0x55, blue: 0x55,alpha:1)
            linePlot.fillGradientEndColor = UIColor(red: 0x44, green: 0x44, blue: 0x44,alpha:1)
            
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
            referenceLines.absolutePositions = [2, 4, 6, 8, 10, 12]
            referenceLines.includeMinMax = false
            referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
            
            // Set up the warining line
            
            let warningLine = ReferenceLines()
            warningLine.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
            warningLine.referenceLineColor = UIColor.red.withAlphaComponent(0.2)
            warningLine.referenceLineLabelColor = UIColor.red
            warningLine.positionType = .absolute
            warningLine.absolutePositions = [6]
            warningLine.includeMinMax = false
            
            // Setup the graph
            graphView.backgroundFillColor = UIColor(red: 0x33, green: 0x33, blue: 0x33,alpha:1)
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
        }
        if(sege.selectedSegmentIndex == 1){
            // Setup the line plot.
            
            let linePlot = LinePlot(identifier: "two")
            linePlot.lineWidth = 1
            linePlot.lineColor = UIColor.black
            linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
            
            linePlot.shouldFill = true
            linePlot.fillType = ScrollableGraphViewFillType.gradient
            linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
            linePlot.fillGradientStartColor = UIColor(red: 0x55, green: 0x55, blue: 0x55,alpha:1)
            linePlot.fillGradientEndColor = UIColor(red: 0x44, green: 0x44, blue: 0x44,alpha:1)
            
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
            referenceLines.absolutePositions = [1, 2, 3, 4]
            referenceLines.includeMinMax = false
            
            referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
            
            // Setup the graph
            graphView.backgroundFillColor = UIColor(red: 0x33, green: 0x33, blue: 0x33,alpha:1)
            graphView.dataPointSpacing = 80
            graphView.shouldAnimateOnStartup = true
            graphView.shouldAdaptRange = true
            graphView.shouldRangeAlwaysStartAtZero = true
            graphView.rangeMax = 50
            
            // Add everything to the graph.
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



