//
//  DisplayAlarmViewController.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 21/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class DisplayAlarmViewController: UIViewController {
    
    
    //Locations
    @IBOutlet weak var alarmOriginTextField: UITextField!
    @IBOutlet weak var alarmDestinationTextField: UITextField!
    
    //InitialAlarm
    var initialAlarmDatePicker = UIDatePicker()
    @IBOutlet weak var initialAlarmTextField: UITextField!
    
    
    //ReadyTime
    var readyTimeDatePicker = UIDatePicker()
    @IBOutlet weak var readyTimeTextField: UITextField!
    
    
    //ReachTime
    var reachTimeDatePicker = UIDatePicker()
    @IBOutlet weak var reachTimeTextField: UITextField!
    

    @IBOutlet weak var alarmSwitch: UISwitch!
    var origin: String = " "
    var destination: String = " "
    var alarmInterval: String = " "
    var fromAlarmTime: Date?
    var readyTime: TimeInterval?
    var reachTime: Date?
    var alarm: Alarm?
    
    
    //Datepicker Toolbars
    
    //Date picker for initial alarm
    func pickUpInitialAlarmDatePicker() {
        
        
        //creating toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        initialAlarmDatePicker.datePickerMode = .time
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneAndSetInitialAlarm))
        toolBar.setItems([doneButton], animated: false)
        initialAlarmTextField.inputAccessoryView = toolBar
        initialAlarmTextField.inputView = initialAlarmDatePicker
    }
    
    //Date picker for reach time
    
       func pickUpReachTimeDatePicker() {
    
        //creating toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        reachTimeDatePicker.datePickerMode = .time
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneAndSetReachTime))
        toolBar.setItems([doneButton], animated: false)
        reachTimeTextField.inputAccessoryView = toolBar
        reachTimeTextField.inputView = reachTimeDatePicker
    }

    func pickUpReadyTimeDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        readyTimeDatePicker.datePickerMode = .countDownTimer
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneAndSetreadyTime))
        toolBar.setItems([doneButton], animated: false)
        readyTimeTextField.inputAccessoryView = toolBar
        readyTimeTextField.inputView = readyTimeDatePicker

    }
    
    
    // done button for toolbar
    func doneAndSetInitialAlarm() {
       initialAlarmTextField.text = DateFormatterHelper.dateFormatter(date: initialAlarmDatePicker.date)
       self.view.endEditing(true)
    }
    
    func doneAndSetreadyTime() {
        readyTimeTextField.text = DateFormatterHelper.dateFormatter(date: readyTimeDatePicker.date)
        self.view.endEditing(true)
    }
    
    func doneAndSetReachTime() {
        self.reachTimeTextField.text = DateFormatterHelper.dateFormatter(date: reachTimeDatePicker.date)
        self.view.endEditing(true)
    }

    
    //initial alarm text field tapped
    @IBAction func intialAlarmTextFieldBeginEditing(_ sender: Any) {
        self.pickUpInitialAlarmDatePicker()
        
    }
    
    
    
    //ready time text field tapped
    @IBAction func readyTimeTextFieldBeginEditing(_ sender: Any) {
       self.pickUpReadyTimeDatePicker()
    }
    
    //reach time text field tapped
    @IBAction func reachTimeTextFieldBeginEditing(_ sender: Any) {
         self.pickUpReachTimeDatePicker()
        
    }
    
    @IBAction func editOrignFieldTapped(_ sender: Any) {
        performSegue(withIdentifier: "editOriginSegue", sender: self)
        alarmOriginTextField.endEditing(true)
    }
    
    @IBAction func editDestinationFieldTapped(_ sender: Any) {
        performSegue(withIdentifier: "editDestinationSegue", sender: self)
        alarmDestinationTextField.endEditing(true)
    }
    
    
    @IBAction func setUpNewInitialAlarm(_ sender: Any) {
    
        let calendar = Calendar(identifier: .gregorian)
          var initialAlarm = DateFormatterHelper.dateFormatterFromString(stringDate: initialAlarmTextField.text!)
        
          let currentDate = Date()
        if currentDate > initialAlarm {
            initialAlarm = calendar.date(byAdding: .day, value: 1, to: initialAlarm)!
        }
        
        var initialAlarmComponents = calendar.dateComponents(in: .current, from: initialAlarm)
        print(initialAlarm)
        NotificationHelper.createNotification("initialAlarm", "It's \(initialAlarmComponents.hour ?? 00):\(initialAlarmComponents.minute ?? 00)", "Go back to sleep after opening the app", "Please keep the app open", "venus-isle-30", initialAlarmComponents)
    }
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            
            let alarm = self.alarm!
                alarm.origin = alarmOriginTextField.text!
                alarm.destination = alarmDestinationTextField.text!
                let formatter = DateFormatter()
                formatter.dateFormat = "HH : mm"
            formatter.timeZone = TimeZone.current
            print(TimeZone.current)
            var readyTimeInDate = formatter.date(from: readyTimeTextField.text!)
            
            let currentTZ = TimeZone.current
            print(readyTimeInDate!)
            let currentDate = Date()
            let calendar = Calendar.current
            if currentTZ.isDaylightSavingTime(for: currentDate) == true {
            readyTimeInDate = calendar.date(byAdding: .hour, value: -1, to: readyTimeInDate!)
            }
            
            
               var components = calendar.dateComponents(in: .current, from: currentDate)
               components.hour = 0
               components.minute = 0
               components.second = 0
               let todayMidnight = calendar.date(from: components)!
               let readyTimeInterval = readyTimeInDate?.timeIntervalSince(todayMidnight)
            
                alarm.readyTime = Int64(readyTimeInterval!)
                
                let reachTimeString = formatter.date(from: reachTimeTextField.text!)
                alarm.reachTime = reachTimeString! as NSDate
                let initialAlarmString = formatter.date(from: initialAlarmTextField.text!)
                alarm.fromInterval = initialAlarmString! as NSDate
                alarm.isOn = alarmSwitch.isOn
            CoreDataHelper.saveAlarm()
        } else if segue.identifier == "editOriginSegue" {
            let DestVC = segue.destination as! SearchViewController
            DestVC.editingFlag = 1
            DestVC.editField = 0
            
        } else if segue.identifier == "editDestinationSegue" {
            let DestVC = segue.destination as! SearchViewController
            DestVC.editingFlag = 1
            DestVC.editField = 1
        }
        
        

    }
    
    @IBAction func unwindToEditLocationSettingsViewController(_ segue: UIStoryboardSegue) {
        
        let sourceVC = segue.source as! SearchViewController
        if sourceVC.editField == 0 {
       
      alarm?.origin = sourceVC.searchResult!
//            alarmOriginTextField.text = origin
        } else if sourceVC.editField == 1 {
          alarm?.destination = sourceVC.searchResult!
//            alarmDestinationTextField.text = destination
        }
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let alarm = alarm {
            alarmOriginTextField.text = alarm.origin
            alarmDestinationTextField.text = alarm.destination
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let gmtFormatter = DateFormatter()
            gmtFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
            gmtFormatter.dateFormat = "HH : mm"
            let readyTimeInSeconds = Double(alarm.readyTime)
            let readyTimeInDate = Date(timeIntervalSince1970: TimeInterval(readyTimeInSeconds))
            initialAlarmTextField.text = DateFormatterHelper.dateFormatter(date: alarm.fromInterval! as Date)
            readyTimeTextField.text = gmtFormatter.string(from: readyTimeInDate)
            reachTimeTextField.text = DateFormatterHelper.dateFormatter(date: alarm.reachTime! as Date)
            
        } else {
           
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let logo = UIImage(named: "DisplayIcon.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        UIApplication.shared.statusBarStyle = .lightContent
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
