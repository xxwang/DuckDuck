import UIKit

// MARK: - 链式语法
public extension DDExtension where Base: UITabBarController {
    /// 设置 `UITabBarController` 代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBarController.dd.delegate(self)
    /// ```
    @discardableResult
    func delegate(_ delegate: UITabBarControllerDelegate) -> Self {
        self.base.delegate = delegate
        return self
    }

    /// 设置 `UITabBarController` 的子控制器
    /// - Parameter viewControllers: 子控制器数组
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBarController.dd.viewControllers([viewController1, viewController2])
    /// ```
    @discardableResult
    func viewControllers(_ viewControllers: [UIViewController]?) -> Self {
        self.base.viewControllers = viewControllers
        return self
    }

    /// 设置 `UITabBarController` 的子控制器，并指定是否使用动画
    /// - Parameters:
    ///   - viewControllers: 子控制器数组
    ///   - animated: 是否使用动画
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBarController.dd.setViewControllers([viewController1, viewController2], animated: true)
    /// ```
    @discardableResult
    func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool = false) -> Self {
        self.base.setViewControllers(viewControllers, animated: animated)
        return self
    }

    /// 设置选中的标签索引
    /// - Parameter index: 标签索引
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBarController.dd.selectedIndex(1)
    /// ```
    @discardableResult
    func selectedIndex(_ index: Int) -> Self {
        self.base.selectedIndex = index
        return self
    }
}
