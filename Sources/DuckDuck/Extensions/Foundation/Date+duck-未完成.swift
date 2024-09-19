//
//  Date+duck-未完成.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import Foundation

private let calendar = Calendar.current
private let dateFormatter = DateFormatter()

public extension Date {
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }
}

// MARK: - 计算属性
public extension DDExtension where Base == Date {
    /// 设置或者获取日期中的`年份`
    ///
    ///     Date().dd.year -> 2017
    ///     var someDate = Date()
    ///     someDate.dd.year = 2000
    ///
    var year: Int {
        get { return calendar.component(.year, from: self.base) }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self.base)
            let yearsToAdd = newValue - currentYear
            guard let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self.base) else { return }
            self.base = date
        }
    }

    /// 设置或者获取日期中的`月份`
    ///
    ///     Date().dd.month -> 1
    ///     var someDate = Date()
    ///     someDate.dd.month = 10
    ///
    var month: Int {
        get { return calendar.component(.month, from: self.base) }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self.base)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: self.base)
            let monthsToAdd = newValue - currentMonth
            guard let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self.base) else { return }
            self.base = date
        }
    }

    /// 设置或者获取日期中的`天`
    ///
    ///     Date().dd.day -> 12
    ///     var someDate = Date()
    ///     someDate.dd.day = 1
    ///
    var day: Int {
        get { return calendar.component(.day, from: self.base) }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self.base)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: self.base)
            let daysToAdd = newValue - currentDay
            guard let date = calendar.date(byAdding: .day, value: daysToAdd, to: self.base) else { return }
            self.base = date
        }
    }

    /// 设置或者获取日期中的`小时`
    ///
    ///     Date().dd.hour -> 17 // 5 pm
    ///     var someDate = Date()
    ///     someDate.dd.hour = 13
    ///
    var hour: Int {
        get { return calendar.component(.hour, from: self.base) }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: self.base)!
            guard allowedRange.contains(newValue) else { return }

            let currentHours = calendar.component(.hour, from: self.base)
            let hoursToAdd = newValue - currentHours
            guard let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: self.base) else { return }
            self.base = date
        }
    }

    /// 设置或者获取日期中的`分钟`
    ///
    ///     Date().dd.minute -> 39
    ///     var someDate = Date()
    ///     someDate.dd.minute = 10
    ///
    var minute: Int {
        get { return calendar.component(.minute, from: self.base) }
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self.base)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = calendar.component(.minute, from: self.base)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: self.base) {
                self.base = date
            }
        }
    }

    /// 设置或者获取日期中的`秒`
    ///
    ///     Date().dd.second -> 55
    ///     var someDate = Date()
    ///     someDate.dd.second = 15
    ///
    var second: Int {
        get { return calendar.component(.second, from: self.base) }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: self.base)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = calendar.component(.second, from: self.base)
            let secondsToAdd = newValue - currentSeconds
            guard let date = calendar.date(byAdding: .second, value: secondsToAdd, to: self.base) else { return }
            self.base = date
        }
    }

    /// 设置或者获取日期中的`毫秒`
    ///
    ///     Date().dd.millisecond -> 68
    ///
    ///     var someDate = Date()
    ///     someDate.dd.millisecond = 68
    ///
    var millisecond: Int {
        get { return calendar.component(.nanosecond, from: self.base) / 1_000_000 }
        set {
            let nanoSeconds = newValue * 1_000_000
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self.base)!
            #endif
            guard allowedRange.contains(nanoSeconds) else { return }
            guard let date = calendar.date(bySetting: .nanosecond, value: nanoSeconds, of: self.base) else { return }
            self.base = date
        }
    }

    /// 设置或者获取日期中的`纳秒`
    ///
    ///     Date().dd.nanosecond -> 981379985
    ///     var someDate = Date()
    ///     someDate.dd.nanosecond = 981379985
    ///
    var nanosecond: Int {
        get { return calendar.component(.nanosecond, from: self.base) }
        set {
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self.base)!
            #endif
            guard allowedRange.contains(newValue) else { return }

            let currentNanoseconds = calendar.component(.nanosecond, from: self.base)
            let nanosecondsToAdd = newValue - currentNanoseconds

            guard let date = calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self.base) else { return }
            self.base = date
        }
    }

    /// 格林尼治标准时间转换为当地时间
    var as2LocalDate: Date {
        let secondFromGMT = TimeInterval(TimeZone.current.secondsFromGMT(for: self.base))
        return self.base.addingTimeInterval(secondFromGMT)
    }

    /// 当地时间转换为格林尼治标准时间
    var as2GMTDate: Date {
        let secondFromGMT = TimeInterval(TimeZone.current.secondsFromGMT(for: self.base))
        return self.base.addingTimeInterval(-secondFromGMT)
    }

    /// 获取当前日期的格林尼治时间戳
    ///
    /// - Note: 单位秒
    var secondStampFromGMT: Int {
        let offset = TimeZone.current.secondsFromGMT(for: self.base)
        return Int(self.base.timeIntervalSince1970) - offset
    }

    /// 获取当前日期的时间戳
    ///
    /// - Note: 单位秒
    var secondStamp: Double {
        return self.base.timeIntervalSince1970
    }

    /// 获取当前日期的时间戳
    ///
    /// - Note: 单位毫秒
    var milliStamp: Int {
        return Int(self.base.timeIntervalSince1970 * 1000)
    }

    /// 获取时间与当前时间之间的间隔差距
    var callTimeAfterNow: String {
        // 获取时间间隔
        let timeInterval = Date().timeIntervalSince(self.base)
        // 后缀
        let suffix = timeInterval > 0 ? "前" : "后"

        let interval = fabs(timeInterval) // 秒数
        let minute = interval / 60 // 分钟
        let hour = interval / 3600 // 小时
        let day = interval / 86400 // 天
        let month = interval / 2_592_000 // 月
        let year = interval / 31_104_000 // 年

        var time: String!
        if minute < 1 {
            time = interval > 0 ? "刚刚" : "马上"
        } else if hour < 1 {
            let s = NSNumber(value: minute as Double).intValue
            time = "\(s)分钟\(suffix)"
        } else if day < 1 {
            let s = NSNumber(value: hour as Double).intValue
            time = "\(s)小时\(suffix)"
        } else if month < 1 {
            let s = NSNumber(value: day as Double).intValue
            time = "\(s)天\(suffix)"
        } else if year < 1 {
            let s = NSNumber(value: month as Double).intValue
            time = "\(s)个月\(suffix)"
        } else {
            let s = NSNumber(value: year as Double).intValue
            time = "\(s)年\(suffix)"
        }
        return time
    }

    /// 获取当前时区的日期
    var currentZoneDate: Date {
        let date = Date()
        let zone = NSTimeZone.system
        let time = zone.secondsFromGMT(for: date)
        let dateNow = date.addingTimeInterval(TimeInterval(time))

        return dateNow
    }

    /// 将日期格式化为`ISO8601`标准的格式
    ///
    ///     Date().dd.as2ISO8601String -> "2017-01-12T14:51:29.574Z"
    ///
    /// - Note: `(yyyy-MM-dd'T'HH:mm:ss.SSS)`
    /// - Returns: `ISO8601`标准日期字符串
    var as2ISO8601String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: self.base).appending("Z")
    }

    /// 距离当前日期最近的可以被五分钟整除的时间
    ///
    ///     let date = Date() // "5:54 PM"
    ///     date.minute = 32 // "5:32 PM"
    ///     date.dd.nearestFiveMinutes() // "5:30 PM"
    ///
    ///     date.minute = 44 // "5:44 PM"
    ///     date.dd.nearestFiveMinutes() // "5:45 PM"
    ///
    var nearestFiveMinutes: Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self.base)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// 距离当前日期最近的可以被十分钟整除的时间
    ///
    ///     let date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.dd.nearestTenMinutes // "5:30 PM"
    ///
    ///     date.minute = 48 // "5:48 PM"
    ///     date.dd.nearestTenMinutes // "5:50 PM"
    ///
    var nearestTenMinutes: Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self.base)
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// 距离当前日期最近的可以被十五分钟(一刻钟)整除的时间
    ///
    ///     let date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.dd.nearestQuarterHour // "5:30 PM"
    ///
    ///     date.minute = 40 // "5:40 PM"
    ///     date.dd.nearestQuarterHour // "5:45 PM"
    ///
    var nearestQuarterHour: Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self.base)
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// 距离当前日期最近的可以被三十分钟(半小时)整除的时间
    ///
    ///     let date = Date() // "6:07 PM"
    ///     date.minute = 41 // "6:41 PM"
    ///     date.dd.nearestHalfHour // "6:30 PM"
    ///
    ///     date.minute = 51 // "6:51 PM"
    ///     date.dd.nearestHalfHour // "7:00 PM"
    ///
    /// - Returns: 结果`Date`
    var nearestHalfHour: Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self.base)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// 距离当前日期最近的可以被六十分钟(一小时)整除的时间
    ///
    ///     let date = Date() // "6:17 PM"
    ///     date.dd.nearestHour // "6:00 PM"
    ///
    ///     date.minute = 36 // "6:36 PM"
    ///     date.dd.nearestHour // "7:00 PM"
    ///
    var nearestHour: Date {
        let min = calendar.component(.minute, from: self.base)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = calendar.date(from: calendar.dateComponents(components, from: self.base))!

        if min < 30 {
            return date
        }
        return calendar.date(byAdding: .hour, value: 1, to: date)!
    }

    /// 返回昨天的日期
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.dd.yesterday // "Oct 2, 2018, 10:57:11"
    ///
    var yesterday: Date {
        return calendar.date(byAdding: .day, value: -1, to: self.base) ?? Date()
    }

    /// 返回明天的日期
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.dd.tomorrow // "Oct 4, 2018, 10:57:11"
    ///
    var tomorrow: Date {
        return calendar.date(byAdding: .day, value: 1, to: self.base) ?? Date()
    }

    /// 获取当前属于哪个年代
    /// - Returns: 结果年代
    var era: Int {
        return calendar.component(.era, from: self.base)
    }

    #if !os(Linux)
        /// 获取当前日期属于本年中的第几个季度
        /// - Returns: 结果季度
        var quarter: Int {
            let month = Double(calendar.component(.month, from: self.base))
            let numberOfMonths = Double(calendar.monthSymbols.count)
            let numberOfMonthsInQuarter = numberOfMonths / 4
            return Int(Darwin.ceil(month / numberOfMonthsInQuarter))
        }
    #endif

    /// 获取当前日期是在本年中的第几周
    var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: self.base)
    }

    /// 获取当前日期在本月中是第几周
    var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: self.base)
    }

    /// 获取当前日期是在本周中的第几天
    var weekday: Int {
        return calendar.component(.weekday, from: self.base)
    }

    /// 获取当前日期是星期几
    ///
    /// - Note: 中文表示
    var weekdayAs2String: String {
        let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: self.base)
        return weekdays[theComponents.weekday! - 1]
    }

    /// 获取当前日期的月份
    ///
    /// - Note: 英文表示
    var monthAs2String: String {
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self.base)
    }

    /// 获取现在的日期
    static var now: Date {
        if #available(iOS 15, *) {
            return Date.now
        } else {
            return Date()
        }
    }

    /// 获取今天的日期
    static var todayDate: Date {
        return Date()
    }

    /// 获取昨天的日期
    static var yesterDayDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
    }

    /// 获取明天的日期
    static var tomorrowDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())
    }

    /// 获取前天的日期
    static var theDayBeforYesterDayDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())
    }

    /// 获取后天的日期
    static var theDayAfterYesterDayDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 2), to: Date())
    }

    /// 获取当前的时间戳
    ///
    /// - Note: 单位`秒`
    static var secondStamp: String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        return "\(Int(timeInterval))"
    }

    /// 获取当前的时间戳
    ///
    /// - Note: 单位`毫秒`
    static var milliStamp: String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(Darwin.round(timeInterval * 1000))
        return "\(millisecond)"
    }

    /// 获取当前月份的天数
    /// - Returns: 结果天数
    static var currentMonthDays: Int {
        let date = Date()
        return self.daysCount(year: date.dd.year, month: date.dd.month)
    }

    /// 判断日期是否在未来
    var isInFuture: Bool {
        return self.base > Date()
    }

    /// 判断日期是否在过去
    var isInPast: Bool {
        return self.base < Date()
    }

    /// 判断日期是否在今天
    var isInToday: Bool {
        return calendar.isDateInToday(self.base)
    }

    /// 判断日期是否在昨天
    var isInYesterday: Bool {
        return calendar.isDateInYesterday(self.base)
    }

    /// 判断日期是否在明天
    var isInTomorrow: Bool {
        return calendar.isDateInTomorrow(self.base)
    }

    /// 判断日期是否在周末
    var isInWeekend: Bool {
        return calendar.isDateInWeekend(self.base)
    }

    /// 判断日期是否在工作日
    var isWorkday: Bool {
        return !calendar.isDateInWeekend(self.base)
    }

    /// 判断日期是否在本周内
    var isInCurrentWeek: Bool {
        return calendar.isDate(self.base, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// 判断日期是否在本月
    var isInCurrentMonth: Bool {
        return calendar.isDate(self.base, equalTo: Date(), toGranularity: .month)
    }

    /// 判断日期是否在本年
    var isInCurrentYear: Bool {
        return calendar.isDate(self.base, equalTo: Date(), toGranularity: .year)
    }

    /// 判断日期所在年是否是润年
    var isLeapYear: Bool {
        let year = self.year
        return (year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0))
    }
}

