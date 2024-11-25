//
//  DateFormatter+chian.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import Foundation

extension DateFormatter: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base: DateFormatter {
    /// 设置日期格式
    /// - Parameter dateFormat: 日期格式，例如 `yyyy/MM/dd`
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let formatter = DateFormatter()
    ///     .dd.dateFormat("yyyy/MM/dd")
    ///     .dd.locale(Locale(identifier: "en_US"))
    /// print(formatter.string(from: Date())) // 按指定格式打印日期
    /// ```
    @discardableResult
    func dateFormat(_ dateFormat: String) -> Self {
        self.base.dateFormat = dateFormat
        return self
    }

    /// 设置地区
    /// - Parameter locale: 地区，例如 `Locale(identifier: "zh_CN")`
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let formatter = DateFormatter()
    ///     .dd.dateFormat("yyyy/MM/dd")
    ///     .dd.locale(Locale(identifier: "zh_CN"))
    /// print(formatter.string(from: Date())) // 按中国地区格式打印日期
    /// ```
    @discardableResult
    func locale(_ locale: Locale) -> Self {
        self.base.locale = locale
        return self
    }

    /// 设置时区
    /// - Parameter timeZone: 时区，例如 `TimeZone(abbreviation: "UTC")`
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let formatter = DateFormatter()
    ///     .dd.dateFormat("yyyy/MM/dd HH:mm")
    ///     .dd.timeZone(TimeZone(abbreviation: "UTC"))
    /// print(formatter.string(from: Date())) // 按 UTC 时区打印日期时间
    /// ```
    @discardableResult
    func timeZone(_ timeZone: TimeZone) -> Self {
        self.base.timeZone = timeZone
        return self
    }
}
