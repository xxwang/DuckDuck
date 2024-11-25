//
//  UISwitch+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UISwitch {
    /// 切换开关状态
    /// - Parameter animated: 是否启用动画，默认为`true`，表示带动画效果
    /// - Returns: `Self`，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// mySwitch.dd.toggle()
    /// ```
    @discardableResult
    func toggle(_ animated: Bool = true) -> Self {
        self.base.setOn(!self.base.isOn, animated: animated)
        return self
    }

    /// 设置开关状态
    /// - Parameter isOn: 是否开启
    /// - Returns: `Self`，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// mySwitch.dd.isOn(true)
    /// ```
    @discardableResult
    func isOn(_ isOn: Bool) -> Self {
        self.base.isOn = isOn
        return self
    }

    /// 设置开启时颜色
    /// - Parameter color: 开启时的颜色
    /// - Returns: `Self`，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// mySwitch.onTintColor(.green)
    /// ```
    @discardableResult
    func onTintColor(_ color: UIColor?) -> Self {
        self.base.onTintColor = color
        return self
    }

    /// 设置关闭时颜色
    /// - Parameter color: 关闭时的颜色
    /// - Returns: `Self`，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// mySwitch.dd.tintColor(.red)
    /// ```
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        self.base.tintColor = color
        return self
    }

    /// 设置滑块的颜色
    /// - Parameter color: 滑块的颜色
    /// - Returns: `Self`，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// mySwitch.dd.thumbTintColor(.blue)
    /// ```
    @discardableResult
    func thumbTintColor(_ color: UIColor?) -> Self {
        self.base.thumbTintColor = color
        return self
    }
}
