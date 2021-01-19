//
//  PersonalOrdersTableViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/18/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

var acceptedOfferId: String = ""

class PersonalOrdersTableViewController: UITableViewController {
    
    var receiverNames = [String]()
    var receiverSurnames = [String]()
    var prices = [String]()
    var statuses = [String]()
    var dates = [String]()
    var orderIds = [String]()
    
    var refresher:UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self,action: #selector(PersonalOrdersTableViewController.updateTable), for: UIControl.Event.valueChanged)
        self.view.addSubview(refresher)
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statuses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalOrdersCell", for: indexPath) as! PersonalOrdersTableViewCell

        cell.dateLabel.text = dates[indexPath.row]
        cell.priceLabel.text = prices[indexPath.row]
        cell.recieverLabel.text = receiverNames[indexPath.row] + " " + receiverSurnames[indexPath.row]
        
        if statuses[indexPath.row] == "Accepted"{
            cell.statusLabel.backgroundColor = UIColor.yellow
            cell.statusLabel.text = statuses[indexPath.row]
        }else if statuses[indexPath.row] == "Finished"{
            cell.statusLabel.backgroundColor = UIColor.green
            cell.statusLabel.text = statuses[indexPath.row]
        }

        return cell
    }
    
    @objc func updateTable(){
        let query = PFQuery(className: "Orders")
        query.whereKey("deliveryManId", equalTo: PFUser.current()?.objectId)
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                for order in objects!{
                    self.dates.append(order["deliveryDate"] as! String)
                    self.prices.append(order["price"] as! String)
                    self.statuses.append(order["status"] as! String)
                    self.orderIds.append(order.objectId!)
                    
                    let userId = order["receiverId"] as! String
                    let userQuery = PFUser.query()
                    do{
                        let user = try userQuery?.getObjectWithId(userId)
                        self.receiverNames.append(user!["firstName"] as! String)
                        self.receiverSurnames.append(user!["lastName"] as! String)
                    }catch{
                        print("Error")
                    }
                    
                    
                    if self.statuses.count == objects?.count{
                        self.refresher.endRefreshing()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if statuses[indexPath.row] == "Accepted"{
            acceptedOfferId = orderIds[indexPath.row]
            performSegue(withIdentifier: "toAcceptedOrderDetails", sender: nil)
        }else{
            displayAlert(title: "Finished Order", message: "This order is already finished")
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
