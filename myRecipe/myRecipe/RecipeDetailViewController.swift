//
//  RecipeDetailViewController.swift
//  myRecipe
//
//  Created by XXY on 11/23/17.
//  Copyright © 2017 Recipe. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let meals = ["Breakfast", "Lunch", "Dinner"];
    var selectedMeal = "Breakfast";
    var recipeDetail: RecipeDetail!
    var mealCalories: Int = 0;
    //date: detailed food
    let noImage: UIImage? = UIImage(named: "noImage.png");
    var temp = DailyMeals(Breakfast: "", Lunch: "", Dinner: "")
    var tempPic = DailyMealsImage(Breakfast: UIImage(named: "noImage.png")!, Lunch: UIImage(named: "noImage.png")!, Dinner: UIImage(named: "noImage.png")!)
    let formatter = DateFormatter()

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var ingredients: UITextView!
    
    @IBOutlet weak var instructions: UITextView!
    
    @IBOutlet weak var mealPicker: UIPickerView!
    
    @IBAction func addToCalendar(_ sender: Any) {
        //get current day
        let currentDate = Date()
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.string(from: currentDate)
        //add to calendar
        let name = recipeDetail.recipeTitle
        let image = recipeDetail.recipeImage
        
        //check for previous meals
        for (day, meals) in dailyMealStorage {
            if (day == date) {
                temp.Breakfast = meals.Breakfast
                temp.Lunch = meals.Lunch
                temp.Dinner = meals.Dinner
            } else {
                temp.Breakfast = ""
                temp.Lunch = ""
                temp.Dinner = ""
            }
        }
        
        //check for previous pictures
        for (day, images) in dailyMealImageStorage {
            if (day == date) {
                tempPic.Breakfast = images.Breakfast
                tempPic.Lunch = images.Lunch
                tempPic.Dinner = images.Dinner
            } else {
                tempPic.Breakfast = UIImage(named: "noImage.png")!
                tempPic.Lunch = UIImage(named: "noImage.png")!
                tempPic.Dinner = UIImage(named: "noImage.png")!
            }
        }
        
        //update new storage
        if (selectedMeal == "Breakfast"){
            temp.Breakfast = name
            tempPic.Breakfast = image
        } else if (selectedMeal == "Lunch"){
            temp.Lunch = name
            tempPic.Lunch = image
        } else {
            temp.Dinner = name
            tempPic.Dinner = image
        }
        dailyMealStorage[date] = temp
        dailyMealImageStorage[date] = tempPic

        
        let successAlert = UIAlertController(title: "Success", message: "This meal is added to your calendar as " + selectedMeal, preferredStyle: UIAlertControllerStyle.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(successAlert, animated: true, completion: nil)
        print(dailyMealStorage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mealPicker.dataSource = self;
        mealPicker.delegate = self;
        name.text = recipeDetail.recipeTitle;
        recipeImage.image = recipeDetail.recipeImage;
        ingredients.text = recipeDetail.ingredients;
        instructions.text = recipeDetail.instructions;
        mealCalories = recipeDetail.calories;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return meals.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return meals[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMeal = meals[row];
        //print(selectedMeal)
    }
    
}
