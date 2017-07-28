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
    var fromAlarmTime: Date?
    
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toListAlarms", sender: self)
    }
    
    
    
   func passDataFromAPI() {
        
        LocationService.durationTraffic(origin, destination, completion: { duration_in_traffic, distance, timeUnix in
        self.estTimeTextLabel.text = duration_in_traffic
        self.distanceTextLabel.text = distance
        self.trafficDuration = timeUnix
            print("print pass data from api traffic duration \(self.trafficDuration)")
        self.convertUnixDateToTimeInterval(self.trafficDuration)
        let wakeUpTime = self.calculateWakeUpTime()
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: .current, from: wakeUpTime)
        let currentDate = Date()
        let currentDateComponents = calendar.dateComponents(in: .current, from: currentDate)
        let trafficAlarmTimeComponents = DateComponents(calendar: calendar, timeZone: .current, month:
            currentDateComponents.month, day: currentDateComponents.day, hour: components.hour, minute: components.minute)
            
        NotificationHelper.createNotification("trafficAlarm", "Wake Up", "You should wake up now", "You should wake up now to reach on time", "venus-isle-30", trafficAlarmTimeComponents)
        })
    
    
    }
    
    
    
    
    func convertUnixDateToTimeInterval (_ ditUnix: Double) {
        trafficDurationF = TimeInterval(ditUnix)

    }
    
    func calculateWakeUpTime () -> Date {
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH : mm"
////        let readyTimeString = formatter.string(from: )
        print("ready time: \(readyTime!)")
        print("reach time: \(reachTime!)")
        print("traffic time \(trafficDurationF!)")
        
        let wakeUpTime = TimeCalculationsHelper.calculateWakeUpTime(readyTime, trafficDurationF, reachTime)
        return wakeUpTime
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListAlarms" {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH : mm"
            let calendar = Calendar.current
            let fromIntervalComponents = calendar.dateComponents(in: .current, from: fromAlarmTime!)
            let fromIntervalString = "\(fromIntervalComponents.hour!) : \(fromIntervalComponents.minute!)"
            let reachTimeComponents = calendar.dateComponents(in: .current, from: reachTime!)
            let reachTimeString = "\(reachTimeComponents.hour!) : \(reachTimeComponents.minute!)"
            let newAlarm = CoreDataHelper.newAlarm()
            newAlarm.origin = origin
            newAlarm.destination = destination
            newAlarm.fromInterval = (formatter.date(from: fromIntervalString)! as NSDate)
           
            newAlarm.readyTime = Int64(readyTime!)
            newAlarm.reachTime = (formatter.date(from: reachTimeString)! as NSDate)
            newAlarm.isOn = true
            newAlarm.reachTimeString = reachTimeString
             CoreDataHelper.saveAlarm()
        }
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        passDataFromAPI()
        
        
        
        
        
        
        
        currentController = self
        
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
