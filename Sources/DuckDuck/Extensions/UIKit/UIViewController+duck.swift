//
//  UIViewController+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - 方法
public extension UIViewController {
    /// 检查`UIViewController`是否加载完成且在`UIWindow`上
    func dd_isVisible() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
}

// MARK: - 子控制器
public extension UIViewController {
    /// 将`UIViewController`添加为当前控制器`childViewController`
    /// - Parameters:
    ///   - child: 子控制器
    ///   - containerView: 子控制器`view`要添加到的父`view`
    func dd_addChildViewController(_ child: UIViewController, to containerView: UIView) {
        self.addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// 从其父级移除当前控制器及其view
    func dd_removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

// MARK: - 页面跳转
public extension UIViewController {
    /// 以`Modal`形式显示控制器
    /// - Parameters:
    ///   - viewController:要显示的控制器
    ///   - animated:是否动画
    ///   - completion:完成回调
    func dd_present(viewController: UIViewController, fullScreen: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        if fullScreen {
            viewController.modalPresentationStyle = .fullScreen
        }
        present(viewController, animated: animated, completion: completion)
    }

    /// 把指定控制器push到导航栈中
    /// - Parameters:
    ///   - viewController:要压入栈的控制器
    ///   - animated:是否动画
    func dd_push(viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    /// `pop`最后一个控制器然后`push`指定控制器
    /// - Parameters:
    ///   - viewController:要压入栈的控制器
    ///   - animated:是否要动画
    func dd_popLast(thenPush viewController: UIViewController, animated: Bool = true) {
        guard let navigationController else { return }

        // 栈中的控制器数组
        var viewControllers = navigationController.viewControllers
        guard viewControllers.count >= 1 else { return }

        viewControllers.removeLast()
        viewControllers.append(viewController)
        navigationController.setViewControllers(viewControllers, animated: animated)
    }

    /// 往前返回(POP)几个控制器 后`push`进某个控制器
    /// - Parameters:
    ///   - count:返回(POP)几个控制器
    ///   - vc:被push的控制器
    ///   - animated:是否要动画
    func dd_pop(count: Int, thenPush viewController: UIViewController, animated: Bool = true) {
        guard let navigationController else { return }
        if count < 1 { return }

        // 如果要pop掉的数量大于或等于栈中的数量
        let navViewControllers = navigationController.viewControllers
        if count >= navViewControllers.count {
            // 保留栈底控制器 + 要push的控制器
            if let firstViewController = navViewControllers.first {
                navigationController.setViewControllers([firstViewController, viewController], animated: animated)
            }
            return
        }

        // 保留需要的控制器
        var vcs = navViewControllers[0 ... (navViewControllers.count - count - 1)]
        // 添加要Push的控制器
        vcs.append(viewController)

        // 如果栈中控制器数量大于0就隐藏tabBar
        viewController.hidesBottomBarWhenPushed = vcs.count > 0

        // 设置栈数组
        navigationController.setViewControllers(Array(vcs), animated: animated)
    }

    /// 获取当前显示的控制器的前一个控制器
    /// - Returns:`UIViewController`
    func dd_previousViewController() -> UIViewController? {
        guard let nav = navigationController else { return nil }
        if nav.viewControllers.count <= 1 { return nil }
        guard let index = nav.viewControllers.firstIndex(of: self), index > 0 else { return nil }
        return nav.viewControllers[index - 1]
    }
}

// MARK: - 退出控制器
public extension UIViewController {
    /// POP到`navigationController`的根控制器
    /// - Parameters:
    ///   - animated:是否动画
    func dd_pop2rootViewController(_ animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }

    /// POP到上级控制器
    /// - Parameters:
    ///   - animated:是否动画
    func dd_popViewController(_ animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }

    /// POP到指定控制器
    /// - Parameters:
    ///   - viewController:指定的控制器
    ///   - animated:是否动画
    func dd_pop2(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.popToViewController(viewController, animated: animated)
    }

    /// `POP`到指定类型控制器, 从栈顶开始逐个遍历
    /// - Parameters:
    ///   - aClass:要`POP`到的控制器类型
    ///   - animated:是否动画
    /// - Returns:是否成功
    @discardableResult
    func dd_pop2(aClass: AnyClass, animated: Bool = false) -> Bool {
        func pop2(nav: UINavigationController?) -> Bool {
            guard let nav else { return false }

            for viewController in nav.viewControllers.reversed() {
                if viewController.isMember(of: aClass) {
                    nav.popToViewController(viewController, animated: animated)
                    return true
                }
            }
            return false
        }

        if let nav = self as? UINavigationController {
            return pop2(nav: nav)
        } else {
            return pop2(nav: navigationController)
        }
    }

    /// POP指定数量的控制器(释放指定数量控制器)
    /// - Parameters:
    ///   - count:返回(POP)几个控制器
    ///   - animated:是否有动画
    func dd_pop(count: Int, animated: Bool = false) {
        guard let navigationController else { return }
        guard count >= 1 else { return }

        // 导航栈中的控制器数组
        let navViewControllers = navigationController.viewControllers

        // 如果要pop掉的控制器数量大于现有的数量,返回到根控制器
        if count >= navViewControllers.count {
            navigationController.popToRootViewController(animated: animated)
            return
        }

        // 回到指定控制器
        let viewController = navViewControllers[navViewControllers.count - count - 1]
        navigationController.popToViewController(viewController, animated: animated)
    }

    /// 释放`Modal`出来的当前控制器
    /// - Parameters:
    ///   - animated:是否动画
    ///   - completion:完成回调
    func dd_dismissViewController(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }

    /// 关闭当前显示的控制器
    /// - Parameter animated:是否动画
    func dd_closeViewController(_ animated: Bool = true) {
        guard let nav = navigationController else {
            self.dismiss(animated: animated, completion: nil)
            return
        }

        if nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
        } else if let _ = nav.presentingViewController {
            nav.dismiss(animated: animated, completion: nil)
        }
    }
}

// MARK: - 方法
public extension UIViewController {
    /// 将`UIViewController`显示为弹出框(`Popover`样式显示)
    /// - Parameters:
    ///   - contentViewController: 要展示的内容控制器
    ///   - arrowPoint: 箭头位置(从哪里显示出来)
    ///   - contentSize: 内容大小
    ///   - delegate: 代理
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func dd_presentPopover(
        _ contentViewController: UIViewController,
        arrowPoint: CGPoint,
        contentSize: CGSize? = nil,
        delegate: UIPopoverPresentationControllerDelegate? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        // 设置`modal`样式为`popover`
        contentViewController.modalPresentationStyle = .popover
        if let contentSize {
            contentViewController.preferredContentSize = contentSize
        }

        // 设置`popoverPresentationController`
        if let popoverPresentationController = contentViewController.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(origin: arrowPoint, size: .zero)
            popoverPresentationController.delegate = delegate
        }
        // 弹出
        self.present(contentViewController, animated: animated, completion: completion)
    }
}

// MARK: - 类方法
public extension UIViewController {
    /// 从`UIStoryboard`中实例化`UIViewController`
    /// - Parameters:
    ///   - storyboard:`UIViewController`所在的`UIStoryboard`的名称
    ///   - bundle:故事板所在的`Bundle`
    ///   - identifier:`UIViewController`的`UIStoryboard`标识符
    /// - Returns:从`UIStoryboard`实例化的`UIViewController`实例
    class func dd_instantiateViewController(from storyboard: String = "Main", bundle: Bundle? = nil, identifier: String? = nil) -> Self {
        let identifier = identifier ?? String(describing: self)
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        let instantiateViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self
        guard let instantiateViewController else {
            preconditionFailure(
                "Unable to instantiate view controller with identifier \(identifier) as type \(type(of: self))")
        }
        return instantiateViewController
    }
}

// MARK: - Runtime
public extension UIViewController {
    /// 交换方法
    static func dd_initMethod() {
        super.dd_initializeMethod()

        if self == UIViewController.self {
            let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
            DispatchQueue.dd_once(token: onceToken) {
                // viewDidLoad
                let oriSel = #selector(viewDidLoad)
                let repSel = #selector(dd_hook_viewDidLoad)
                _ = self.dd_hookInstanceMethod(of: oriSel, with: repSel)

                // viewWillAppear
                let oriSel1 = #selector(viewWillAppear(_:))
                let repSel1 = #selector(dd_hook_viewWillAppear(animated:))
                _ = self.dd_hookInstanceMethod(of: oriSel1, with: repSel1)

                // viewWillDisappear
                let oriSel2 = #selector(viewWillDisappear(_:))
                let repSel2 = #selector(dd_hook_viewWillDisappear(animated:))
                _ = self.dd_hookInstanceMethod(of: oriSel2, with: repSel2)

                // present
                let oriSelPresent = #selector(present(_:animated:completion:))
                let repSelPresent = #selector(dd_hook_present(_:animated:completion:))
                _ = self.dd_hookInstanceMethod(of: oriSelPresent, with: repSelPresent)
            }
        } else if self == UINavigationController.self {
            let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
            DispatchQueue.dd_once(token: onceToken) {
                // pushViewController
                let oriSel = #selector(UINavigationController.pushViewController(_:animated:))
                let repSel = #selector(UINavigationController.dd_hook_pushViewController(_:animated:))
                _ = self.dd_hookInstanceMethod(of: oriSel, with: repSel)
            }
        }
    }

