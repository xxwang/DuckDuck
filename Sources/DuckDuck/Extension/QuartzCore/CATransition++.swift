//
//  CATransition++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import QuartzCore

public extension CATransition {
    /// 设置过渡动画的类型
    /// - Parameter type: 过渡动画类型
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let transition = CATransition().dd_type(.fade)  // 设置过渡动画为淡入淡出
    /// ```
    @discardableResult
    func dd_type(_ type: CATransitionType) -> Self {
        self.type = type
        return self
    }

    /// 设置过渡动画的方向
    /// - Parameter subtype: 过渡动画方向
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let transition = CATransition().dd_subtype(.fromLeft)  // 设置过渡动画方向为从左边进入
    /// ```
    @discardableResult
    func dd_subtype(_ subtype: CATransitionSubtype) -> Self {
        self.subtype = subtype
        return self
    }
}
