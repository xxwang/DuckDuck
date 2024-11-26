//
//  UINavigationController+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UINavigationController {
    /// 设置导航控制器代理
    /// - Parameter delegate: 导航控制器的代理
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationController?.dd.delegate(self)
    /// ```
    @discardableResult
    func delegate(_ delegate: UINavigationControllerDelegate) -> Self {
        self.base.delegate = delegate
        return self
    }

    /// 设置导航栏是否隐藏
    /// - Parameters:
    ///   - hidden: 是否隐藏导航栏，`true` 表示隐藏，`false` 表示显示
    ///   - animated: 是否使用动画，默认是 `false`
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationController?.dd.setNavigationBarHidden(true, animated: true)
    /// ```
    @discardableResult
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        self.base.setNavigationBarHidden(hidden, animated: animated)
        return self
    }
}
