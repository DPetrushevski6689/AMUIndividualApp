//
//  UserOrdersTableViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/18/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

class UserOrdersTableViewController: UITableViewController {
    
    var refresher:UIRefreshControl = UIRefreshControl()
    
    var dates = [String]()
    var prices = [String]()
    var statuses = [String]()
    var sellerNames = [String]()
    var sellerSurnames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(UserOrdersTableViewController.updateTable), for: UIControl.Event.valueChanged)
        self.view.addSubview(refresher)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statuses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userOrdersCell", for: indexPath) as! UserOrdersTableViewCell

        cell.dateLabel.text = dates[indexPath.row]
        cell.priceLabel.text = prices[indexPath.row]
        cell.sellerLabel.text = sellerNames[indexPath.row] + " " + sellerSurnames[indexPath.row]
        
        if statuses[indexPath.row] == "Accepted"{
            cell.statusLabel.text = "Accepted"
            cell.statusLabel.backgroundColor = UIColor.yellow
        }else if statuses[indexPath.row] == "Finished"{
            cell.statusLabel.text = "Finished"
            cell.statusLabel.backgroundColor = UIColor.green
        }else if statuses[indexPath.row] == "Active"{
            cell.statusLabel.text = "Active"
            cell.statusLabel.backgroundColor = UIColor.cyan
        }
        
        return cell
    }
    
    @objc func updateTable(){
        let query = PFQuery(className: "Orders")
        query.whereKey("receiverId", equalTo: PFUser.current()?.objectId!)
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                for order in objects!{
                    self.prices.append(order["price"] as! String)
                    self.statuses.append(order["status"] as! String)
                    
                    /*
                    if order["status"] as! String == "Accepted"{
                        self.dates.append(order["deliveryDate"] as! String)
                    }else{
                        self.dates.append(order["finishingDate"] as! String)
                    }*/
                    
                    self.dates.append(order["date"] as! String)
                    
                    if let sellerId:String = order["sellerId"] as! String{
                        let userQuery = PFUser.query()
                        /*
                        userQuery?.getObjectInBackground(withId: sellerId, block: { (object, err) in
                            if err != nil{
                                self.displayAlert(title: "Error", message: (err?.localizedDescription)!)
                            }else{
                                if let seller = object{
                                    self.sellerNames.append(seller["firstName"] as! String)
                                    self.sellerSurnames.append(seller["lastName"] as! String)
                                }
                            }
                        })*/
                        do{
                            let user = try userQuery?.getObjectWithId(sellerId)
                            self.sellerNames.append(user!["firstName"] as! String)
                            self.sellerSurnames.append(user!["lastName"] as! String)
                        }catch{
                            print("Error")
                        }
                    }
                    
                }
            }
            if self.dates.count == objects?.count{
                self.refresher.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
    

}
