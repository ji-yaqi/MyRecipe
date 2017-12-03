//
//  DailyMealsCalories.swift
//  myRecipe
//
//  Created by Yaqi Ji on 12/3/17.
//  Copyright © 2017 Recipe. All rights reserved.
//

import Foundation

struct DailyMealCalories {
    var Breakfast: Int
    var Lunch: Int
    var Dinner: Int
    init(Breakfast: Int, Lunch: Int, Dinner: Int){
        self.Breakfast = Breakfast
        self.Lunch = Lunch
        self.Dinner = Dinner
    }
}
var dailyMealCaloriesStorage: [String: DailyMealCalories] = [:]
