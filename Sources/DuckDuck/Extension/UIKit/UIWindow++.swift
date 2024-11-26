//
//  UIWindow++.swift
//  DuckDuck
//
//  Created by xxwang on 19/11/2024.
//

import UIKit

// MARK: - UIWindow Extensions
public extension UIWindow {
    /// 返回当前有效的`UIWindow`
    /// - Returns: 返回一个有效的`UIWindow`，如果没有找到有效窗口则返回`nil`
    ///
    /// - Example:
    /// ```swift
    /// if let window = UIWindow.dd_mainWindow() {
    ///     // 使用有效窗口
    /// } else {
    ///     print("没有有效窗口")
    /// }
    /// ```
    static func dd_mainWindow() -> UIWindow? {
        var resultWindow: UIWindow?

        // 获取AppDelegate中的窗口
        if let delegateWindow = self.dd_delegateWindow() {
            resultWindow = delegateWindow
        }

        // 获取当前的keyWindow
        if let keyWindow = self.dd_keyWindow() {
            resultWindow = keyWindow
        }

        // 获取windows数组中的最后一个窗口
        if let firstWindow = self.dd_allWindows().last {
            resultWindow = firstWindow
        }

        // 如果窗口级别为normal，则返回此窗口
        if resultWindow?.windowLevel == .normal {
            return resultWindow
        }

        // 遍历所有窗口并返回level为normal的窗口
        for window in self.dd_allWindows() {
            if window.windowLevel == .normal {
                resultWindow = window
            }
        }
        return resultWindow
    }

    /// 返回当前的`keyWindow`
    /// - Returns: 返回当前的`keyWindow`，如果没有找到则返回`nil`
    ///
    /// - Example:
    /// ```swift
    /// if let keyWindow = UIWindow.dd_keyWindow() {
    ///     // 使用keyWindow
    /// } else {
    ///     print("没有找到keyWindow")
    /// }
    /// ```
    static func dd_keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return self.dd_allWindows().first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    /// 返回`AppDelegate`中的窗口
    /// - Returns: 返回`AppDelegate`的窗口，iOS 13及之后版本该值为`nil`
    static func dd_delegateWindow() -> UIWindow? {
        guard let delegateWindow = UIApplication.shared.delegate?.window else { return nil }
        return delegateWindow
    }

    /// 返回当前所有连接的`UIWindow`对象
    /// - Returns: 返回所有`UIWindow`对象的数组
    static func dd_allWindows() -> [UIWindow] {
        var windows: [UIWindow] = []
        if #available(iOS 13.0, *) {
            for connectedScene in UIApplication.shared.connectedScenes {
                guard let windowScene = connectedScene as? UIWindowScene,
                      let window = windowScene.windows.first(where: \.isKeyWindow)
                else {
                    continue
                }
                windows.append(window)
            }
        } else {
            windows = UIApplication.shared.windows
        }
        return windows
    }
}

// MARK: - UIViewController Extensions
public extension UIWindow {
    /// 返回当前可用窗口的根视图控制器
    /// - Returns: 返回`UIViewController?`，如果找不到返回`nil`
    ///
    /// - Example:
    /// ```swift
    /// if let rootVC = UIWindow.dd_rootViewController() {
    ///     // 使用rootVC
    /// } else {
    ///     print("没有找到rootViewController")
    /// }
    /// ```
    static func dd_rootViewController() -> UIViewController? {
        return self.dd_mainWindow()?.rootViewController
    }

    /// 获取基准控制器的最顶层控制器
    /// - Parameter base: 基准控制器，默认为`rootViewController`
    /// - Returns: 返回最顶层的`UIViewController`
    ///
    /// - Example:
    /// ```swift
    /// if let topVC = UIWindow.dd_topViewController() {
    ///     // 使用topVC
    /// } else {
    ///     print("没有找到顶层控制器")
    /// }
    /// ```
    static func dd_topViewController(_ base: UIViewController? = UIWindow.dd_rootViewController()) -> UIViewController? {
        guard let base else { return nil }

        // 如果是导航控制器，递归获取visibleViewController
        if let navigationController = base as? UINavigationController {
            return self.dd_topViewController(navigationController.visibleViewController)
        }

        // 如果是标签控制器，递归获取选中的视图控制器
        if let tabBarController = base as? UITabBarController {
            return self.dd_topViewController(tabBarController.selectedViewController)
        }

        // 如果有presentedViewController，递归获取其最顶层控制器
        if let presentedViewController = base.presentedViewController {
            return self.dd_topViewController(presentedViewController)
        }

        return base
    }
}

