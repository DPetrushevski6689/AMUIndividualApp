//
//  ShoesTableViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/15/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

var shoeItemId: String = ""

class ShoesTableViewController: UITableViewController {
    
    var refresher:UIRefreshControl = UIRefreshControl()
    
    var shoeIds = [String]()
    var shoeBrands = [String]()
    var shoeImages = [PFFileObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if langFlag == 1{
            self.navigationItem.title = "Shoes"
        }else if langFlag == 2{
            self.navigationItem.title = "Обувки"
        }
        
        updateTable()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(ShoesTableViewController.updateTable), for: UIControl.Event.valueChanged)
        self.view.addSubview(refresher)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoeBrands.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoesCell", for: indexPath) as! ShoesTableViewCell

        cell.shoeBrandLabel.text = shoeBrands[indexPath.row]
        
        shoeImages[indexPath.row].getDataInBackground(){ (data,error) in
            if let imageData = data{
                if let imageToDisplay = UIImage(data: imageData){
                    cell.shoeImage.image = imageToDisplay
                }
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shoeItemId = shoeIds[indexPath.row]
        performSegue(withIdentifier: "toShoeDetails", sender: nil)
    }
 
    
    @objc func updateTable(){
        let query = PFQuery(className: "Shoes")
        query.whereKey("sellerId", notEqualTo: PFUser.current()?.objectId)
        query.whereKey("status", equalTo: "Available")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                for item in objects!{
                    self.shoeIds.append(item.objectId!)
                    self.shoeBrands.append(item["brand"] as! String)
                    self.shoeImages.append(item["image"] as! PFFileObject)
                    if self.shoeBrands.count == objects?.count{
                        self.refresher.endRefreshing()
                        self.tableView.reloadData()
                    }
                }
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
