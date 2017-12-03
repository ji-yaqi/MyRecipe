//
//  DailyMeals.swift
//  myRecipe
//
//  Created by Yaqi Ji on 12/2/17.
//  Copyright © 2017 Recipe. All rights reserved.
//

import Foundation

struct DailyMeals {
    var Breakfast: String
    var Lunch: String
    var Dinner: String
    init(Breakfast: String, Lunch: String, Dinner: String){
        self.Breakfast = Breakfast
        self.Lunch = Lunch
        self.Dinner = Dinner
    }
}
var dailyMealStorage: [String: DailyMeals] = [:]
