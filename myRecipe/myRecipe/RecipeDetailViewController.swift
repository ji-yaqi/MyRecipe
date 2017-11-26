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
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var ingredients: UITextView!
    
    @IBOutlet weak var instructions: UITextView!
    
    @IBOutlet weak var mealPicker: UIPickerView!
    
    @IBAction func addToCalendar(_ sender: Any) {
        // TODO (JYQ): add the meal to the calendar.
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
        // TODO (XXY): handle the selected value.
    }
    
}
