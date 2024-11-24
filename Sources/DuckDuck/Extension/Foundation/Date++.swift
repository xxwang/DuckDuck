//
//  Date++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 22/11/2024.
//

import Foundation

private let calendar = Calendar.current
private let dateFormatter = DateFormatter()

// MARK: - 计算属性
public extension Date {
    // MARK: - 日期扩展，用于获取和设置各个日期组件

    /// 获取或设置日期中的年份
    ///
    ///     Date().dd_year -> 2017
    ///     var someDate = Date()
    ///     someDate.dd_year = 2000
    var dd_year: Int {
        get { return calendar.component(.year, from: self) }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            guard let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) else { return }
            self = date
        }
    }

    /// 获取或设置日期中的月份
    ///
    ///     Date().dd_month -> 1
    ///     var someDate = Date()
    ///     someDate.dd_month = 10
    var dd_month: Int {
        get { return calendar.component(.month, from: self) }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            guard let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) else { return }
            self = date
        }
    }

    /// 获取或设置日期中的天
    ///
    ///     Date().dd_day -> 12
    ///     var someDate = Date()
    ///     someDate.dd_day = 1
    var dd_day: Int {
        get { return calendar.component(.day, from: self) }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            guard let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) else { return }
            self = date
        }
    }

    /// 获取或设置日期中的小时
    ///
    ///     Date().dd_hour -> 17 // 5 pm
    ///     var someDate = Date()
    ///     someDate.dd_hour = 13
    var dd_hour: Int {
        get { return calendar.component(.hour, from: self) }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentHours = calendar.component(.hour, from: self)
            let hoursToAdd = newValue - currentHours
            guard let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: self) else { return }
            self = date
        }
    }

    /// 获取或设置日期中的分钟
    ///
    ///     Date().dd_minute -> 39
    ///     var someDate = Date()
    ///     someDate.dd_minute = 10
    var dd_minute: Int {
        get { return calendar.component(.minute, from: self) }
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = calendar.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }

    /// 获取或设置日期中的秒
    ///
    ///     Date().dd_second -> 55
    ///     var someDate = Date()
    ///     someDate.dd_second = 15
    var dd_second: Int {
        get { return calendar.component(.second, from: self) }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = calendar.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            guard let date = calendar.date(byAdding: .second, value: secondsToAdd, to: self) else { return }
            self = date
        }
    }

    /// 获取或设置日期中的毫秒
    ///
    ///     Date().dd_millisecond -> 68
    ///     var someDate = Date()
    ///     someDate.dd_millisecond = 68
    var dd_millisecond: Int {
        get { return calendar.component(.nanosecond, from: self) / 1_000_000 }
        set {
            let nanoSeconds = newValue * 1_000_000
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
            #endif
            guard allowedRange.contains(nanoSeconds) else { return }
            guard let date = calendar.date(bySetting: .nanosecond, value: nanoSeconds, of: self) else { return }
            self = date
        }
    }

    /// 获取或设置日期中的纳秒
    ///
    ///     Date().dd_nanosecond -> 981379985
    ///     var someDate = Date()
    ///     someDate.dd_nanosecond = 981379985
    var dd_nanosecond: Int {
        get { return calendar.component(.nanosecond, from: self) }
        set {
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
            #endif
            guard allowedRange.contains(newValue) else { return }

            let currentNanoseconds = calendar.component(.nanosecond, from: self)
            let nanosecondsToAdd = newValue - currentNanoseconds

            guard let date = calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self) else { return }
            self = date
        }
    }
}

// MARK: - 构造方法
public extension Date {
    /// 根据 `Calendar` 和 `DateComponents` 创建 `Date`
    ///
    /// - Parameters:
    ///   - calendar: `Calendar` 对象，默认使用当前日历 (`.current`)
    ///   - components: `DateComponents` 对象，包含年、月、日等信息
    init?(calendar: Calendar? = .current, components: DateComponents) {
        guard let calendar, let date = calendar.date(from: components) else { return nil }
        self = date
    }

    /// 根据日期字符串创建 `Date`
    ///
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - dateFormat: 日期格式，默认为 `"yyyy-MM-dd'T'HH:mm:ss.SSSZ"`
    init?(string: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }

    /// 根据时间戳创建 `Date`
    ///
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - isUnix: 是否是 Unix 格式（秒为单位），默认为 `true`，表示 Unix 格式
    init(timestamp: TimeInterval, isUnix: Bool = true) {
        let timeInterval = isUnix ? timestamp : timestamp / 1000.0
        self.init(timeIntervalSince1970: timeInterval)
    }
}

// MARK: - Getter方法
public extension Date {
    /// 将格林尼治标准时间（GMT）转换为当地时间
    ///
    /// - Example:
    /// ```swift
    /// let gmtDate = Date()
    /// let localDate = gmtDate.dd_toLocalDate()
    /// print(localDate)  // 输出当地时间
    /// ```
    func dd_toLocalDate() -> Date {
        let secondsFromGMT = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return self.addingTimeInterval(secondsFromGMT)
    }

    /// 将当地时间转换为格林尼治标准时间（GMT）
    ///
    /// - Example:
    /// ```swift
    /// let localDate = Date()
    /// let gmtDate = localDate.dd_toGMTDate()
    /// print(gmtDate)  // 输出GMT时间
    /// ```
    func dd_toGMTDate() -> Date {
        let secondsFromGMT = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return self.addingTimeInterval(-secondsFromGMT)
    }

