import QuartzCore
import UIKit

// MARK: - 方法
public extension CALayer {
    /// 将图层内容转为颜色 (`UIColor`)
    /// - Returns: 返回转换的颜色，如果失败则返回 `nil`
    ///
    /// **示例**:
    /// ```swift
    /// let color = myLayer.dd_toUIColor()
    /// ```
    func dd_toUIColor() -> UIColor? {
        if let image = self.dd_toUIImage() {
            return UIColor(patternImage: image)
        }
        return nil
    }

    /// 将 `CALayer` 转换为 `UIImage?`
    /// - Parameters:
    ///   - scale: 缩放比例，默认值为 `1.0`，通常与设备的屏幕密度相匹配。
    /// - Returns: 返回转换后的 `UIImage`，如果失败则返回 `nil`
    ///
    /// **示例**:
    /// ```swift
    /// let image = myLayer.dd_toUIImage(scale: 2.0)
    /// ```
    func dd_toUIImage(scale: CGFloat = 1.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, scale)
        defer { UIGraphicsEndImageContext() }
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        self.render(in: ctx)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - CABasicAnimation
public extension CALayer {
    /// `BasicAnimation` 移动到指定`CGPoint`
    /// - Parameters:
    ///   - point: 要移动到的`Point`
    ///   - duration: 动画持续时长
    ///   - delay: 延时
    ///   - repeatCount: 重复动画次数
    ///   - removedOnCompletion: 动画完成后是否移除动画
    ///   - timingFunction: 动画节奏控制
    /// - Example:
    /// ```swift
    /// layer.dd_basicAnimationMovePoint(CGPoint(x: 100, y: 100), duration: 2.0)
    /// ```
    func dd_basicAnimationMovePoint(to point: CGPoint,
                                    duration: TimeInterval,
                                    delay: TimeInterval = 0,
                                    repeatCount: Float = 1,
                                    removedOnCompletion: Bool = false,
                                    timingFunction: CAMediaTimingFunctionName = .default)
    {
        self.dd_applyBasicAnimation(
            keyPath: "position",
            startValue: self.position,
            endValue: point,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// `BasicAnimation` 水平 (X 轴) 移动动画
    /// - Parameters:
    ///   - moveValue: 移动到的 `x` 值
    ///   - duration: 动画持续时长
    ///   - delay: 延时
    ///   - repeatCount: 重复动画次数
    ///   - removedOnCompletion: 动画完成后是否移除动画
    ///   - timingFunction: 动画节奏控制
    /// - Example:
    /// ```swift
    /// layer.dd_basicAnimationMoveX(to: 200, duration: 1.5)
    /// ```
    func dd_basicAnimationMoveX(to moveValue: Any?,
                                duration: TimeInterval = 2.0,
                                delay: TimeInterval = 0,
                                repeatCount: Float = 1,
                                removedOnCompletion: Bool = false,
                                timingFunction: CAMediaTimingFunctionName = .default)
    {
        self.dd_applyBasicAnimation(
            keyPath: "transform.translation.x",
            startValue: self.position,
            endValue: moveValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// `BasicAnimation` 垂直 (Y 轴) 移动动画
    /// - Parameters:
    ///   - moveValue: 移动到的 `y` 值
    ///   - duration: 动画持续时长
    ///   - delay: 延时
    ///   - repeatCount: 重复动画次数
    ///   - removedOnCompletion: 动画完成后是否移除动画
    ///   - timingFunction: 动画节奏控制
    /// - Example:
    /// ```swift
    /// layer.dd_basicAnimationMoveY(to: 300, duration: 2.0)
    /// ```
    func dd_basicAnimationMoveY(to moveValue: Any?,
                                duration: TimeInterval = 2.0,
                                delay: TimeInterval = 0,
                                repeatCount: Float = 1,
                                removedOnCompletion: Bool = false,
                                timingFunction: CAMediaTimingFunctionName = .default)
    {
        self.dd_applyBasicAnimation(
            keyPath: "transform.translation.y",
            startValue: self.position,
            endValue: moveValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// `BasicAnimation` 圆角变化动画
    /// - Parameters:
    ///   - cornerRadius: 圆角大小
    ///   - duration: 动画持续时长
    ///   - delay: 延时
    ///   - repeatCount: 重复动画次数
    ///   - removedOnCompletion: 动画完成后是否移除动画
    ///   - timingFunction: 动画节奏控制
    /// - Example:
    /// ```swift
    /// layer.dd_basicAnimationCornerRadius(to: 20, duration: 1.0)
    /// ```
    func dd_basicAnimationCornerRadius(to cornerRadius: Any?,
                                       duration: TimeInterval = 2.0,
                                       delay: TimeInterval = 0,
                                       repeatCount: Float = 1,
                                       removedOnCompletion: Bool = false,
                                       timingFunction: CAMediaTimingFunctionName = .default)
    {
        self.dd_applyBasicAnimation(
            keyPath: "cornerRadius",
            startValue: self.position,
            endValue: cornerRadius,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// `BasicAnimation` 缩放动画
    /// - Parameters:
    ///   - scaleValue: 缩放值
    ///   - duration: 动画持续时长
    ///   - delay: 延时
    ///   - repeatCount: 重复动画次数
    ///   - removedOnCompletion: 动画完成后是否移除动画
    ///   - timingFunction: 动画节奏控制
    /// - Example:
    /// ```swift
    /// layer.dd_basicAnimationScale(to: 1.5, duration: 2.0)
    /// ```
    func dd_basicAnimationScale(to scaleValue: Any?,
                                duration: TimeInterval = 2.0,
                                delay: TimeInterval = 0,
                                repeatCount: Float = 1,
                                removedOnCompletion: Bool = true,
                                timingFunction: CAMediaTimingFunctionName = .default)
    {
        self.dd_applyBasicAnimation(
            keyPath: "transform.scale",
            startValue: 1,
            endValue: scaleValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// `BasicAnimation` 旋转动画
    /// - Parameters:
    ///   - rotation: 旋转的角度
    ///   - duration: 动画持续时长
    ///   - delay: 延时
    ///   - repeatCount: 重复动画次数
    ///   - removedOnCompletion: 动画完成后是否移除动画
    ///   - timingFunction: 动画节奏控制
    /// - Example:
    /// ```swift
    /// layer.dd_basicAnimationRotation(to: CGFloat.pi, duration: 3.0)
    /// ```
    func dd_basicAnimationRotation(to rotation: Any?,
                                   duration: TimeInterval = 2.0,
                                   delay: TimeInterval = 0,
                                   repeatCount: Float = 1,
                                   removedOnCompletion: Bool = true,
                                   timingFunction: CAMediaTimingFunctionName = .default)
    {
        self.dd_applyBasicAnimation(
            keyPath: "transform.rotation",
            startValue: nil,
            endValue: rotation,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 基本动画应用方法
    /// - Parameters:
    ///   - keyPath: 动画的类型，表示动画作用的属性路径，例如 `"position"` 或 `"transform.scale"`
    ///   - startValue: 动画的起始值，可以是任何类型，取决于动画的属性。例如，`CGPoint` 或 `CGFloat`
    ///   - endValue: 动画的结束值，类型与 `startValue` 相同，表示动画最终的目标状态
    ///   - duration: 动画持续时间，默认 2.0 秒
    ///   - delay: 动画开始前的延时，默认 0 秒
    ///   - repeatCount: 动画重复次数，默认 1 次，设置为 `Float.infinity` 可实现无限重复
    ///   - removedOnCompletion: 动画完成后是否从图层中移除，默认为 `false`，即保留动画状态
    ///   - timingFunction: 动画节奏控制函数，决定动画的加速与减速模式，默认为 `.default`
    ///
    /// - Example:
    /// ```swift
    /// layer.dd_applyBasicAnimation(keyPath: "position", startValue: CGPoint(x: 0, y: 0), endValue: CGPoint(x: 100, y: 100), duration: 2.0)
    /// ```
    func dd_applyBasicAnimation(keyPath: String,
                                startValue: Any?,
                                endValue: Any?,
                                duration: TimeInterval = 2.0,
                                delay: TimeInterval = 0,
                                repeatCount: Float = 1,
                                removedOnCompletion: Bool = false,
                                timingFunction: CAMediaTimingFunctionName = .default)
    {
        // 创建 CABasicAnimation 实例
        let basicAnimation = CABasicAnimation()

        // 设置动画的开始时间，允许延时
        basicAnimation.beginTime = CACurrentMediaTime() + delay

        // 设置动画的属性路径（例如位置、缩放等）
        basicAnimation.keyPath = keyPath

        // 设置动画的起始值
        basicAnimation.fromValue = startValue

        // 设置动画的结束值
        basicAnimation.toValue = endValue

        // 设置动画的持续时间
        basicAnimation.duration = duration

        // 设置动画重复次数，默认为 1 次
        basicAnimation.repeatCount = repeatCount

        // 设置动画完成后是否移除动画
        basicAnimation.isRemovedOnCompletion = removedOnCompletion

        // 设置动画的填充模式，使图层保持动画结束时的状态
        basicAnimation.fillMode = .forwards

        // 设置动画的节奏函数，用于控制动画的时间曲线
        basicAnimation.timingFunction = CAMediaTimingFunction(name: timingFunction)

        // 将动画添加到当前图层
        self.add(basicAnimation, forKey: nil)
    }
}

// MARK: - CAKeyframeAnimation
public extension CALayer {
    /// 添加位置动画(通过指定的 `CGPoint` 数组移动)
    /// - Parameters:
    ///   - values: 位置数组，包含多个 `CGPoint` 值
    ///   - keyTimes: 每个位置值对应的时间点数组
    ///   - duration: 动画持续时间，默认 2 秒
    ///   - delay: 动画延迟时间，默认 0 秒
    ///   - repeatCount: 动画重复次数，默认 1 次
    ///   - removedOnCompletion: 动画完成后是否移除，默认 `false`
    ///   - timingFunction: 动画节奏控制函数，默认 `.default`
    /// - Example:
    /// ```swift
    /// layer.dd_addKeyframeAnimationPosition(
    ///     values: [CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 100)],
    ///     keyTimes: [0, 1],
    ///     duration: 2.0
    /// )
    /// ```
    func dd_addKeyframeAnimationPosition(_ values: [Any],
                                         keyTimes: [NSNumber]?,
                                         duration: TimeInterval = 2.0,
                                         delay: TimeInterval = 0,
                                         repeatCount: Float = 1,
                                         removedOnCompletion: Bool = false,
                                         timingFunction: CAMediaTimingFunctionName = .default)
    {
        self.dd_applyKeyframeAnimation(
            keyPath: "position",
            values: values,
            keyTimes: keyTimes,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: nil,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 添加抖动动画(通过指定的旋转角度数组)
    /// - Parameters:
    ///   - values: 旋转角度数组
    ///   - keyTimes: 每个旋转值对应的时间点数组
    ///   - duration: 动画持续时间，默认 1 秒
    ///   - delay: 动画延迟时间，默认 0 秒
    ///   - repeatCount: 动画重复次数，默认 1 次
    ///   - removedOnCompletion: 动画完成后是否移除，默认 `true`
    ///   - timingFunction: 动画节奏控制函数，默认 `.default`
    /// - Example:
    /// ```swift
    /// layer.dd_addKeyframeAnimationRotation(
    ///     values: [-5.dd_radians(), 5.dd_radians(), -5.dd_toRadians()],
    ///     keyTimes: [0, 1],
    ///     duration: 1.0
    /// )
    /// ```
    func dd_addKeyframeAnimationRotation(_ values: [Any] = [
        -5.dd_toRadians(),
        5.dd_toRadians(),
        -5.dd_toRadians(),
    ],
    keyTimes: [NSNumber]?,
    duration: TimeInterval = 1.0,
    delay: TimeInterval = 0,
    repeatCount: Float = 1,
    removedOnCompletion: Bool = true,
    timingFunction: CAMediaTimingFunctionName = .default) {
        self.dd_applyKeyframeAnimation(
            keyPath: "transform.rotation",
            values: values,
            keyTimes: keyTimes,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: nil,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 添加路径动画(根据 `CGPath` 路径移动)
    /// - Parameters:
    ///   - path: 动画路径，使用 `CGPath`
    ///   - duration: 动画持续时间，默认 2 秒
    ///   - delay: 动画延迟时间，默认 0 秒
    ///   - repeatCount: 动画重复次数，默认 1 次
    ///   - removedOnCompletion: 动画完成后是否移除，默认 `false`
    ///   - timingFunction: 动画节奏控制函数，默认 `.default`
    /// - Example:
    /// ```swift
    /// let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100)).cgPath
    /// layer.dd_addKeyframeAnimationPositionBezierPath(
    ///     path: path,
    ///     duration: 2.0
    /// )
    /// ```
    func dd_addKeyframeAnimationPositionBezierPath(_ path: CGPath? = nil,
                                                   duration: TimeInterval = 2.0,
                                                   delay: TimeInterval = 0,
                                                   repeatCount: Float = 1,
                                                   removedOnCompletion: Bool = false,
                                                   timingFunction: CAMediaTimingFunctionName = .default)
    {
        self.dd_applyKeyframeAnimation(
            keyPath: "position",
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: path,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 通用 `CAKeyframeAnimation` 动画方法
    /// - Parameters:
    ///   - keyPath: 动画类型，例如 "position", "transform.scale", "opacity" 等
    ///   - values: 动画的值数组，包含每个时间点的动画值
    ///   - keyTimes: 每个动画值对应的时间点数组，指定每个值的时间位置
    ///   - duration: 动画的总时长，默认值为 2 秒
    ///   - delay: 动画延迟的时间，默认值为 0 秒
    ///   - repeatCount: 动画重复次数，默认值为 1 次
    ///   - path: 动画路径，仅适用于位置动画等路径动画
    ///   - removedOnCompletion: 动画完成后是否移除，默认 `false` (保留动画)
    ///   - timingFunction: 动画节奏控制函数，默认值为 `.default`
    /// - Example:
    /// ```swift
    /// layer.dd_applyKeyframeAnimation(
    ///     keyPath: "position",
    ///     values: [CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 100)],
    ///     keyTimes: [0, 1],
    ///     duration: 2.0,
    ///     repeatCount: 1
    /// )
    /// ```
    func dd_applyKeyframeAnimation(keyPath: String,
                                   values: [Any]? = nil,
                                   keyTimes: [NSNumber]? = nil,
                                   duration: TimeInterval = 2.0,
                                   delay: TimeInterval = 0,
                                   repeatCount: Float = 1,
                                   path: CGPath? = nil,
                                   removedOnCompletion: Bool = false,
                                   timingFunction: CAMediaTimingFunctionName = .default)
    {
        // 创建 CAKeyframeAnimation 实例
        let keyframeAnimation = CAKeyframeAnimation(keyPath: keyPath)

        // 设置动画时长
        keyframeAnimation.duration = duration

        // 设置动画开始时间
        keyframeAnimation.beginTime = CACurrentMediaTime() + delay

        // 设置动画完成后的行为，是否移除动画
        keyframeAnimation.isRemovedOnCompletion = removedOnCompletion

        // 设置动画填充模式，控制动画结束后是否保留
        keyframeAnimation.fillMode = .forwards

        // 设置动画重复次数
        keyframeAnimation.repeatCount = repeatCount

        // 设置旋转模式，适用于旋转动画
        keyframeAnimation.rotationMode = .rotateAuto

        // 设置动画节奏控制函数，控制动画的速度变化
        keyframeAnimation.timingFunction = CAMediaTimingFunction(name: timingFunction)

        // 设置动画值，指定每个关键帧的动画值
        if let values {
            keyframeAnimation.values = values
        }

        // 设置时间点，控制每个值的时间位置
        if let keyTimes {
            keyframeAnimation.keyTimes = keyTimes
        }

        // 如果有路径动画，设置路径
        if let path {
            keyframeAnimation.path = path
            keyframeAnimation.calculationMode = .cubicPaced // 设置路径计算模式
        }

        // 添加动画到图层
        self.add(keyframeAnimation, forKey: nil)
    }
}

// MARK: - CASpringAnimation 弹簧动画
public extension CALayer {
    /// `CASpringAnimation` 动画，适用于 `bounds` 属性的变化
    /// - Parameters:
    ///   - toValue: 动画目标值(CGRect)，指定动画结束时的目标 `bounds` 值
    ///   - delay: 动画延迟时间，默认 0 秒
    ///   - mass: 质量，影响弹簧的惯性。质量越大，弹簧惯性越大，运动幅度越大
    ///   - stiffness: 刚度系数，影响弹簧的形变力。刚度系数越大，弹簧运动越快
    ///   - damping: 阻尼系数，控制弹簧停止的速度。阻尼系数越大，停止越快
    ///   - initialVelocity: 初速率，指定动画开始时的初始速度。若为 0，则忽略
    ///   - repeatCount: 动画重复次数，默认 1 次
    ///   - removedOnCompletion: 动画完成后是否移除，默认 `false`
    ///   - option: 动画节奏控制选项，默认 `.default`
    ///
    /// - Example Usage:
    /// ```swift
    /// layer.dd_addSpringAnimationBounds(
    ///     toValue: CGRect(x: 0, y: 0, width: 200, height: 200),
    ///     delay: 1.0,
    ///     mass: 12.0,
    ///     stiffness: 6000,
    ///     damping: 150.0,
    ///     initialVelocity: 6,
    ///     repeatCount: 2,
    ///     removedOnCompletion: true,
    ///     option: .easeInEaseOut
    /// )
    /// ```
    func dd_addSpringAnimationBounds(toValue: Any?,
                                     delay: TimeInterval = 0,
                                     mass: CGFloat = 10.0,
                                     stiffness: CGFloat = 5000,
                                     damping: CGFloat = 100.0,
                                     initialVelocity: CGFloat = 5,
                                     repeatCount: Float = 1,
                                     removedOnCompletion: Bool = false,
                                     option: CAMediaTimingFunctionName = .default)
    {
        // 调用基础的弹簧动画方法
        self.dd_applySpringAnimation(
            path: "bounds",
            toValue: toValue,
            delay: delay,
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// 通用的 `CASpringAnimation` 动画
    /// - Parameters:
    ///   - path: 动画类型，例如 "position", "transform.scale" 等
    ///   - toValue: 动画目标值，目标位置、缩放值等
    ///   - delay: 动画延迟时间，默认 0 秒
    ///   - mass: 质量，影响弹簧的惯性，质量越大，弹簧惯性越大，运动幅度越大
    ///   - stiffness: 刚度系数，影响弹簧形变的力，刚度系数越大，运动越快
    ///   - damping: 阻尼系数，控制弹簧停止的速度，阻尼系数越大，停止越快
    ///   - initialVelocity: 初速率，指定动画开始时的初始速度。若为 0，则忽略
    ///   - repeatCount: 动画重复次数，默认 1 次
    ///   - removedOnCompletion: 动画完成后是否移除，默认 `false`
    ///   - option: 动画节奏控制选项，默认 `.default`
    ///
    /// Example Usage:
    /// ```swift
    /// layer.dd_applySpringAnimation(
    ///     path: "position",
    ///     toValue: CGPoint(x: 100, y: 100),
    ///     delay: 0.5,
    ///     mass: 15.0,
    ///     stiffness: 4500,
    ///     damping: 80.0,
    ///     initialVelocity: 4,
    ///     repeatCount: 3,
    ///     removedOnCompletion: true,
    ///     option: .easeInOut
    /// )
    /// ```
    func dd_applySpringAnimation(path: String?,
                                 toValue: Any? = nil,
                                 delay: TimeInterval = 0,
                                 mass: CGFloat = 10.0,
                                 stiffness: CGFloat = 5000,
                                 damping: CGFloat = 100.0,
                                 initialVelocity: CGFloat = 5,
                                 repeatCount: Float = 1,
                                 removedOnCompletion: Bool = false,
                                 option: CAMediaTimingFunctionName = .default)
    {
        let springAnimation = CASpringAnimation(keyPath: path)

        // 设置动画参数
        springAnimation.beginTime = CACurrentMediaTime() + delay // 延时
        springAnimation.mass = mass // 质量
        springAnimation.stiffness = stiffness // 刚度系数
        springAnimation.damping = damping // 阻尼系数
        springAnimation.initialVelocity = initialVelocity // 初速率
        springAnimation.duration = springAnimation.settlingDuration // 设置弹簧的结算时间
        springAnimation.toValue = toValue // 动画目标值
        springAnimation.isRemovedOnCompletion = removedOnCompletion // 动画结束时是否移除
        springAnimation.fillMode = CAMediaTimingFillMode.forwards // 保持动画最终状态
        springAnimation.timingFunction = CAMediaTimingFunction(name: option) // 动画节奏控制函数

        // 添加动画到图层
        self.add(springAnimation, forKey: nil)
    }
}

// MARK: - CAAnimationGroup 动画组
public extension CALayer {
    /// `CAAnimationGroup` 动画，允许多个动画同时执行
    /// - Parameters:
    ///   - animations: 要执行的 `CAAnimation` 动画数组
    ///   - duration: 动画时长，默认 2 秒
    ///   - delay: 延时，默认 0 秒
    ///   - repeatCount: 动画重复次数，默认 1 次
    ///   - removedOnCompletion: 动画完成后是否移除，默认 `false`
    ///   - option: 动画节奏控制选项，默认 `.default`
    ///
    /// Example Usage:
    /// ```swift
    /// let positionAnimation = CABasicAnimation(keyPath: "position")
    /// positionAnimation.fromValue = CGPoint(x: 0, y: 0)
    /// positionAnimation.toValue = CGPoint(x: 200, y: 200)
    /// positionAnimation.duration = 1.0
    ///
    /// let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    /// scaleAnimation.fromValue = 1.0
    /// scaleAnimation.toValue = 2.0
    /// scaleAnimation.duration = 1.0
    ///
    /// layer.dd_applyAnimationGroup(
    ///     animations: [positionAnimation, scaleAnimation],
    ///     duration: 2.0,
    ///     delay: 0.5,
    ///     repeatCount: 3,
    ///     removedOnCompletion: true,
    ///     option: .easeInEaseOut
    /// )
    /// ```
    func dd_applyAnimationGroup(animations: [CAAnimation]? = nil,
                                duration: TimeInterval = 2.0,
                                delay: TimeInterval = 0,
                                repeatCount: Float = 1,
                                removedOnCompletion: Bool = false,
                                option: CAMediaTimingFunctionName = .default)
    {
        let animationGroup = CAAnimationGroup()
        // 设置动画组的起始时间，延迟后执行
        animationGroup.beginTime = CACurrentMediaTime() + delay
        // 设置要执行的动画数组（CAAnimation）
        animationGroup.animations = animations
        // 设置动画的总时长
        animationGroup.duration = duration
        // 设置填充模式
        animationGroup.fillMode = .forwards
        // 动画完成后是否移除
        animationGroup.isRemovedOnCompletion = removedOnCompletion
        // 设置动画的节奏函数
        animationGroup.timingFunction = CAMediaTimingFunction(name: option)

        // 添加动画组到图层
        self.add(animationGroup, forKey: nil)
    }
}

// MARK: - CATransition 过渡动画
public extension CALayer {
    /// 过渡动画，常用于视图之间的平滑切换（例如页面切换）
    /// - Parameters:
    ///   - type: 过渡动画的类型，常见的类型有 `.fade`, `.push`, `.reveal`, `.moveIn` 等
    ///   - subtype: 过渡动画的方向，例如 `.fromLeft`, `.fromRight`, `.fromTop`, `.fromBottom`
    ///   - duration: 动画的时长，默认 2 秒
    ///   - delay: 动画的延时，默认 0 秒
    ///
    /// Example Usage:
    /// ```swift
    /// layer.dd_addTransition(
    ///     type: .fade,
    ///     subtype: .fromLeft,
    ///     duration: 1.5,
    ///     delay: 0.5
    /// )
    /// ```
    func dd_addTransition(_ type: CATransitionType,
                          subtype: CATransitionSubtype? = nil,
                          duration: CFTimeInterval = 2.0,
                          delay: TimeInterval = 0)
    {
        let transition = CATransition()
        // 设置动画开始时间，支持延时
        transition.beginTime = CACurrentMediaTime() + delay
        // 设置过渡动画的类型（如淡入淡出、推出、揭示等）
        transition.type = type
        // 设置动画的方向（例如从左侧推入、从右侧推出等）
        transition.subtype = subtype
        // 设置动画时长
        transition.duration = duration

        // 将过渡动画添加到图层
        self.add(transition, forKey: nil)
    }
}

// MARK: - 链式语法
public extension CALayer {
    /// 设置 frame
    /// - Parameter frame: 需要设置的 `frame`，定义了图层的位置和大小
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_frame(CGRect(x: 10, y: 20, width: 100, height: 100))`
    @discardableResult
    func dd_frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    /// 添加到父视图
    /// - Parameter superView: 父视图（`UIView`），要将当前图层添加到该视图的图层中
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_add2(superView)`
    @discardableResult
    func dd_add2(_ superView: UIView) -> Self {
        superView.layer.addSublayer(self)
        return self
    }

    /// 添加到父层 (`CALayer`)
    /// - Parameter superLayer: 父层（`CALayer`），要将当前图层添加到该图层中
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_add2(superLayer)`
    @discardableResult
    func dd_add2(_ superLayer: CALayer) -> Self {
        superLayer.addSublayer(self)
        return self
    }

    /// 设置背景色
    /// - Parameter color: 设置背景色的 `UIColor`
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_backgroundColor(.red)`
    @discardableResult
    func dd_backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color.cgColor
        return self
    }

    /// 设置是否隐藏图层
    /// - Parameter isHidden: 设置图层是否隐藏，`true` 隐藏，`false` 显示
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_isHidden(true)`
    @discardableResult
    func dd_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置边框宽度
    /// - Parameter width: 设置边框的宽度
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_borderWidth(2.0)`
    @discardableResult
    func dd_borderWidth(_ width: CGFloat) -> Self {
        self.borderWidth = width
        return self
    }

    /// 设置边框颜色
    /// - Parameter color: 设置边框的颜色
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_borderColor(.black)`
    @discardableResult
    func dd_borderColor(_ color: UIColor) -> Self {
        self.borderColor = color.cgColor
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize: 是否开启光栅化，开启光栅化可以提高图层的渲染性能
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_shouldRasterize(true)`
    @discardableResult
    func dd_shouldRasterize(_ rasterize: Bool) -> Self {
        self.shouldRasterize = rasterize
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale: 设置光栅化的比例，通常使用 `UIScreen.main.scale`
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_rasterizationScale(UIScreen.main.scale)`
    @discardableResult
    func dd_rasterizationScale(_ scale: CGFloat) -> Self {
        self.rasterizationScale = scale
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color: 设置阴影的颜色
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_shadowColor(.gray)`
    @discardableResult
    func dd_shadowColor(_ color: UIColor) -> Self {
        self.shadowColor = color.cgColor
        return self
    }

    /// 设置阴影透明度
    /// - Parameter opacity: 设置阴影的透明度，范围 `0` 到 `1`
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_shadowOpacity(0.5)`
    @discardableResult
    func dd_shadowOpacity(_ opacity: Float) -> Self {
        self.shadowOpacity = opacity
        return self
    }

    /// 设置阴影的偏移量
    /// - Parameter offset: 设置阴影的偏移量，使用 `CGSize` 来指定偏移
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_shadowOffset(CGSize(width: 2, height: 2))`
    @discardableResult
    func dd_shadowOffset(_ offset: CGSize) -> Self {
        self.shadowOffset = offset
        return self
    }

    /// 设置阴影半径
    /// - Parameter radius: 设置阴影的半径
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_shadowRadius(5.0)`
    @discardableResult
    func dd_shadowRadius(_ radius: CGFloat) -> Self {
        self.shadowRadius = radius
        return self
    }

    /// 设置阴影路径
    /// - Parameter path: 设置阴影的路径，使用 `CGPath` 来定义
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_shadowPath(path)`
    @discardableResult
    func dd_shadowPath(_ path: CGPath) -> Self {
        self.shadowPath = path
        return self
    }

    /// 设置是否显示阴影
    /// - Parameter hasShadow: 是否显示阴影
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CALayer()
    /// shapeLayer.dd_showShadow(true)
    /// ```
    @discardableResult
    func dd_showShadow(_ hasShadow: Bool) -> Self {
        self.shadowOpacity = hasShadow ? 0.5 : 0
        return self
    }

    /// 设置透明度
    /// - Parameter opacity: 透明度值 (0.0 - 1.0)
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_opacity(0.5)
    /// ```
    @discardableResult
    func dd_opacity(_ opacity: Float) -> Self {
        self.opacity = opacity
        return self
    }

    /// 设置是否裁剪图层内容
    /// - Parameter masksToBounds: 是否裁剪，`true` 表示裁剪，`false` 不裁剪
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_masksToBounds(true)`
    @discardableResult
    func dd_masksToBounds(_ masksToBounds: Bool = true) -> Self {
        self.masksToBounds = masksToBounds
        return self
    }

    /// 设置圆角
    /// - Parameter cornerRadius: 圆角的半径
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_cornerRadius(10.0)`
    @discardableResult
    func dd_cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        return self
    }

    /// 设置圆角，⚠️ `frame` 必须已经确定
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 设置需要圆角的角，默认是所有角
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd_corner(10.0, corners: .topLeft)`
    @discardableResult
    func dd_corner(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> Self {
        let size = CGSize(width: radius, height: radius)
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.mask = maskLayer

        return self
    }

    /// 设置是否旋转
    /// - Parameter isRotated: 是否旋转
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CALayer()
    /// shapeLayer.dd_rotation(true)
    /// ```
    @discardableResult
    func dd_rotation(_ isRotated: Bool) -> Self {
        if isRotated {
            self.transform = CATransform3DMakeRotation(.pi / 4, 0, 0, 1)
        }
        return self
    }

    /// 旋转图层
    /// - Parameter angle: 旋转角度（单位：弧度）
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// layer.dd_rotate(by: .pi / 4)  // 旋转图层 45 度
    /// ```
    @discardableResult
    func dd_rotate(by angle: CGFloat) -> Self {
        // 使用 CATransform3DRotate 应用旋转变换，绕 Z 轴旋转指定角度
        self.transform = CATransform3DRotate(self.transform, angle, 0, 0, 1)
        return self
    }

    /// 缩放图层
    /// - Parameter scale: 缩放比例，值大于 1 表示放大，介于 0 和 1 之间表示缩小
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// layer.dd_scale(by: 1.5)  // 缩放图层 1.5 倍
    /// ```
    @discardableResult
    func dd_scale(by scale: CGFloat) -> Self {
        // 使用 CATransform3DScale 应用缩放变换，等比例缩放图层（X 和 Y 轴）
        self.transform = CATransform3DScale(self.transform, scale, scale, 1)
        return self
    }

    /// 平移图层
    /// - Parameter translation: 平移位移量，x 和 y 分别表示水平方向和垂直方向的位移
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// layer.dd_translate(by: CGPoint(x: 100, y: 200))  // 平移图层 100 单位 x 和 200 单位 y
    /// ```
    @discardableResult
    func dd_translate(by translation: CGPoint) -> Self {
        // 使用 CATransform3DTranslate 应用平移变换，沿 X 和 Y 轴分别移动指定的距离
        self.transform = CATransform3DTranslate(self.transform, translation.x, translation.y, 0)
        return self
    }

    /// 设置是否启用光栅化
    /// - Parameter isRasterized: 是否启用光栅化
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_rasterization(true)
    /// ```
    @discardableResult
    func dd_rasterization(_ isRasterized: Bool) -> Self {
        self.shouldRasterize = isRasterized
        return self
    }

    /// 设置遮罩图层
    /// - Parameter mask: 遮罩
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let textLayer = CALayer()
    /// let maskLayer = CALayer()
    /// textLayer.dd_mask(maskLayer)
    /// ```
    @discardableResult
    func dd_mask(_ mask: CALayer) -> Self {
        self.mask = mask
        return self
    }
}