    /// hook`viewDidLoad`
    /// - Parameter animated:是否动画
    @objc private func dd_hook_viewDidLoad(animated: Bool) {
        // 需要注入的代码写在此处
        self.dd_hook_viewDidLoad(animated: animated)
    }

    /// hook`viewWillAppear`
    /// - Parameter animated:是否动画
    @objc private func dd_hook_viewWillAppear(animated: Bool) {
        // 需要注入的代码写在此处
        self.dd_hook_viewWillAppear(animated: animated)
    }

    /// hook`viewWillDisappear`
    /// - Parameter animated:是否动画
    @objc private func dd_hook_viewWillDisappear(animated: Bool) {
        // 需要注入的代码写在此处
        self.dd_hook_viewWillDisappear(animated: animated)
    }

    /// hook`present`
    /// - Parameters:
    ///   - viewControllerToPresent:要`modal`的控制器
    ///   - flag:是否动画
    ///   - completion:完成回调
    @objc private func dd_hook_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent.presentationController == nil {
            viewControllerToPresent.presentationController?.presentedViewController.dismiss(animated: false, completion: nil)
            print("viewControllerToPresent.presentationController 不能为 nil")
            return
        }
        dd_hook_present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

// MARK: - UINavigationController
@objc public extension UINavigationController {
    /// hook`pushViewController`
    /// - Parameters:
    ///   - viewController:要压入栈的控制器
    ///   - animated:是否动画
    func dd_hook_pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 判断是否是根控制器
        if viewControllers.count <= 1 {
            DDLog.info("根控制器")
        }

