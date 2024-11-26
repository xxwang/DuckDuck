//
//  CATransition+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import QuartzCore

// MARK: - 链式语法
public extension DDExtension where Base: CATransition {
    /// 设置过渡动画的类型
    /// - Parameter type: 过渡动画类型
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let transition = CATransition().dd.type(.fade)  // 设置过渡动画为淡入淡出
    /// ```
    @discardableResult
    func type(_ type: CATransitionType) -> Self {
        self.base.type = type
        return self
    }

    /// 设置过渡动画的方向
    /// - Parameter subtype: 过渡动画方向
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let transition = CATransition().dd.subtype(.fromLeft)  // 设置过渡动画方向为从左边进入
    /// ```
    @discardableResult
    func subtype(_ subtype: CATransitionSubtype) -> Self {
        self.base.subtype = subtype
        return self
    }
}