    /// 获取当前时间与目标时间之间的间隔，并返回自然语言描述
    ///
    /// - Example:
    /// ```swift
    /// let pastDate = Date().addingTimeInterval(-3600)
    /// let timeDifference = pastDate.dd_toTimeDifferenceFromNow()
    /// print(timeDifference)  // 输出类似“1小时前”的字符串
    /// ```
    func dd_callTimeAfterNow() -> String {
        let timeInterval = Date().timeIntervalSince(self)
        let suffix = timeInterval > 0 ? "前" : "后"

        let absoluteInterval = fabs(timeInterval)
        let minute = absoluteInterval / 60
        let hour = absoluteInterval / 3600
        let day = absoluteInterval / 86400
        let month = absoluteInterval / 2_592_000
        let year = absoluteInterval / 31_104_000

        var timeDescription: String!
        if minute < 1 {
            timeDescription = absoluteInterval > 0 ? "刚刚" : "马上"
        } else if hour < 1 {
            let minuteValue = Int(minute)
            timeDescription = "\(minuteValue)分钟\(suffix)"
        } else if day < 1 {
            let hourValue = Int(hour)
            timeDescription = "\(hourValue)小时\(suffix)"
        } else if month < 1 {
            let dayValue = Int(day)
            timeDescription = "\(dayValue)天\(suffix)"
        } else if year < 1 {
            let monthValue = Int(month)
            timeDescription = "\(monthValue)个月\(suffix)"
        } else {
            let yearValue = Int(year)
            timeDescription = "\(yearValue)年\(suffix)"
        }

        return timeDescription
    }

    /// 获取当前时区的日期
    ///
    /// - Example:
    /// ```swift
    /// let currentZoneDate = Date.dd_currentZoneDate()
    /// print(currentZoneDate)  // 输出当前时区的日期
    /// ```
    static func dd_currentZoneDate() -> Date {
        let date = Date()
        let zone = TimeZone.current
        let timeZoneOffset = zone.secondsFromGMT(for: date)
        return date.addingTimeInterval(TimeInterval(timeZoneOffset))
    }

