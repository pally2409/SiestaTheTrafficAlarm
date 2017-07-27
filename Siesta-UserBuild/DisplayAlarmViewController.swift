//
//  DisplayAlarmViewController.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 21/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class DisplayAlarmViewController: UIViewController {
    
    
    @IBOutlet weak var alarmOriginTextField: UITextField!
    @IBOutlet weak var alarmDestinationTextField: UITextField!
    @IBOutlet weak var readyTimeTextField: UITextField!
    
    @IBOutlet weak var reachTimeTextField: UITextField!
    
    @IBOutlet weak var fromIntervalLabel: UITextField!
   
    @IBOutlet weak var dashedLabel: UITextField!
    
    @IBOutlet weak var toIntervalLabel: UITextField!
    
    @IBOutlet weak var alarmSwitch: UISwitch!
    var origin: String = " "
    var destination: String = " "
    var alarmInterval: String = " "
    var fromAlarmTime: Date?
    var toAlarmTime: Date?
    var readyTime: TimeInterval?
    var reachTime: Date?
    var alarm: Alarm?
    
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            
            let alarm = self.alarm!
                alarm.origin = alarmOriginTextField.text!
                alarm.destination = alarmDestinationTextField.text!
                
//                let readyTimeCast = NSDate(timeIntervalSince1970: Double(readyTimeTextField.text!)!)
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
//                let readyTimeString = formatter.string(from: readyTimeCast as Date)
                let readyTimeDate = formatter.date(from: readyTimeTextField.text!)
                alarm.readyTime = Int64(readyTime!)
                let reachTimeString = formatter.date(from: reachTimeTextField.text!)
                alarm.reachTime = reachTimeString! as NSDate
                let fromIntervalString = formatter.date(from: fromIntervalLabel.text!)
                let toIntervalString = formatter.date(from: toIntervalLabel.text!)
                alarm.fromInterval = fromIntervalString! as NSDate
                alarm.toInterval = toIntervalString! as NSDate
                alarm.isOn = alarmSwitch.isOn
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let alarm = alarm {
            alarmOriginTextField.text = alarm.origin
            alarmDestinationTextField.text = alarm.destination
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            readyTimeTextField.text = String(alarm.readyTime)
            let calendar = Calendar.current
            let componentsReachTime = calendar.dateComponents(in: .current, from: alarm.reachTime! as Date)
            let componentsFromAlarmTime = calendar.dateComponents(in: .current, from: alarm.fromInterval! as Date)
            let componentsToAlarmTime = calendar.dateComponents(in: .current, from: alarm.toInterval! as Date)
            reachTimeTextField.text = "\(componentsReachTime.hour!) : \(componentsReachTime.minute!)"
            fromIntervalLabel.text = "\(componentsFromAlarmTime.hour!):\(componentsFromAlarmTime.minute!)"
            toIntervalLabel.text = "\(componentsToAlarmTime.hour!):\(componentsToAlarmTime.minute!)"
        } else {
           
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
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
