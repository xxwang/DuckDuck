import UIKit

extension UIGestureRecognizer: DDExtensionable {}

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIGestureRecognizer {
    /// 将手势识别器添加到指定视图
    ///
    /// 该方法将当前的手势识别器添加到指定的视图，并确保视图启用用户交互。
    /// 如果视图没有启用用户交互，手势识别器将无法生效。
    ///
    /// 示例:
    /// ```swift
    /// let tapGesture = UITapGestureRecognizer()
    /// tapGesture.dd.add2(someView)
    /// ```
    @discardableResult
    func add2(_ view: UIView) -> Self {
        // 确保视图启用用户交互
        view.isUserInteractionEnabled = true

        // 将当前手势识别器添加到视图
        view.addGestureRecognizer(self.base)

        return self
    }

    /// 移除手势识别器
    ///
    /// 该方法从视图中移除当前的手势识别器。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd.removeGesture()
    /// ```
    @discardableResult
    func removeGesture() -> Self {
        self.base.view?.removeGestureRecognizer(self.base)
        return self
    }

    /// 从视图中移除所有手势识别器。
    ///
    /// 该方法将从视图中删除所有添加的手势识别器。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd.removeAllGestures()
    /// ```
    @discardableResult
    func removeAllGestures() -> Self {
        self.base.view?.gestureRecognizers?.forEach {
            self.base.view?.removeGestureRecognizer($0)
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
    /// tapGesture.dd.onRecognized { recognizer in
    ///     print("手势识别成功")
    /// }
    /// ```
    @discardableResult
    func onRecognized(_ closure: @escaping (UIGestureRecognizer) -> Void) -> Self {
        self.base.dd_addTarget(self.base, action: #selector(self.base.dd_onRecognizedClosure))
        AssociatedObject.set(self.base, key: &Base.AssociateKeys.eventKey, value: closure, policy: .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return self
    }

    /// 观察手势识别器状态变化。
    ///
    /// 该方法允许观察手势识别器的状态变化，并在状态变化时执行回调。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd.onStateChanged { state in
    ///     print("手势状态变化: \(state)")
    /// }
    /// ```
    @discardableResult
    func onStateChanged(_ closure: @escaping (UIGestureRecognizer.State) -> Void) -> Self {
        self.base.dd_addTarget(self.base, action: #selector(self.base.dd_onStateChange))
        AssociatedObject.set(self.base, key: &Base.AssociateKeys.stateChangeKey, value: closure, policy: .OBJC_ASSOCIATION_COPY_NONATOMIC)
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
    /// gestureRecognizer.dd.addTarget(self, action: #selector(handleGesture))
    /// ```
    @discardableResult
    func addTarget(_ target: Any, action: Selector) -> Self {
        self.base.addTarget(target, action: action)
        return self
    }

    /// 是否启用当前手势识别器
    ///
    /// 该方法将禁用当前的手势识别器，不再响应手势。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd.isEnabled(true)
    /// ```
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        self.base.isEnabled = isEnabled
        return self
    }

    /// 设置手势的方向。
    ///
    /// 该方法设置手势识别器的方向，适用于 `UISwipeGestureRecognizer` 等手势。
    ///
    /// 示例:
    /// ```swift
    /// gestureRecognizer.dd.direction(.left)
    /// ```
    @discardableResult
    func direction(_ direction: UISwipeGestureRecognizer.Direction) -> Self {
        if let swipeGesture = self.base as? UISwipeGestureRecognizer {
            swipeGesture.direction = direction
        }
        return self
    }
}
