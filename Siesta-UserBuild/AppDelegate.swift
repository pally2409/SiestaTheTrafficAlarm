//
//  AppDelegate.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 17/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import UserNotifications
import CoreLocation
import MapKit
import GooglePlaces

var currentController: UIViewController!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    var locationManager: CLLocationManager?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey("AIzaSyB6XJH5i52THSBY5kaTLNCiTWelK_KGsmQ")
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification)
    {
        
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "venus-isle-30", ofType: "wav")!)
        print(alertSound)
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
        
        let controller = UIAlertController(title: "test", message: "hello", preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "option 1", style: .default, handler: { action in
            self.audioPlayer?.stop()
        }))
        
        currentController.present(controller, animated: true, completion: nil)

    }

}

