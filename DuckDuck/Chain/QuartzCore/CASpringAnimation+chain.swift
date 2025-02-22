import QuartzCore

// MARK: - 链式语法
public extension DDExtension where Base: CASpringAnimation {
    /// 设置弹簧动画的质量（Mass）
    /// - Parameter mass: 物体的质量，默认值为 1.0
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let springAnimation = CASpringAnimation().dd_mass(2.0)  // 设置质量为 2.0
    /// ```
    @discardableResult
    func dd_mass(_ mass: CGFloat) -> Self {
        self.base.mass = mass
        return self
    }

    /// 设置弹簧动画的刚度（Stiffness）
    /// - Parameter stiffness: 刚度，默认值为 100.0
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let springAnimation = CASpringAnimation().dd_stiffness(150.0)  // 设置刚度为 150.0
    /// ```
    @discardableResult
    func dd_stiffness(_ stiffness: CGFloat) -> Self {
        self.base.stiffness = stiffness
        return self
    }

    /// 设置弹簧动画的阻尼（Damping）
    /// - Parameter damping: 阻尼，默认值为 10.0
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let springAnimation = CASpringAnimation().dd_damping(12.0)  // 设置阻尼为 12.0
    /// ```
    @discardableResult
    func dd_damping(_ damping: CGFloat) -> Self {
        self.base.damping = damping
        return self
    }

    /// 设置弹簧动画的初始速度（Initial Velocity）
    /// - Parameter velocity: 初始速度，默认值为 0.0
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let springAnimation = CASpringAnimation().dd_initialVelocity(1.0)  // 设置初始速度为 1.0
    /// ```
    @discardableResult
    func dd_initialVelocity(_ velocity: CGFloat) -> Self {
        self.base.initialVelocity = velocity
        return self
    }

    /// 设置弹簧动画的最终值（Final Value）
    /// - Parameter finalValue: 动画的目标值
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let springAnimation = CASpringAnimation().dd_finalValue(10.0)  // 设置动画最终值为 10.0
    /// ```
    @discardableResult
    func dd_toValue(_ finalValue: CGFloat) -> Self {
        self.base.toValue = finalValue
        return self
    }
}
