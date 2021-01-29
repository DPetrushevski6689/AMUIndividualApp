//
//  UserViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/14/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

var userObjectId: String = ""

class UserViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var clothesLabel: UILabel!
    @IBOutlet weak var shoesLabel: UILabel!
    
    @IBOutlet weak var ordersNav: UIBarButtonItem!
    @IBOutlet weak var itemsNav: UIBarButtonItem!
    @IBOutlet weak var postNav: UIBarButtonItem!
    @IBOutlet weak var logoutNav: UIBarButtonItem!
    
    
    
    let currUser = PFUser.current()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        userObjectId = (currUser?.objectId)!
        
        if langFlag == 2{
            //mak
            self.navigationItem.title = "Дома"
            ordersNav.title = "Нарачки"
            itemsNav.title = "Продукти"
            postNav.title = "Пост"
            logoutNav.title = "Логаут"
             welcomeLabel.text = "Здраво " + (currUser?.object(forKey: "firstName") as! String) + " " + (currUser?.object(forKey: "lastName") as! String)
            clothesLabel.text = "Облека"
            shoesLabel.text = "Обувки"
        }else if langFlag == 1{
            //ang
            self.navigationItem.title = "Home"
            ordersNav.title = "Orders"
            itemsNav.title = "Items"
            postNav.title = "Post"
            logoutNav.title = "Logout"
             welcomeLabel.text = "Welcome " + (currUser?.object(forKey: "firstName") as! String) + " " + (currUser?.object(forKey: "lastName") as! String)
            clothesLabel.text = "Clothes"
            shoesLabel.text = "Shoes"
        }
        
       
    }
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        PFUser.logOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clothesPressed(_ sender: Any) {
        performSegue(withIdentifier: "toClothesList", sender: nil)
    }
    
    @IBAction func shoesPressed(_ sender: Any) {
        performSegue(withIdentifier: "toShoesList", sender: nil)
    }
    
    
    @IBAction func postPressed(_ sender: Any) {
        performSegue(withIdentifier: "toPost", sender: nil)
    }
    
    @IBAction func yourItemsPressed(_ sender: Any) {
        performSegue(withIdentifier: "toItems", sender: nil)
    }
    
    @IBAction func ordersPressed(_ sender: Any) {
        performSegue(withIdentifier: "toUserOrders", sender: nil)
        
    }
    

}
