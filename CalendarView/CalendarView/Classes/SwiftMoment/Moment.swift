//
//  Moment.swift
//  SwiftMoment
//
//  Created by Adrian on 19/01/15.
//  Copyright (c) 2015 Adrian Kosmaczewski. All rights reserved.
//

// Swift adaptation of Moment.js http://momentjs.com
// Github: https://github.com/moment/moment/

import Foundation

/**
 Returns a moment representing the current instant in time
 at the current timezone.

 - returns: A Moment instance.
 */
public func moment(timeZone: TimeZone = TimeZone.autoupdatingCurrent
    , locale: Locale = Locale.autoupdatingCurrent) -> Moment {
    return Moment(timeZone: timeZone, locale: locale)
}

public func utc() -> Moment {
    let zone = TimeZone(abbreviation: "UTC")!
    return moment(timeZone: zone)
}

/**
 Returns an Optional wrapping a Moment structure, representing the
 current instant in time. If the string passed as parameter cannot be
 parsed by the function, the Optional wraps a nil value.

 - parameter stringDate: A string with a date representation.
 - parameter timeZone:   An TimeZone object

 - returns: An optional Moment instance.
 */
public func moment(stringDate: String
    , timeZone: TimeZone = TimeZone.autoupdatingCurrent
    , locale: Locale = Locale.autoupdatingCurrent) -> Moment? {

    let formatter = DateFormatter()
    formatter.timeZone = timeZone
    formatter.locale = locale
    let isoFormat = "yyyy-MM-ddTHH:mm:ssZ"

    // The contents of the array below are borrowed
    // and adapted from the source code of Moment.js
    // https://github.com/moment/moment/blob/develop/moment.js
    let formats = [
        isoFormat,
        "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'",
        "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'",
        "yyyy-MM-dd",
        "h:mm:ss A",
        "h:mm A",
        "MM/dd/yyyy",
        "MMMM d, yyyy",
        "MMMM d, yyyy LT",
        "dddd, MMMM D, yyyy LT",
        "yyyyyy-MM-dd",
        "yyyy-MM-dd",
        "GGGG-[W]WW-E",
        "GGGG-[W]WW",
        "yyyy-ddd",
        "HH:mm:ss.SSSS",
        "HH:mm:ss",
        "HH:mm",
        "HH"
    ]

    for format in formats {
        formatter.dateFormat = format

        if let date = formatter.date(from: stringDate) {
            return Moment(date: date, timeZone: timeZone, locale: locale)
        }
    }
    return nil
}

public func moment(stringDate: String
    , dateFormat: String
    , timeZone: TimeZone = TimeZone.autoupdatingCurrent
    , locale: Locale = Locale.autoupdatingCurrent) -> Moment? {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    formatter.timeZone = timeZone
    formatter.locale = locale
    if let date = formatter.date(from: stringDate) {
        return Moment(date: date, timeZone: timeZone, locale: locale)
    }
    return nil
}

/**
 Builds a new Moment instance using an array with the following components,
 in the following order: [ year, month, day, hour, minute, second ]

 - parameter dateComponents: An array of integer values
 - parameter timeZone:   An TimeZone object

 - returns: An optional wrapping a Moment instance
 */
public func moment(params: [Int]
    , timeZone: TimeZone = TimeZone.autoupdatingCurrent
    , locale: Locale = Locale.autoupdatingCurrent) -> Moment? {
    if params.count > 0 {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        var components = DateComponents()
        components.year = params[0]
        
        if params.count > 1 {
            components.month = params[1]
            if params.count > 2 {
                components.day = params[2]
                if params.count > 3 {
                    components.hour = params[3]
                    if params.count > 4 {
                        components.minute = params[4]
                        if params.count > 5 {
                            components.second = params[5]
                        }
                    }
                }
            }
        }
        
        if let date = calendar.date(from: components) {
            return moment(date: date, timeZone: timeZone, locale: locale)
        }
    }
    return nil
}

public func moment(dict: [String: Int]
    , timeZone: TimeZone = TimeZone.autoupdatingCurrent
    , locale: Locale = Locale.autoupdatingCurrent) -> Moment? {
    if dict.count > 0 {
        var params = [Int]()
        if let year = dict["year"] {
            params.append(year)
        }
        if let month = dict["month"] {
            params.append(month)
        }
        if let day = dict["day"] {
            params.append(day)
        }
        if let hour = dict["hour"] {
            params.append(hour)
        }
        if let minute = dict["minute"] {
            params.append(minute)
        }
        if let second = dict["second"] {
            params.append(second)
        }
        return moment(params: params, timeZone: timeZone, locale: locale)
    }
    return nil
}

