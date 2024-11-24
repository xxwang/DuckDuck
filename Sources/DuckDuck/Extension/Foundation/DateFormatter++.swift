//
//  DateFormatter++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 21/11/2024.
//

import Foundation

// MARK: - 构造方法
public extension DateFormatter {
    /// `DateFormatter`便利构造方法
    /// - Parameters:
    ///   - format: 格式化样式，例如 `yyyy-MM-dd` 或 `HH:mm:ss`
    ///   - locale: 地区，默认使用系统地区
    ///   - timeZone: 时区，默认使用系统时区
    ///
    /// - Example:
    /// ```swift
    /// let formatter = DateFormatter(format: "yyyy-MM-dd", locale: Locale(identifier: "en_US"), timeZone: TimeZone(abbreviation: "UTC"))
    /// print(formatter.string(from: Date())) // 打印格式化日期
    /// ```
    convenience init(format: String, locale: Locale? = nil, timeZone: TimeZone? = nil) {
        self.init()
        self.dateFormat = format
        if let locale { self.locale = locale }
        if let timeZone { self.timeZone = timeZone }
    }
}

public extension DateFormatter {
    /// 默认格式化器
    /// - Returns: 配置了默认样式、地区和时区的 `DateFormatter`
    ///
    /// - Example:
    /// ```swift
    /// let formatter = DateFormatter.default()
    /// print(formatter.string(from: Date())) // 打印 ISO 格式的日期
    /// ```
    static func `default`() -> DateFormatter {
        return DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss", locale: .current, timeZone: .current)
    }
}

// MARK: - 链式语法
public extension DateFormatter {
    /// 设置日期格式
    /// - Parameter dateFormat: 日期格式，例如 `yyyy/MM/dd`
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let formatter = DateFormatter()
    ///     .dd_dateFormat("yyyy/MM/dd")
    ///     .dd_locale(Locale(identifier: "en_US"))
    /// print(formatter.string(from: Date())) // 按指定格式打印日期
    /// ```
    @discardableResult
    func dd_dateFormat(_ dateFormat: String) -> Self {
        self.dateFormat = dateFormat
        return self
    }

    /// 设置地区
    /// - Parameter locale: 地区，例如 `Locale(identifier: "zh_CN")`
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let formatter = DateFormatter()
    ///     .dd_dateFormat("yyyy/MM/dd")
    ///     .dd_locale(Locale(identifier: "zh_CN"))
    /// print(formatter.string(from: Date())) // 按中国地区格式打印日期
    /// ```
    @discardableResult
    func dd_locale(_ locale: Locale) -> Self {
        self.locale = locale
        return self
    }

    /// 设置时区
    /// - Parameter timeZone: 时区，例如 `TimeZone(abbreviation: "UTC")`
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let formatter = DateFormatter()
    ///     .dd_dateFormat("yyyy/MM/dd HH:mm")
    ///     .dd_timeZone(TimeZone(abbreviation: "UTC"))
    /// print(formatter.string(from: Date())) // 按 UTC 时区打印日期时间
    /// ```
    @discardableResult
    func dd_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }
}
