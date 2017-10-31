//
//  NSDate+Extension.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import Foundation

public extension NSDate {
    
    // MARK:  NSDate Manipulation
    
    /**
    Returns a new NSDate object representing the date calculated by adding the amount specified to self date
    
    :param: seconds number of seconds to add
    :param: minutes number of minutes to add
    :param: hours number of hours to add
    :param: days number of days to add
    :param: weeks number of weeks to add
    :param: months number of months to add
    :param: years number of years to add
    :returns: the NSDate computed
    */
    public func add(seconds: Int = 0, minutes: Int = 0, hours: Int = 0, days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        
        var component = NSDateComponents()
//        let options = NSCalendarOptions.MatchStrictly
        let options = NSCalendarOptions(rawValue: 0)
        if #available(iOS 8.0, *) {
            component.setValue(seconds, forComponent: .Second)
            var date : NSDate! = calendar.dateByAddingComponents(component, toDate: self, options: options)!
            component = NSDateComponents()
            component.setValue(minutes, forComponent: .Minute)
            date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
            
            component = NSDateComponents()
            component.setValue(hours, forComponent: .Hour)
            date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
            
            component = NSDateComponents()
            component.setValue(days, forComponent: .Day)
            date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
            
            component = NSDateComponents()
            component.setValue(weeks, forComponent: .WeekOfMonth)
            date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
            
            component = NSDateComponents()
            component.setValue(months, forComponent: .Month)
            date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
            
            component = NSDateComponents()
            component.setValue(years, forComponent: .Year)
            date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
            return date
        }
        
        component.second = seconds
        var date : NSDate! = calendar.dateByAddingComponents(component, toDate: self, options: options)
        
        component = NSDateComponents()
        component.minute = minutes
        date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
        
        component = NSDateComponents()
        component.day = days
        date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
        
        component = NSDateComponents()
        component.hour = hours
        date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
        
        component = NSDateComponents()
        component.weekOfMonth = weeks
        date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
        
        component = NSDateComponents()
        component.month = months
        date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
        
        component = NSDateComponents()
        component.year = years
        date = calendar.dateByAddingComponents(component, toDate: date, options: options)!
        
        return date
    }
    
    /**
     Returns a new NSDate object representing the date calculated by adding an amount of seconds to self date
     
     :param: seconds number of seconds to add
     :returns: the NSDate computed
     */
    public func addSeconds (seconds: Int) -> NSDate {
        return add(seconds)
    }
    
    /**
     Returns a new NSDate object representing the date calculated by adding an amount of minutes to self date
     
     :param: minutes number of minutes to add
     :returns: the NSDate computed
     */
    public func addMinutes (minutes: Int) -> NSDate {
        return add(minutes: minutes)
    }
    
    /**
     Returns a new NSDate object representing the date calculated by adding an amount of hours to self date
     
     :param: hours number of hours to add
     :returns: the NSDate computed
     */
    public func addHours(hours: Int) -> NSDate {
        return add(hours: hours)
    }
    
    /**
     Returns a new NSDate object representing the date calculated by adding an amount of days to self date
     
     :param: days number of days to add
     :returns: the NSDate computed
     */
    public func addDays(days: Int) -> NSDate {
        return add(days: days)
    }
    
    /**
     Returns a new NSDate object representing the date calculated by adding an amount of weeks to self date
     
     :param: weeks number of weeks to add
     :returns: the NSDate computed
     */
    public func addWeeks(weeks: Int) -> NSDate {
        return add(weeks: weeks)
    }
    
    
    /**
     Returns a new NSDate object representing the date calculated by adding an amount of months to self date
     
     :param: months number of months to add
     :returns: the NSDate computed
     */
    
    public func addMonths(months: Int) -> NSDate {
        return add(months: months)
    }
    
    /**
     Returns a new NSDate object representing the date calculated by adding an amount of years to self date
     
     :param: years number of year to add
     :returns: the NSDate computed
     */
    public func addYears(years: Int) -> NSDate {
        return add(years: years)
    }
    
    // MARK:  Date comparison
    
    /**
    Checks if self is after input NSDate
    
    :param: date NSDate to compare
    :returns: True if self is after the input NSDate, false otherwise
    */
    public func isAfter(date: NSDate) -> Bool{
        return (self.compare(date) == NSComparisonResult.OrderedDescending)
    }
    
    /**
     Checks if self is before input NSDate
     
     :param: date NSDate to compare
     :returns: True if self is before the input NSDate, false otherwise
     */
    public func isBefore(date: NSDate) -> Bool{
        return (self.compare(date) == NSComparisonResult.OrderedAscending)
    }
    
    
    // MARK: Getter
    
    /**
    Date year
    */
    public var year : Int {
        get {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Year, fromDate: self)
            return components.year
        }
    }
    
    /**
     Date month
     */
    public var month : Int {
        get {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Month, fromDate: self)
            return components.month
        }
    }
    
    /**
     Date weekday
     */
    public var weekday : Int {
        get {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Weekday, fromDate: self)
            return components.weekday
        }
    }
    
    /**
     Date weekMonth
     */
    public var weekMonth : Int {
        get {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.WeekOfMonth, fromDate: self)
            return components.weekOfMonth
        }
    }
    
    
    /**
     Date days
     */
    public var days : Int {
        get {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Day, fromDate: self)
            return components.day
        }
    }
    
    /**
     Date hours
     */
    public var hours : Int {
        
        get {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Hour, fromDate: self)
            return components.hour
        }
    }
    
    /**
     Date minuts
     */
    public var minutes : Int {
        get {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Minute, fromDate: self)
            return components.minute
        }
    }
    
    /**
     Date seconds
     */
    public var seconds : Int {
        get {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Second, fromDate: self)
            return components.second
        }
    }
    
    public var daysOfCurrentMonth : Int {
        get {
            let calendar = NSCalendar.currentCalendar()
            let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: self)
            return range.length
        }
    }
}