    /// 将日期格式化为 ISO8601 标准的日期字符串（UTC时区）
    ///
    /// - Example:
    /// ```swift
    /// let iso8601String = Date().dd_toISO8601String()
    /// print(iso8601String)  // 输出 "2017-01-12T14:51:29.574Z"
    /// ```
    /// - Note: 格式 `(yyyy-MM-dd'T'HH:mm:ss.SSSZ)`，UTC时区
    /// - Returns: ISO8601 标准的日期字符串
    func dd_toISO8601String() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: self).appending("Z")
    }

    /// 获取距离当前日期最近的可以被五分钟整除的时间
    ///
    /// - Example:
    /// ```swift
    /// let nearestFiveMinutes = Date().dd_nearestMultipleOfMinutes(minutes: 5)
    /// print(nearestFiveMinutes)  // 输出类似 "5:30 PM" 或 "5:45 PM"
    /// ```
    /// - Parameter minutes: 可被整除的分钟数，支持5, 10, 15等
    /// - Returns: 距离当前日期最近的可以被 `minutes` 整除的时间
    func dd_nearestMultipleOfMinutes(minutes: Int) -> Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % minutes < minutes / 2 ? min - min % minutes : min + minutes - (min % minutes)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// 获取距离当前日期最近的可以被十分钟整除的时间
    ///
    /// - Example:
    /// ```swift
    /// let nearestTenMinutes = Date().dd_nearestMultipleOfMinutes(minutes: 10)
    /// print(nearestTenMinutes)  // 输出类似 "5:30 PM" 或 "5:40 PM"
    /// ```
    /// - Parameter minutes: 可被整除的分钟数
    /// - Returns: 距离当前日期最近的可以被 `minutes` 整除的时间
    func dd_nearestTenMinutes() -> Date {
        return dd_nearestMultipleOfMinutes(minutes: 10)
    }

    /// 获取距离当前日期最近的可以被十五分钟（即一刻钟）整除的时间
    ///
    /// - Example:
    /// ```swift
    /// let nearestQuarterHour = Date().dd_nearestMultipleOfMinutes(minutes: 15)
    /// print(nearestQuarterHour)  // 输出类似 "5:30 PM" 或 "5:45 PM"
    /// ```
    /// - Parameter minutes: 可被整除的分钟数
    /// - Returns: 距离当前日期最近的可以被 `minutes` 整除的时间
    func dd_nearestQuarterHour() -> Date {
        return dd_nearestMultipleOfMinutes(minutes: 15)
    }

    /// 获取距离当前日期最近的可以被三十分钟（半小时）整除的时间
    ///
    /// - Example:
    /// ```swift
    /// let nearestHalfHour = Date().dd_nearestMultipleOfMinutes(minutes: 30)
    /// print(nearestHalfHour)  // 输出类似 "6:30 PM" 或 "7:00 PM"
    /// ```
    /// - Parameter minutes: 可被整除的分钟数
    /// - Returns: 距离当前日期最近的可以被 `minutes` 整除的时间
    func dd_nearestHalfHour() -> Date {
        return dd_nearestMultipleOfMinutes(minutes: 30)
    }

    /// 获取距离当前日期最近的可以被六十分钟（一小时）整除的时间
    ///
    /// - Example:
    /// ```swift
    /// let nearestHour = Date().dd_nearestHour()
    /// print(nearestHour)  // 输出类似 "6:00 PM" 或 "7:00 PM"
    /// ```
    /// - Returns: 距离当前日期最近的可以被一小时整除的时间
    func dd_nearestHour() -> Date {
        let min = calendar.component(.minute, from: self)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = calendar.date(from: calendar.dateComponents(components, from: self))!

        if min < 30 {
            return date
        }
        return calendar.date(byAdding: .hour, value: 1, to: date)!
    }

    /// 返回昨天的日期
    ///
    /// - Example:
    /// ```swift
    /// let yesterday = Date().dd_yesterday()
    /// print(yesterday)  // 输出 "Oct 2, 2018, 10:57:11"
    /// ```
    /// - Returns: 昨天的日期
    func dd_yesterday() -> Date {
        return calendar.date(byAdding: .day, value: -1, to: self) ?? Date()
    }

    /// 返回明天的日期
    ///
    /// - Example:
    /// ```swift
    /// let tomorrow = Date().dd_tomorrow()
    /// print(tomorrow)  // 输出 "Oct 4, 2018, 10:57:11"
    /// ```
    /// - Returns: 明天的日期
    func dd_tomorrow() -> Date {
        return calendar.date(byAdding: .day, value: 1, to: self) ?? Date()
    }

    /// 获取当前日期属于哪个年代
    ///
    /// - Example:
    /// ```swift
    /// let era = Date().dd_era()
    /// print(era)  // 输出当前日期所在的年代
    /// ```
    /// - Returns: 当前日期所在的年代
    func dd_era() -> Int {
        return calendar.component(.era, from: self)
    }

    #if !os(Linux)
        /// 获取当前日期属于本年中的第几个季度
        ///
        /// - Example:
        /// ```swift
        /// let quarter = Date().dd_quarter
        /// print(quarter)  // 输出当前日期所在的季度，例如1, 2, 3, 4
        /// ```
        /// - Returns: 当前日期所在的季度（1-4）
        var dd_quarter: Int {
            let month = Double(calendar.component(.month, from: self))
            let numberOfMonths = Double(calendar.monthSymbols.count)
            let numberOfMonthsInQuarter = numberOfMonths / 4
            return Int(Darwin.ceil(month / numberOfMonthsInQuarter))
        }
    #endif

    /// 获取当前日期是本年中的第几周
    ///
    /// - Example:
    /// ```swift
    /// let weekOfYear = Date().dd_weekOfYear()
    /// print(weekOfYear)  // 输出当前日期在本年度中的周数
    /// ```
    /// - Returns: 当前日期在本年中的第几周
    func dd_weekOfYear() -> Int {
        return calendar.component(.weekOfYear, from: self)
    }

    /// 获取当前日期在本月中是第几周
    ///
    /// - Example:
    /// ```swift
    /// let weekOfMonth = Date().dd_weekOfMonth()
    /// print(weekOfMonth)  // 输出当前日期在本月中的周数
    /// ```
    /// - Returns: 当前日期在本月中的第几周
    func dd_weekOfMonth() -> Int {
        return calendar.component(.weekOfMonth, from: self)
    }

    /// 获取当前日期是在本周中的第几天
    ///
    /// - Example:
    /// ```swift
    /// let weekday = Date().dd_weekday()
    /// print(weekday)  // 输出当前日期是本周中的第几天（1-7）
    /// ```
    /// - Returns: 当前日期在本周中的第几天（1-7）
    func dd_weekday() -> Int {
        return calendar.component(.weekday, from: self)
    }

    /// 获取当前日期是星期几（中文表示）
    ///
    /// - Example:
    /// ```swift
    /// let weekdayString = Date().dd_weekdayAs2String()
    /// print(weekdayString)  // 输出 "星期一"
    /// ```
    /// - Note: 输出中文星期，如 "星期日"、"星期一" 等
    /// - Returns: 中文星期字符串（"星期日" 到 "星期六"）
    func dd_weekdayAs2String() -> String {
        let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: self)
        return weekdays[theComponents.weekday! - 1]
    }

    /// 获取当前日期的月份（英文表示）
    ///
    /// - Example:
    /// ```swift
    /// let month = Date().dd_monthAs2String()
    /// print(month)  // 输出 "January", "February" 等
    /// ```
    /// - Returns: 当前月份的英文名称
    func dd_monthAs2String() -> String {
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }

    /// 获取当前日期
    ///
    /// - Example:
    /// ```swift
    /// let now = Date.dd_now()
    /// print(now)  // 输出当前日期和时间
    /// ```
    /// - Returns: 当前的日期
    static func dd_now() -> Date {
        if #available(iOS 15, *) {
            return Date.now
        } else {
            return Date()
        }
    }

    /// 获取今天的日期
    ///
    /// - Example:
    /// ```swift
    /// let today = Date.dd_todayDate()
    /// print(today)  // 输出今天的日期
    /// ```
    /// - Returns: 今天的日期
    static func dd_todayDate() -> Date {
        return Date()
    }

    /// 获取昨天的日期
    ///
    /// - Example:
    /// ```swift
    /// let yesterday = Date.dd_yesterDayDate()
    /// print(yesterday)  // 输出昨天的日期
    /// ```
    /// - Returns: 昨天的日期，如果无法计算则返回 `nil`
    static func dd_yesterDayDate() -> Date? {
        return calendar.date(byAdding: DateComponents(day: -1), to: Date())
    }

    /// 获取明天的日期
    ///
    /// - Example:
    /// ```swift
    /// let tomorrow = Date.dd_tomorrowDate()
    /// print(tomorrow)  // 输出明天的日期
    /// ```
    /// - Returns: 明天的日期，如果无法计算则返回 `nil`
    static func dd_tomorrowDate() -> Date? {
        return calendar.date(byAdding: DateComponents(day: 1), to: Date())
    }

    /// 获取前天的日期
    ///
    /// - Example:
    /// ```swift
    /// let theDayBeforeYesterday = Date.dd_theDayBeforYesterDayDate()
    /// print(theDayBeforeYesterday)  // 输出前天的日期
    /// ```
    /// - Returns: 前天的日期，如果无法计算则返回 `nil`
    static func dd_theDayBeforYesterDayDate() -> Date? {
        return calendar.date(byAdding: DateComponents(day: -2), to: Date())
    }

    /// 获取后天的日期
    ///
    /// - Example:
    /// ```swift
    /// let theDayAfterYesterday = Date.dd_theDayAfterYesterDayDate()
    /// print(theDayAfterYesterday)  // 输出后天的日期
    /// ```
    /// - Returns: 后天的日期，如果无法计算则返回 `nil`
    static func dd_theDayAfterYesterDayDate() -> Date? {
        return calendar.date(byAdding: DateComponents(day: 2), to: Date())
    }

    /// 获取当前月份的天数
    ///
    /// - Example:
    /// ```swift
    /// let daysInMonth = Date.dd_currentMonthDays()
    /// print(daysInMonth)  // 输出当前月份的天数
    /// ```
    /// - Returns: 当前月份的天数
    static func dd_currentMonthDays() -> Int {
        let date = Date()
        return self.dd_daysCount(year: date.dd_year, month: date.dd_month)
    }
}

