//
//  UISwitch++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - Creatable
public extension UISwitch {
    /// 纯净的创建方法
    static func create<T: UISwitch>(_ aClass: T.Type = UISwitch.self) -> T {
        let switchButton = UISwitch()
        return switchButton as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UISwitch>(_ aClass: T.Type = UISwitch.self) -> T {
        let switchButton: UISwitch = self.create()
        return switchButton as! T
    }
}

// MARK: - 链式语法
public extension UISwitch {
    /// 切换开关状态
    /// - Parameter animated: 是否启用动画，默认为`true`，表示带动画效果
    /// - Returns: `Self`，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// mySwitch.dd_toggle()
    /// ```
    @discardableResult
    func dd_toggle(_ animated: Bool = true) -> Self {
        self.setOn(!self.isOn, animated: animated)
        return self
    }

    /// 设置开关状态
    /// - Parameter isOn: 是否开启
    /// - Returns: `Self`，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// mySwitch.dd_isOn(true)
    /// ```
    @discardableResult
    func dd_isOn(_ isOn: Bool) -> Self {
        self.isOn = isOn
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
    func dd_onTintColor(_ color: UIColor?) -> Self {
        self.onTintColor = color
        return self
    }

    /// 设置关闭时颜色
    /// - Parameter color: 关闭时的颜色
    /// - Returns: `Self`，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// mySwitch.dd_tintColor(.red)
    /// ```
    @discardableResult
    override func dd_tintColor(_ color: UIColor?) -> Self {
        self.tintColor = color
        return self
    }

    /// 设置滑块的颜色
    /// - Parameter color: 滑块的颜色
    /// - Returns: `Self`，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// mySwitch.dd_thumbTintColor(.blue)
    /// ```
    @discardableResult
    func dd_thumbTintColor(_ color: UIColor?) -> Self {
        self.thumbTintColor = color
        return self
    }
}