extension NSDate: Strideable {
    public func distanceTo(other: NSDate) -> NSTimeInterval {
        return other - self
    }
    
    public func advancedBy(n: NSTimeInterval) -> Self {
        return self.dynamicType.init(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate + n)
    }
}
// MARK: Arithmetic

func +(date: NSDate, timeInterval: Int) -> NSDate {
    return date + NSTimeInterval(timeInterval)
}

func -(date: NSDate, timeInterval: Int) -> NSDate {
    return date - NSTimeInterval(timeInterval)
}

func +=(inout date: NSDate, timeInterval: Int) {
    date = date + timeInterval
}

func -=(inout date: NSDate, timeInterval: Int) {
    date = date - timeInterval
}

func +(date: NSDate, timeInterval: Double) -> NSDate {
    return date.dateByAddingTimeInterval(NSTimeInterval(timeInterval))
}

func -(date: NSDate, timeInterval: Double) -> NSDate {
    return date.dateByAddingTimeInterval(NSTimeInterval(-timeInterval))
}

func +=(inout date: NSDate, timeInterval: Double) {
    date = date + timeInterval
}

func -=(inout date: NSDate, timeInterval: Double) {
    date = date - timeInterval
}

func -(date: NSDate, otherDate: NSDate) -> NSTimeInterval {
    return date.timeIntervalSinceDate(otherDate)
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
}

extension NSDate {
    func toRequestTimestampDate() -> String {
        let format = NSDateFormatter()
        format.timeZone = NSTimeZone(name: "GMT")
        format.dateFormat = "yyyy-MM-dd"
        return format.stringFromDate(self)
    }
    
    func toRequestTimestampString() -> String {
        return convertToString("yyyyMMddHHmmss")
    }
    
    func toChartXAxisFormatterString() -> String {
        return convertToString("MM.dd")
    }
    
    func toChartShowValueFormatterString() -> String {
        return convertToString("yyyy.MM.dd")
    }
        
    func convertToString(formatStr: String) -> String {
        let format = NSDateFormatter()
        format.dateFormat = formatStr
        return format.stringFromDate(self)
    }
    
    static func fromDateStringYYYY_MM_DD(dateString:String) ->NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.dateFromString(dateString)!
    }
}