// MARK: - 判断
public extension Date {
    /// 判断当前日期是否在未来
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isInFuture = date.dd_isInFuture() // 如果日期在未来，返回 true
    /// ```
    /// - Returns: 如果当前日期在未来，返回 `true`，否则返回 `false`
    func dd_isInFuture() -> Bool {
        return self > Date()
    }

    /// 判断当前日期是否在过去
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isInPast = date.dd_isInPast() // 如果日期在过去，返回 true
    /// ```
    /// - Returns: 如果当前日期在过去，返回 `true`，否则返回 `false`
    func dd_isInPast() -> Bool {
        return self < Date()
    }

    /// 判断当前日期是否在今天
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isInToday = date.dd_isInToday() // 如果日期在今天，返回 true
    /// ```
    /// - Returns: 如果当前日期在今天，返回 `true`，否则返回 `false`
    func dd_isInToday() -> Bool {
        return calendar.isDateInToday(self)
    }

    /// 判断当前日期是否在昨天
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isInYesterday = date.dd_isInYesterday() // 如果日期在昨天，返回 true
    /// ```
    /// - Returns: 如果当前日期在昨天，返回 `true`，否则返回 `false`
    func dd_isInYesterday() -> Bool {
        return calendar.isDateInYesterday(self)
    }

    /// 判断当前日期是否在明天
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isInTomorrow = date.dd_isInTomorrow() // 如果日期在明天，返回 true
    /// ```
    /// - Returns: 如果当前日期在明天，返回 `true`，否则返回 `false`
    func dd_isInTomorrow() -> Bool {
        return calendar.isDateInTomorrow(self)
    }

    /// 判断当前日期是否在周末
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isInWeekend = date.dd_isInWeekend() // 如果日期在周末，返回 true
    /// ```
    /// - Returns: 如果当前日期在周末，返回 `true`，否则返回 `false`
    func dd_isInWeekend() -> Bool {
        return calendar.isDateInWeekend(self)
    }

    /// 判断当前日期是否在工作日
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isWorkday = date.dd_isWorkday() // 如果日期在工作日，返回 true
    /// ```
    /// - Returns: 如果当前日期是工作日，返回 `true`，否则返回 `false`
    func dd_isWorkday() -> Bool {
        return !calendar.isDateInWeekend(self)
    }

    /// 判断当前日期是否在本周内
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isInCurrentWeek = date.dd_isInCurrentWeek() // 如果日期在本周内，返回 true
    /// ```
    /// - Returns: 如果当前日期在本周内，返回 `true`，否则返回 `false`
    func dd_isInCurrentWeek() -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// 判断当前日期是否在本月内
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isInCurrentMonth = date.dd_isInCurrentMonth() // 如果日期在本月内，返回 true
    /// ```
    /// - Returns: 如果当前日期在本月内，返回 `true`，否则返回 `false`
    func dd_isInCurrentMonth() -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }

    /// 判断当前日期是否在本年内
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isInCurrentYear = date.dd_isInCurrentYear() // 如果日期在本年内，返回 true
    /// ```
    /// - Returns: 如果当前日期在本年内，返回 `true`，否则返回 `false`
    func dd_isInCurrentYear() -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }

    /// 判断当前年份是否是润年
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let isLeapYear = date.dd_isLeapYear() // 如果当前年份是润年，返回 true
    /// ```
    /// - Returns: 如果当前年份是润年，返回 `true`，否则返回 `false`
    func dd_isLeapYear() -> Bool {
        let year = self.dd_year
        return (year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0))
    }
}

