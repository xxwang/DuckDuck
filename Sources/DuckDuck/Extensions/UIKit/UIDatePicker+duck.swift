//
//  UIDatePicker+duck.swift
//
//
//  Created by 王哥 on 2024/6/18.
//

import UIKit

// MARK: - Defaultable
public extension UIDatePicker {
    public typealias Associatedtype = UIDatePicker
    open override class func `default`() -> Associatedtype {
        return UIDatePicker()
    }
}

// MARK: - 链式语法
public extension UIDatePicker {
    /// 设置时区
    /// - Parameter timeZone:时区
    /// - Returns:`Self`
    @discardableResult
    func dd_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    /// 设置模式
    /// - Parameter datePickerMode:模式
    /// - Returns:`Self`
    @discardableResult
    func dd_datePickerMode(_ datePickerMode: Mode) -> Self {
        self.datePickerMode = datePickerMode
        return self
    }

    /// 设置样式
    /// - Parameter preferredDatePickerStyle:样式
    /// - Returns:`Self`
    @discardableResult
    @available(iOS 13.4, *)
    func dd_preferredDatePickerStyle(_ preferredDatePickerStyle: UIDatePickerStyle) -> Self {
        self.preferredDatePickerStyle = preferredDatePickerStyle
        return self
    }

    /// 是否高亮今天
    /// - Parameter highlightsToday:是否高亮今天
    /// - Returns:`Self`
    @discardableResult
    func dd_highlightsToday(_ highlightsToday: Bool) -> Self {
        self.setValue(highlightsToday, forKey: "highlightsToday")
        return self
    }

    /// 设置文字颜色
    /// - Parameter textColor:文字颜色
    /// - Returns:`Self`
    @discardableResult
    func dd_textColor(_ textColor: UIColor) -> Self {
        self.setValue(textColor, forKeyPath: "textColor")
        return self
    }
}

