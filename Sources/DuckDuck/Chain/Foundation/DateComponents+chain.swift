//
//  DateComponents+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import Foundation

extension DateComponents: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base == DateComponents {
    /// 设置日历对象
    /// - Parameter calendar: 日历对象
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.calendar(.current)
    /// ```
    @discardableResult
    func calendar(_ calendar: Calendar) -> Self {
        self.base.calendar = calendar
        return self
    }

    /// 设置时区
    /// - Parameter timeZone: 时区
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.timeZone(TimeZone(secondsFromGMT: 0)!)
    /// ```
    @discardableResult
    func timeZone(_ timeZone: TimeZone) -> Self {
        self.base.timeZone = timeZone
        return self
    }

    /// 设置时代
    /// - Parameter era: 时代
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.era(1)
    /// ```
    @discardableResult
    func era(_ era: Int) -> Self {
        self.base.era = era
        return self
    }

    /// 设置年份
    /// - Parameter year: 年份
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.year(2024)
    /// ```
    @discardableResult
    func year(_ year: Int) -> Self {
        self.base.year = year
        return self
    }

    /// 设置月份
    /// - Parameter month: 月份
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.month(11)
    /// ```
    @discardableResult
    func month(_ month: Int) -> Self {
        self.base.month = month
        return self
    }

    /// 设置星期几
    /// - Parameter weekday: 星期几 (1: 周日, 2: 周一, ...)
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.weekday(2) // 设置为周一
    /// ```
    @discardableResult
    func weekday(_ weekday: Int) -> Self {
        self.base.weekday = weekday
        return self
    }

    /// 设置星期几的序号
    /// - Parameter weekdayOrdinal: 星期几在当前月份的序号
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.weekdayOrdinal(2) // 设置为当月第2个星期几
    /// ```
    @discardableResult
    func weekdayOrdinal(_ weekdayOrdinal: Int) -> Self {
        self.base.weekdayOrdinal = weekdayOrdinal
        return self
    }

    /// 设置季度
    /// - Parameter quarter: 季度 (1: 第一季度, 2: 第二季度, ...)
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.quarter(3) // 设置为第三季度
    /// ```
    @discardableResult
    func quarter(_ quarter: Int) -> Self {
        self.base.quarter = quarter
        return self
    }

    /// 设置周数
    /// - Parameter weekOfMonth: 当前月的第几周
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.weekOfMonth(2) // 设置为当月的第2周
    /// ```
    @discardableResult
    func weekOfMonth(_ weekOfMonth: Int) -> Self {
        self.base.weekOfMonth = weekOfMonth
        return self
    }

    /// 设置年份中的周数
    /// - Parameter weekOfYear: 当前年的第几周
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.weekOfYear(15) // 设置为当年的第15周
    /// ```
    @discardableResult
    func weekOfYear(_ weekOfYear: Int) -> Self {
        self.base.weekOfYear = weekOfYear
        return self
    }

    /// 设置天数
    /// - Parameter day: 天数
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.day(21)
    /// ```
    @discardableResult
    func day(_ day: Int) -> Self {
        self.base.day = day
        return self
    }

    /// 设置小时
    /// - Parameter hour: 小时
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.hour(10)
    /// ```
    @discardableResult
    func hour(_ hour: Int) -> Self {
        self.base.hour = hour
        return self
    }

    /// 设置分钟
    /// - Parameter minute: 分钟
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.minute(30)
    /// ```
    @discardableResult
    func minute(_ minute: Int) -> Self {
        self.base.minute = minute
        return self
    }

    /// 设置秒钟
    /// - Parameter second: 秒钟
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.second(45)
    /// ```
    @discardableResult
    func second(_ second: Int) -> Self {
        self.base.second = second
        return self
    }

    /// 设置纳秒
    /// - Parameter nanosecond: 纳秒
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// var components = DateComponents()
    /// components.dd.nanosecond(100)
    /// ```
    @discardableResult
    func nanosecond(_ nanosecond: Int) -> Self {
        self.base.nanosecond = nanosecond
        return self
    }
}