// MARK: - 时间戳
public extension Date {
    /// 获取当前的时间戳（单位：秒）
    ///
    /// - Example:
    /// ```swift
    /// let secondStamp = Date.dd_secondTimestamp()
    /// print(secondStamp)  // 输出当前的时间戳（秒）
    /// ```
    /// - Returns: 当前的时间戳（秒）
    static func dd_secondTimestamp() -> String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        return "\(Int(timeInterval))"
    }

    /// 获取当前日期的时间戳（单位：秒）
    ///
    /// - Example:
    /// ```swift
    /// let timestamp = Date().dd_toSecondTimestamp()
    /// print(timestamp)  // 输出秒级时间戳
    /// ```
    func dd_toSecondTimestamp() -> Double {
        return self.timeIntervalSince1970
    }

    /// 获取当前日期的格林尼治时间戳（单位：秒）
    ///
    /// - Example:
    /// ```swift
    /// let gmtTimestamp = Date().dd_toSecondTimestampFromGMT()
    /// print(gmtTimestamp)  // 输出秒级的格林尼治时间戳
    /// ```
    func dd_toSecondTimestampFromGMT() -> Int {
        let offset = TimeZone.current.secondsFromGMT(for: self)
        return Int(self.timeIntervalSince1970) - offset
    }

    /// 获取当前的时间戳（单位：毫秒）
    ///
    /// - Example:
    /// ```swift
    /// let milliStamp = Date.dd_milliStamp()
    /// print(milliStamp)  // 输出当前的时间戳（毫秒）
    /// ```
    /// - Returns: 当前的时间戳（毫秒）
    static func dd_milliTimestamp() -> String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(Darwin.round(timeInterval * 1000))
        return "\(millisecond)"
    }

    /// 获取当前日期的时间戳（单位：毫秒）
    ///
    /// - Example:
    /// ```swift
    /// let milliTimestamp = Date().dd_toMilliTimestamp()
    /// print(milliTimestamp)  // 输出毫秒级时间戳
    /// ```
    func dd_toMilliTimestamp() -> Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }

    /// 获取当前日期对象的时间戳
    ///
    /// **示例**:
    /// ```swift
    /// let timestamp = Date().dd_timestamp(isUnix: true)
    /// ```
    /// - Note: 支持返回秒和毫秒的时间戳
    /// - Parameter isUnix: 是否使用`Unix`格式 (默认 `true`，返回秒级时间戳)
    /// - Returns: `Int`类型时间戳
    func dd_timestamp(isUnix: Bool = true) -> Int {
        if isUnix {
            return Int(self.timeIntervalSince1970)
        }
        return Int(self.timeIntervalSince1970 * 1000)
    }

    /// 时间戳字符串转格式化日期字符串
    ///
    /// **示例**:
    /// ```swift
    /// let formattedDate = Date.dd_timestampAsDateString(timestamp: "1622567890", format: "yyyy-MM-dd")
    /// ```
    /// - Parameters:
    ///   - timestamp: 时间戳字符串
    ///   - format: 格式化样式，默认为 `yyyy-MM-dd HH:mm:ss`
    /// - Returns: 格式化后的日期字符串
    static func dd_timestampAsDateString(timestamp: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        // 时间戳转为Date
        let date = self.dd_timestampAs2Date(timestamp: timestamp)
        // 设置 dateFormat
        dateFormatter.dateFormat = format
        // 按照dateFormat把Date转化为String
        return dateFormatter.string(from: date)
    }

    /// 时间戳字符串转 `Date` 对象
    ///
    /// **示例**:
    /// ```swift
    /// let date = Date.dd_timestampAs2Date(timestamp: "1622567890")
    /// ```
    /// - Parameter timestamp: 时间戳字符串
    /// - Returns: 转换后的 `Date` 对象
    /// - Note: 时间戳位数必须是 10 或 13 位
    static func dd_timestampAs2Date(timestamp: String) -> Date {
        guard timestamp.count == 10 || timestamp.count == 13 else {
            #if DEBUG
                fatalError("时间戳位数不是 10 也不是 13")
            #else
                return Date()
            #endif
        }
        let timestampValue = timestamp.count == 10 ? timestamp.dd_toInt() : timestamp.dd_toInt() / 1000
        // 时间戳转为Date
        let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
        return date
    }

    /// `Date` 对象转时间戳
    ///
    /// **示例**:
    /// ```swift
    /// let timestampString = Date().dd_dateAs2Timestamp(isUnix: true)
    /// ```
    /// - Parameter isUnix: 是否使用 `Unix` 格式 (默认 `true` 返回秒级时间戳)
    /// - Returns: 时间戳字符串
    func dd_dateAs2Timestamp(isUnix: Bool = true) -> String {
        let interval = isUnix ? CLongLong(Int(self.timeIntervalSince1970)) : CLongLong(Darwin.round(self.timeIntervalSince1970 * 1000))
        return "\(interval)"
    }
}

