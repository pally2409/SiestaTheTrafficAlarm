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
    var toAlarmTime: Date?
    
    
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
        self.calculateWakeUpTime()
        
        })
        
       
    }
    
    
    func convertUnixDateToTimeInterval (_ ditUnix: Double) {
        trafficDurationF = TimeInterval(ditUnix)

    }
    
    func calculateWakeUpTime () {
        print("ready time: \(readyTime!)")
        print("reach time: \(reachTime!)")
        print("traffic time \(trafficDurationF!)")
        
        TimeCalculationsHelper.calculateWakeUpTime(readyTime, trafficDurationF, reachTime)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListAlarms" {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH : mm"
            let calendar = Calendar.current
            let fromIntervalComponents = calendar.dateComponents(in: .current, from: fromAlarmTime!)
            let fromIntervalString = "\(fromIntervalComponents.hour!) : \(fromIntervalComponents.minute!)"
            let toIntervalComponents = calendar.dateComponents(in: .current, from: toAlarmTime!)
            let toIntervalString = "\(toIntervalComponents.hour!) : \(toIntervalComponents.minute!)"
            let reachTimeComponents = calendar.dateComponents(in: .current, from: reachTime!)
            let reachTimeString = "\(reachTimeComponents.hour!) : \(reachTimeComponents.minute!)"
            let newAlarm = CoreDataHelper.newAlarm()
            newAlarm.origin = origin
            newAlarm.destination = destination
            newAlarm.fromInterval = (formatter.date(from: fromIntervalString)! as NSDate)
            newAlarm.toInterval = (formatter.date(from: toIntervalString)! as NSDate)
            let readyTimeCast = NSDate(timeIntervalSince1970: readyTime!)
            let readyTimeString = formatter.string(from: readyTimeCast as Date)
            let readyTimeDate = formatter.date(from: readyTimeString)
            newAlarm.readyTime = readyTimeDate! as NSDate
            newAlarm.reachTime = (formatter.date(from: reachTimeString)! as NSDate)
            newAlarm.isOn = false
             CoreDataHelper.saveAlarm()
        }
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
