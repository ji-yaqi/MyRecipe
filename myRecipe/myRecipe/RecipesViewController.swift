//
//  RecipesViewController.swift
//  myRecipe
//
//  API: http://www.TheMealDB.com
//  Created by XXY on 11/17/17.
//  Copyright © 2017 Recipe. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var theData: [Info] = []
    var theImageCache: [String: UIImage] = [:]
    var urlPrefix: String = "http://www.themealdb.com/api/json/v1/1/search.php?s="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        theData = [];
//        theCollectionView.reloadData();
        if(searchText != "") {
            self.fetchDataCollectionView(query: searchText);
        }
    }

    // getJSON from class demo 2.
    private func getJSON(_ url:String) -> JSON {
        if let url = URL(string: url) {
            if let data = try? Data(contentsOf: url) {
                let json = try? JSON(data: data)
                return json!
            } else {
                return JSON.null
            }
        } else {
            return JSON.null
        }
        
    }
    
    func fetchDataCollectionView(query: String) {
        let formatQuery = query.replacingOccurrences(of: " ", with: "&");
        let json = getJSON(urlPrefix + formatQuery)
        for result in json["meals"].arrayValue {
            print (result)
            let id = result["idMeal"].stringValue
            print (id)
        }
    }
}
