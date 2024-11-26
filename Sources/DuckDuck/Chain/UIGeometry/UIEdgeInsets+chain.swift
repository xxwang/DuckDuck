//
//  UIEdgeInsets+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import UIKit

extension UIEdgeInsets: DDExtensionable {}

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base == UIEdgeInsets {
    /// 基于当前值和顶部偏移创建新的`UIEdgeInsets`
    /// - Parameter top: 顶部的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let inset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    /// let newInset = inset.dd.insetBy(top: 5)
    /// // 结果: UIEdgeInsets(top: 15, left: 5, bottom: 5, right: 5)
    /// ```
    @discardableResult
    func insetBy(top: CGFloat) -> Self {
        self.base = UIEdgeInsets(top: self.base.top + top, left: self.base.left, bottom: self.base.bottom, right: self.base.right)
        return self
    }

    /// 基于当前值和左侧偏移创建新的`UIEdgeInsets`
    /// - Parameter left: 左侧的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let newInset = inset.dd.insetBy(left: 10)
    /// // 结果: UIEdgeInsets(top: 10, left: 15, bottom: 5, right: 5)
    /// ```
    @discardableResult
    func insetBy(left: CGFloat) -> Self {
        self.base = UIEdgeInsets(top: self.base.top, left: self.base.left + left, bottom: self.base.bottom, right: self.base.right)
        return self
    }

    /// 基于当前值和底部偏移创建新的`UIEdgeInsets`
    /// - Parameter bottom: 底部的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let newInset = inset.dd.insetBy(bottom: 10)
    /// // 结果: UIEdgeInsets(top: 10, left: 5, bottom: 15, right: 5)
    /// ```
    @discardableResult
    func insetBy(bottom: CGFloat) -> Self {
        self.base = UIEdgeInsets(top: self.base.top, left: self.base.left, bottom: self.base.bottom + bottom, right: self.base.right)
        return self
    }

    /// 基于当前值和右侧偏移创建新的`UIEdgeInsets`
    /// - Parameter right: 右侧的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let newInset = inset.dd.insetBy(right: 15)
    /// // 结果: UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 20)
    /// ```
    @discardableResult
    func insetBy(right: CGFloat) -> Self {
        self.base = UIEdgeInsets(top: self.base.top, left: self.base.left, bottom: self.base.bottom, right: self.base.right + right)
        return self
    }

    /// 基于当前值和水平值等分并应用于左右偏移，创建新的`UIEdgeInsets`
    /// - Parameter horizontal: 要应用于左侧和右侧的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let newInset = inset.dd.insetBy(horizontal: 20)
    /// // 结果: UIEdgeInsets(top: 10, left: 15, bottom: 5, right: 25)
    /// ```
    @discardableResult
    func insetBy(horizontal: CGFloat) -> Self {
        self.base = UIEdgeInsets(top: self.base.top, left: self.base.left + horizontal / 2, bottom: self.base.bottom, right: self.base.right + horizontal / 2)
        return self
    }

    /// 基于当前值和垂直值等分并应用于顶部和底部，创建新的`UIEdgeInsets`
    /// - Parameter vertical: 要应用于顶部和底部的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let newInset = inset.dd.insetBy(vertical: 30)
    /// // 结果: UIEdgeInsets(top: 25, left: 5, bottom: 25, right: 5)
    /// ```
    @discardableResult
    func insetBy(vertical: CGFloat) -> Self {
        self.base = UIEdgeInsets(top: self.base.top + vertical / 2, left: self.base.left, bottom: self.base.bottom + vertical / 2, right: self.base.right)
        return self
    }
}
