//
//  AppDelegate.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 17/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AudioToolbox
import UserNotifications
import CoreLocation
import MapKit
import GooglePlaces
import CoreData

var currentController: UIViewController!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {
    
    
    var vc = ListAlarmsTableViewController()
    var backgroundSessionCompletionHandler: (() -> Void)?
    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    var locationManager: CLLocationManager?
    
    

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor(red: 249/255, green: 147/255, blue: 145/255, alpha: 1)
        

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
         if let initialViewController = storyboard.instantiateInitialViewController() {
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
            GMSPlacesClient.provideAPIKey("AIzaSyB6XJH5i52THSBY5kaTLNCiTWelK_KGsmQ")
            locationManager = CLLocationManager()
            locationManager?.requestWhenInUseAuthorization()
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
            
            
            
        }
        
        
        
        return true
        
        
        // Override point for customization after application launch.

    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Alarm")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }
    
        
                
        func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            
            let alarms: [Alarm] = CoreDataHelper.retrieveAlarms()
            for alarm in alarms {
                LocationService.durationTraffic(alarm.origin!, alarm.destination! , completion: { duration_in_traffic, distance, timeUnix in

                    print("fetched from background: \(duration_in_traffic)")
                   
                })
        
            }
        
             completionHandler(UIBackgroundFetchResult.newData)
            

        }
        
    
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        
//        }
//    
//        func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
    
    
    func passDataFromAPI() {
        
        
        let alarms: [Alarm] = CoreDataHelper.retrieveAlarms()
        print("lol palli")
        for alarm in alarms {
            if alarm.isOn == true {
                LocationService.durationTraffic(alarm.origin!, alarm.destination!, completion: {
                    duration_in_traffic, distance, timeUnix in
                    
                    let calendar = Calendar.current
                    let readyTimeInterval = TimeInterval(alarm.readyTime)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH : mm"
                    formatter.timeZone = TimeZone.current
                    let trafficDurationF = TimeInterval(timeUnix)
                    var reachTimeInDate = alarm.reachTime! as Date
                    
                    var wakeUpTime = TimeCalculationsHelper.calculateWakeUpTime(readyTimeInterval, trafficDurationF, reachTimeInDate)
                    
                    let currentTZ = TimeZone.current
                    let currentDate1 = Date()
                    let calendar2 = Calendar.current
                    
                    if alarm.reachTimeString == "no"
                    {
                        if currentTZ.isDaylightSavingTime(for: currentDate1) == true {
                            wakeUpTime = calendar2.date(byAdding: .hour, value: -1, to: wakeUpTime)!
                        }

                        
                    }
                    
                    
                
                    
                    var currentDate = Date()
                    var currentDateComponents = calendar.dateComponents(in: .current, from: currentDate)
                    var wakeUpComp = calendar.dateComponents(in: .current, from: wakeUpTime)
                    var helperComponents = calendar.dateComponents(in: .current, from: currentDate)
                    let newHelperComponents = DateComponents(calendar: calendar, timeZone: .current, year: helperComponents.year, month: helperComponents.month, day: helperComponents.day, hour: wakeUpComp.hour, minute: wakeUpComp.minute)

                    wakeUpTime = calendar.date(from:   newHelperComponents)!
                    if currentDate > wakeUpTime {
                        wakeUpTime = calendar.date(byAdding: .day, value: 1, to: wakeUpTime)!
                    }
                
                    
                    var wakeUpTimecomponents = calendar.dateComponents(in: .current, from: wakeUpTime)
                    var finalWakeUpComponents = DateComponents(calendar: calendar, timeZone: .current, year: wakeUpTimecomponents.year, month: wakeUpTimecomponents.month, day: wakeUpTimecomponents.day, hour: wakeUpTimecomponents.hour, minute: wakeUpTimecomponents.minute)

                    print("wake up components")
                    print(finalWakeUpComponents)
                    
                    
                    NotificationHelper.createNotification("trafficAlarm", "Wake Up", "You should wake up now", "You should wake up now to reach on time", "venus-isle-30", finalWakeUpComponents)
                    
                    
                    let center = UNUserNotificationCenter.current()
                    center.getPendingNotificationRequests(completionHandler: { requests in
                        for request in requests {
                            print("the pending requests are \(request)")
                        }
                    })

                })
                
                
               
            }
            
        }
        
    }
    

    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification)
    {
        if notification.category == "initialAalrmCategory"
        {
        passDataFromAPI()
            
        }
       //        self.audioPlayer?.stop()
//        
//        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "venus-isle-30", ofType: "wav")!)
//        print(alertSound)
//        
//        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//        try! AVAudioSession.sharedInstance().setActive(true)
//        
//        try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
//        audioPlayer!.prepareToPlay()
//        audioPlayer!.play()
        
        let controller = UIAlertController(title: "test", message: "hello", preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "option 1", style: .default, handler: { action in
            self.audioPlayer?.stop()
        }))
        
        if (currentController) != nil {
            currentController.present(controller, animated: true, completion: nil)
        }
            else {
             print("no current controller sorry")
            
        return
        
        }
        
        
    
    }

}


