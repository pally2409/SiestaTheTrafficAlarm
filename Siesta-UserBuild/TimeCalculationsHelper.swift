//
//  TimeCalculationsService.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 20/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
struct TimeCalculationsHelper {
    
   static func calculateWakeUpTime(_ readyTime: TimeInterval?, _ trafficDuration: TimeInterval?, _ reachTime: Date?) {
        let calendar = Calendar.current
        let readyPlusTraffic = -1*(trafficDuration! + readyTime!)
        let wakeUpTime = calendar.date(byAdding: .second, value: Int(readyPlusTraffic), to: reachTime!)
        let wakeUpTimeComponents = calendar.dateComponents(in: .current, from: wakeUpTime!)
        print("\(wakeUpTimeComponents.hour)! : \(wakeUpTimeComponents.minute)!")

        
    }
}
