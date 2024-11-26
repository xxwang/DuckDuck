//
//  DateComponents++.swift
//  DuckDuck
//
//  Created by xxwang on 21/11/2024.
//

import Foundation

public extension DateComponents {
    /// 快速创建日期对象
    /// - Parameter calendar: 日历对象，默认为 `Calendar.current`
    /// - Returns: 生成的 `Date` 对象（如果设置的组件有效）
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// let date = components
    ///     .dd_year(2024)
    ///     .dd_month(11)
    ///     .dd_day(21)
    ///     .dd_hour(10)
    ///     .dd_minute(30)
    ///     .dd_toDate()
    /// print(date)
    /// ```
    func dd_toDate(using calendar: Calendar = .current) -> Date? {
        return calendar.date(from: self)
    }
}

// MARK: - 链式语法
public extension DateComponents {
    /// 设置日历对象
    /// - Parameter calendar: 日历对象
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_calendar(.current)
    /// ```
    @discardableResult
    mutating func dd_calendar(_ calendar: Calendar) -> Self {
        self.calendar = calendar
        return self
    }

    /// 设置时区
    /// - Parameter timeZone: 时区
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_timeZone(TimeZone(secondsFromGMT: 0)!)
    /// ```
    @discardableResult
    mutating func dd_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    /// 设置时代
    /// - Parameter era: 时代
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_era(1)
    /// ```
    @discardableResult
    mutating func dd_era(_ era: Int) -> Self {
        self.era = era
        return self
    }

    /// 设置年份
    /// - Parameter year: 年份
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_year(2024)
    /// ```
    @discardableResult
    mutating func dd_year(_ year: Int) -> Self {
        self.year = year
        return self
    }

    /// 设置月份
    /// - Parameter month: 月份
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_month(11)
    /// ```
    @discardableResult
    mutating func dd_month(_ month: Int) -> Self {
        self.month = month
        return self
    }

    /// 设置星期几
    /// - Parameter weekday: 星期几 (1: 周日, 2: 周一, ...)
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_weekday(2) // 设置为周一
    /// ```
    @discardableResult
    mutating func dd_weekday(_ weekday: Int) -> Self {
        self.weekday = weekday
        return self
    }

    /// 设置星期几的序号
    /// - Parameter weekdayOrdinal: 星期几在当前月份的序号
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_weekdayOrdinal(2) // 设置为当月第2个星期几
    /// ```
    @discardableResult
    mutating func dd_weekdayOrdinal(_ weekdayOrdinal: Int) -> Self {
        self.weekdayOrdinal = weekdayOrdinal
        return self
    }

    /// 设置季度
    /// - Parameter quarter: 季度 (1: 第一季度, 2: 第二季度, ...)
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_quarter(3) // 设置为第三季度
    /// ```
    @discardableResult
    mutating func dd_quarter(_ quarter: Int) -> Self {
        self.quarter = quarter
        return self
    }

    /// 设置周数
    /// - Parameter weekOfMonth: 当前月的第几周
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_weekOfMonth(2) // 设置为当月的第2周
    /// ```
    @discardableResult
    mutating func dd_weekOfMonth(_ weekOfMonth: Int) -> Self {
        self.weekOfMonth = weekOfMonth
        return self
    }

    /// 设置年份中的周数
    /// - Parameter weekOfYear: 当前年的第几周
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_weekOfYear(15) // 设置为当年的第15周
    /// ```
    @discardableResult
    mutating func dd_weekOfYear(_ weekOfYear: Int) -> Self {
        self.weekOfYear = weekOfYear
        return self
    }

    /// 设置天数
    /// - Parameter day: 天数
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_day(21)
    /// ```
    @discardableResult
    mutating func dd_day(_ day: Int) -> Self {
        self.day = day
        return self
    }

    /// 设置小时
    /// - Parameter hour: 小时
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_hour(10)
    /// ```
    @discardableResult
    mutating func dd_hour(_ hour: Int) -> Self {
        self.hour = hour
        return self
    }

    /// 设置分钟
    /// - Parameter minute: 分钟
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_minute(30)
    /// ```
    @discardableResult
    mutating func dd_minute(_ minute: Int) -> Self {
        self.minute = minute
        return self
    }

    /// 设置秒钟
    /// - Parameter second: 秒钟
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_second(45)
    /// ```
    @discardableResult
    mutating func dd_second(_ second: Int) -> Self {
        self.second = second
        return self
    }

    /// 设置纳秒
    /// - Parameter nanosecond: 纳秒
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd_nanosecond(100)
    /// ```
    @discardableResult
    mutating func dd_nanosecond(_ nanosecond: Int) -> Self {
        self.nanosecond = nanosecond
        return self
    }
}
