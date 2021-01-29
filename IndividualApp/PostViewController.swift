//
//  PostViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/15/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

extension UIImage{
    enum JPEGQuality: CGFloat{
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var itemType: Int = -1 //1->clothes, 2->shoes
    
    @IBOutlet weak var chooseLabel: UILabel!
    
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var clothesButton: UIButton!
    @IBOutlet weak var shoesButton: UIButton!
    
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var sizeField: UITextField!
    
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var orLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemImage.isHidden = true
        chooseImageButton.isHidden = true
        brandField.isHidden = true
        priceField.isHidden = true
        ageField.isHidden = true
        sizeField.isHidden = true
        uploadButton.isHidden = true
        
        checkLang()
        
    }
    
    func checkLang(){
        if langFlag == 2{
            //mak
            self.navigationItem.title = "Пост"
            chooseLabel.text = "Одберете продукт за продажба"
            orLabel.text = "Или"
            clothesButton.setTitle("Облека", for: .normal)
            shoesButton.setTitle("Обувки", for: .normal)
            chooseImageButton.setTitle("Одберете слика", for: .normal)
            brandField.placeholder = "Внесете бренд и модел"
            priceField.placeholder = "Внесете цена"
            ageField.placeholder = "Внесете старост"
            sizeField.placeholder = "Внесете големина"
            uploadButton.setTitle("Прикачи", for: .normal)
        }else if langFlag == 1{
            //ang
            self.navigationItem.title = "Post"
            chooseLabel.text = "Choose what you want to sell"
            orLabel.text = "Or"
            clothesButton.setTitle("Clothes", for: .normal)
            shoesButton.setTitle("Shoes", for: .normal)
            chooseImageButton.setTitle("Choose an Image", for: .normal)
            brandField.placeholder = "Enter the brand and model"
            priceField.placeholder = "Enter the price"
            ageField.placeholder = "Enter the item age"
            sizeField.placeholder = "Enter the size"
            uploadButton.setTitle("Upload", for: .normal)
        }
    }
    
    @IBAction func clothesChosen(_ sender: Any) {
        itemType = 1 //clothes
        secondLabel.isHidden = true
        clothesButton.isHidden = true
        shoesButton.isHidden = true
        if langFlag == 1{
            firstLabel.text = "Chosen item: Clothes"
        }else if langFlag == 2{
            firstLabel.text = "Одбравте Облека"
        }
        
        
        itemImage.isHidden = false
        chooseImageButton.isHidden = false
        brandField.isHidden = false
        priceField.isHidden = false
        ageField.isHidden = false
        sizeField.isHidden = false
        uploadButton.isHidden = false
    }
    
    @IBAction func shoesChosen(_ sender: Any) {
        itemType = 2//shoes
        secondLabel.isHidden = true
        clothesButton.isHidden = true
        shoesButton.isHidden = true
        
        if langFlag == 1{
            firstLabel.text = "Chosen item: Shoes"
        }else if langFlag == 2{
            firstLabel.text = "Одбравте Обувки"
        }
        
        
        itemImage.isHidden = false
        chooseImageButton.isHidden = false
        brandField.isHidden = false
        priceField.isHidden = false
        ageField.isHidden = false
        sizeField.isHidden = false
        uploadButton.isHidden = false
    }
    
    @IBAction func chooseImagePressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            itemImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        if brandField.text != "" && priceField.text != "" && sizeField.text != "" && ageField.text != ""{
            if itemType != -1 && itemType == 1{
                //CLOTHES UPLOAD
                let clothesItem = PFObject(className: "Clothes")
                clothesItem["sellerId"] = PFUser.current()?.objectId
                clothesItem["brand"] = brandField.text
                clothesItem["price"] = priceField.text
                clothesItem["age"] = ageField.text
                clothesItem["size"] = sizeField.text
                clothesItem["rating"] = "No Rating"
                clothesItem["status"] = "Available"
                if let img = itemImage.image{
                    if let imageData = img.jpeg(.medium){
                        let imageFile = PFFileObject(name: "image.jpg", data: imageData)
                        clothesItem["image"] = imageFile
                    }
                }
                
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.style = UIActivityIndicatorView.Style.gray
                view.addSubview(activityIndicator)
                UIApplication.shared.beginIgnoringInteractionEvents()
                clothesItem.saveInBackground { (success, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if success{
                        if langFlag == 1{
                            self.displayAlert(title: "Success", message: "Item uploaded successfully")
                        }else if langFlag == 2{
                            self.displayAlert(title: "Потврда", message: "Продуктот е успешно прикачен")
                        }
                        
                    }else{
                        if langFlag == 1{
                            self.displayAlert(title: "Error", message: "Unsuccessful upload")
                        }else if langFlag == 2{
                            self.displayAlert(title: "Проблем", message: "Неуспешно прикачување")
                        }
                        
                    }
                }
                
            }else if itemType != -1 && itemType == 2{
                //SHOES UPLOAD
                let shoesItem = PFObject(className: "Shoes")
                shoesItem["sellerId"] = PFUser.current()?.objectId
                shoesItem["brand"] = brandField.text
                shoesItem["price"] = priceField.text
                shoesItem["age"] = ageField.text
                shoesItem["size"] = sizeField.text
                shoesItem["rating"] = "No Rating"
                shoesItem["status"] = "Available"
                if let img = itemImage.image{
                    if let imageData = img.jpeg(.medium){
                        let imageFile = PFFileObject(name: "image.jpg", data: imageData)
                        shoesItem["image"] = imageFile
                    }
                }
                
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.style = UIActivityIndicatorView.Style.gray
                view.addSubview(activityIndicator)
                UIApplication.shared.beginIgnoringInteractionEvents()
                shoesItem.saveInBackground { (success, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if success{
                        if langFlag == 1{
                            self.displayAlert(title: "Success", message: "Item uploaded successfully")
                        }else if langFlag == 2{
                            self.displayAlert(title: "Потврда", message: "Продуктот е успешно прикачен")
                        }
                        
                    }else{
                        if langFlag == 1{
                            self.displayAlert(title: "Error", message: "Unsuccessful upload")
                        }else if langFlag == 2{
                            self.displayAlert(title: "Проблем", message: "Неуспешно прикачување")
                        }
                        
                    }
                }
                
            }else{
                if langFlag == 1{
                    displayAlert(title: "Error", message: "You must choose an item type")
                }else if langFlag == 2{
                    displayAlert(title: "Проблем", message: "Мора да изберете тип на продукт")
                }
                
            }
        }else{
            if langFlag == 1{
                displayAlert(title: "Error", message: "All fields must be entered")
            }else if langFlag == 2{
                displayAlert(title: "Проблем", message: "Сите полиња мора да бидат внесени")
            }
            
        }
        
    }
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
}
