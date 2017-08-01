//
//  TimeZoneConversionHelper.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 26/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation


struct DateFormatterHelper {
    
    static func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH : mm"
        let formattedDateString = formatter.string(from: date)
        return formattedDateString
    }
    
    static func dateFormatterFromString(stringDate: String) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH : mm"
        let formattedDate = formatter.date(from: stringDate)
        return formattedDate!
    }
    
    static func getComponents(date: Date) -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: .current, from: date)
        return components
    }
    
}