public func moment(milliseconds: Int) -> Moment {
    return moment(seconds: TimeInterval(milliseconds / 1000))
}

public func moment(seconds: TimeInterval) -> Moment {
    let interval = TimeInterval(seconds)
    let date = Date(timeIntervalSince1970: interval)
    return Moment(date: date)
}

public func moment(date: Date
    , timeZone: TimeZone = TimeZone.autoupdatingCurrent
    , locale: Locale = Locale.autoupdatingCurrent) -> Moment {
    return Moment(date: date, timeZone: timeZone, locale: locale)
}

public func moment(moment: Moment) -> Moment {
    let copy = moment.date
    let timeZone = moment.timeZone
    let locale = moment.locale
    return Moment(date: copy, timeZone: timeZone, locale: locale)
}

public func past() -> Moment {
    return Moment(date: Date.distantPast )
}

public func future() -> Moment {
    return Moment(date: Date.distantFuture )
}

public func since(past: Moment) -> Duration {
    return moment().intervalSince(past)
}

public func maximum(moments: Moment...) -> Moment? {
    if moments.count > 0 {
        var max: Moment = moments[0]
        for moment in moments {
            if moment > max {
                max = moment
            }
        }
        return max
    }
    return nil
}

public func minimum(moments: Moment...) -> Moment? {
    if moments.count > 0 {
        var min: Moment = moments[0]
        for moment in moments {
            if moment < min {
                min = moment
            }
        }
        return min
    }
    return nil
}

/**
 Internal structure used by the family of moment() functions.
 Instead of modifying the native Date class, this is a
 wrapper for the Date object. To get this wrapper object, simply
 call moment() with one of the supported input types.
 */
public struct Moment: Comparable {
    let date: Date
    let timeZone: TimeZone
    let locale: Locale

    init(date: Date = Date()
        , timeZone: TimeZone = TimeZone.autoupdatingCurrent
        , locale: Locale = Locale.autoupdatingCurrent) {
        self.date = date
        self.timeZone = timeZone
        self.locale = locale
    }

    /// Returns the year of the current instance.
    public var year: Int {
        var cal = Calendar.current
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.dateComponents([.year], from: date)
        return components.year!
    }

    /// Returns the month (1-12) of the current instance.
    public var month: Int {
        var cal = Calendar.current
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.dateComponents([.month], from: date)
        return components.month!
    }

    /// Returns the name of the month of the current instance, in the current locale.
    public var monthName: String {
        let formatter = DateFormatter()
        formatter.locale = locale
        return formatter.monthSymbols[month - 1] 
    }

    public var day: Int {
        var cal = Calendar.current
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.dateComponents([.day], from: date)
        return components.day!
    }

    public var hour: Int {
        var cal = Calendar.current
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.dateComponents([.hour], from: date)
        return components.hour!
    }

    public var minute: Int {
        var cal = Calendar.current
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.dateComponents([.minute], from: date)
        return components.minute!
    }

    public var second: Int {
        var cal = Calendar.current
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.dateComponents([.second], from: date)
        return components.second!
    }

    public var weekday: Int {
        var cal = Calendar.current
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.dateComponents([.weekday], from: date)
        return components.weekday!
    }

