//
//  EditViewController.swift
//  travel-log
//
//  Created by Eunseo Lee and Karen Ren on 2022/4/21.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class EditViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var viewMap: MKMapView!
    var audioPlayer: AVAudioPlayer?
    var audioURL : URL?
    
    var locManager = CLLocationManager()
    
    var prevVC =  TableViewController()
    var place : LogObject? = nil
    var loc = 0
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var editImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewMap.delegate = self
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let lat = place?.latitude
        let lon = place?.longitude
        
        let location =  CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        
        viewMap.setRegion(region, animated: true)
        
        let annotaiton = MKPointAnnotation()
        annotaiton.coordinate.latitude = lat!
        annotaiton.coordinate.longitude = lon!
        
        annotaiton.subtitle = "Travel logs"
        
        self.viewMap.addAnnotation(annotaiton)
        
        name.text = place?.placeName

        
        if let imageData = place?.image as? NSData {
            if let image = UIImage(data:imageData as Data) {
                editImageView.image = image
            }
        }
        
    }//viewDidLoad
    
    
    
    @IBAction func playButton(_ sender: Any) {

        if let audioURL = place?.url {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        }
        
    }//playButton
    
    

    

}//EditViewController
