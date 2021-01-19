//
//  LoginViewController.swift
//  
//
//  Created by David Petrushevski on 1/14/21.
//

import UIKit
import Parse


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
            displayAlert(title: "Error", message: "Both email and password must be entered!")
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