// MARK: - 常用方法
public extension Date {
    /// 使用指定格式化字符串将日期转换为日期字符串
    ///
    /// **示例**:
    ///
    /// ```swift
    /// Date().dd_toString(with: "dd/MM/yyyy") // 输出: "01/12/2023"
    /// Date().dd_toString(with: "HH:mm")      // 输出: "23:50"
    /// Date().dd_toString(with: "dd/MM/yyyy HH:mm") // 输出: "01/12/2023 23:50"
    /// ```
    ///
    /// - Parameters:
    ///   - format: 日期格式字符串 (默认 `yyyy-MM-dd HH:mm:ss`)
    ///   - isGMT: 是否使用格林尼治时间 (默认 `false`，使用本地时间)
    /// - Returns: 格式化后的日期字符串
    func dd_toString(with format: String = "yyyy-MM-dd HH:mm:ss", isGMT: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = .current
        dateFormatter.timeZone = isGMT ? TimeZone(secondsFromGMT: 0) : TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self)
    }

    /// 当前日期的月份名称
    ///
    /// **示例**:
    /// ```swift
    /// Date().dd_monthName(of: "MMMMM") // 输出: "J"
    /// Date().dd_monthName(of: "MMM") // 输出: "Jan"
    /// Date().dd_monthName(of: "MMMM") // 输出: "January"
    /// ```
    /// - Parameter style: 月份名称的样式 (可选值: `"MMMMM"`, `"MMM"`, `"MMMM"`, 默认值: `"MMMM"`)
    /// - Returns: 月份名称字符串 (例如: `J`, `Dec`, `December`)
    func dd_monthName(of style: String = "full") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate(style)
        return dateFormatter.string(from: self)
    }

    /// 当前日期的天名称(周一到周日)
    ///
    /// **示例**:
    /// ```swift
    /// Date().dd_dayName(of: "EEEEE") // 输出: "T"
    /// Date().dd_dayName(of: "EEE") // 输出: "Thu"
    /// Date().dd_dayName(of: "EEEE") // 输出: "Thursday"
    /// ```
    /// - Parameter style: 日期名称的样式 (可选值: `"EEEEE"`, `"EEE"`, `"EEEE"`, 默认值: `"EEEE"`)
    /// - Returns: 日期名称字符串 (例如: `W`, `Wed`, `Wednesday`)
    func dd_dayName(of style: String = "EEEE") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate(style)
        return dateFormatter.string(from: self)
    }

    /// 获取两个日期之间的天数
    ///
    /// **示例**:
    /// ```swift
    /// let days = Date().dd_daysSince(anotherDate)
    /// ```
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果天数 (返回的值为浮动值)
    func dd_daysSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date) / (3600 * 24)
    }

    /// 获取两个日期之间的小时数
    ///
    /// **示例**:
    /// ```swift
    /// let hours = Date().dd_hoursSince(anotherDate)
    /// ```
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果小时数 (返回的值为浮动值)
    func dd_hoursSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date) / 3600
    }

    /// 获取两个日期之间的分钟数
    ///
    /// **示例**:
    /// ```swift
    /// let minutes = Date().dd_minutesSince(anotherDate)
    /// ```
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果分钟数 (返回的值为浮动值)
    func dd_minutesSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date) / 60
    }

    /// 获取两个日期之间的秒数
    ///
    /// **示例**:
    /// ```swift
    /// let seconds = Date().dd_secondsSince(anotherDate)
    /// ```
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果秒钟数 (返回的值为浮动值)
    func dd_secondsSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date)
    }

    /// 比较两个日期之间的距离，返回秒数
    ///
    /// **示例**:
    /// ```swift
    /// let distance = Date().dd_distance(anotherDate)
    /// ```
    /// - Note: 结果为秒数
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果秒钟数
    func dd_distance(_ date: Date) -> TimeInterval {
        return self.timeIntervalSince(date)
    }

    /// 获取指定年份中指定月的天数
    ///
    /// **示例**:
    /// ```swift
    /// let daysInMonth = Date.dd_daysCount(year: 2024, month: 2)
    /// ```
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 结果天数
    /// - Note: 处理闰年
    static func dd_daysCount(year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            return isLeapYear ? 29 : 28
        default:
            fatalError("非法的月份:\(month)")
        }
    }

    /// 判断两个日期是否是同一天
    ///
    /// **示例**:
    /// ```swift
    /// let isSameDay = Date().dd_isSameDay(date: anotherDate)
    /// ```
    /// - Parameter date: 参与比较的日期
    /// - Returns: 是否是同一天
    func dd_isSameDay(date: Date) -> Bool {
        return calendar.isDate(self, inSameDayAs: date)
    }

    /// 判断日期是否是同年同月同一天
    ///
    /// **示例**:
    /// ```swift
    /// let isSame = Date().dd_isSameYearMonthDay(date: anotherDate)
    /// ```
    /// - Parameter date: 参与比较的日期
    /// - Returns: 是否是同年同月同天
    func dd_isSameYearMonthDay(date: Date) -> Bool {
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date)
        return components1.year == components2.year && components1.month == components2.month && components1.day == components2.day
    }

    /// 获取两个日期的差距
    ///
    /// **示例**:
    /// ```swift
    /// let difference = Date().dd_componentCompare(from: anotherDate)
    /// ```
    /// - Parameters:
    ///   - date: 参与比较的日期
    ///   - unit: 单位，默认为 [年、月、日]
    /// - Returns: 差距的日历组件
    func dd_componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year, .month, .day]) -> DateComponents {
        return calendar.dateComponents(unit, from: date, to: self)
    }

    /// 判断日期是否在当前指定的日历组件中
    ///
    /// **示例**:
    /// ```swift
    /// let isInYear = Date().dd_isInCurrent(.year)
    /// ```
    /// - Parameter component: 日历组件（如 .year, .month, .day）
    func dd_isInCurrent(_ component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: component)
    }

    /// 判断当前日期是否在给定的两个日期区间之中
    ///
    /// **示例**:
    /// ```swift
    /// let isInRange = Date().dd_isBetween(startDate, endDate, includeBounds: true)
    /// ```
    /// - Parameters:
    ///   - startDate: 开始日期
    ///   - endDate: 结束日期
    ///   - includeBounds: 是否包含边界日期，默认为 `false`
    /// - Returns: 是否在指定日期区间内
    func dd_isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(self).rawValue * self.compare(endDate).rawValue >= 0
        }
        return startDate.compare(self).rawValue * self.compare(endDate).rawValue > 0
    }

    /// 判断日历组件的值是否在当前日期和指定日期之间
    ///
    /// **示例**:
    /// ```swift
    /// let isWithin = Date().dd_isWithin(5, .day, of: anotherDate)
    /// ```
    /// - Parameters:
    ///   - value: 指定日历组件的值
    ///   - component: 日历组件（如 .day, .month, .year）
    func dd_isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        let components = calendar.dateComponents([component], from: self, to: date)
        guard let componentValue = components.value(for: component) else { return false }
        return abs(componentValue) <= value
    }

    /// 在指定日期区间中生成一个随机日期（不包含边界日期）
    ///
    /// **示例**:
    /// ```swift
    /// let randomDate = Date.dd_random(in: dateRange)
    /// ```
    /// - Parameter range: 日期区间（不包含边界日期）
    static func dd_random(in range: Range<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate: TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound.timeIntervalSinceReferenceDate))
    }

    /// 在指定日期区间中生成一个随机日期（包含边界日期）
    ///
    /// **示例**:
    /// ```swift
    /// let randomDate = Date.dd_random(in: dateClosedRange)
    /// ```
    /// - Parameter range: 日期区间（包含边界日期）
    static func dd_random(in range: ClosedRange<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate: TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound.timeIntervalSinceReferenceDate))
    }

    /// 使用指定的生成器在指定日期区间生成一个随机日期（不包含边界日期）
    ///
    /// **示例**:
    /// ```swift
    /// var generator = SystemRandomNumberGenerator()
    /// let randomDate = Date.dd_random(in: dateRange, using: &generator)
    /// ```
    /// - Parameters:
    ///   - range: 日期区间（不包含边界日期）
    static func dd_random(in range: Range<Date>, using generator: inout some RandomNumberGenerator) -> Date {
        return Date(timeIntervalSinceReferenceDate: TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound.timeIntervalSinceReferenceDate, using: &generator))
    }

    /// 使用指定的生成器在指定日期区间生成一个随机日期（包含边界日期）
    ///
    /// **示例**:
    /// ```swift
    /// var generator = SystemRandomNumberGenerator()
    /// let randomDate = Date.dd_random(in: dateClosedRange, using: &generator)
    /// ```
    /// - Parameters:
    ///   - range: 日期区间（包含边界日期）
    static func dd_random(in range: ClosedRange<Date>, using generator: inout some RandomNumberGenerator) -> Date {
        return Date(timeIntervalSinceReferenceDate: TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound.timeIntervalSinceReferenceDate, using: &generator))
    }

    /// 获取两个日期之间的天数
    ///
    /// **示例**:
    /// ```swift
    /// let days = Date().dd_numberOfDays(from: anotherDate)
    /// ```
    /// - Parameter date: 参与比较的日期
    /// - Returns: 两个日期之间的天数
    func dd_numberOfDays(from date: Date) -> Int? {
        return self.dd_componentCompare(from: date, unit: [.day]).day
    }

    /// 获取两个日期之间的小时数
    ///
    /// **示例**:
    /// ```swift
    /// let hours = Date().dd_numberOfHours(from: anotherDate)
    /// ```
    /// - Parameter date: 参与比较的日期
    /// - Returns: 两个日期之间的小时数
    func dd_numberOfHours(from date: Date) -> Int? {
        return self.dd_componentCompare(from: date, unit: [.hour]).hour
    }

    /// 获取两个日期之间的分钟数
    ///
    /// **示例**:
    /// ```swift
    /// let minutes = Date().dd_numberOfMinutes(from: anotherDate)
    /// ```
    /// - Parameter date: 参与比较的日期
    /// - Returns: 两个日期之间的分钟数
    func dd_numberOfMinutes(from date: Date) -> Int? {
        return self.dd_componentCompare(from: date, unit: [.minute]).minute
    }

    /// 获取两个日期之间的秒数
    ///
    /// **示例**:
    /// ```swift
    /// let seconds = Date().dd_numberOfSeconds(from: anotherDate)
    /// ```
    /// - Parameter date: 参与比较的日期
    /// - Returns: 两个日期之间的秒数
    func dd_numberOfSeconds(from date: Date) -> Int? {
        return self.dd_componentCompare(from: date, unit: [.second]).second
    }

    /// 向当前日期增加指定天数
    ///
    /// **示例**:
    /// ```swift
    /// let newDate = Date().dd_adding(day: 5)
    /// ```
    /// - Parameter day: 要增加的天数
    /// - Returns: 增加天数后的日期
    func dd_adding(day: Int) -> Date? {
        return calendar.date(byAdding: DateComponents(day: day), to: self)
    }

    /// 添加指定日历组件的值到当前日期
    ///
    /// **示例**:
    /// ```swift
    /// let newDate = Date().dd_adding(.minute, value: -10)
    /// ```
    /// - Parameters:
    ///   - component: 日历组件（如 .minute, .day, .month, .year）
    func dd_adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: self)!
    }

    /// 修改当前日期的指定日历组件的值
    ///
    /// **示例**:
    /// ```swift
    /// let newDate = Date().dd_changing(.minute, value: 10)
    /// ```
    /// - Parameters:
    ///   - component: 日历组件（如 .minute, .hour, .day, .month, .year）
    func dd_changing(_ component: Calendar.Component, value: Int) -> Date? {
        switch component {
        case .nanosecond:
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
            #endif
            guard allowedRange.contains(value) else { return nil }
            let currentNanoseconds = calendar.component(.nanosecond, from: self)
            let nanosecondsToAdd = value - currentNanoseconds
            return calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self)

        case .second:
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentSeconds = calendar.component(.second, from: self)
            let secondsToAdd = value - currentSeconds
            return calendar.date(byAdding: .second, value: secondsToAdd, to: self)

        case .minute:
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentMinutes = calendar.component(.minute, from: self)
            let minutesToAdd = value - currentMinutes
            return calendar.date(byAdding: .minute, value: minutesToAdd, to: self)

        case .hour:
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentHour = calendar.component(.hour, from: self)
            let hoursToAdd = value - currentHour
            return calendar.date(byAdding: .hour, value: hoursToAdd, to: self)

        case .day:
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = value - currentDay
            return calendar.date(byAdding: .day, value: daysToAdd, to: self)

        case .month:
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = value - currentMonth
            return calendar.date(byAdding: .month, value: monthsToAdd, to: self)

        case .year:
            guard value > 0 else { return nil }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = value - currentYear
            return calendar.date(byAdding: .year, value: yearsToAdd, to: self)

        default:
            return calendar.date(bySetting: component, value: value, of: self)
        }
    }

    #if !os(Linux)

        /// 获取指定日历组件起始时刻的日期
        ///
        /// **示例**:
        /// ```swift
        /// let beginningOfDay = Date().dd_beginning(of: .hour) // "Jan 12, 2017, 7:00 PM"
        /// ```
        /// - Note: 由于日期格式的原因，日期显示的格式可能不同。
        /// - Parameter component: 日历组件 (如 .hour, .month, .year)
        /// - Returns: 该日历组件开始时刻的日期
        func dd_beginning(of component: Calendar.Component) -> Date? {
            if component == .day {
                return calendar.startOfDay(for: self)
            }

            var components: Set<Calendar.Component> {
                switch component {
                case .second:
                    return [.year, .month, .day, .hour, .minute, .second]

                case .minute:
                    return [.year, .month, .day, .hour, .minute]

                case .hour:
                    return [.year, .month, .day, .hour]

                case .weekOfYear, .weekOfMonth:
                    return [.yearForWeekOfYear, .weekOfYear]

                case .month:
                    return [.year, .month]

                case .year:
                    return [.year]

                default:
                    return []
                }
            }

            guard !components.isEmpty else { return nil }
            return calendar.date(from: calendar.dateComponents(components, from: self))
        }
    #endif

    /// 获取指定日历组件结束时刻的日期
    ///
    /// **示例**:
    /// ```swift
    /// let endOfDay = Date().dd_end(of: .day) // "Jan 12, 2017, 11:59 PM"
    /// ```
    /// - Parameter component: 日历组件 (如 .day, .month, .year)
    /// - Returns: 该日历组件结束时刻的日期
    func dd_end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = self.dd_adding(.second, value: 1)
            date = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
            return date.dd_adding(.second, value: -1)
        case .minute:
            var date = self.dd_adding(.minute, value: 1)
            let after = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.dd_adding(.second, value: -1)
            return date
        case .hour:
            var date = self.dd_adding(.hour, value: 1)
            let after = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.dd_adding(.second, value: -1)
            return date
        case .day:
            var date = self.dd_adding(.day, value: 1)
            date = calendar.startOfDay(for: date)
            return date.dd_adding(.second, value: -1)
        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = calendar.date(from:
                calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.dd_adding(.day, value: 7).dd_adding(.second, value: -1)
            return date
        case .month:
            var date = self.dd_adding(.month, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month], from: date))!
            date = after.dd_adding(.second, value: -1)
            return date
        case .year:
            var date = self.dd_adding(.year, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year], from: date))!
            date = after.dd_adding(.second, value: -1)
            return date
        default:
            return nil
        }
    }
}

