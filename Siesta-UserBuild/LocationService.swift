//
//  LocationService.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 18/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON


class LocationService {
    
    
    static var duration_in_traffic: String =  " "
    static var distance: String = " "
    static var timeUnix: Double = 0.0
    static var origin: String = " "
    static var destination: String = " "
    
    
    static func durationTraffic(_ origin: String, _ destination: String, completion: @escaping (String, String, Double) -> Void) {
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let validOrigin = origin.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let validDestination = destination.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(validOrigin)&destinations=\(validDestination)&departure_time=now&traffic_model=best_guess&key=AIzaSyDez34Ppe7_MNun3BYGJk_CZeH4BNFx1EU")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        let jsonLocation = JSON(json)
                        print(jsonLocation["destination_addresses"][0].stringValue)
                        
                        duration_in_traffic = jsonLocation["rows"][0]["elements"][0]["duration_in_traffic"]["text"].stringValue
                        distance = jsonLocation["rows"][0]["elements"][0]["distance"]["text"].stringValue
                        // timeUnix
                        let rawTime = jsonLocation["rows"][0]["elements"][0]["duration_in_traffic"]["value"].rawValue as? Double
                        
                        if let realDouble = rawTime
                        {
                            timeUnix = realDouble
                        }
                        
                        
                        
                        //All UI updates should be in the main thread.
                        DispatchQueue.main.async {
                            completion(duration_in_traffic, distance, timeUnix)
                        }
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
            }
            
        })
        task.resume()
    }
    
   
}
