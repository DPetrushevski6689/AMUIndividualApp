//
//  LoginViewController.swift
//  
//
//  Created by David Petrushevski on 1/14/21.
//

import UIKit
import Parse

var langFlag: Int = -1 //1 -> english, 2 -> macedonian


class LoginViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var languageSwitch: UISwitch!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSwitch.isOn = false
        langFlag = 1 //default -> English
    }
    
    @IBAction func switchFunc(_ sender: Any) {
        if languageSwitch.isOn == true{
            langFlag = 2
            self.navigationItem.title = "Логин"
            welcomeLabel.text = "Добредојдовте! Логирајте се!"
            emailField.placeholder = "Е-Адреса"
            passwordField.placeholder = "Лозинка"
            //logInButton.titleLabel?.text = "Логин"
            logInButton.setTitle("Логин", for: .normal)
            orLabel.text = "Или"
            //registerButton.titleLabel?.text = "Регистрација"
            registerButton.setTitle("Регистрација", for: .normal)
            displayAlert(title: "Информација", message: "Вие одбравте македонски јазик")
            print("\(langFlag)")
        }else{
            langFlag = 1
            self.navigationItem.title = "Login"
            welcomeLabel.text = "Welcome to our shop! Please log in!"
            emailField.placeholder = "Еmail Address"
            passwordField.placeholder = "Password"
            //logInButton.titleLabel?.text = "Log In"
            logInButton.setTitle("Log In", for: .normal)
            orLabel.text = "Or"
            //registerButton.titleLabel?.text = "Register"
            registerButton.setTitle("Register", for: .normal)
            displayAlert(title: "Alert", message: "You chose english language")
            print("\(langFlag)")
        }
    }
    
 
    @IBAction func loginPressed(_ sender: Any) {
        //login based on role
        if emailField.text != "" && passwordField.text != ""{
            PFUser.logInWithUsername(inBackground: emailField.text!, password: passwordField.text!){ (user,error) in
                if let err = error{
                    print("Login Error")
                    self.displayAlert(title: "Error", message: err.localizedDescription)
                }else{
                    print("Successful login")
                    if user?.object(forKey: "role") as! String == "User"{
                        self.performSegue(withIdentifier: "toUser", sender: nil)
                    }else if user?.object(forKey: "role") as! String == "Delivery"{
                        self.performSegue(withIdentifier: "toDelivery", sender: nil)
                    }
                }
            }
        }else{
            if langFlag == 1{
                displayAlert(title: "Error", message: "Both email and password must be entered!")
            }else if langFlag == 2{
                displayAlert(title: "Проблем", message: "Е-Адреса и лозинка мора да бидат внесени!")
            }
            
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        performSegue(withIdentifier: "toRegister", sender: nil)
    }
    
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
        //self.presentedViewController(alert,animated: true, completition: nil)
    }

    

}
