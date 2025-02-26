import QuartzCore

extension CAAnimation: DDExtended {}

// MARK: - 链式语法
public extension DDExtension where Base: CAAnimation {
    /// 设置过渡动画的速度
    /// - Parameter speed: 动画速度
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let transition = CAAnimation().dd.speed(2.0)  // 设置过渡动画的速度为 2.0
    /// ```
    @discardableResult
    func speed(_ speed: Float) -> Self {
        self.base.speed = speed
        return self
    }

    /// 设置动画的持续时间
    /// - Parameter duration: 动画时长
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd.duration(1.0)  // 设置动画时长为 1.0 秒
    /// ```
    @discardableResult
    func duration(_ duration: TimeInterval) -> Self {
        self.base.duration = duration
        return self
    }

    /// 设置动画的重复时间间隔
    /// - Parameter repeatDuration: 动画组重复的时间间隔
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animationGroup = CAAnimation().dd.repeatDuration(5.0)  // 设置动画组重复持续 5 秒
    /// ```
    @discardableResult
    func repeatDuration(_ repeatDuration: TimeInterval) -> Self {
        self.base.repeatDuration = repeatDuration
        return self
    }

    /// 设置动画的开始时间
    /// - Parameter beginTime: 动画开始时间
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd.beginTime(0.5)  // 设置动画开始时间为 0.5 秒
    /// ```
    @discardableResult
    func beginTime(_ beginTime: TimeInterval) -> Self {
        self.base.beginTime = beginTime
        return self
    }

    /// 设置动画的时间偏移量
    /// - Parameter timeOffset: 时间偏移量，单位为秒
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd.timeOffset(1.0)  // 设置动画的时间偏移为 1.0 秒
    /// ```
    @discardableResult
    func timeOffset(_ timeOffset: CFTimeInterval) -> Self {
        self.base.timeOffset = timeOffset
        return self
    }

    /// 设置动画的延迟时间
    /// - Parameter delay: 延迟时间
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd.delay(0.3)  // 设置动画延迟时间为 0.3 秒
    /// ```
    @discardableResult
    func delay(_ delay: TimeInterval) -> Self {
        self.base.beginTime = CACurrentMediaTime() + delay
        return self
    }

    /// 设置动画的重复次数
    /// - Parameter repeatCount: 动画的重复次数
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd.repeatCount(3)  // 设置动画重复 3 次
    /// ```
    @discardableResult
    func repeatCount(_ repeatCount: Float) -> Self {
        self.base.repeatCount = repeatCount
        return self
    }

    /// 设置动画是否反转
    /// - Parameter autoreverses: 是否自动反转
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd.autoreverses(true)  // 设置动画自动反转
    /// ```
    @discardableResult
    func autoreverses(_ autoreverses: Bool) -> Self {
        self.base.autoreverses = autoreverses
        return self
    }

    /// 设置动画的时间函数（Timing Function）
    /// - Parameter timingFunction: 动画时间函数
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd.timingFunction(.easeInOut)  // 设置动画的时间函数为 easeInOut
    /// ```
    @discardableResult
    func timingFunction(_ timingFunction: CAMediaTimingFunctionName) -> Self {
        self.base.timingFunction = CAMediaTimingFunction(name: timingFunction)
        return self
    }

    /// 设置动画的填充模式
    /// - Parameter fillMode: 填充模式
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd.fillMode(.forwards)  // 设置动画填充模式为 forwards
    /// ```
    @discardableResult
    func fillMode(_ fillMode: CAMediaTimingFillMode) -> Self {
        self.base.fillMode = fillMode
        return self
    }

    /// 设置动画的完成处理
    /// - Parameter completion: 动画完成时的回调闭包
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let animation = CAAnimation().dd.completion { finished in
    ///     print("Animation finished: \(finished)")
    /// }
    /// ```
    @discardableResult
    func completion(_ completion: @escaping (Bool) -> Void) -> Self {
        let animationCompletion = completion
        CATransaction.setCompletionBlock {
            animationCompletion(true)
        }
        return self
    }
}
