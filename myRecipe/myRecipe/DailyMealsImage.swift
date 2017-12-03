//
//  DailyMealsImage.swift
//  myRecipe
//
//  Created by Yaqi Ji on 12/2/17.
//  Copyright © 2017 Recipe. All rights reserved.
//

import Foundation
import UIKit

struct DailyMealsImage {
    var Breakfast: UIImage
    var Lunch: UIImage
    var Dinner: UIImage
    init(Breakfast: UIImage, Lunch: UIImage, Dinner: UIImage){
        self.Breakfast = Breakfast
        self.Lunch = Lunch
        self.Dinner = Dinner
    }
}
var dailyMealImageStorage: [String: DailyMealsImage] = [:]


