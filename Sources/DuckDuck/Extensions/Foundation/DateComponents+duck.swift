//
//  DateComponents+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import Foundation

// MARK: - 链式语法
public extension DateComponents {
    /// 设置日历对象
    /// - Parameter calendar: 日历对象
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_calendar(_ calendar: Calendar) -> Self {
        self.calendar = calendar
        return self
    }

    /// 设置时区
    /// - Parameter timeZone: 时区
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    /// 设置时代
    /// - Parameter era: 时代
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_era(_ era: Int) -> Self {
        self.era = era
        return self
    }

    /// 设置年份
    /// - Parameter year: 年份
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_year(_ year: Int) -> Self {
        self.year = year
        return self
    }

    /// 设置月份
    /// - Parameter month: 月份
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_month(_ month: Int) -> Self {
        self.month = month
        return self
    }

    /// 设置天数
    /// - Parameter day: 天数
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_day(_ day: Int) -> Self {
        self.day = day
        return self
    }

    /// 设置小时
    /// - Parameter hour: 小时
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_hour(_ hour: Int) -> Self {
        self.hour = hour
        return self
    }

    /// 设置分钟
    /// - Parameter minute: 分钟
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_minute(_ minute: Int) -> Self {
        self.minute = minute
        return self
    }

    /// 设置秒钟
    /// - Parameter second: 秒钟
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_second(_ second: Int) -> Self {
        self.second = second
        return self
    }

    /// 设置纳秒
    /// - Parameter nanosecond: 纳秒
    /// - Returns: `Self`
    @discardableResult
    mutating func dd_nanosecond(_ nanosecond: Int) -> Self {
        self.nanosecond = nanosecond
        return self
    }
}
