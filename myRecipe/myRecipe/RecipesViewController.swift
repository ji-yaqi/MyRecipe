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
        theCollectionView.delegate = self;
        theCollectionView.dataSource = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // Similar to the same function in Lab 4.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath);
        var content: Info;
        // TODO (XXY): Fix the situation where only 1 result is returned.
        if (theData.count == 1) {
//            print ("Data count 1")
            content = theData[0];
        } else {
            content = theData[indexPath.row + 2 * indexPath.section];
        }
        
        let id = content.recipeID;
        let name = content.name;
//        print (name)
        let url = content.url;
        let noImage: UIImage? = UIImage(named: "noImage.png");
        let recipeImage: UIImageView = UIImageView();
        recipeImage.image = noImage;
        if (url != "") {
            if (theImageCache[id] != nil) {
                recipeImage.image = theImageCache[id];
            }
        }
        
        recipeImage.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height - 3)
        
        let nameLabel: UILabel = UILabel();
        nameLabel.text = name;
        nameLabel.frame = CGRect(x: 0, y: cell.frame.height - 38, width: cell.frame.width, height: 36)
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.numberOfLines = 0;
        nameLabel.textColor = UIColor.white;
        nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5);
        nameLabel.textAlignment = .center;
        
        cell.addSubview(recipeImage);
        cell.addSubview(nameLabel);
        return cell;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print (theData.count)
        let num = theData.count;
        if (num == 1) {
            return 1;
        }
        return num / 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content: Info;
        if (theData.count == 1) {
            content = theData[0];
        } else {
            content = theData[indexPath.row + 2 * indexPath.section];
        }
        let id = content.recipeID;
        let name = content.name;
        let url = content.url;
        let noImage: UIImage? = UIImage(named: "noImage.png");
        var recipeImage = UIImage();
        if (url != "") {
            if (theImageCache[id] != nil) {
                recipeImage = theImageCache[id]!
            } else {
                recipeImage = noImage!;
            }
        } else {
            recipeImage = noImage!;
        }
        
        let json = getJSON("http://www.themealdb.com/api/json/v1/1/lookup.php?i=" + id)
        let mealDetail = json["meals"].arrayValue[0];
        let instructions = mealDetail["strInstructions"].stringValue;
        let firstIngredient = mealDetail["strIngredient1"].stringValue;
        let firstMeasure = mealDetail["strMeasure1"].stringValue;
        var ingredientsStr = "";
        if (firstIngredient != "null" && firstIngredient != "") {
            ingredientsStr = firstIngredient + ": " + firstMeasure;
            for i in 2...20 {
                let ingredientIndex = "strIngredient" + String(i);
                let measureIndex = "strMeasure" + String(i);
                let curIngredient = mealDetail[ingredientIndex].stringValue;
                let curMeasure = mealDetail[measureIndex].stringValue;
                if (curIngredient != "null" && curIngredient != "") {
                    ingredientsStr += ", " + "\r\n" + curIngredient + ": " + curMeasure;
                } else {
                    break;
                }
            }
        }
        let recipeDetail: RecipeDetail = RecipeDetail(recipeID: id, recipeTitle:name, recipeImage: recipeImage, ingredients: ingredientsStr, instructions: instructions);
        let detailedVC = storyboard!.instantiateViewController(withIdentifier:"recipeDetailVC") as! RecipeDetailViewController
        detailedVC.recipeDetail = recipeDetail;
        navigationController?.pushViewController(detailedVC, animated: true)
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
//        print (theData.count);
        cacheImages();
    }
}
