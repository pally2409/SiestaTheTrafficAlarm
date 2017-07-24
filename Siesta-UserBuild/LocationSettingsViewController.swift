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
    var toAlarmTime: Date?
    
    

    
    
    
    @IBOutlet weak var currentLocationAddressField: UITextField!
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    
    @IBOutlet weak var inputLocationAddressField: UITextField!
    @IBOutlet weak var inputLocationSwitch: UISwitch!
    
    @IBOutlet weak var destinationAddressField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func inputLocationSwitchOn(_ sender: Any) {
            if self.inputLocationSwitch.isOn {
                self.inputLocationAddressField.isEnabled = true
                currentLocationSwitch.isOn = false
                present(autocompleteControllerOrigin, animated: true, completion: nil)
            }
            else {
                self.inputLocationAddressField.isEnabled = false
            }

    }
    
    @IBAction func currentLocationSwitchOn(_ sender: Any) {
        if currentLocationSwitch.isOn {
            currentLocationAddressField.isEnabled = true
            inputLocationSwitch.isOn = false
        }
        else {
            currentLocationAddressField.isEnabled = false
        }
        manager.startUpdatingLocation()
    }
    
    
    //Getting currentlocation
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
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
            
            self.currentLocationAddressField.text = "\(trimmed)"
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
    
    @IBAction func textFieldEditingDidEnd(_ sender: Any) {
                   if (!(inputLocationAddressField.text?.isEmpty)! && !(destinationAddressField.text?.isEmpty)!) || !(currentLocationAddressField.text?.isEmpty)! && !(destinationAddressField.text?.isEmpty)! {
                continueButton.isEnabled = true
            } else {
                continueButton.isEnabled = false
            }

    }
    @IBAction func addressFieldTapped(_ sender: Any) {
        present(autocompleteControllerDestination, animated: true, completion: nil)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "trafficDataViewControllerSegue", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trafficDataViewControllerSegue" {
             let DestViewController = segue.destination as! TrafficDataViewController
            if currentLocationSwitch.isOn == true {
            DestViewController.origin = currentLocationAddressField.text!
            DestViewController.destination = destinationAddressField.text!
            print(DestViewController.origin)
            print(DestViewController.destination)
                
            } else {
                DestViewController.origin = inputLocationAddressField.text!
                DestViewController.destination = destinationAddressField.text!
                print(DestViewController.origin)
                print(DestViewController.destination)
                
            }
            
            DestViewController.readyTime = self.readyTime!
            DestViewController.reachTime = self.reachTime!
            DestViewController.fromAlarmTime = self.fromAlarmTime!
            DestViewController.toAlarmTime = self.toAlarmTime!
            
        }
    }
 
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For use in foreground
        self.manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        self.hideKeyboard()
        autocompleteControllerOrigin.delegate = self
        autocompleteControllerDestination.delegate = self

        // Do any additional setup after loading the view.
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

extension LocationSettingsViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)!")
        print("Place attributions: \(place.attributions)!")
        dismiss(animated: true, completion: nil)
        
        if viewController == autocompleteControllerOrigin {
            inputLocationAddressField.text = "\(place.formattedAddress!)"
        } else {
            destinationAddressField.text = "\(place.formattedAddress!)"
        }
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
