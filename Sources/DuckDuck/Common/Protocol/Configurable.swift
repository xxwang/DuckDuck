//
//  Configurable.swift
//  DuckDuck
//
//  Created by xxwang on 15/11/2024.
//

import UIKit

/// 为便捷地配置和创建对象提供扩展。
public protocol Configurable {}

/// 为 Configurable 提供默认实现
public extension Configurable where Self: NSObject {
    /// 配置当前对象的属性。
    /// - Parameter configuration: 配置闭包，提供当前对象供修改。
    /// - Returns: 配置完成的当前对象。
    ///
    /// - Example:
    /// ```swift
    /// let label = UILabel().dd_configure {
    ///     $0.text = "Hello"
    ///     $0.textColor = .blue
    /// }
    /// ```
    @discardableResult
    func dd_configure(configuration: (_ object: Self) -> Void) -> Self {
        configuration(self)
        return self
    }

    /// 创建并配置一个对象。
    /// - Parameter configuration: 配置闭包，提供新对象供修改。
    /// - Returns: 配置完成的对象。
    ///
    /// - Example:
    /// ```swift
    /// let button = UILabel.dd_build {
    ///     $0.text = "Hello"
    ///     $0.textColor = .blue
    /// }
    /// ```
    @discardableResult
    static func dd_build(configuration: (_ object: Self) -> Void) -> Self {
        let object = Self()
        configuration(object)
        return object
    }
}

extension UIView: Configurable {}
extension UIViewController: Configurable {}
