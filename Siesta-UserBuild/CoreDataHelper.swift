//
//  CoreDataHelper.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 24/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    
    static func newAlarm() -> Alarm {
        let alarm = NSEntityDescription.insertNewObject(forEntityName: "Alarm", into: managedContext) as! Alarm
        return alarm
    }
    
    static func saveAlarm() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func delete(alarm: Alarm) {
        managedContext.delete(alarm)
        saveAlarm()
    }
    
    static func retrieveAlarms() -> [Alarm] {
        let fetchRequest = NSFetchRequest<Alarm>(entityName: "Alarm")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
