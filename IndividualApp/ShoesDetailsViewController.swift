//
//  ShoesDetailsViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/15/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

class ShoesDetailsViewController: UIViewController {
    
    let itemId = shoeItemId
    
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var shoesImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if langFlag == 1{
            self.navigationItem.title = "Details"
            orderButton.setTitle("Order", for: .normal)
        }else if langFlag == 2{
            self.navigationItem.title = "Детали"
            orderButton.setTitle("Купи", for: .normal)
        }
        let query = PFQuery(className: "Shoes")
        query.getObjectInBackground(withId: itemId) { (object, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                if let item = object{
                    print("Object found!")
                    self.brandLabel.text = item["brand"] as! String
                    self.priceLabel.text = item["price"] as! String
                    self.sizeLabel.text = item["size"] as! String
                    self.ageLabel.text = item["age"] as! String
                    
                    if let itemImg:PFFileObject = item["image"] as! PFFileObject{
                        itemImg.getDataInBackground(block: { (data, error) in
                            if let imageData = data{
                                if let imageToDisplay = UIImage(data: imageData){
                                    self.shoesImage.image = imageToDisplay
                                    print("Image set!")
                                }
                            }
                        })
                    }
                    
                }
            }
        }
    }
    

    @IBAction func orderPressed(_ sender: Any) {
        performSegue(withIdentifier: "toOrderShoes", sender: nil)
    }
    
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }

}
