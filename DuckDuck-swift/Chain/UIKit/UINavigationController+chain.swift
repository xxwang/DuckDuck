import UIKit

// MARK: - 链式语法
public extension DDExtension where Base: UINavigationController {
    /// 设置导航控制器代理
    /// - Parameter delegate: 导航控制器的代理
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationController?.dd.delegate(self)
    /// ```
    @discardableResult
    func delegate(_ delegate: UINavigationControllerDelegate) -> Self {
        self.base.delegate = delegate
        return self
    }

    /// 设置导航栏是否隐藏
    /// - Parameters:
    ///   - hidden: 是否隐藏导航栏，`true` 表示隐藏，`false` 表示显示
    ///   - animated: 是否使用动画，默认是 `false`
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationController?.dd.setNavigationBarHidden(true, animated: true)
    /// ```
    @discardableResult
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        self.base.setNavigationBarHidden(hidden, animated: animated)
        return self
    }

    /// 设置视图控制器栈，并且返回当前导航控制器
    /// - Parameters:
    ///   - viewControllers: 一个 `UIViewController` 数组，表示导航控制器的视图控制器栈。
    ///   - animated: 一个布尔值，表示是否使用动画来设置视图控制器。
    /// - Returns: 当前的 `UINavigationController` 实例，支持链式调用。
    ///
    /// 示例用法：
    /// ```swift
    /// let navigationController = UINavigationController()
    /// navigationController.dd.viewControllers([vc1, vc2, vc3], animated: true)
    /// ```
    @discardableResult
    func viewControllers(_ viewControllers: [UIViewController], animated: Bool = false) -> Self {
        self.base.setViewControllers(viewControllers, animated: animated)
        return self
    }
}
