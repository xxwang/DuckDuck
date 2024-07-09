//
//  Date+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import Foundation

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
