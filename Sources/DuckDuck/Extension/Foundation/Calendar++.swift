//
//  Calendar++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 21/11/2024.
//

import Foundation

// MARK: - 方法
public extension Calendar {
    /// 获取指定`Date`所在月份的天数
    /// - Parameter date: 日期 (默认:`Date.now`)
    /// - Returns: 当月天数
    ///
    /// - Example:
    /// ```swift
    /// let daysInMonth = Calendar.current.dd_daysInMonth(for: someDate)
    /// print("当月天数: \(daysInMonth)")
    /// ```
    func dd_daysInMonth(for date: Date = Date()) -> Int {
        return self.range(of: .day, in: .month, for: date)!.count
    }

    /// 获取指定`Date`所在星期几
    /// - Parameter date: 日期 (默认:`Date.now`)
    /// - Returns: 星期几，1是星期天，7是星期六
    ///
    /// - Example:
    /// ```swift
    /// let weekday = Calendar.current.dd_weekday(for: someDate)
    /// print("星期几: \(weekday)") // 输出 1-7 之间的值
    /// ```
    func dd_weekday(for date: Date = Date()) -> Int {
        return self.component(.weekday, from: date)
    }

    /// 获取当前月份的开始日期
    /// - Parameter date: 日期 (默认:`Date.now`)
    /// - Returns: 当前月的第一天
    ///
    /// - Example:
    /// ```swift
    /// if let startOfMonth = Calendar.current.dd_startOfMonth(for: someDate) {
    ///     print("当前月的开始日期: \(startOfMonth)")
    /// }
    /// ```
    func dd_startOfMonth(for date: Date = Date()) -> Date? {
        return self.date(from: self.dateComponents([.year, .month], from: date))
    }

    /// 获取当前月份的结束日期
    /// - Parameter date: 日期 (默认:`Date.now`)
    /// - Returns: 当前月的最后一天
    ///
    /// - Example:
    /// ```swift
    /// if let endOfMonth = Calendar.current.dd_endOfMonth(for: someDate) {
    ///     print("当前月的结束日期: \(endOfMonth)")
    /// }
    /// ```
    func dd_endOfMonth(for date: Date = Date()) -> Date? {
        guard let startOfMonth = dd_startOfMonth(for: date) else { return nil }
        return self.date(byAdding: .month, value: 1, to: startOfMonth)?.addingTimeInterval(-1)
    }

    /// 计算两个日期之间的天数差
    /// - Parameters:
    ///   - startDate: 开始日期
    ///   - endDate: 结束日期
    /// - Returns: 两个日期之间的天数
    ///
    /// - Example:
    /// ```swift
    /// let daysDifference = Calendar.current.dd_daysBetween(startDate: startDate, endDate: endDate)
    /// print("日期差: \(daysDifference)天")
    /// ```
    func dd_daysBetween(startDate: Date, endDate: Date) -> Int {
        return self.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }

    /// 获取指定日期的上一个月
    /// - Parameter date: 日期 (默认:`Date.now`)
    /// - Returns: 上个月的日期
    ///
    /// - Example:
    /// ```swift
    /// if let previousMonth = Calendar.current.dd_previousMonth(for: someDate) {
    ///     print("上个月的日期: \(previousMonth)")
    /// }
    /// ```
    func dd_previousMonth(for date: Date = Date()) -> Date? {
        return self.date(byAdding: .month, value: -1, to: date)
    }

    /// 获取指定日期的下一个月
    /// - Parameter date: 日期 (默认:`Date.now`)
    /// - Returns: 下个月的日期
    ///
    /// - Example:
    /// ```swift
    /// if let nextMonth = Calendar.current.dd_nextMonth(for: someDate) {
    ///     print("下个月的日期: \(nextMonth)")
    /// }
    /// ```
    func dd_nextMonth(for date: Date = Date()) -> Date? {
        return self.date(byAdding: .month, value: 1, to: date)
    }
}
