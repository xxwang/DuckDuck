//
//  CAAnimationGroup+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import QuartzCore

// MARK: - 链式语法
public extension DDExtension where Base: CAAnimationGroup {
    /// 设置动画组中的动画数组
    /// - Parameter animations: 要添加到动画组中的动画数组
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animationGroup = CAAnimationGroup().dd.animations([rotationAnimation, scaleAnimation])
    /// ```
    @discardableResult
    func animations(_ animations: [CAAnimation]) -> Self {
        self.base.animations = animations
        return self
    }
}
