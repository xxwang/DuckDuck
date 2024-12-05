//
//  UINavigationController++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - Creatable
public extension UINavigationController {
    /// 纯净的创建方法
    static func create<T: UINavigationController>(_ aClass: T.Type = UINavigationController.self) -> T {
        let navigationController = UINavigationController()
        return navigationController as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UINavigationController>(_ aClass: T.Type = UINavigationController.self) -> T {
        let navigationController: UINavigationController = self.create()
        return navigationController as! T
    }
}

// MARK: - 方法
public extension UINavigationController {
    /// 把控制器压入导航栈中
    /// - Parameters:
    ///   - viewController: 要入栈的控制器
    ///   - animated: 是否使用动画效果，默认是 `true`
    ///   - completion: 动画完成后的回调，默认为 `nil`
    /// - Example:
    /// ```swift
    /// navigationController?.dd_push(nextViewController, animated: true, completion: {
    ///     print("Push completed.")
    /// })
    /// ```
    func dd_push(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    /// 把控制器从栈中移除
    /// - Parameters:
    ///   - animated: 是否使用动画效果，默认是 `true`
    ///   - completion: 动画完成后的回调，默认为 `nil`
    /// - Example:
    /// ```swift
    /// navigationController?.dd_pop(animated: true, completion: {
    ///     print("Pop completed.")
    /// })
    /// ```
    func dd_pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }

    /// 设置导航条为透明
    /// - Parameter tintColor: 导航条的`tintColor`，默认是白色
    /// - Example:
    /// ```swift
    /// navigationController?.dd_transparent(with: .black)
    /// ```
    func dd_transparent(with tintColor: UIColor = .white) {
        self.navigationBar
            .dd_isTranslucent(true)
            .dd_backgroundImage(UIImage())
            .dd_backgroundColor(.clear)
            .dd_shadowImage(UIImage())
            .dd_tintColor(tintColor)
            .dd_barTintColor(.clear)
            .dd_titleTextAttributes([.foregroundColor: tintColor])
    }

    /// 设置全屏返回手势
    /// - Parameter isOpen: 是否开启全屏手势，`true` 表示开启，`false` 表示关闭
    /// - Example:
    /// ```swift
    /// navigationController?.dd_fullScreenBackGesture(true)
    /// ```
    func dd_fullScreenBackGesture(_ isOpen: Bool) {
        if isOpen {
            guard let popGestureRecognizer = self.interactivePopGestureRecognizer,
                  let targets = popGestureRecognizer.value(forKey: "_targets") as? [NSObject]
            else {
                return
            }
            guard let targetObjc = targets.first else { return }
            guard let target = targetObjc.value(forKey: "target") else { return }
            let action = Selector(("handleNavigationTransition:"))

            // 创建并添加全屏手势
            let panGR = UIPanGestureRecognizer(target: target, action: action)
            self.view.addGestureRecognizer(panGR)
        } else {
            // 移除所有的手势
            self.view.gestureRecognizers?.filter { ges in
                ges is UIPanGestureRecognizer
            }.forEach { ges in
                ges.dd_removeGesture()
            }
        }
    }
}

// MARK: - 链式语法
public extension UINavigationController {
    /// 设置导航控制器代理
    /// - Parameter delegate: 导航控制器的代理
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationController?.dd_delegate(self)
    /// ```
    @discardableResult
    func dd_delegate(_ delegate: UINavigationControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置导航栏是否隐藏
    /// - Parameters:
    ///   - hidden: 是否隐藏导航栏，`true` 表示隐藏，`false` 表示显示
    ///   - animated: 是否使用动画，默认是 `false`
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationController?.dd_navigationBarHidden(true, animated: true)
    /// ```
    @discardableResult
    func dd_navigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        self.setNavigationBarHidden(hidden, animated: animated)
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
    /// navigationController.dd_viewControllers([vc1, vc2, vc3], animated: true)
    /// ```
    @discardableResult
    func dd_viewControllers(_ viewControllers: [UIViewController], animated: Bool = false) -> Self {
        self.setViewControllers(viewControllers, animated: animated)
        return self
    }
}
