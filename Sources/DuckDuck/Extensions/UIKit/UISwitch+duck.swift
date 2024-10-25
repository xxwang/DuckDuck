//
//  UISwitch+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - 链式语法
public extension UISwitch {
    /// 切换开关状态
    /// - Parameter animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dd_toggle(_ animated: Bool = true) -> Self {
        self.setOn(!self.isOn, animated: animated)
        return self
    }

        /// 设置开关状态
        /// - Parameter isOn: 是否开启
        /// - Returns: `Self`
        @discardableResult
        func dd_isOn(_ isOn: Bool = true) -> Self {
            self.isOn = isOn
            return self
        }

    
    /// 打开时颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_openTintColor(_ color: UIColor?) -> Self {
        self.onTintColor = color
        return self
    }

    /// 关闭时颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_closeTintColor(_ color: UIColor?) -> Self {
        self.tintColor = color
        return self
    }

    /// 开关滑块的颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_thumbTintColor(_ color: UIColor?) -> Self {
        self.thumbTintColor = color
        return self
    }
}