// MARK: - 构造方法
public extension Date {
    /// 根据`Calendar`和`DateComponents`创建`Date`
    /// - Parameters:
    ///   - calendar: 日历对象
    ///   - components: 日期组件
    init?(calendar: Calendar? = .current, components: DateComponents) {
        guard let date = calendar?.date(from: components) else { return nil }
        self = date
    }

    /// 根据日期字符串创建`Date`
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - formatter: 格式
    init?(string: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }

    /// 根据时间戳创建`Date`
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - isUnix: 是否是`unix`格式
    init(timestamp: TimeInterval, isUnix: Bool = true) {
        self.init(timeIntervalSince1970: isUnix ? timestamp : timestamp / 1000.0)
    }
}

// MARK: - 方法
public extension DDExtension where Base == Date {
    /// 使用格式化字符串格式化日期返回日期字符串
    ///
    ///     Date().dd.as2String(with:"dd/MM/yyyy") -> "1/12/17"
    ///     Date().dd.as2String(with:"HH:mm") -> "23:50"
    ///     Date().dd.as2String(with:"dd/MM/yyyy HH:mm") -> "1/12/17 23:50"
    ///
    /// - Parameters:
    ///   - format: 日期格式(默认 `yyyy-MM-dd HH:mm:ss`)
    ///   - isGMT: 是否是`格林尼治时区`
    /// - Returns: 日期字符串
    func as2String(with format: String = "yyyy-MM-dd HH:mm:ss", isGMT: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = .current
        dateFormatter.timeZone = isGMT ? TimeZone(secondsFromGMT: 0) : TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self.base)
    }

    /// 使用格式化枚举格式化日期返回日期字符串
    ///
    ///     Date().dd.as2DateString(of:.short) -> "1/12/17"
    ///     Date().dd.as2DateString(of:.medium) -> "Jan 12, 2017"
    ///     Date().dd.as2DateString(of:.long) -> "January 12, 2017"
    ///     Date().dd.as2DateString(of:.full) -> "Thursday, January 12, 2017"
    ///
    /// - Note: 只格式化日期
    /// - Parameter style: 日期格式的样式(默认 `.medium`)
    /// - Returns: 日期字符串
    func as2DateString(of style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self.base)
    }

    /// 使用格式化枚举格式化时间时间字符串
    ///
    ///     Date().dd.as2TimeString(of:.short) -> "7:37 PM"
    ///     Date().dd.as2TimeString(of:.medium) -> "7:37:02 PM"
    ///     Date().dd.as2TimeString(of:.long) -> "7:37:02 PM GMT+3"
    ///     Date().dd.as2TimeString(of:.full) -> "7:37:02 PM GMT+03:00"
    ///
    /// - Note: 只格式化时间
    /// - Parameter style: 日期格式的样式(默认 `.medium`)
    /// - Returns: 时间字符串
    func as2TimeString(of style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self.base)
    }

    /// 使用格式化枚举格式化日期和时间返回日期和时间字符串
    ///
    ///     Date().dd.as2DateTimeString(of:.short) -> "1/12/17, 7:32 PM"
    ///     Date().dd.as2DateTimeString(of:.medium) -> "Jan 12, 2017, 7:32:00 PM"
    ///     Date().dd.as2DateTimeString(of:.long) -> "January 12, 2017 at 7:32:00 PM GMT+3"
    ///     Date().dd.as2DateTimeString(of:.full) -> "Thursday, January 12, 2017 at 7:32:00 PM GMT+03:00"
    ///
    /// - Note: 格式化日期与时间
    /// - Parameter style: 日期格式的样式(默认 `.medium`)
    /// - Returns: 日期和时间字符串
    func as2DateTimeString(of style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self.base)
    }

    // MARK: - 月份名称格式枚举
    enum MonthNameStyle {
        /// 3 个字母月份的月份名称缩写
        case threeLetters
        /// 月份名称的 1 个字母月份缩写
        case oneLetter
        /// 完整的月份名称
        case full
    }

    /// 当前日期的月份名称
    ///
    ///     Date().dd.monthName(of:.oneLetter) -> "J"
    ///     Date().dd.monthName(of:.threeLetters) -> "Jan"
    ///     Date().dd.monthName(of:.full) -> "January"
    ///
    /// - Parameter Style: 月份名称的样式(默认 `MonthNameStyle.full`)
    /// - Returns: 月份名称字符串(例如:`D、Dec、December`)
    func monthName(of style: DDExtension.MonthNameStyle = .full) -> String {
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "MMMMM"
            case .threeLetters:
                return "MMM"
            case .full:
                return "MMMM"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self.base)
    }

    // MARK: - 日期名称格式枚举
    enum DayNameStyle {
        /// 日期名称的 3 个字母日期缩写
        case threeLetters
        /// 日期名称的 1 个字母日期缩写
        case oneLetter
        /// 完整的天名称
        case full
    }

    /// 当前日期的天名称(周一到周日)
    ///
    ///     Date().dd.dayName(of:.oneLetter) -> "T"
    ///     Date().dd.dayName(of:.threeLetters) -> "Thu"
    ///     Date().dd.dayName(of:.full) -> "Thursday"
    ///
    /// - Parameter Style:日期名称的样式(默认 `DayNameStyle.full`)
    /// - Returns:日期名称字符串(例如:`W、Wed、Wednesday`)
    func dayName(of style: DDExtension.DayNameStyle = .full) -> String {
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "EEEEE"
            case .threeLetters:
                return "EEE"
            case .full:
                return "EEEE"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self.base)
    }

    /// 获取两个日期之间的天数
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果天数
    func daysSince(_ date: Date) -> Double {
        return self.base.timeIntervalSince(date) / (3600 * 24)
    }

    /// 获取两个日期之间的小时数
    ///
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果小时数
    func hoursSince(_ date: Date) -> Double {
        return self.base.timeIntervalSince(date) / 3600
    }

    /// 获取两个日期之间的分钟数
    ///
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果分钟数
    func minutesSince(_ date: Date) -> Double {
        return self.base.timeIntervalSince(date) / 60
    }

    /// 获取两个日期之间的秒数
    ///
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果秒钟数
    func secondsSince(_ date: Date) -> Double {
        return self.base.timeIntervalSince(date)
    }

    /// 比较两个日期之间的距离
    ///
    /// - Note: 结果为秒数
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果秒钟数
    func distance(_ date: Date) -> TimeInterval {
        return self.base.timeIntervalSince(date)
    }

    /// 获取指定年份中指定月的天数
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 结果天数
    static func daysCount(year: Int, month: Int) -> Int {
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

    /// 获取当前日期对象的时间戳
    ///
    /// - Note: 支持返回秒和毫秒的时间戳
    /// - Parameter isUnix: 是否使用`Unix`格式
    /// - Returns: `Int`类型时间戳
    func timestamp(isUnix: Bool = true) -> Int {
        if isUnix { return Int(self.base.timeIntervalSince1970) }
        return Int(self.base.timeIntervalSince1970 * 1000)
    }

    /// 时间戳字符串转格式化日期字符串
    /// - Parameters:
    ///   - timestamp: 时间戳字符串
    ///   - format: 格式化样式
    /// - Returns: 结果字符串
    static func timestampAsDateString(timestamp: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        // 时间戳转为Date
        let date = self.timestampAs2Date(timestamp: timestamp)
        // 设置 dateFormat
        dateFormatter.dateFormat = format
        // 按照dateFormat把Date转化为String
        return dateFormatter.string(from: date)
    }

    /// 时间戳字符串转`Date`对象
    /// - Parameter timestamp: 时间戳字符串
    /// - Returns: 结果 `Date`
    static func timestampAs2Date(timestamp: String) -> Date {
        guard timestamp.count == 10 || timestamp.count == 13 else {
            #if DEBUG
                fatalError("时间戳位数不是 10 也不是 13")
            #else
                return Date()
            #endif
        }
        let timestampValue = timestamp.count == 10 ? timestamp.dd.as2Int : timestamp.dd.as2Int / 1000
        // 时间戳转为Date
        let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
        return date
    }

    /// `Date`对象转时间戳
    /// - Parameter isUnix: 是否使用`Unix`格式
    /// - Returns: 时间戳字符串
    func dateAs2Timestamp(isUnix: Bool = true) -> String {
        let interval = isUnix ? CLongLong(Int(self.base.timeIntervalSince1970)) : CLongLong(Darwin.round(self.base.timeIntervalSince1970 * 1000))
        return "\(interval)"
    }

    /// 判断两个日期是否是同一天
    /// - Parameter date: 参与比较的日期
    /// - Returns: 是否是同一天
    func isSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self.base, inSameDayAs: date)
    }

    /// 判断日期是否是同年同月同一天
    /// - Parameter date: 参与比较的日期
    /// - Returns: 是否是同年同月同天
    func isSameYeaerMountDay(_ date: Date) -> Bool {
        let com = Calendar.current.dateComponents([.year, .month, .day], from: self.base)
        let comToday = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return com.day == comToday.day
            && com.month == comToday.month
            && com.year == comToday.year
    }

    /// 获取两个日期的差距
    /// - Parameters:
    ///   - date: 参与比较的日期
    ///   - unit: 单位
    /// - Returns: 差距日历组件
    func componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year, .month, .day]) -> DateComponents {
        return Calendar.current.dateComponents(unit, from: date, to: self.base)
    }

    /// 判断日期是否在当前指定的日历组件中
    ///
    ///     Date().dd.isInCurrent(.day) -> true
    ///     Date().dd.isInCurrent(.year) -> true
    ///
    /// - Parameter component: 日历组件
    /// - Returns: 是否在指定的日历组件中
    func isInCurrent(_ component: Calendar.Component) -> Bool {
        return calendar.isDate(self.base, equalTo: Date(), toGranularity: component)
    }

    /// 判断当前日期是否在给定的两个日期对象区间之中
    /// - Parameters:
    ///   - startDate: 开始日期
    ///   - endDate: 结束日期
    ///   - includeBounds: 是否包含边界
    /// - Returns: 是否在指定日期中
    func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(self.base).rawValue * self.base.compare(endDate).rawValue >= 0
        }
        return startDate.compare(self.base).rawValue * self.base.compare(endDate).rawValue > 0
    }

    /// 判断日历组件的值是否包含在当前日期和指定日期之间
    /// - Parameters:
    ///   - value: 指定日历组件的值
    ///   - component: 日历组件
    ///   - date: 结果日期
    /// - Returns: 是否包含
    func isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        let components = calendar.dateComponents([component], from: self.base, to: date)
        let componentValue = components.value(for: component)!
        return Darwin.abs(Int32(componentValue)) <= value
    }

    /// 在指定日期区间中生成一个随机日期
    ///
    /// - Note: 不包含结果日期本身
    /// - Parameter range: 日期区间
    /// - Returns: 随机结果
    static func random(in range: Range<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval
                .random(in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound
                    .timeIntervalSinceReferenceDate))
    }

    /// 在指定日期区间中生成一个随机日期
    ///
    /// - Note: 包含结果日期本身
    /// - Parameter range: 日期区间
    /// - Returns: 随机结果
    static func random(in range: ClosedRange<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval
                .random(in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound
                    .timeIntervalSinceReferenceDate))
    }

    /// 使用给定的生成器在指定日期区间生成一个随机日期
    ///
    /// - Note: 不包含结果日期本身
    /// - Parameters:
    ///   - range: 日期区间
    ///   - generator: 生成器
    /// - Returns: 随机结果
    static func random(in range: Range<Date>, using generator: inout some RandomNumberGenerator) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(
                in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound.timeIntervalSinceReferenceDate,
                using: &generator
            ))
    }

    /// 使用给定的生成器在指定日期区间生成一个随机日期
    ///
    /// - Note: 包含结果日期本身
    /// - Parameters:
    ///   - range: 日期区间
    ///   - generator: 生成器
    /// - Returns: 随机结果
    static func random(in range: ClosedRange<Date>, using generator: inout some RandomNumberGenerator) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(
                in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound.timeIntervalSinceReferenceDate,
                using: &generator
            ))
    }

    /// 获取两个日期之间的天数
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果天数
    func numberOfDays(from date: Date) -> Int? {
        return self.componentCompare(from: date, unit: [.day]).day
    }

    /// 获取两个日期之间的小时数
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果小时数
    func numberOfHours(from date: Date) -> Int? {
        return self.componentCompare(from: date, unit: [.hour]).hour
    }

    /// 获取两个日期之间的分钟数
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果分钟数
    func numberOfMinutes(from date: Date) -> Int? {
        return self.componentCompare(from: date, unit: [.minute]).minute
    }

    /// 获取两个日期之间的秒数
    /// - Parameter date: 参与比较的日期
    /// - Returns: 结果秒数
    func numberOfSeconds(from date: Date) -> Int? {
        return self.componentCompare(from: date, unit: [.second]).second
    }

    /// 向当前日期增加指定天数
    /// - Parameter day: 要增加的天数
    /// - Returns: 结果日期
    func adding(day: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: day), to: self.base)
    }

    /// 添加指定日历组件的值到当前日期
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.dd.adding(.minute, value:-10) // "Jan 12, 2017, 6:57 PM"
    ///     let date3 = date.dd.adding(.day, value:4) // "Jan 16, 2017, 7:07 PM"
    ///     let date4 = date.dd.adding(.month, value:2) // "Mar 12, 2017, 7:07 PM"
    ///     let date5 = date.dd.adding(.year, value:13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: 日历组件
    ///   - value: 日历组件对应的值
    /// - Returns: 结果日期
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self.base)!
    }

    /// 个性日期对象指定日历组件的值
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.dd.changing(.minute, value:10) // "Jan 12, 2017, 7:10 PM"
    ///     let date3 = date.dd.changing(.day, value:4) // "Jan 4, 2017, 7:07 PM"
    ///     let date4 = date.dd.changing(.month, value:2) // "Feb 12, 2017, 7:07 PM"
    ///     let date5 = date.dd.changing(.year, value:2000) // "Jan 12, 2000, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: 日历组件
    ///   - value: 日历组件对应值
    /// - Returns: 结果日期
    func changing(_ component: Calendar.Component, value: Int) -> Date? {
        switch component {
        case .nanosecond:
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self.base)!
            #endif
            guard allowedRange.contains(value) else { return nil }
            let currentNanoseconds = calendar.component(.nanosecond, from: self.base)
            let nanosecondsToAdd = value - currentNanoseconds
            return calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self.base)

        case .second:
            let allowedRange = calendar.range(of: .second, in: .minute, for: self.base)!
            guard allowedRange.contains(value) else { return nil }
            let currentSeconds = calendar.component(.second, from: self.base)
            let secondsToAdd = value - currentSeconds
            return calendar.date(byAdding: .second, value: secondsToAdd, to: self.base)

        case .minute:
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self.base)!
            guard allowedRange.contains(value) else { return nil }
            let currentMinutes = calendar.component(.minute, from: self.base)
            let minutesToAdd = value - currentMinutes
            return calendar.date(byAdding: .minute, value: minutesToAdd, to: self.base)

        case .hour:
            let allowedRange = calendar.range(of: .hour, in: .day, for: self.base)!
            guard allowedRange.contains(value) else { return nil }
            let currentHour = calendar.component(.hour, from: self.base)
            let hoursToAdd = value - currentHour
            return calendar.date(byAdding: .hour, value: hoursToAdd, to: self.base)

        case .day:
            let allowedRange = calendar.range(of: .day, in: .month, for: self.base)!
            guard allowedRange.contains(value) else { return nil }
            let currentDay = calendar.component(.day, from: self.base)
            let daysToAdd = value - currentDay
            return calendar.date(byAdding: .day, value: daysToAdd, to: self.base)

        case .month:
            let allowedRange = calendar.range(of: .month, in: .year, for: self.base)!
            guard allowedRange.contains(value) else { return nil }
            let currentMonth = calendar.component(.month, from: self.base)
            let monthsToAdd = value - currentMonth
            return calendar.date(byAdding: .month, value: monthsToAdd, to: self.base)

        case .year:
            guard value > 0 else { return nil }
            let currentYear = calendar.component(.year, from: self.base)
            let yearsToAdd = value - currentYear
            return calendar.date(byAdding: .year, value: yearsToAdd, to: self.base)

        default:
            return calendar.date(bySetting: component, value: value, of: self.base)
        }
    }

    #if !os(Linux)

        /// 获取以指定日历组件为开头的日期
        ///
        ///     let date = Date() // "Jan 12, 2017, 7:14 PM"
        ///     let date2 = date.dd.beginning(of:.hour) // "Jan 12, 2017, 7:00 PM"
        ///     let date3 = date.dd.beginning(of:.month) // "Jan 1, 2017, 12:00 AM"
        ///     let date4 = date.dd.beginning(of:.year) // "Jan 1, 2017, 12:00 AM"
        ///
        /// - Note: 由于日期格式的原因, 显示因格式不一样
        /// - Parameter component: 日历组件
        /// - Returns: 结果日期
        func beginning(of component: Calendar.Component) -> Date? {
            if component == .day { return calendar.startOfDay(for: self.base) }

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
            return calendar.date(from: calendar.dateComponents(components, from: self.base))
        }
    #endif

    /// 获取以指定日历组件为结尾的日期
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:27 PM"
    ///     let date2 = date.dd.end(of:.day) // "Jan 12, 2017, 11:59 PM"
    ///     let date3 = date.dd.end(of:.month) // "Jan 31, 2017, 11:59 PM"
    ///     let date4 = date.dd.end(of:.year) // "Dec 31, 2017, 11:59 PM"
    ///
    /// - Parameter component: 日历组件
    /// - Returns: 结果日期
    func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = self.adding(.second, value: 1)
            date = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
            return date.dd.adding(.second, value: -1)
        case .minute:
            var date = self.adding(.minute, value: 1)
            let after = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.dd.adding(.second, value: -1)
            return date
        case .hour:
            var date = self.adding(.hour, value: 1)
            let after = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.dd.adding(.second, value: -1)
            return date
        case .day:
            var date = self.adding(.day, value: 1)
            date = calendar.startOfDay(for: date)
            return date.dd.adding(.second, value: -1)
        case .weekOfYear, .weekOfMonth:
            var date = self.base
            let beginningOfWeek = calendar.date(from:
                calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.dd.adding(.day, value: 7).dd.adding(.second, value: -1)
            return date
        case .month:
            var date = self.adding(.month, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month], from: date))!
            date = after.dd.adding(.second, value: -1)
            return date
        case .year:
            var date = self.adding(.year, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year], from: date))!
            date = after.dd.adding(.second, value: -1)
            return date
        default:
            return nil
        }
    }
}

