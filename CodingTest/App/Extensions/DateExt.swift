//
//  DateExt.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import Foundation

enum DateState {
    case past
    case current
    case future
}

extension Date {
    
    var daysOfWeek: [Date] {
        let dateInWeek = isSunday() ? self.dayBefore : self
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: dateInWeek)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: dateInWeek)!
        var days = (weekdays.lowerBound ..< weekdays.upperBound).compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: dateInWeek) }
        days.removeFirst()
        days.append(days.last?.dayAfter ?? Date())
        return days
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+00")
        return dateFormatter.string(from: self)
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    func isCurrentDate() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let components  = calendar.dateComponents([.year, .month, .day], from: self)
        
        if components.day == currentComponents.day,
            components.month == currentComponents.month,
            components.year == currentComponents.year {
            return true
        }
        return false
    }
    
    func checkDateState() -> DateState {
        let date = Date()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let components  = calendar.dateComponents([.year, .month, .day], from: self)
        
        guard let componentsDay = components.day,
              let componentsMonth = components.month,
              let componentsYear = components.year,
              let currentComponentsDay = currentComponents.day,
              let currentComponentsMonth = currentComponents.month,
              let currentComponentsYear = currentComponents.year
        else {
            return .current
        }
        
        if componentsDay == currentComponentsDay,
            componentsMonth == currentComponentsMonth,
            componentsYear == currentComponentsYear {
            return .current
        }
        
        if componentsDay > currentComponentsDay,
            componentsMonth >= currentComponentsMonth,
            componentsYear >= currentComponentsYear {
            return .future
        }
        
        if componentsDay < currentComponentsDay,
            componentsMonth <= currentComponentsMonth,
            componentsYear <= currentComponentsYear {
            return .past
        }
        
        return .current
    }
    
    func isSunday() -> Bool {
        let weekday = NSCalendar.current.component(.weekday, from: Date())
        return weekday == 1 ? true : false
    }
}


