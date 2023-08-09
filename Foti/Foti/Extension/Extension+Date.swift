//
//  Extension+Date.swift
//  InstagramClone
//
//  Created by Alper Us on 2023-06-16.
//

import Foundation
extension Date {
    func timeBefore() -> String {
        
        
        let secondAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week  = 7 * day
        let month = 4 * week
        
        let ratio : Int
        let unit : String
        
        if secondAgo < minute {
            ratio = secondAgo
            unit = "Second"
        } else if secondAgo < hour {
            ratio = secondAgo / minute
            unit = "Minute"
        } else if secondAgo < day {
            ratio = secondAgo / hour
            unit = "Hour"
        } else if secondAgo < week {
            ratio = secondAgo / day
            unit = "Day"
        } else if secondAgo < month {
            ratio = secondAgo / week
            unit = "Week"
        } else {
            ratio = secondAgo / month
            unit = "Month"
        }
        
        return "\(ratio) \(unit) Ago"
        
    }
}
