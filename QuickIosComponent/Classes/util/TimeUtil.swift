//
//  TimeUtil.swift
//  StudioBase
//
//  Created by hyonsoo han on 2018. 7. 18..
//  Copyright © 2018년 StudioMate. All rights reserved.
//

import Foundation

/// 서버시간을 맞추기 위한 유틸. 수강권과 관련된 시간계산시 사용한다.
final public class TimeUtil {
    
    public static var currentLocalIdentifier = identifierKorea
    public static var deviceTimeOffset: TimeInterval = 0
    public static var identifierKorea = "ko_KR"
    public static var currentLocal = Locale(identifier: currentLocalIdentifier)
    public static let oneDayTimeInterval = TimeInterval(24 * 60 * 60.0)
    
    public static func setTimeOffset(from: Date) {
        deviceTimeOffset = floor(from.timeIntervalSince1970 - Date().timeIntervalSince1970)
    }
    
    public static var now: Date {
        return Date(timeIntervalSinceNow: deviceTimeOffset)
    }

    public static var nowZero: Date {
        let n = string(now, format: "yyyy-MM-dd")
        return date(from: n, format: "yyyy-MM-dd")!
    }

    public static var calendar: Calendar {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.locale = Locale(identifier: currentLocalIdentifier)
        return cal
    }

    public static func yoil(from: Date) -> String {
        return calendar.weekdaySymbols[from.weekday - 1]
    }
    
    public static func yoilShort(from: Date) -> String {
        return calendar.shortWeekdaySymbols[from.weekday - 1]
    }
    /// weekdayIndex : 0~6
    public static func yoil(weekdayIndex: Int) -> String {
        return calendar.weekdaySymbols[weekdayIndex]
    }

    /// weekdayIndex : 0~6
    public static func yoilShort(weekdayIndex: Int) -> String {
        return calendar.shortWeekdaySymbols[weekdayIndex]
    }

    public static func timeIntervalSinceNow(_ date: Date?) -> TimeInterval {
        guard let target = date else {
            return 0
        }
        return target.timeIntervalSince1970 - now.timeIntervalSince1970
    }
    
    public static func string(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: currentLocalIdentifier)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public static func date(from: String, format: String) -> Date? {
        let form = DateFormatter()
        form.locale = Locale(identifier: currentLocalIdentifier)
        form.dateFormat = format
        return form.date(from: from)
    }
    /// 몇년 몇달 몇일
    public static func readableIntervalDays(from: Date, to endDate: Date) -> String? {
        // https://soooprmx.com/archives/6661
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.allowedUnits = [.year, .month, .day]
        formatter.unitsStyle = .full
        if endDate < from {
            if let daysString = formatter.string(from: endDate, to: from.addingTimeInterval(oneDayTimeInterval)) {
                return "\(daysString) 전"
            }
            return nil
        } else {
            return formatter.string(from: from, to: endDate.addingTimeInterval(oneDayTimeInterval))
        }
    }

    /// 몇시간 몇분 몇일
    public static func readableIntervalTimes(from: Date, to endDate: Date,
                                             units: NSCalendar.Unit = [.day, .hour, .minute]) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.allowedUnits = units
        formatter.unitsStyle = .full
        if endDate < from {
            if let readable = formatter.string(from: endDate, to: from.addingTimeInterval(60.0)) {
                return "\(readable) 전"
            }
            return nil
        } else {
            return formatter.string(from: from, to: endDate.addingTimeInterval(60.0))
        }
    }
    
    public static func readableIntervalTimes(from: TimeInterval,
                                             units: NSCalendar.Unit = [.day, .hour, .minute]) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.allowedUnits = units
        formatter.unitsStyle = .full
        return formatter.string(from: from)
    }
    
    public static func readableYearMonthDay(from: Date, style: DateFormatter.Style = .full) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = currentLocal
        formatter.dateStyle = style
        return formatter.string(from: from)
    }
    
}
