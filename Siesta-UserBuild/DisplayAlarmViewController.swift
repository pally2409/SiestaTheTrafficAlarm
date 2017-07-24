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
    
    var origin: String = " "
    var destination: String = " "
    var alarmInterval: String = " "
    var fromAlarmTime: Date?
    var toAlarmTime: Date?
    var readyTime: TimeInterval?
    var reachTime: Date?
    var alarm: Alarm?
    
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListAlarmsTableViewController
        if segue.identifier == "save" {
            if let alarm = alarm {
                alarm.origin = alarmOriginTextField.text!
                alarm.destination = alarmDestinationTextField.text!
                alarm.readyTime = TimeInterval(readyTimeTextField.text!)!
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let reachTimeString = formatter.date(from: reachTimeTextField.text!)
                alarm.reachTime = reachTimeString!
                let fromIntervalString = formatter.date(from: fromIntervalLabel.text!)
                let toIntervalString = formatter.date(from: toIntervalLabel.text!)
                alarm.fromInterval = fromIntervalString!
                alarm.toInterval = toIntervalString!
                destinationVC.tableView.reloadData()
            } else {
            
            
        }
      }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let alarm = alarm {
            alarmOriginTextField.text = alarm.origin
            alarmDestinationTextField.text = alarm.destination
            readyTimeTextField.text = String(alarm.readyTime)
            let calendar = Calendar.current
            let componentsReachTime = calendar.dateComponents(in: .current, from: alarm.reachTime)
            let componentsFromAlarmTime = calendar.dateComponents(in: .current, from: alarm.fromInterval)
            let componentsToAlarmTime = calendar.dateComponents(in: .current, from: alarm.toInterval)
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
