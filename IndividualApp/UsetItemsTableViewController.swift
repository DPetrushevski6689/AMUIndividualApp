//
//  UsetItemsTableViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/15/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

class UsetItemsTableViewController: UITableViewController {
    
    let userId = userObjectId
    
    var brands = [String]()
    var prices = [String]()
    var images = [PFFileObject]()
    var statuses = [String]()

    var refresher:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if langFlag == 1{
            self.navigationItem.title = "Your Products"
        }else if langFlag == 2{
            self.navigationItem.title = "Ваши продукти"
        }

        
        updateClothes()
        updateShoes()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(UsetItemsTableViewController.updateClothes), for: UIControl.Event.valueChanged)
        refresher.addTarget(self, action: #selector(UsetItemsTableViewController.updateShoes), for: UIControl.Event.valueChanged)
        self.view.addSubview(refresher)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return brands.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userItemsCell", for: indexPath) as! UserItemsTableViewCell

        cell.brandLabel.text = brands[indexPath.row]
        cell.priceLabel.text = prices[indexPath.row]
        
        if statuses[indexPath.row] == "Available"{
            if langFlag == 1{
                cell.statusLabel.text = statuses[indexPath.row]
            }else if langFlag == 2{
                cell.statusLabel.text = "За продажба"
            }
            
            cell.statusLabel.backgroundColor = UIColor.green
        }else if statuses[indexPath.row] == "Sold"{
            if langFlag == 1{
                cell.statusLabel.text = statuses[indexPath.row]
            }else if langFlag == 2{
                cell.statusLabel.text = "Продадено"
            }
            
            cell.statusLabel.backgroundColor = UIColor.red
        }
        
        images[indexPath.row].getDataInBackground(){ (data,error) in
            if let imageData = data{
                if let imageToDisplay = UIImage(data: imageData){
                    cell.itemImage.image = imageToDisplay
                }
            }
        }

        return cell
    }
    
    @objc func updateClothes(){
        let query = PFQuery(className: "Clothes")
        query.whereKey("sellerId", equalTo: userId)
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                for item in objects!{
                    self.brands.append(item["brand"] as! String)
                    self.images.append(item["image"] as! PFFileObject)
                    self.prices.append(item["price"] as! String)
                    self.statuses.append(item["status"] as! String)
                }
                self.refresher.endRefreshing()
            }
        }
    }
    
    @objc func updateShoes(){
        let query = PFQuery(className: "Shoes")
        query.whereKey("sellerId", equalTo: userId)
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                for item in objects!{
                    self.brands.append(item["brand"] as! String)
                    self.images.append(item["image"] as! PFFileObject)
                    self.prices.append(item["price"] as! String)
                    self.statuses.append(item["status"] as! String)
                }
                self.refresher.endRefreshing()
                
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