        // 非栈顶控制器(要入栈的控制器不是栈顶控制器, 隐藏TabBar)
        if !children.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }

        // push进入下一个控制器
        self.dd_hook_pushViewController(viewController, animated: animated)
    }
}

// MARK: - 链式语法
public extension UIViewController {
    /// 设置控制用户界面样式(亮色/黑暗)
    /// - Parameter userInterfaceStyle: 用户界面样式
    /// - Returns: `Self`
    @discardableResult
    func dd_overrideUserInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) -> Self {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = userInterfaceStyle
        }
        return self
    }

    /// 设置是否允许滚动视图自动缩进(iOS11以下版本)
    /// - Parameter automaticallyAdjustsScrollViewInsets: 是否
    /// - Returns: `Self`
    @discardableResult
    func dd_automaticallyAdjustsScrollViewInsets(_ automaticallyAdjustsScrollViewInsets: Bool) -> Self {
        if #available(iOS 11, *) {} else { // iOS11以下版本
            self.automaticallyAdjustsScrollViewInsets = automaticallyAdjustsScrollViewInsets
        }
        return self
    }

    /// 设置控制模态样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func dd_modalPresentationStyle(_ style: UIModalPresentationStyle) -> Self {
        self.modalPresentationStyle = style
        return self
    }
}

// MARK: - view
public extension UIViewController {
    /// 设置控制器根视图背景颜色
    /// - Parameter backgroundColor: 要设置的背景颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.view.backgroundColor = backgroundColor
        return self
    }
}
