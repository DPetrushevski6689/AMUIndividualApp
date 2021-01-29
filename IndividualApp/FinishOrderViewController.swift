//
//  FinishOrderViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/18/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

class FinishOrderViewController: UIViewController {
    
    let itemId = acceptedOfferId
    
    let datePicker = UIDatePicker()
    
    var sellerId:String = ""
    var recId:String = ""
    
    @IBOutlet weak var sellerTitle: UILabel!
    @IBOutlet weak var recieverTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var priceTitle: UILabel!
    
    
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var recieverLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var finishDateField: UITextField!
    
    @IBOutlet weak var finishOrderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
        if langFlag == 1{
            self.navigationItem.title = "Accepted Order"
            sellerTitle.text = "Seller:"
            recieverTitle.text = "Reciever:"
            dateTitle.text = "Date:"
            priceTitle.text = "Price:"
            finishDateField.placeholder = "Enter Finishing Date"
            finishOrderButton.setTitle("Finish Order", for: .normal)
        }else if langFlag == 2{
            self.navigationItem.title = "Прифатена Нарачка"
            sellerTitle.text = "Праќач:"
            recieverTitle.text = "Примач:"
            dateTitle.text = "Дата:"
            priceTitle.text = "Цена:"
            finishDateField.placeholder = "Внесете датум на завршување"
            finishOrderButton.setTitle("Заврши Нарачка", for: .normal)
        }
        
        let query = PFQuery(className: "Orders")
        query.getObjectInBackground(withId: itemId) { (object, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                if let item = object{
                    self.dateLabel.text = item["deliveryDate"] as! String
                    self.priceLabel.text = item["price"] as! String
                    
                    self.sellerId = item["sellerId"] as! String
                    self.recId = item["receiverId"] as! String
                    
                    
                    let firstQuery = PFUser.query()
                    do{
                        let firstUser = try firstQuery?.getObjectWithId(self.sellerId)
                        let secondUser = try firstQuery?.getObjectWithId(self.recId)
                        self.sellerLabel.text = (firstUser!["firstName"] as! String) + " " + (firstUser!["lastName"] as! String)
                        self.recieverLabel.text = (secondUser!["firstName"] as! String) + " " + (secondUser!["lastName"] as! String)
                    }catch{
                        print("Error")
                    }
                    
                    /*
                    let secondQuery = PFUser.query()
                    do{
                        let secondUser = try secondQuery?.getObjectWithId(self.recId)
                        self.sellerLabel.text = (secondUser!["firstName"] as! String) + " " + (secondUser!["lastName"] as! String)
                    }catch{
                        print("Error")
                    }*/
                    
                }
            }
        }
        
        
    }
    

    @IBAction func finishOrderPressed(_ sender: Any) {
        
        if finishDateField.text != ""{
            let query = PFQuery(className: "Orders")
            query.getObjectInBackground(withId: itemId) { (object, error) in
                if error != nil{
                    self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                }else{
                    if let item = object{
                        item["status"] = "Finished"
                        item["finishingDate"] = self.finishDateField.text
                        item.saveInBackground(block: { (success, error) in
                            if success{
                                self.displayAlert(title: "Success", message: "Order finished")
                            }else{
                                self.displayAlert(title: "Error", message: "Error finishing the order")
                            }
                        })
                    }
                }
            }
        }else{
            self.displayAlert(title: "Error", message: "Please enter a finishing date")
        }
    }
    
    func createDatePicker(){
        finishDateField.textAlignment = .center
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        finishDateField.inputAccessoryView = toolbar
        finishDateField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        finishDateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    

    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
}
