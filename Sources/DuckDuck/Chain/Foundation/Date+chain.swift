//
//  Date+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import Foundation

extension Date: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base == Date {
    /// 设置年份
    /// - Parameter year: 年份，整数值，表示日期的年份部分
    /// - Returns: 返回更新后的日期对象，支持链式调用
    /// - Example:
    /// ```swift
    /// var date = Date()
    /// date.dd.year(2024)
    /// ```
    @discardableResult
    func year(_ year: Int) -> Self {
        let updatedDate = Calendar.current.date(bySetting: .year, value: year, of: self.base)!
        self.base = updatedDate
        return self
    }

    /// 设置月份
    /// - Parameter month: 月份，整数值，表示日期的月份部分（1 至 12）
    /// - Returns: 返回更新后的日期对象，支持链式调用
    /// - Example:
    /// ```swift
    /// var date = Date()
    /// date.dd.month(12)
    /// ```
    @discardableResult
    func month(_ month: Int) -> Self {
        let updatedDate = Calendar.current.date(bySetting: .month, value: month, of: self.base)!
        self.base = updatedDate
        return self
    }

    /// 设置天
    /// - Parameter day: 天，整数值，表示日期的天数部分
    /// - Returns: 返回更新后的日期对象，支持链式调用
    /// - Example:
    /// ```swift
    /// var date = Date()
    /// date.dd.day(15)
    /// ```
    @discardableResult
    func day(_ day: Int) -> Self {
        let updatedDate = Calendar.current.date(bySetting: .day, value: day, of: self.base)!
        self.base = updatedDate
        return self
    }

    /// 设置小时
    /// - Parameter hour: 小时，整数值，表示日期的小时部分（0 至 23）
    /// - Returns: 返回更新后的日期对象，支持链式调用
    /// - Example:
    /// ```swift
    /// var date = Date()
    /// date.dd.hour(18)
    /// ```
    @discardableResult
    func hour(_ hour: Int) -> Self {
        let updatedDate = Calendar.current.date(bySetting: .hour, value: hour, of: self.base)!
        self.base = updatedDate
        return self
    }

    /// 设置分钟
    /// - Parameter minute: 分钟，整数值，表示日期的分钟部分（0 至 59）
    /// - Returns: 返回更新后的日期对象，支持链式调用
    /// - Example:
    /// ```swift
    /// var date = Date()
    /// date.dd.minute(30)
    /// ```
    @discardableResult
    func minute(_ minute: Int) -> Self {
        let updatedDate = Calendar.current.date(bySetting: .minute, value: minute, of: self.base)!
        self.base = updatedDate
        return self
    }

    /// 设置秒
    /// - Parameter second: 秒，整数值，表示日期的秒数部分（0 至 59）
    /// - Returns: 返回更新后的日期对象，支持链式调用
    /// - Example:
    /// ```swift
    /// var date = Date()
    /// date.dd.second(45)
    /// ```
    @discardableResult
    func second(_ second: Int) -> Self {
        let updatedDate = Calendar.current.date(bySetting: .second, value: second, of: self.base)!
        self.base = updatedDate
        return self
    }

    /// 设置毫秒
    /// - Parameter millisecond: 毫秒，整数值，表示日期的毫秒部分（0 至 999）
    /// - Returns: 返回更新后的日期对象，支持链式调用
    /// - Example:
    /// ```swift
    /// var date = Date()
    /// date.dd.millisecond(500)
    /// ```
    @discardableResult
    func millisecond(_ millisecond: Int) -> Self {
        let updatedDate = Calendar.current.date(bySetting: .nanosecond, value: millisecond * 1_000_000, of: self.base)!
        self.base = updatedDate
        return self
    }

    /// 设置纳秒
    /// - Parameter nanosecond: 纳秒，整数值，表示日期的纳秒部分
    /// - Returns: 返回更新后的日期对象，支持链式调用
    /// - Example:
    /// ```swift
    /// var date = Date()
    /// date.dd.nanosecond(500_000_000)
    /// ```
    @discardableResult
    func nanosecond(_ nanosecond: Int) -> Self {
        let updatedDate = Calendar.current.date(bySetting: .nanosecond, value: nanosecond, of: self.base)!
        self.base = updatedDate
        return self
    }
}
