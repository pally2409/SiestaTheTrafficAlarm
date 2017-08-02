//
//  NotificationHelper.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 21/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationHelper {
    
    static func createNotification(_ alarmType: String, _ title: String, _ subtitle: String, _ body: String, _ soundName: String, _ alarmTimeComponents: DateComponents) {
        
        if alarmType == "initialAlarm" {
            let initialAlarmContent = UNMutableNotificationContent()
            initialAlarmContent.title = title
            initialAlarmContent.subtitle = subtitle
            initialAlarmContent.body = body
            initialAlarmContent.sound = UNNotificationSound.init(named: soundName)
            initialAlarmContent.categoryIdentifier = "initialAalrmCategory"
            let trigger = UNCalendarNotificationTrigger(dateMatching: alarmTimeComponents, repeats: false)
            let request = UNNotificationRequest(identifier:
                "initialAlarmDone", content: initialAlarmContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print("notification is scheduled for \(alarmTimeComponents.hour!):\(alarmTimeComponents.minute!)")
            
        } else if alarmType == "trafficAlarm" {
            let trafficAlarmContent = UNMutableNotificationContent()
            trafficAlarmContent.title = title
            trafficAlarmContent.subtitle = subtitle
            trafficAlarmContent.body = body
            trafficAlarmContent.sound = UNNotificationSound.init(named: soundName)
            trafficAlarmContent.categoryIdentifier = "AlarmCategory"
            let trigger = UNCalendarNotificationTrigger(dateMatching: alarmTimeComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier:
                "trafficAlarmDone", content: trafficAlarmContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
                
            
            print("notification is scheduled for \(alarmTimeComponents.hour!):\(alarmTimeComponents.minute!)")
        }
    }
}


