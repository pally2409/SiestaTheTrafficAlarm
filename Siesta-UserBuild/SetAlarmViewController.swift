//
//  SetAlarmViewController.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 17/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import UserNotifications

class SetAlarmViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var fromAlarmTime: UIDatePicker!
    @IBOutlet weak var toAlarmTime: UIDatePicker!
    @IBOutlet weak var readyTime: UIDatePicker!
    @IBOutlet weak var reachTime: UIDatePicker!
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        self.initialAlarm()
    }
   
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "locationSettingsViewControllerSegue", sender: self)
    }
    
    func initialAlarm() {
        
        //Components from Date Picker
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: fromAlarmTime.date)
        
        let initialAlarmTimeComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        //Notification
        NotificationHelper.createNotification("initialAlarm", "It's \(initialAlarmTimeComponents.hour ?? 00):\(initialAlarmTimeComponents.minute ?? 00)", "Go back to sleep after opening the app", "Please keep the app open", "venus-isle-30", initialAlarmTimeComponents)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationSettingsViewControllerSegue"
        {
            let DestViewController = segue.destination as! LocationSettingsViewController
            let currentDate = Date()
            let calendar = Calendar.current
            var components = calendar.dateComponents(in: .current, from: currentDate)
            components.hour = 0
            components.minute = 0
            components.second = 0
            let todayMidnight = calendar.date(from: components)!
            let readyTimeInterval = readyTime.date.timeIntervalSince(todayMidnight)
            DestViewController.readyTime = readyTimeInterval
            DestViewController.reachTime = reachTime.date
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //Setting the current controller
        currentController = self
        
        //Asking authorization from user
        UNUserNotificationCenter.current().requestAuthorization(options: [], completionHandler: {didAllow, error in
        })
        UNUserNotificationCenter.current().delegate = self
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


