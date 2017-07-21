//
//  TrafficDataViewController.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 18/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Foundation

class TrafficDataViewController: UIViewController {
    


    @IBOutlet weak var distanceFromTextLabel: UILabel!
    @IBOutlet weak var distanceTextLabel: UILabel!
    
    @IBOutlet weak var estTextLabel: UILabel!
    @IBOutlet weak var estTimeTextLabel: UILabel!
    
    
    
    var origin: String = " "
    var destination: String = " "
    var trafficDuration: Double = 0.0
    var readyTime: TimeInterval?
    var reachTime: Date?
    var trafficDurationF: TimeInterval?
    
    
    
   func passDataFromAPI() {
        
        LocationService.durationTraffic(origin, destination, completion: { duration_in_traffic, distance, timeUnix in
        self.estTimeTextLabel.text = duration_in_traffic
        self.distanceTextLabel.text = distance
        self.trafficDuration = timeUnix
            print("print pass data from api traffic duration \(self.trafficDuration)")
        self.convertUnixDateToTimeInterval(self.trafficDuration)
        self.calculateWakeUpTime()
        
        })
        
       
    }
    
    
    func convertUnixDateToTimeInterval (_ ditUnix: Double) {
        trafficDurationF = TimeInterval(ditUnix)

    }
    
    func calculateWakeUpTime () {
        print("ready time: \(readyTime)")
        print("reach time: \(reachTime)")
        print("traffic time \(trafficDurationF)")
        
//        let calendar = Calendar.current
//        let readyPlusTraffic = -1*(trafficDurationF! + readyTime!)
//        let wakeUpTime = calendar.date(byAdding: .second, value: Int(readyPlusTraffic), to: reachTime!)
//        let wakeUpTimeComponents = calendar.dateComponents(in: .current, from: wakeUpTime!)
//        print("\(wakeUpTimeComponents.hour)! : \(wakeUpTimeComponents.minute)!")
        
        TimeCalculationsHelper.calculateWakeUpTime(readyTime, trafficDurationF, reachTime)
        
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        passDataFromAPI()
        _ = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(passDataFromAPI), userInfo: nil, repeats: true)
        
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
