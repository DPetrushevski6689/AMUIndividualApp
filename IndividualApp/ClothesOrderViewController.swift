//
//  ClothesOrderViewController.swift
//  IndividualApp
//
//  Created by David Petrushevski on 1/15/21.
//  Copyright © 2021 David Petrushevski. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit

class ClothesOrderViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let itemId = clothesItemId
    
    var orderSellerId: String = ""
    var orderPrice: String = ""
    
    
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var orderMap: MKMapView!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    var orderLat = CLLocationDegrees()
    var orderLon = CLLocationDegrees()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeOrderButton.isHidden = true
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        orderMap.addGestureRecognizer(uilpgr)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        orderMap.delegate = self
        orderMap.mapType = .standard
        orderMap.isZoomEnabled = true
        orderMap.isScrollEnabled = true
        
        if let coor = orderMap.userLocation.location?.coordinate{
            orderMap.setCenter(coor, animated: true)
        }
        
        
        let query = PFQuery(className: "Clothes")
        query.getObjectInBackground(withId: itemId) { (object, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                if let item = object{
                    print("Object found!")
                    self.brandLabel.text = item["brand"] as! String
                    self.priceLabel.text = item["price"] as! String
                    self.sizeLabel.text = item["size"] as! String
                    self.orderSellerId = item["sellerId"] as! String
                    self.orderPrice = item["price"] as! String
                }
            }
        }
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: self.orderMap)
            let newCoordinate = self.orderMap.convert(touchPoint, toCoordinateFrom: self.orderMap)
            
            let newLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            orderLat = newCoordinate.latitude //order Lat
            orderLon = newCoordinate.longitude //order Lon
            
            
            var title = ""
            CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error!)
                }
                else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    }
                    if title == "" {
                        title = "Added \(NSDate())"
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    self.orderMap.addAnnotation(annotation)
                    self.placeOrderButton.isHidden = false
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord:CLLocationCoordinate2D = manager.location?.coordinate{
            orderMap.mapType = MKMapType.standard
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coord, span: span)
            orderMap.setRegion(region, animated: true)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coord
            anno.title = "Your current location"
            orderMap.addAnnotation(anno)
        }
    }
    
    @IBAction func placeOrderPressed(_ sender: Any) {
        
        let query = PFQuery(className: "Clothes")
        query.getObjectInBackground(withId: itemId) { (object, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }else{
                if let item = object{
                    item["status"] = "Sold"
                    item.saveInBackground()
                    print("Status is now sold and saved")
                }
            }
        }
        
        let order = PFObject(className: "Orders")
        order["sellerId"] = orderSellerId
        order["receiverId"] = PFUser.current()?.objectId
        order["price"] = orderPrice
        order["lat"] = orderLat
        order["lon"] = orderLon
        let currDate = Date()
        order["date"] = currDate.description.components(separatedBy: " ").first
        order["status"] = "Active" //Delivered
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        order.saveInBackground { (success, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if success{
                self.displayAlert(title: "Success", message: "Order was placed!")
            }else{
                self.displayAlert(title: "Error", message: "Order failed!")
            }
        }
        
    }
    

    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
}