    public var weekdayName: String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "EEEE"
        formatter.timeZone = timeZone
        return formatter.string(from: date)
    }

    public var weekdayOrdinal: Int {
        var cal = Calendar.current
        cal.locale = locale
        cal.timeZone = timeZone
        let components = cal.dateComponents([.weekdayOrdinal], from: date)
        return components.weekdayOrdinal!
    }

    public var weekOfYear: Int {
        var cal = Calendar.current
        cal.locale = locale
        cal.timeZone = timeZone
        let components = cal.dateComponents([.weekOfYear], from: date)
        return components.weekOfYear!
    }

    public var quarter: Int {
        var cal = Calendar.current
        cal.locale = locale
        cal.timeZone = timeZone
        let components = cal.dateComponents([.quarter], from: date)
        return components.quarter!
    }

    // Methods

    public func get(unit: TimeUnit) -> Int? {
        switch unit {
        case .seconds:
            return second
        case .minutes:
            return minute
        case .hours:
            return hour
        case .days:
            return day
        case .months:
            return month
        case .quarters:
            return quarter
        case .years:
            return year
        }
    }

    public func get(unitName: String) -> Int? {
        if let unit = TimeUnit(rawValue: unitName) {
            return get(unit: unit)
        }
        return nil
    }

    public func format(dateFormat: String = "yyyy-MM-dd HH:mm:ss ZZZZ") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.string(from: date)
    }

    public func isEqualTo(moment: Moment) -> Bool {
        return date == moment.date
    }

    public func intervalSince(_ moment: Moment) -> Duration {
        let interval = date.timeIntervalSince(moment.date)
        return Duration(value: interval)
    }

    public func add(_ value: Int, _ unit: TimeUnit) -> Moment {
        var components = DateComponents()
        switch unit {
        case .years:
            components.year = value
        case .quarters:
            components.month = 3 * value
        case .months:
            components.month = value
        case .days:
            components.day = value
        case .hours:
            components.hour = value
        case .minutes:
            components.minute = value
        case .seconds:
            components.second = value
        }
        let cal = NSCalendar(calendarIdentifier: .gregorian)!
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        if let newDate = cal.date(byAdding: components, to: date) {
            return Moment(date: newDate)
        }
        return self
    }

    public func add(_ value: TimeInterval, _ unit: TimeUnit) -> Moment {
        let seconds = convert(value, unit)
        let interval = TimeInterval(seconds)
        let newDate = date.addingTimeInterval(interval)
        return Moment(date: newDate)
    }

    public func add(_ value: Int, _ unitName: String) -> Moment {
        if let unit = TimeUnit(rawValue: unitName) {
            return add(value, unit)
        }
        return self
    }

    public func add(_ duration: Duration) -> Moment {
        return add(duration.interval, .seconds)
    }

    public func subtract(_ value: TimeInterval, _ unit: TimeUnit) -> Moment {
        return add(-value, unit)
    }

    public func subtract(_ value: Int, _ unit: TimeUnit) -> Moment {
        return add(-value, unit)
    }

    public func subtract(_ value: Int, _ unitName: String) -> Moment {
        if let unit = TimeUnit(rawValue: unitName) {
            return subtract(value, unit)
        }
        return self
    }

    public func subtract(_ duration: Duration) -> Moment {
        return subtract(duration.interval, .seconds)
    }

    public func isCloseTo(moment: Moment, precision: TimeInterval = 300) -> Bool {
        // "Being close" is measured using a precision argument
        // which is initialized a 300 seconds, or 5 minutes.
        let delta = intervalSince(moment)
        return abs(delta.interval) < precision
    }

    public func startOf(_ unit: TimeUnit) -> Moment {
        let cal = Calendar.current
        var newDate: Date?
        var components = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        switch unit {
        case .seconds:
            return self
        case .years:
            components.month = 1
            fallthrough
        case .quarters, .months:
            components.day = 1
            fallthrough
        case .days:
            components.hour = 0
            fallthrough
        case .hours:
            components.minute = 0
            fallthrough
        case .minutes:
            components.second = 0
        }
        newDate = cal.date(from: components)
        return newDate == nil ? self : Moment(date: newDate!)
    }

    public func startOf(_ unitName: String) -> Moment {
        if let unit = TimeUnit(rawValue: unitName) {
            return startOf(unit)
        }
        return self
    }

    public func endOf(_ unit: TimeUnit) -> Moment {
        return startOf(unit).add(1, unit).subtract(1.seconds)
    }

    public func endOf(_ unitName: String) -> Moment {
        if let unit = TimeUnit(rawValue: unitName) {
            return endOf(unit)
        }
        return self
    }

    public func epoch() -> TimeInterval {
        return date.timeIntervalSince1970
    }

    // Private methods

    func convert(_ value: Double, _ unit: TimeUnit) -> Double {
        switch unit {
        case .seconds:
            return value
        case .minutes:
            return value * 60
        case .hours:
            return value * 3600 // 60 minutes
        case .days:
            return value * 86400 // 24 hours
        case .months:
            return value * 2592000 // 30 days
        case .quarters:
            return value * 7776000 // 3 months
        case .years:
            return value * 31536000 // 365 days
        }
    }
}

extension Moment: CustomStringConvertible {
    public var description: String {
        return format()
    }
}

extension Moment: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}

