//
//  OrderDetailsViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/18/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit

class OrderDetailsViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    let datePicker = UIDatePicker()
    
    let orderId = orderObjectId
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderMap: MKMapView!
    @IBOutlet weak var deliveryDateField: UITextField!
    @IBOutlet weak var receiverLabel: UILabel!
    
    
    
    let locationManager = CLLocationManager()
    
    var orderLat: Double = -1
    var orderLon: Double = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        self.orderMap.delegate = self
        self.orderMap.mapType = .standard
        self.orderMap.isZoomEnabled = true
        self.orderMap.isScrollEnabled = true

        let query = PFQuery(className: "Orders")
        query.getObjectInBackground(withId: orderId) { (object, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                if let item = object{
                    self.dateLabel.text = item["date"] as! String
                    self.priceLabel.text = item["price"] as! String
                    
                    self.orderLat = item["lat"] as! Double
                    self.orderLon = item["lon"] as! Double
                    
                    print("\(self.orderLat)")
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    let coordinate = CLLocationCoordinate2D(latitude: self.orderLat, longitude: self.orderLon)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    self.orderMap.setRegion(region, animated: true)
                    let anno = MKPointAnnotation()
                    anno.coordinate = coordinate
                    anno.title = "Order Location"
                    self.orderMap.addAnnotation(anno)
                    
                    let recId = item["receiverId"] as! String
                    
                    let userQuery = PFUser.query()
                    userQuery?.getObjectInBackground(withId: recId, block: { (object, error) in
                        if let reciever = object{
                            self.receiverLabel.text = (reciever["firstName"] as! String) + " " + (reciever["lastName"] as! String)
                        }
                    })
                    
                }
            }
        }
        
    }
    
    func createDatePicker(){
        deliveryDateField.textAlignment = .center
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        deliveryDateField.inputAccessoryView = toolbar
        deliveryDateField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        deliveryDateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.orderMap.setRegion(region, animated: true)
        
    }
    

    @IBAction func acceptOrderPressed(_ sender: Any) {
        if deliveryDateField.text != ""{
            
            let query = PFQuery(className: "Orders")
            query.getObjectInBackground(withId: orderId) { (object, error) in
                if error != nil{
                    self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                }else{
                    if let order = object{
                        order["deliveryDate"] = self.deliveryDateField.text
                        order["status"] = "Accepted"
                        order["deliveryManId"] = PFUser.current()?.objectId
                        order.saveInBackground(block: { (success, error) in
                            if success{
                                self.displayAlert(title: "Success", message: "Order Accepted")
                            }else{
                                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                            }
                        })
                    }
                }
            }
            
        }else{
            displayAlert(title: "Error", message: "Please enter a delivery date")
        }
    }
    
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
    
}
