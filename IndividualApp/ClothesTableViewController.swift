//
//  ClothesTableViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/15/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse

var clothesItemId: String = ""

class ClothesTableViewController: UITableViewController {
    
    var refresher:UIRefreshControl = UIRefreshControl()
    
    var brandModels = [String]()
    var clothesIds = [String]()
    var images = [PFFileObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if langFlag == 1{
            self.navigationItem.title = "Clothes"
        }else if langFlag == 2{
            self.navigationItem.title = "Облека"
        }
        
        updateTable()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(ClothesTableViewController.updateTable), for: UIControl.Event.valueChanged)
        self.view.addSubview(refresher)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return brandModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothesCell", for: indexPath) as! ClothesTableViewCell

        cell.brandLabel.text = brandModels[indexPath.row]
        
        images[indexPath.row].getDataInBackground(){ (data,error) in
            if let imageData = data{
                if let imageToDisplay = UIImage(data: imageData){
                    cell.clothesImage.image = imageToDisplay
                }
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clothesItemId = clothesIds[indexPath.row]
        performSegue(withIdentifier: "toClothesDetails", sender: nil)
    }
    
    @objc func updateTable(){
        let query = PFQuery(className: "Clothes")
        query.whereKey("sellerId", notEqualTo: PFUser.current()?.objectId)
        query.whereKey("status", equalTo: "Available")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                for item in objects!{
                    self.clothesIds.append(item.objectId!)
                    self.brandModels.append(item["brand"] as! String)
                    self.images.append(item["image"] as! PFFileObject)
                    if self.brandModels.count == objects?.count{
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
