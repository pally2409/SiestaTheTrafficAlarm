//
//  LocationSettingsViewController.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 17/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import MapKit
import Contacts
import CoreLocation
import GooglePlaces


class LocationSettingsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

//   static let sharedLS = LocationSettingsViewController()
    
    
    let manager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var location = " "
    let autocompleteControllerOrigin = GMSAutocompleteViewController()
    let autocompleteControllerDestination = GMSAutocompleteViewController()
    var readyTime: TimeInterval?
    var reachTime: Date?
    var fromAlarmTime: Date?
    var selectedPin: MKPlacemark?
    var searchResult: String?
    var originCoordinate = CLLocationCoordinate2D()
    var destinationCoordinate = CLLocationCoordinate2D()
    let origPin = MKPointAnnotation()
    let destPin = MKPointAnnotation()

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationAddressField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var originAddressField: UITextField!

    
    @IBAction func dropPinWithLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        let newPin = MKPointAnnotation()
        newPin.coordinate = locationCoordinate
        mapView.addAnnotation(newPin)
        
    }
    
    
    @IBAction func unwindToLocationSettingsViewController(_ segue: UIStoryboardSegue) {
        let sourceVC = segue.source as! SearchViewController
        if sourceVC.flag == 0 {
        originAddressField.text = sourceVC.searchResult
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
            let originLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(sourceVC.resultCoordinate.latitude, sourceVC.resultCoordinate.longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(originLocation, span)
            mapView.setRegion(region, animated: true)

            originCoordinate = sourceVC.resultCoordinate
            
            origPin.coordinate = originCoordinate
            mapView.addAnnotation(origPin)
            origPin.title = "Orign"
            
            
        } else if sourceVC.flag == 1 {
            destinationAddressField.text = sourceVC.searchResult
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
            let destinationLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(sourceVC.resultCoordinate.latitude, sourceVC.resultCoordinate.longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(destinationLocation, span)
            mapView.setRegion(region, animated: true)

            destinationCoordinate = sourceVC.resultCoordinate
            
            destPin.coordinate = destinationCoordinate
            mapView.addAnnotation(destPin)
            destPin.title = "Destination"
        }
        
    }
    
    
    
    
 
    @IBAction func orginFieldTapped(_ sender: Any) {
        performSegue(withIdentifier: "showOriginSearchTableView", sender: self)
        originAddressField.endEditing(true)
        

    }
    
    
    
    @IBAction func destinationAddressFieldTapped(_ sender: Any) {
        performSegue(withIdentifier: "showDestinationSearchTableView", sender: self)
        destinationAddressField.endEditing(true)
        
    }
    
    //Getting currentlocation
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let myCurrentLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myCurrentLocation, span)
        mapView.setRegion(region, animated: true)
        origPin.coordinate = myCurrentLocation
        mapView.addAnnotation(origPin)
        origPin.title = "Orign"
        self.mapView.showsUserLocation = true
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print ("there was an error")
            } else if (placemark?.count)! > 0 {
                let pm = placemark![0]
                let address = self.getAddressString(placemark: pm)
                self.location = address!
            }
            
            var trimmed = self.location
            trimmed = trimmed.replacingOccurrences(of: "\n", with: ", ")
            
            self.originAddressField.text = "\(trimmed)"
            manager.stopUpdatingLocation()
            
        }
    }

        
    func getAddressString(placemark: CLPlacemark) -> String? {
        var originAddress : String?
        
        if let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String]
        {
            originAddress =  addrList.joined(separator: ", ")
        }
        
        return originAddress
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "trafficDataViewControllerSegue", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trafficDataViewControllerSegue" {
             let DestViewController = segue.destination as! TrafficDataViewController
            
                DestViewController.origin = originAddressField.text!
                DestViewController.destination = destinationAddressField.text!
                print(DestViewController.origin)
                print(DestViewController.destination)
            
            
            DestViewController.readyTime = self.readyTime!
            DestViewController.reachTime = self.reachTime!
            DestViewController.fromAlarmTime = self.fromAlarmTime!
                        
        } else if segue.identifier == "showOriginSearchTableView" {
            let DestViewController = segue.destination as! SearchViewController
            DestViewController.flag = 0
        } else if segue.identifier == "showDestinationSearchTableView" {
            
            
            let DestViewController = segue.destination as! SearchViewController
            DestViewController.flag = 1
            
        }
    }
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                let controller = UIAlertController(title: "Location Services are disabled", message: "Please enable location for better user experience", preferredStyle: .alert)
                
                controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                }))
                
                if (currentController) != nil {
                    currentController.present(controller, animated: true, completion: nil)
                }
                else {
                    print("no current controller sorry")
                    
                    return
                    
                }
                
                
            

            case .authorizedWhenInUse:
                print("Access")
            default:
                print("...")
            }
        } else {
            
            
    let controller = UIAlertController(title: "Location Services are disabled", message: "Please enable location for better user experience", preferredStyle: .alert)
    
    controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
    }))
    
    if (currentController) != nil {
    currentController.present(controller, animated: true, completion: nil)
    }
    else {
    print("no current controller sorry")
    
    return
    
    }
        }
    
    
        if InternetConnectionHelper.connectedToNetwork() == false {
    
            let controller = UIAlertController(title: "No Internet Connection", message: "You need internet connection to use this feature", preferredStyle: .alert)
            
            controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            }))
            
            if (currentController) != nil {
                currentController.present(controller, animated: true, completion: nil)
            }
            else {
                print("no current controller sorry")
                
                return
                
            }

            
        }
        
        currentController = self
        // For use in foreground
        self.manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        manager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
        
        self.hideKeyboard()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

