//
//  CAKeyframeAnimation+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import QuartzCore

// MARK: - 链式语法
public extension DDExtension where Base: CAKeyframeAnimation {
    /// 设置动画的值数组
    /// - Parameter values: 要设置的动画值数组，可以包含任何类型的数据（如数值、颜色、路径等）
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAKeyframeAnimation().dd.values([0, 50, 100])  // 设置动画的值为 [0, 50, 100]
    /// ```
    @discardableResult
    func values(_ values: [Any]) -> Self {
        self.base.values = values
        return self
    }

    /// 设置动画的关键时间数组
    /// - Parameter keyTimes: 关键时间点数组，表示各个值出现的时刻，范围 `[0.0, 1.0]`，值越大表示越接近动画的结束时刻
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAKeyframeAnimation().dd.keyTimes([0, 0.5, 1])  // 设置关键时间为 [0, 0.5, 1]
    /// ```
    @discardableResult
    func keyTimes(_ keyTimes: [NSNumber]) -> Self {
        self.base.keyTimes = keyTimes
        return self
    }

    /// 设置动画的计算模式
    /// - Parameter mode: 动画的计算模式，决定了关键帧之间的插值方式
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAKeyframeAnimation().dd.calculationMode(.cubic)  // 设置计算模式为 cubic
    /// ```
    @discardableResult
    func calculationMode(_ mode: CAAnimationCalculationMode) -> Self {
        self.base.calculationMode = mode
        return self
    }
}
