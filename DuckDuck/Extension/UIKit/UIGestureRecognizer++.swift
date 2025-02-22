import UIKit

public extension UIGestureRecognizer {
    // MARK: - 关联键
    class AssociateKeys {
        static var eventKey = UnsafeRawPointer(bitPattern: ("UIGestureRecognizer" + "eventKey").hashValue)
        static var stateChangeKey = UnsafeRawPointer(bitPattern: ("UIGestureRecognizer" + "stateChangeKey").hashValue)
    }
}

// MARK: - 私有方法
extension UIGestureRecognizer {
    /// 手势识别成功后的回调
    @objc func dd_onRecognizedClosure() {
        if let closure = AssociatedObject.get(self, key: &AssociateKeys.eventKey) as? (_ recognizer: UIGestureRecognizer) -> Void {
            closure(self)
        }
    }

    /// 手势状态变化时调用
    @objc func dd_onStateChange() {
        if let closure = AssociatedObject.get(self, key: &AssociateKeys.stateChangeKey) as? (UIGestureRecognizer.State) -> Void {
            closure(self.state)
        }
    }
}

// MARK: - 方法
public extension UIGestureRecognizer {
    /// 延迟触发手势识别。
    ///
    /// 该方法允许延迟指定时间后再触发手势识别，通常用于交互效果或动画。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd_delayRecognize(by: 1.0)
    /// ```
    func dd_delayRecognize(by delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.state = .began
        }
    }

    /// 检查视图是否可以响应手势。
    ///
    /// 该方法检查视图是否启用用户交互，并返回一个布尔值，表示视图是否可以响应手势。
    ///
    /// 示例:
    /// ```swift
    /// let canRecognize = gestureRecognizer.dd_canRecognizeGesture()
    /// ```
    func dd_canRecognizeGesture() -> Bool {
        guard let view = self.view else { return false }
        return view.isUserInteractionEnabled
    }

    /// 获取手势识别器的触摸点。
    ///
    /// 该方法返回当前手势识别器的触摸位置，相对于视图的位置。
    ///
    /// 示例:
    /// ```swift
    /// let touchPoint = gestureRecognizer.dd_locationInView()
    /// ```
    func dd_locationInView() -> CGPoint {
        guard let view = self.view else { return .zero }
        return self.location(in: view)
    }

    /// 检查手势是否已识别。
    ///
    /// 该方法检查当前手势识别器是否已经成功识别。
    ///
    /// 示例:
    /// ```swift
    /// let isRecognized = gestureRecognizer.dd_isRecognized()
    /// ```
    func dd_isRecognized() -> Bool {
        return self.state == .recognized
    }
}

// MARK: - 链式语法
public extension UIGestureRecognizer {
    /// 将手势识别器添加到指定视图
    ///
    /// 该方法将当前的手势识别器添加到指定的视图，并确保视图启用用户交互。
    /// 如果视图没有启用用户交互，手势识别器将无法生效。
    ///
    /// 示例:
    /// ```swift
    /// let tapGesture = UITapGestureRecognizer()
    /// tapGesture.dd_add2(someView)
    /// ```
    @discardableResult
    func dd_add2(_ view: UIView) -> Self {
        // 确保视图启用用户交互
        view.isUserInteractionEnabled = true

        // 将当前手势识别器添加到视图
        view.addGestureRecognizer(self)

        return self
    }

    /// 移除手势识别器
    ///
    /// 该方法从视图中移除当前的手势识别器。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd_removeGesture()
    /// ```
    @discardableResult
    func dd_removeGesture() -> Self {
        self.view?.removeGestureRecognizer(self)
        return self
    }

    /// 从视图中移除所有手势识别器。
    ///
    /// 该方法将从视图中删除所有添加的手势识别器。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd_removeAllGestures()
    /// ```
    @discardableResult
    func dd_removeAllGestures() -> Self {
        self.view?.gestureRecognizers?.forEach {
            self.view?.removeGestureRecognizer($0)
        }
        return self
    }

    /// 设置手势识别成功后的回调。
    ///
    /// 该方法允许在手势识别成功后执行回调，避免每个手势都创建单独的目标和动作方法。
    ///
    /// 示例:
    /// ```swift
    /// let tapGesture = UITapGestureRecognizer()
    /// tapGesture.dd_onRecognized { recognizer in
    ///     print("手势识别成功")
    /// }
    /// ```
    @discardableResult
    func dd_onRecognized(_ closure: @escaping (UIGestureRecognizer) -> Void) -> Self {
        self.addTarget(self, action: #selector(dd_onRecognizedClosure))
        AssociatedObject.set(self, key: &AssociateKeys.eventKey, value: closure, policy: .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return self
    }

    /// 观察手势识别器状态变化。
    ///
    /// 该方法允许观察手势识别器的状态变化，并在状态变化时执行回调。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd_onStateChanged { state in
    ///     print("手势状态变化: \(state)")
    /// }
    /// ```
    @discardableResult
    func dd_onStateChanged(_ closure: @escaping (UIGestureRecognizer.State) -> Void) -> Self {
        self.addTarget(self, action: #selector(dd_onStateChange))
        AssociatedObject.set(self, key: &AssociateKeys.stateChangeKey, value: closure, policy: .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return self
    }

    /// 添加响应方法
    ///
    /// 该方法允许将目标对象和方法选择器添加到手势识别器中。适用于需要传统方法调用的场景。
    ///
    /// - Parameters:
    ///   - target: 响应方法的目标对象。
    ///   - action: 方法选择器。
    /// - Returns: `Self`，允许链式调用。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd_addTarget(self, action: #selector(handleGesture))
    /// ```
    @discardableResult
    func dd_addTarget(_ target: Any, action: Selector) -> Self {
        self.addTarget(target, action: action)
        return self
    }

    /// 是否启用当前手势识别器
    ///
    /// 该方法将禁用当前的手势识别器，不再响应手势。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd_isEnabled(true)
    /// ```
    @discardableResult
    func dd_isEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }

    /// 设置手势的方向。
    ///
    /// 该方法设置手势识别器的方向，适用于 `UISwipeGestureRecognizer` 等手势。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd_direction(.left)
    /// ```
    @discardableResult
    func dd_direction(_ direction: UISwipeGestureRecognizer.Direction) -> Self {
        if let swipeGesture = self as? UISwipeGestureRecognizer {
            swipeGesture.direction = direction
        }
        return self
    }
}
