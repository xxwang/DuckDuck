//
//  CABasicAnimation++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import QuartzCore

// MARK: - 链式语法
public extension CABasicAnimation {
    /// 设置动画的起始值
    /// - Parameter value: 动画的起始值，可以是任何类型（如数值、UIColor、CGPoint 等）
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CABasicAnimation().dd_fromValue(0)  // 设置动画的起始值为 0
    /// ```
    @discardableResult
    func dd_fromValue(_ value: Any?) -> Self {
        self.fromValue = value
        return self
    }

    /// 设置动画的结束值
    /// - Parameter value: 动画的结束值，可以是任何类型（如数值、UIColor、CGPoint 等）
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CABasicAnimation().dd_toValue(100)  // 设置动画的结束值为 100
    /// ```
    @discardableResult
    func dd_toValue(_ value: Any?) -> Self {
        self.toValue = value
        return self
    }

    /// 设置动画是否在完成时移除
    /// - Parameter removedOnCompletion: 动画完成时是否移除
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CABasicAnimation().dd_removedOnCompletion(true)  // 设置动画完成时移除
    /// ```
    @discardableResult
    func dd_removedOnCompletion(_ removedOnCompletion: Bool) -> Self {
        self.isRemovedOnCompletion = removedOnCompletion
        return self
    }

    /// 设置动画的自定义键值对
    /// - Parameter keyPath: 键值路径
    /// - Parameter value: 键值对应的值
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CABasicAnimation().dd_setValue(1, forKeyPath: "transform.scale")  // 设置自定义值
    /// ```
    @discardableResult
    func dd_setValue(_ value: Any?, forKeyPath keyPath: String) -> Self {
        self.setValue(value, forKeyPath: keyPath)
        return self
    }
}