// MARK: - 链式语法
extension Date {
    /// 设置年份
    /// - Parameter year: 年份
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_year(_ year: Int) -> Self {
        self.dd.year = year
        return self
    }

    /// 设置月份
    /// - Parameter month: 月份
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_month(_ month: Int) -> Self {
        self.dd.month = month
        return self
    }

    /// 设置天
    /// - Parameter day: 天
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_day(_ day: Int) -> Self {
        self.dd.day = day
        return self
    }

    /// 设置小时
    /// - Parameter hour: 小时
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_hour(_ hour: Int) -> Self {
        self.dd.hour = hour
        return self
    }

    /// 设置分钟
    /// - Parameter minute: 分钟
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_minute(_ minute: Int) -> Self {
        self.dd.minute = minute
        return self
    }

    /// 设置秒
    /// - Parameter second: 秒
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_second(_ second: Int) -> Self {
        self.dd.second = second
        return self
    }

    /// 设置毫秒
    /// - Parameter millisecond: 毫秒
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_millisecond(_ millisecond: Int) -> Self {
        self.dd.millisecond = millisecond
        return self
    }

    /// 设置纳秒
    /// - Parameter nanosecond: 纳秒
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_nanosecond(_ nanosecond: Int) -> Self {
        self.dd.nanosecond = nanosecond
        return self
    }
}
