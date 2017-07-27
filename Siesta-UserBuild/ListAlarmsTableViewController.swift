//
//  ListNotesTableTableViewController.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 21/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class ListAlarmsTableViewController: UITableViewController {
    
    let currentTime = Date()
    var activeAlarms = [Alarm]()
    var alarms = [Alarm]() {
    didSet {
        tableView.reloadData()
    }
    
    }
    
    
    @IBAction func unwindToListAlarmsViewController(_ segue: UIStoryboardSegue) {
        self.alarms = CoreDataHelper.retrieveAlarms()
        
    }
    
   func getActiveAlarms() {
        
    for alarm in alarms {
        if alarm.isOn == true {
            activeAlarms.append(alarm)
        }
    }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "displayAlarmFromListSegue" {
                print("Table view cell tapped")
                let indexPath = tableView.indexPathForSelectedRow!
                let alarm = alarms[indexPath.row]
                let destinationVC = segue.destination as! DisplayAlarmViewController
                destinationVC.alarm = alarm
                
                
            }
                
            }
        }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        alarms = CoreDataHelper.retrieveAlarms()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let logo = UIImage(named: "Group 4.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
//        getActiveAlarms()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH : mm"
//        let currentTimeString = formatter.string(from: currentTime)
//        let currentTimeFormatted = formatter.date(from: currentTimeString)
//        let calendar = Calendar.current
//        let currentTimecomponents = calendar.dateComponents(in: .current, from: currentTimeFormatted!)
//        
//        for alarm in activeAlarms {
//            let alarmTimeComponents = calendar.dateComponents(in: .current, from: alarm.fromInterval as! Date)
//            if currentTimecomponents.hour! > alarmTimeComponents.hour! {
//                
//            }
//        }
        
        
        
    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            CoreDataHelper.delete(alarm: alarms[indexPath.row])
            alarms = CoreDataHelper.retrieveAlarms()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listAlarmsTableViewCell", for: indexPath) as! ListAlarmsTableViewCell
        // Configure the cell...
        let row = indexPath.row
        let alarm = alarms[row]
        let calendar = Calendar.current
        let componentsFromAlarmTime = calendar.dateComponents(in: .current, from: alarm.fromInterval! as Date)
        let componentsToAlarmTime = calendar.dateComponents(in: .current, from: alarm.toInterval! as Date)
        
        cell.alarmTimeLabel.text = "\(componentsFromAlarmTime.hour!) : \(componentsFromAlarmTime.minute!) -  \(componentsToAlarmTime.hour!) : \(componentsToAlarmTime.minute!)"
        cell.alarmOrigin.text = alarm.origin
        cell.alarmDestination.text = alarm.destination
        
        return cell
        
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
