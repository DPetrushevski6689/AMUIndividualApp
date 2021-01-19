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
    
    let currUser = PFUser.current()

    override func viewDidLoad() {
        super.viewDidLoad()

        userObjectId = (currUser?.objectId)!
        welcomeLabel.text = "Welcome " + (currUser?.object(forKey: "firstName") as! String) + " " + (currUser?.object(forKey: "lastName") as! String)
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
