//
//  CalendarViewController.swift
//  myRecipe
//  
//  Created by Yaqi Ji on 11/19/17.
//  Copyright © 2017 Recipe. All rights reserved.
//

import Foundation
import JTAppleCalendar

class CalendarViewController: UIViewController {
    @IBOutlet var calendarView: JTAppleCalendarView?
    @IBOutlet var year: UILabel!
    @IBOutlet var month: UILabel!

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet var foodPic: UIImageView!
    @IBOutlet var foodCalories: UILabel!
    
    //default selection: breakfast
    var selectionStatus = "b"
    var selectedDate = Date()
    
    @IBAction func selectMeal(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                selectionStatus = "b"
                break
            case 1:
                selectionStatus = "l"
                break
            case 2:
                selectionStatus = "d"
                break
            default:
                break
            }
        updateMeal(status: selectionStatus, date: selectedDate)
        }
    
    func updateMeal(status: String, date: Date){
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.string(from: date)
        for (day, meals) in dailyMealStorage {
            if (day == date) {
                switch status {
                case "b":
                    foodName.text = meals.Breakfast
                    print("date "+date)
                    break
                case "l":
                    foodName.text = meals.Lunch
                    break
                case "d":
                    foodName.text = meals.Dinner
                    break
                default:
                    break
                }
            }
        }
        for (day, images) in dailyMealImageStorage {
            if (day == date) {
                switch status {
                case "b":
                    foodPic.image = images.Breakfast
                    break
                case "l":
                    foodPic.image = images.Lunch
                    break
                case "d":
                    foodPic.image = images.Dinner
                    break
                default:
                    break
                }
            }
        }
        for (day, caloriess) in dailyMealCaloriesStorage {
            if (day == date) {
                switch status {
                case "b":
                    foodCalories.text = "\(caloriess.Breakfast)" + " cal"
                    break
                case "l":
                    foodCalories.text = "\(caloriess.Lunch)" + " cal"
                    break
                case "d":
                    foodCalories.text = "\(caloriess.Dinner)" + " cal"
                    break
                default:
                    break
                }
            }
        }
    }
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView?.selectDates([Date()])
        year.text = "2017"
        month.text = "December"
        //update today's meal
        updateMeal(status: selectionStatus,date:selectedDate)
    }
    
    func handleCelltextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else {return}
        if cellState.isSelected {
            validCell.dateLabel.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = UIColor.black
            } else {
                validCell.dateLabel.textColor = UIColor.lightGray
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale

        let startDate = formatter.date(from: "2017 12 01")!
        let endDate = formatter.date(from: "2018 12 31")!

        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        handleCelltextColor(view: cell, cellState: cellState)
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        return
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("selected")
        //select a cell
        guard let validCell = cell as? CalendarCell else {return}
        handleCelltextColor(view: cell, cellState: cellState)
        validCell.selectedView.isHidden = false
        //pass the selected date with default breakfast
        selectedDate = date
        updateMeal(status: selectionStatus, date: selectedDate)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        //deselect a cell after you select a new cell
        guard let validCell = cell as? CalendarCell else {return}
        handleCelltextColor(view: cell, cellState: cellState)
        validCell.selectedView.isHidden = true
        foodName.text = ""
        foodPic.image = UIImage(named: "noImage.png")
        foodCalories.text = ""
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
}
