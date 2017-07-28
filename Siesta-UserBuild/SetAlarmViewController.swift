//
//  SetOtherInformationViewController.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 23/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import UserNotifications

class SetAlarmViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var fromAlarmTime: UIDatePicker!
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        self.initialAlarm()
        performSegue(withIdentifier: "otherInfoSegue", sender: self)
    }

    func initialAlarm() {
        
        //Components from Date Picker
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: fromAlarmTime.date)
        
        let initialAlarmTimeComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        //Notification
        NotificationHelper.createNotification("initialAlarm", "It's \(initialAlarmTimeComponents.hour ?? 00):\(initialAlarmTimeComponents.minute ?? 00)", "Go back to sleep after opening the app", "Please keep the app open", "venus-isle-30", initialAlarmTimeComponents)
        
        print(fromAlarmTime.date)
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "otherInfoSegue" {
            let DestViewController = segue.destination as! SetOtherInformationViewController
            DestViewController.fromAlarmTime = fromAlarmTime.date
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let logo = UIImage(named: "Group 4.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        
        //Setting the current controller
        currentController = self
        
        //Asking authorization from user
        UNUserNotificationCenter.current().requestAuthorization(options: [], completionHandler: {didAllow, error in
        })
        fromAlarmTime.setValue(UIColor.white, forKeyPath: "textColor")
        fromAlarmTime.setValue(false, forKeyPath: "highlightsToday")
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
