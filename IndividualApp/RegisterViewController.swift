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
    
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    
    
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
        checkLang()
    }
    
    func checkLang(){
        if langFlag == 1{
            //ang
            self.navigationItem.title = "Register"
            registerLabel.text = "Register as a:"
            userButton.setTitle("User", for: .normal)
            deliveryButton.setTitle("Delivery Man", for: .normal)
            orLabel.text = "Or"
            firstNameField.placeholder = "First Name"
            lastNameField.placeholder = "Last Name"
            emailField.placeholder = "Email Address"
            phoneField.placeholder = "Telephone Number"
            birthDateLabel.placeholder = "Birth Date"
            passwordField.placeholder = "Password"
            registerButton.setTitle("Register", for: .normal)
        }else if langFlag == 2{
            //mak
            self.navigationItem.title = "Регистрација"
            registerLabel.text = "Регистрирај:"
            userButton.setTitle("Корисник", for: .normal)
            deliveryButton.setTitle("Доставувач", for: .normal)
            orLabel.text = "Или"
            firstNameField.placeholder = "Име"
            lastNameField.placeholder = "Презиме"
            emailField.placeholder = "Е-Адреса"
            phoneField.placeholder = "Телефонски број"
            birthDateLabel.placeholder = "Дата на раѓање"
            passwordField.placeholder = "Лозинка"
            registerButton.setTitle("Регистрација", for: .normal)
        }
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
        if langFlag == 1{
            firstLabel.text = "User"
            secondLabel.isHidden = true
         
        }else if langFlag == 2{
            firstLabel.text = "Корисник"
            secondLabel.isHidden = true
        }
        userButton.isHidden = true
    }
    
    @IBAction func deliveryManPressed(_ sender: Any) {
        userRole = "Delivery"
        userButton.isHidden = true
        if langFlag == 1{
            firstLabel.text = "Delivery Man"
            secondLabel.isHidden = true
        }else if langFlag == 2{
            firstLabel.text = "Доставувач"
            secondLabel.isHidden = true
        }
        
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
                        if langFlag == 1{
                           self.displayAlertReg(title: "Success", message: "You have registered successfully")
                        }else if langFlag == 2{
                            self.displayAlertReg(title: "Потврда", message: "Успешна регистрација")
                        }
                        
                    }
                }
            }else{
                if langFlag == 1{
                    self.displayAlert(title: "Error", message: "All fields must be entered")
                }else if langFlag == 2{
                    self.displayAlert(title: "Проблем", message: "Сите полиња мора да бидат внесени")
                }
                
            }
        }else{
            if langFlag == 1{
                self.displayAlert(title: "Error", message: "Please choose a user type")
            }else if langFlag == 2{
                self.displayAlert(title: "Проблем", message: "Ве молиме изберете тип на корисник")
            }
            
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
