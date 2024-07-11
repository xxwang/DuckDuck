//
//  DateFormatter+duck.swift
//
//
//  Created by 王哥 on 2024/7/4.
//

import Foundation

extension DateFormatter: DDExtensionable {}

// MARK: - 构造方法
public extension DateFormatter {
    /// `DateFormatter`便利构造方法
    /// - Parameters:
    ///   - format: 格式化样式
    ///   - locale: 地区
    ///   - timeZone: 时区
    convenience init(format: String, locale: Locale? = nil, timeZone: TimeZone? = nil) {
        self.init()
        self.dateFormat = format
        if let locale { self.locale = locale }
        if let timeZone { self.timeZone = timeZone }
    }
}

// MARK: - Defaultable
extension DateFormatter: Defaultable {
    public typealias Associatedtype = DateFormatter
    @objc open class func `default`() -> Associatedtype {
        return DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss", locale: .current, timeZone: .current)
    }
}

// MARK: - 链式语法
public extension DateFormatter {
    /// 设置日期格式
    /// - Parameter dateFormat: 日期格式
    /// - Returns: `Self`
    @discardableResult
    func dd_dateFormat(_ dateFormat: String) -> Self {
        self.dateFormat = dateFormat
        return self
    }

    /// 设置地区
    /// - Parameter locale: 地区
    /// - Returns: `Self`
    @discardableResult
    func dd_locale(_ locale: Locale) -> Self {
        self.locale = locale
        return self
    }

    /// 设置时区
    /// - Parameter locale: 时区
    /// - Returns: `Self`
    @discardableResult
    func dd_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }
}
