//
//  RegisterViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/14/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var birthDateLabel: UITextField!
    let datePicker = UIDatePicker()
    
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var deliveryButton: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    var userRole: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        userButton.isHidden = false
        deliveryButton.isHidden = false
    }
    
    
    func createDatePicker(){
        birthDateLabel.textAlignment = .center
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        birthDateLabel.inputAccessoryView = toolbar
        birthDateLabel.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        birthDateLabel.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @IBAction func userPressed(_ sender: Any) {
        userRole = "User"
        deliveryButton.isHidden = true
        firstLabel.text = "You have chosen:"
        secondLabel.text = "User"
        userButton.isHidden = true
    }
    
    @IBAction func deliveryManPressed(_ sender: Any) {
        userRole = "Delivery"
        userButton.isHidden = true
        firstLabel.text = "You have chosen:"
        secondLabel.text = "Delivery Man"
        deliveryButton.isHidden = true
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if userRole != ""{
            if firstNameField.text != "" && lastNameField.text != "" && emailField.text != "" && phoneField.text != "" && birthDateLabel.text != "" && passwordField.text != ""{
                let user = PFUser()
                user.username = emailField.text
                user.email = emailField.text
                user.password = passwordField.text
                user["firstName"] = firstNameField.text
                user["lastName"] = lastNameField.text
                user["phone"] = phoneField.text
                user["birthDate"] = birthDateLabel.text
                user["role"] = userRole
                
                user.signUpInBackground { (success, error) in
                    if let err = error{
                        self.displayAlert(title: "Error", message: err.localizedDescription)
                    }else{
                        print("Sign Up Success")
                        self.displayAlertReg(title: "Success", message: "You have registered successfully")
                        
                    }
                }
            }else{
                self.displayAlert(title: "Error", message: "All fields must be entered")
            }
        }else{
            self.displayAlert(title: "Error", message: "Please choose a user type")
        }
    }
    
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
    
    func displayAlertReg(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true)
    }

}
