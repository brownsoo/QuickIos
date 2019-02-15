//
//  YearMonthDay.swift
//
//  Created by hyonsoo han on 2018. 7. 20..
//

import Foundation

/// 년월일만 표현하는 모델
public struct YearMonthDay: Equatable {
    public let year: Int
    public let month: Int
    public let day: Int
    
    public var y: String {
        return String(year)
    }
    public var m: String {
        return String(month)
    }
    public var d: String {
        return String(day)
    }
    
    public var date: Date {
        return TimeUtil.date(from: yyyyMMdd(joiner: "-"), format: "yyyy-MM-dd")!
    }
    
    public func yyyyMMdd(joiner: String = "/") -> String {
        return [y,
                YearMonthDay.twoDigitString(month),
                YearMonthDay.twoDigitString(day)].joined(separator:joiner)
    }
    
    public func yyMMdd(joiner: String = "/") -> String {
        return [y.from(2, until: -1)!,
                YearMonthDay.twoDigitString(month),
                YearMonthDay.twoDigitString(day)].joined(separator:joiner)
    }

    public func MMdd(joiner: String = "/") -> String {
        return [YearMonthDay.twoDigitString(month),
                YearMonthDay.twoDigitString(day)].joined(separator:joiner)
    }
    
    fileprivate static func twoDigitString(_ value: Int) -> String {
        if value < 10 {
            return "0\(value)"
        } else {
            return "\(value)"
        }
    }
    
    public func compare(versus: YearMonthDay) -> Int {
        if year > versus.year {
            return 1
        } else if year < versus.year {
            return -1
        }
        if month > versus.month {
            return 1
        } else if month < versus.month {
            return -1
        }
        if day > versus.day {
            return 1
        } else if day < versus.day {
            return -1
        } else {
            return 0
        }
    }
}

public extension YearMonthDay {
    /// init with yyyy-MM-dd
    public init?(yyyyMMdd: String) {
        let format = DateFormatter()
        format.locale = TimeUtil.currentLocale
        format.dateFormat = "yyyy-MM-dd"
        let date = format.date(from: yyyyMMdd)
        if let date = date {
            let set: Set<Calendar.Component> = [.year, .month, .day]
            let comps = Calendar.current.dateComponents(set, from: date)
            self = YearMonthDay(
                year: comps.year!,
                month: comps.month!,
                day: comps.day!)
        } else {
            return nil
        }
    }
    /// init with now date
    public init() {
        self.init(TimeUtil.now)
    }
    
    public init(y: Int, m: Int, d: Int) {
        self = YearMonthDay(year: y, month: m, day: d)
    }
    
    /// init with date
    public init(_ date: Date, calendar: Calendar = TimeUtil.calendar) {
        let set: Set<Calendar.Component> = [.year, .month, .day]
        let comps = calendar.dateComponents(set, from: date)
        self = YearMonthDay(
            y: comps.year!,
            m: comps.month!,
            d: comps.day!)
    }
}

public extension YearMonthDay {
    static func <(lhs: YearMonthDay, rhs: YearMonthDay) -> Bool {
        return lhs.compare(versus: rhs) < 0
    }
    static func >(lhs: YearMonthDay, rhs: YearMonthDay) -> Bool {
        return lhs.compare(versus: rhs) > 0
    }
    static func ==(lhs: YearMonthDay, rhs: YearMonthDay) -> Bool {
        return lhs.compare(versus: rhs) == 0
    }
    static func >=(lhs: YearMonthDay, rhs: YearMonthDay) -> Bool {
        let val = lhs.compare(versus: rhs)
        return val > 0 || val == 0
    }
    static func <=(lhs: YearMonthDay, rhs: YearMonthDay) -> Bool {
        let val = lhs.compare(versus: rhs)
        return val < 0 || val == 0
    }
}

public extension Date {
    func toYearMonthDay() -> YearMonthDay {
        return YearMonthDay(self)
    }
}