// MARK: - 屏幕方向控制
public extension UIWindow {
    /// 切换屏幕方向
    /// - Parameter isLandscape: 是否横屏，`true`为横屏，`false`为竖屏
    ///
    /// - Example:
    /// ```swift
    /// UIWindow.dd_switchOrientation(toLandscape: true)
    /// ```
    static func dd_switchOrientation(toLandscape isLandscape: Bool) {
        if isLandscape { // 横屏
            guard !CommonHelper.isLandscape else { return }
            // 重置方向
            UIDevice.current.setValue(NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue), forKey: "orientation")
            // 设置横屏
            UIDevice.current.setValue(NSNumber(integerLiteral: UIInterfaceOrientation.landscapeRight.rawValue), forKey: "orientation")
        } else { // 竖屏
            guard CommonHelper.isLandscape else { return }
            // 重置方向
            UIDevice.current.setValue(NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue), forKey: "orientation")
            // 设置竖屏
            UIDevice.current.setValue(NSNumber(integerLiteral: UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
}

// MARK: - rootViewController切换
public extension UIWindow {
    /// 使用动画切换`rootViewController`
    /// - Parameters:
    ///   - rootVC: 要设置的`UIViewController`
    ///   - animated: 是否使用动画
    ///   - duration: 动画时长
    ///   - options: 动画选项
    ///   - completion: 动画完成后的回调
    ///
    /// - Example:
    /// ```swift
    /// UIWindow.dd_switchRootViewController(to: newRootVC, animated: true, duration: 0.3) {
    ///     print("切换完成")
    /// }
    /// ```
    static func dd_switchRootViewController(to rootVC: UIViewController,
                                            animated: Bool = true,
                                            duration: TimeInterval = 0.25,
                                            options: UIView.AnimationOptions = .transitionFlipFromRight,
                                            completion: (() -> Void)?)
    {
        guard let window = self.dd_mainWindow() else { return }

        if animated {
            // 动画切换
            UIView.transition(with: window, duration: duration, options: options) {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootVC
                UIView.setAnimationsEnabled(oldState)
            } completion: { _ in
                completion?()
            }
        } else {
            window.rootViewController = rootVC
            completion?()
        }
    }

    /// 使用转场动画切换`rootViewController`
    /// - Parameters:
    ///   - rootVC: 要设置的`UIViewController`
    ///   - animated: 是否使用动画
    ///   - duration: 动画时长
    ///   - animationType: 动画类型
    ///   - animationSubtype: 动画子类型
    ///   - timingFunction: 动画时间曲线
    ///   - completion: 动画完成后的回调
    static func dd_switchRootViewControllerWithTransition(to rootVC: UIViewController,
                                                          animated: Bool = true,
                                                          duration: TimeInterval = 0.25,
                                                          animationType: CATransitionType = .fade,
                                                          animationSubtype: CATransitionSubtype? = .fromRight,
                                                          timingFunction: CAMediaTimingFunction? = CAMediaTimingFunction(name: .easeOut),
                                                          completion: (() -> Void)? = nil)
    {
        guard let window = self.dd_mainWindow() else { return }

        if animated {
            // 转场动画设置
            let animation = CATransition()
            animation.type = animationType
            animation.subtype = animationSubtype
            animation.duration = duration
            animation.timingFunction = timingFunction
            animation.isRemovedOnCompletion = true
            window.layer.add(animation, forKey: "animation")
        }

        window.rootViewController = rootVC
        completion?()
    }
}
