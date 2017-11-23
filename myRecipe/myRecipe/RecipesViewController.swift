//
//  RecipesViewController.swift
//  myRecipe
//
//  API: http://www.TheMealDB.com
//  Created by XXY on 11/17/17.
//  Copyright © 2017 Recipe. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    
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
        theCollectionView.reloadData();
        if(searchText != "") {
            self.fetchDataCollectionView(query: searchText);
        }
    }

    // 2 cells per row.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath);
        return cell;
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

    func cacheImages() {
        for item in theData {
            let url = URL(string: item.url)
            let recipeID = item.recipeID
            
            if (url != nil) {
                let data = try? Data(contentsOf: url!)
                if (data != nil) {
                    let image = UIImage(data: data!)
                    theImageCache[recipeID] = image
                }
            }
        }
    }

    // From Lab 4.
    func fetchDataCollectionView(query: String) {
        let formatQuery = query.replacingOccurrences(of: " ", with: "&");
        let json = getJSON(urlPrefix + formatQuery)
        for result in json["meals"].arrayValue {
            let id = result["idMeal"].stringValue;
            let name = result["strMeal"].stringValue;
            let url = result["strMealThumb"].stringValue;
            theData.append(Info(name: name, recipeID: id, url: url))
        }
        cacheImages();
    }
}
