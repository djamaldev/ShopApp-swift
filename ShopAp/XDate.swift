//
//  XDate.swift
//  ShopAp
//
//  Created by mr Yacine on 11/27/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//

import Foundation

extension Date {
    static var time = Date()
    ///
    /// Provides a humanised date. For instance: 1 minute, 1 week ago, 3 months ago
    ///
    /// - Parameters:
    //      - numericDates: Set it to true to get "1 year ago", "1 month ago" or false if you prefer "Last year", "Last month"
    ///
    func get(){
        print("hi")
    }
      func timeAgoSinceDate(_ date:Date, currentDate: Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)//self < now ? self : now
        let latest =  (earliest == now) ? date : now//self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        //print("")
        //print(components)
        if let year = components.year {
            if (year >= 2) {
                return "\(year) years ago"
            } else if (year >= 1) {
                return numericDates ?  "1 year ago" : "Last year"
            }
        }
        if let month = components.month {
            if (month >= 2) {
                return "\(month) months ago"
            } else if (month >= 1) {
                return numericDates ? "1 month ago" : "Last month"
            }
        }
        if let weekOfMonth = components.weekOfMonth {
            if (weekOfMonth >= 2) {
                return "\(weekOfMonth) weeks ago"
            } else if (weekOfMonth >= 1) {
                return numericDates ? "1 week ago" : "Last week"
            }
        }
        if let day = components.day {
            if (day >= 2) {
                return "\(day) days ago"
            } else if (day >= 1) {
                return numericDates ? "1 day ago" : "Yesterday"
            }
        }
        if let hour = components.hour {
            if (hour >= 2) {
                return "\(hour) hours ago"
            } else if (hour >= 1) {
                return numericDates ? "1 hour ago" : "An hour ago"
            }
        }
        if let minute = components.minute {
            if (minute >= 2) {
                return "\(minute) minutes ago"
            } else if (minute >= 1) {
                return numericDates ? "1 minute ago" : "A minute ago"
            }
        }
        if let second = components.second {
            if (second >= 3) {
                return "\(second) seconds ago"
            }
        }
        return "Just now"
    }
}

extension TimeInterval {
    
    func getTimeAgo()-> String {
        let time = Date()
        //return timeAgoSinceDate(Date.init(timeIntervalSince: self), currentDate: Date(), numericDates: true)
        return time.timeAgoSinceDate(Date.init(timeIntervalSince1970: self), currentDate: Date(), numericDates: true)
    }
}