// MARK: - 链式语法
public extension Date {
    /// 设置年份
    /// - Parameter year: 年份
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_year(_ year: Int) -> Self {
        let components = calendar.dateComponents([.year], from: self)
        let updatedDate = calendar.date(bySetting: .year, value: year, of: self)!
        self = updatedDate
        return self
    }

    /// 设置月份
    /// - Parameter month: 月份
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_month(_ month: Int) -> Self {
        let components = calendar.dateComponents([.month], from: self)
        let updatedDate = calendar.date(bySetting: .month, value: month, of: self)!
        self = updatedDate
        return self
    }

    /// 设置天
    /// - Parameter day: 天
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_day(_ day: Int) -> Self {
        let updatedDate = calendar.date(bySetting: .day, value: day, of: self)!
        self = updatedDate
        return self
    }

    /// 设置小时
    /// - Parameter hour: 小时
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_hour(_ hour: Int) -> Self {
        let updatedDate = calendar.date(bySetting: .hour, value: hour, of: self)!
        self = updatedDate
        return self
    }

    /// 设置分钟
    /// - Parameter minute: 分钟
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_minute(_ minute: Int) -> Self {
        let updatedDate = calendar.date(bySetting: .minute, value: minute, of: self)!
        self = updatedDate
        return self
    }

    /// 设置秒
    /// - Parameter second: 秒
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_second(_ second: Int) -> Self {
        let updatedDate = calendar.date(bySetting: .second, value: second, of: self)!
        self = updatedDate
        return self
    }

    /// 设置毫秒
    /// - Parameter millisecond: 毫秒
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_millisecond(_ millisecond: Int) -> Self {
        let updatedDate = calendar.date(bySetting: .nanosecond, value: millisecond * 1_000_000, of: self)!
        self = updatedDate
        return self
    }

    /// 设置纳秒
    /// - Parameter nanosecond: 纳秒
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_nanosecond(_ nanosecond: Int) -> Self {
        let updatedDate = calendar.date(bySetting: .nanosecond, value: nanosecond, of: self)!
        self = updatedDate
        return self
    }
}
