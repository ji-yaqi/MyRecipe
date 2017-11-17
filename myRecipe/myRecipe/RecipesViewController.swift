//
//  RecipesViewController.swift
//  myRecipe
//
//  API: http://api2.bigoven.com/web/documentation/recipes 
//  Created by XXY on 11/17/17.
//  Copyright © 2017 Recipe. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var theData: [Info] = []
    var theImageCache: [String: UIImage] = [:]
    var urlPrefix: String = "http://api2.bigoven.com/recipes?pg=1&rpp=25&title_kw="
    var apiKey: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self;
    }
}
