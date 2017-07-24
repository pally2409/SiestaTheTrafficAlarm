//
//  Alarm.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 21/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation

class Alarm {
    

    var fromInterval: Date
    var toInterval: Date
    var origin: String
    var destination: String
    var isOn: Bool
    var readyTime: TimeInterval
    var reachTime: Date
    
    init(fromInterval: String, toInterval: String, origin: String, destination: String, isOn: Bool, readyTime: TimeInterval, reachTime: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let fromIntervalString = formatter.date(from: fromInterval)
        let toIntervalString = formatter.date(from: toInterval)
        let reachTimeString = formatter.date(from: reachTime)
        self.fromInterval = fromIntervalString!
        self.toInterval = toIntervalString!
        self.origin = origin
        self.destination = destination
        self.isOn = isOn
        self.readyTime = readyTime
        self.reachTime = reachTimeString!
        
    }
}
