//
//  LocAddViewController.swift
//  travel-log
//
//  Created by Eunseo Lee and Karen Ren on 2022/4/21.
//

import UIKit

import UIKit
import MapKit
import CoreLocation

class LocAddViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var prevVC =  AddViewController()
    
    override func viewDidLoad() {
        
    
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let gestureRecognizer = UILongPressGestureRecognizer( target: self,
            action: #selector(chooseLocation(gestureRecognizer: )))
        gestureRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(gestureRecognizer)
    }//viewDidLoad()
    
    @objc func chooseLocation(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state == .began) {
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
            let lat = touchedCoordinates.latitude
            let lon = touchedCoordinates.longitude
            
            var address = ""
            var dateString = ""
            var addrExists = false
                    
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: lat, longitude: lon)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // Location name
                if let locationName = placeMark.name {
                    address += locationName
                    address += " "
                    
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    address += street
                    address += " "
                    addrExists = true
                    
                }
                // City
                if let city = placeMark.locality {
                    address += city
                    address += " "
                    
                }
                // State
                if let state = placeMark.administrativeArea {
                    address += state
                    address += " "
                   
                }
                // Zip code
                if let zipCode = placeMark.postalCode {
                    address += zipCode
                    address += " "
                }
                // Country
                if let country = placeMark.country {
                    address += country
                }
                
                let annotaiton = MKPointAnnotation()
                annotaiton.coordinate = touchedCoordinates
                if(!addrExists){
                    let dateFormatter : DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = Date()
                    
                    dateString = dateFormatter.string(from: date)
                    annotaiton.title = dateString
                }else{
                    annotaiton.title = address
                }//else
                
                annotaiton.subtitle = "Travel logs"
                
                self.mapView.addAnnotation(annotaiton)
                
                if let context = (UIApplication.shared.delegate as?AppDelegate)?.persistentContainer.viewContext{
                    
                    let place = LogObject(entity: LogObject.entity(), insertInto: context)
                    
                    place.placeName = address
                    place.latitude = lat
                    place.longitude = lon
                    let img = UIImage(named: "map.png")
                    let imgData = img!.jpegData(compressionQuality: 1)
                    place.setValue(imgData, forKey: "image")
              
                    try? context.save()
                    //self.prevVC.getPlaces()
                    self.navigationController?.popViewController(animated: true)
                }//if let context = (UIApplication.
            })//completionHandler
            
        }// if (gestureRecognizer.state
        
    }//chooseLocation
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude
        let lng  = locations[0].coordinate.longitude
        
        let location =  CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }//locationManager
    
    
}//MapViewController

