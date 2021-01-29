//
//  OrdersTableViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/18/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

var orderObjectId: String = ""
var deliveryManId: String = ""

class OrdersTableViewController: UITableViewController {
    
    var orderIds = [String]()
    var orderDates = [String]()
    var orderPrices = [String]()
    var orderStatuses = [String]()
    
    @IBOutlet weak var logoutNav: UIBarButtonItem!
    @IBOutlet weak var yourOrdersNav: UIBarButtonItem!
    
    
    var refresher:UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if langFlag == 1{
            self.navigationItem.title = "Active Orders"
            logoutNav.title = "Logout"
            yourOrdersNav.title = "Your Orders"
        }else if langFlag == 2{
            self.navigationItem.title = "Активни Нарачки"
            logoutNav.title = "Логаут"
            yourOrdersNav.title = "Ваши Нарачки"
        }
        
        updateTable()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(OrdersTableViewController.updateTable), for: UIControl.Event.valueChanged)
        self.view.addSubview(refresher)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderIds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersTableViewCell
        
        cell.dateLabel.text = orderDates[indexPath.row]
        cell.priceLabel.text = orderPrices[indexPath.row]
        /*
        if orderStatuses[indexPath.row] == "Active"{
            cell.dateLabel.text = orderDates[indexPath.row]
            cell.priceLabel.text = orderPrices[indexPath.row]
        }else{
            cell.dateLabel.text = ""
            cell.priceLabel.text = ""
        }*/

        return cell
    }
    
    
    @objc func updateTable(){
        let query = PFQuery(className: "Orders")
        query.whereKey("status", equalTo: "Active")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                for order in objects!{
                    self.orderIds.append(order.objectId!)
                    self.orderDates.append(order["date"] as! String)
                    self.orderPrices.append(order["price"] as! String)
                    self.orderStatuses.append(order["status"] as! String)
                    
                    if self.orderIds.count == objects?.count{
                        self.refresher.endRefreshing()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orderObjectId = orderIds[indexPath.row]
        performSegue(withIdentifier: "toOrderDetails", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }

    
    @IBAction func logoutPressed(_ sender: Any) {
        PFUser.logOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func yourOrdersPressed(_ sender: Any) {
        deliveryManId = (PFUser.current()?.objectId)!
        performSegue(withIdentifier: "toPersonalOrders", sender: nil)
    }
    
    
}
