import UIKit

// MARK: - Creatable
public extension UITabBarController {
    /// 纯净的创建方法
    static func create<T: UITabBarController>(_ aClass: T.Type = UITabBarController.self) -> T {
        let tabBarController = UITabBarController()
        return tabBarController as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITabBarController>(_ aClass: T.Type = UITabBarController.self) -> T {
        let tabBarController: UITabBarController = self.create()
        return tabBarController as! T
    }
}

// MARK: - 计算属性
public extension UITabBarController {
    /// 获取或设置当前 `UITabBarController` 的选中索引
    /// - Getter: 返回当前选中的索引，默认返回 0
    /// - Setter: 设置选中的索引
    /// - Example:
    /// ```swift
    /// UITabBarController.selectIndex = 2 // 设置选中索引为 2
    /// let index = UITabBarController.selectIndex // 获取当前选中的索引
    /// ```
    static var selectIndex: Int {
        get { return self.current()?.selectedIndex ?? 0 }
        set { self.current()?.selectedIndex = newValue }
    }

    /// 获取当前作为 `rootViewController` 的 `UITabBarController`
    /// - Returns: 返回当前的 `UITabBarController`，如果当前 rootViewController 不是 `UITabBarController`，则返回 `nil`
    /// - Example:
    /// ```swift
    /// if let tabBarController = UITabBarController.current() {
    ///     // 使用 tabBarController
    /// }
    /// ```
    static func current() -> UITabBarController? {
        guard let tabBarController = UIWindow.dd_rootViewController() as? UITabBarController else {
            return nil
        }
        return tabBarController
    }
}

// MARK: - 链式语法
public extension UITabBarController {
    /// 设置 `UITabBarController` 代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBarController.dd_delegate(self)
    /// ```
    @discardableResult
    func dd_delegate(_ delegate: UITabBarControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 `UITabBarController` 的子控制器，并指定是否使用动画
    /// - Parameters:
    ///   - viewControllers: 子控制器数组
    ///   - animated: 是否使用动画
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBarController.dd_viewControllers([viewController1, viewController2], animated: true)
    /// ```
    @discardableResult
    func dd_viewControllers(_ viewControllers: [UIViewController]?, animated: Bool = false) -> Self {
        if animated {
            self.setViewControllers(viewControllers, animated: true)
        } else {
            self.viewControllers = viewControllers
        }
        return self
    }

    /// 设置选中的标签索引
    /// - Parameter index: 标签索引
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBarController.dd_selectedIndex(1)
    /// ```
    @discardableResult
    func dd_selectedIndex(_ index: Int) -> Self {
        self.selectedIndex = index
        return self
    }
}
