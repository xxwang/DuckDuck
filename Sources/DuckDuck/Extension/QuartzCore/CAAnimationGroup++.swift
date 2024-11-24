//
//  CAAnimationGroup++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 23/11/2024.
//

import QuartzCore

public extension CAAnimationGroup {
    /// 设置动画组中的动画数组
    /// - Parameter animations: 要添加到动画组中的动画数组
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animationGroup = CAAnimationGroup().dd_animations([rotationAnimation, scaleAnimation])
    /// ```
    @discardableResult
    func dd_animations(_ animations: [CAAnimation]) -> Self {
        self.animations = animations
        return self
    }
}
