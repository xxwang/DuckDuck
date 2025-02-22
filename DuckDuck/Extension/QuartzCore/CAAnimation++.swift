import QuartzCore

public extension CAAnimation {
    /// 设置过渡动画的速度
    /// - Parameter speed: 动画速度
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let transition = CAAnimation().dd_speed(2.0)  // 设置过渡动画的速度为 2.0
    /// ```
    @discardableResult
    func dd_speed(_ speed: Float) -> Self {
        self.speed = speed
        return self
    }

    /// 设置动画的持续时间
    /// - Parameter duration: 动画时长
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd_duration(1.0)  // 设置动画时长为 1.0 秒
    /// ```
    @discardableResult
    func dd_duration(_ duration: TimeInterval) -> Self {
        self.duration = duration
        return self
    }

    /// 设置动画的重复时间间隔
    /// - Parameter repeatDuration: 动画组重复的时间间隔
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animationGroup = CAAnimation().dd_repeatDuration(5.0)  // 设置动画组重复持续 5 秒
    /// ```
    @discardableResult
    func dd_repeatDuration(_ repeatDuration: TimeInterval) -> Self {
        self.repeatDuration = repeatDuration
        return self
    }

    /// 设置动画的开始时间
    /// - Parameter beginTime: 动画开始时间
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd_beginTime(0.5)  // 设置动画开始时间为 0.5 秒
    /// ```
    @discardableResult
    func dd_beginTime(_ beginTime: TimeInterval) -> Self {
        self.beginTime = beginTime
        return self
    }

    /// 设置动画的时间偏移量
    /// - Parameter timeOffset: 时间偏移量，单位为秒
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd_timeOffset(1.0)  // 设置动画的时间偏移为 1.0 秒
    /// ```
    @discardableResult
    func dd_timeOffset(_ timeOffset: CFTimeInterval) -> Self {
        self.timeOffset = timeOffset
        return self
    }

    /// 设置动画的延迟时间
    /// - Parameter delay: 延迟时间
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd_delay(0.3)  // 设置动画延迟时间为 0.3 秒
    /// ```
    @discardableResult
    func dd_delay(_ delay: TimeInterval) -> Self {
        self.beginTime = CACurrentMediaTime() + delay
        return self
    }

    /// 设置动画的重复次数
    /// - Parameter repeatCount: 动画的重复次数
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd_repeatCount(3)  // 设置动画重复 3 次
    /// ```
    @discardableResult
    func dd_repeatCount(_ repeatCount: Float) -> Self {
        self.repeatCount = repeatCount
        return self
    }

    /// 设置动画是否反转
    /// - Parameter autoreverses: 是否自动反转
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd_autoreverses(true)  // 设置动画自动反转
    /// ```
    @discardableResult
    func dd_autoreverses(_ autoreverses: Bool) -> Self {
        self.autoreverses = autoreverses
        return self
    }

    /// 设置动画的时间函数（Timing Function）
    /// - Parameter timingFunction: 动画时间函数
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd_timingFunction(.easeInOut)  // 设置动画的时间函数为 easeInOut
    /// ```
    @discardableResult
    func dd_timingFunction(_ timingFunction: CAMediaTimingFunctionName) -> Self {
        self.timingFunction = CAMediaTimingFunction(name: timingFunction)
        return self
    }

    /// 设置动画的填充模式
    /// - Parameter fillMode: 填充模式
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd_fillMode(.forwards)  // 设置动画填充模式为 forwards
    /// ```
    @discardableResult
    func dd_fillMode(_ fillMode: CAMediaTimingFillMode) -> Self {
        self.fillMode = fillMode
        return self
    }

    /// 设置动画的完成处理
    /// - Parameter completion: 动画完成时的回调闭包
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd_completion { finished in
    ///     print("Animation finished: \(finished)")
    /// }
    /// ```
    @discardableResult
    func dd_completion(_ completion: @escaping (Bool) -> Void) -> Self {
        let animationCompletion = completion
        CATransaction.setCompletionBlock {
            animationCompletion(true)
        }
        return self
    }
}
