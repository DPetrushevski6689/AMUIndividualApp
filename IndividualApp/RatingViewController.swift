//
//  RatingViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/29/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

class RatingViewController: UIViewController {
    
    var itemId = ratingItemId
    var itemType = ratingItemType
    
    //var ratingNum:Int = -1

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var addARatingLabel: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if langFlag == 1{
            addARatingLabel.text = "Add a rating"
            saveButton.setTitle("Save", for: .normal)
        }else if langFlag == 2{
            addARatingLabel.text = "Додади рејтинг"
            saveButton.setTitle("Зачувај", for: .normal)
        }

        if itemType == "ClothesItem"{
            //clothesQuery
            let clothesQuery = PFQuery(className: "Clothes")
            clothesQuery.getObjectInBackground(withId: itemId) { (object, error) in
                if error != nil{
                    print(error?.localizedDescription)
                }else{
                    if let item = object{
                        self.brandLabel.text = item["brand"] as! String
                        if let itemImg:PFFileObject = item["image"] as! PFFileObject{
                            itemImg.getDataInBackground(block: { (data, error) in
                                if let imageData = data{
                                    if let imageToDisplay = UIImage(data: imageData){
                                        self.itemImage.image = imageToDisplay
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }else if itemType == "ShoesItem"{
            //shoesQuery
            let shoesQuery = PFQuery(className: "Shoes")
            shoesQuery.getObjectInBackground(withId: itemId) { (object, error) in
                if error != nil{
                    print(error?.localizedDescription)
                }else{
                    if let item = object{
                        self.brandLabel.text = item["brand"] as! String
                        if let itemImg:PFFileObject = item["image"] as! PFFileObject{
                            itemImg.getDataInBackground(block: { (data, error) in
                                if let imageData = data{
                                    if let imageToDisplay = UIImage(data: imageData){
                                        self.itemImage.image = imageToDisplay
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        ratingValueLabel.text = String(Int(sender.value))
        //ratingNum = Int(sender.value)
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        if itemType == "ClothesItem"{
            let itemQuery = PFQuery(className: "Clothes")
            itemQuery.getObjectInBackground(withId: itemId) { (object, error) in
                if error != nil{
                    print(error?.localizedDescription)
                }else{
                    if let item = object{
                        item["rating"] = self.ratingValueLabel.text
                        item.saveInBackground(block: { (success, error) in
                            if success{
                                if langFlag == 1{
                                    self.displayAlert(title: "Success", message: "Rating added!")
                                }else if langFlag == 2{
                                    self.displayAlert(title: "Потврда", message: "Рејтингот е зачуван!")
                                }
                                
                            }else{
                                if langFlag == 1{
                                    self.displayAlert(title: "Error", message: "Rating addition failed!")
                                }else if langFlag == 2{
                                    self.displayAlert(title: "Проблем", message: "Рејтингот не е зачуван!")
                                }
                            }
                        })
                    }
                }
            }
        }else if itemType == "ShoesItem"{
            let itemQuery = PFQuery(className: "Shoes")
            itemQuery.getObjectInBackground(withId: itemId) { (object, error) in
                if error != nil{
                    print(error?.localizedDescription)
                }else{
                    if let item = object{
                        item["rating"] = self.ratingValueLabel.text
                        item.saveInBackground(block: { (success, error) in
                            if success{
                                if langFlag == 1{
                                    self.displayAlert(title: "Success", message: "Rating added!")
                                }else if langFlag == 2{
                                    self.displayAlert(title: "Потврда", message: "Рејтингот е зачуван!")
                                }
                                
                            }else{
                                if langFlag == 1{
                                    self.displayAlert(title: "Error", message: "Rating addition failed!")
                                }else if langFlag == 2{
                                    self.displayAlert(title: "Проблем", message: "Рејтингот не е зачуван!")
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }

}
