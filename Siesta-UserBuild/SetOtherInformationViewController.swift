//
//  SetAlarmViewController.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 17/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import UserNotifications

class SetOtherInformationViewController: UIViewController, UNUserNotificationCenterDelegate {

    
    @IBOutlet weak var readyTime: UIDatePicker!
    @IBOutlet weak var reachTime: UIDatePicker!
    
    var fromAlarmTime: Date?
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "locationSettingsViewControllerSegue", sender: self)
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
            DestViewController.fromAlarmTime = fromAlarmTime
            
            
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
        UNUserNotificationCenter.current().delegate = self
        readyTime.setValue(UIColor.white, forKeyPath: "textColor")
        readyTime.setValue(false, forKeyPath: "highlightsToday")
        reachTime.setValue(UIColor.white, forKeyPath: "textColor")
        reachTime.setValue(false, forKeyPath: "highlightsToday")

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


