//
//  UIViewController++.swift
//  DuckDuck
//
//  Created by xxwang on 24/11/2024.
//

import UIKit

// MARK: - 类方法
public extension UIViewController {
    /// 从`UIStoryboard`中实例化`UIViewController`
    ///
    /// 该方法从指定的`UIStoryboard`中根据标识符`identifier`实例化对应的视图控制器。
    /// - Parameters:
    ///   - storyboard: `UIViewController`所在的`UIStoryboard`的名称，默认为`"Main"`
    ///   - bundle: 故事板所在的`Bundle`，默认为`nil`
    ///   - identifier: `UIViewController`的`UIStoryboard`标识符，默认为类名
    /// - Returns: 返回从`UIStoryboard`实例化的`UIViewController`实例
    /// - Example:
    /// ```swift
    /// let myVC = MyViewController.dd_instantiateViewController(from: "Main", identifier: "MyViewControllerID")
    /// ```
    class func dd_instantiateViewController(from storyboard: String = "Main", bundle: Bundle? = nil, identifier: String? = nil) -> Self {
        let identifier = identifier ?? String(describing: self)
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        guard let instantiateViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            preconditionFailure("Unable to instantiate view controller with identifier \(identifier) as type \(type(of: self))")
        }
        return instantiateViewController
    }
}

// MARK: - 视图控制器钩子
public extension UIViewController {
    /// 初始化方法，进行方法交换
    ///
    /// 该方法用于交换系统的`viewDidLoad`、`viewWillAppear`、`viewWillDisappear`、`present`等方法，以注入自定义行为。
    /// 通常用于执行一些调试、日志记录或者修改默认行为。
    /// - Example:
    /// ```swift
    /// UIViewController.dd_initMethod()
    /// ```
    static func dd_initMethod() {
        super.dd_initializeMethod()

        if self == UIViewController.self {
            let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
            DispatchQueue.dd_once(token: onceToken) {
                // hook viewDidLoad
                let oriSel = #selector(viewDidLoad)
                let repSel = #selector(dd_hook_viewDidLoad)
                _ = self.dd_hookInstanceMethod(of: oriSel, with: repSel)

                // hook viewWillAppear
                let oriSel1 = #selector(viewWillAppear(_:))
                let repSel1 = #selector(dd_hook_viewWillAppear(animated:))
                _ = self.dd_hookInstanceMethod(of: oriSel1, with: repSel1)

                // hook viewWillDisappear
                let oriSel2 = #selector(viewWillDisappear(_:))
                let repSel2 = #selector(dd_hook_viewWillDisappear(animated:))
                _ = self.dd_hookInstanceMethod(of: oriSel2, with: repSel2)

                // hook present
                let oriSelPresent = #selector(present(_:animated:completion:))
                let repSelPresent = #selector(dd_hook_present(_:animated:completion:))
                _ = self.dd_hookInstanceMethod(of: oriSelPresent, with: repSelPresent)
            }
        }
    }

    /// hook`viewDidLoad`方法
    /// - Parameter animated: 是否动画
    /// - Example:
    /// ```swift
    /// // 自定义viewDidLoad行为
    /// self.dd_hook_viewDidLoad(animated: true)
    /// ```
    @objc private func dd_hook_viewDidLoad(animated: Bool) {
        // 在这里插入自定义代码
        self.dd_hook_viewDidLoad(animated: animated)
    }

    /// hook`viewWillAppear`方法
    /// - Parameter animated: 是否动画
    /// - Example:
    /// ```swift
    /// // 自定义viewWillAppear行为
    /// self.dd_hook_viewWillAppear(animated: true)
    /// ```
    @objc private func dd_hook_viewWillAppear(animated: Bool) {
        // 在这里插入自定义代码
        self.dd_hook_viewWillAppear(animated: animated)
    }

    /// hook`viewWillDisappear`方法
    /// - Parameter animated: 是否动画
    /// - Example:
    /// ```swift
    /// // 自定义viewWillDisappear行为
    /// self.dd_hook_viewWillDisappear(animated: true)
    /// ```
    @objc private func dd_hook_viewWillDisappear(animated: Bool) {
        // 在这里插入自定义代码
        self.dd_hook_viewWillDisappear(animated: animated)
    }

    /// hook`present`方法
    /// - Parameters:
    ///   - viewControllerToPresent: 要`modal`的控制器
    ///   - flag: 是否动画
    ///   - completion: 完成回调
    /// - Example:
    /// ```swift
    /// self.dd_hook_present(myVC, animated: true)
    /// ```
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
    /// hook`pushViewController`方法
    ///
    /// 该方法在推送新的视图控制器时检查控制器栈，如果是非根控制器，会自动隐藏TabBar。
    /// - Parameters:
    ///   - viewController: 要压入栈的控制器
    ///   - animated: 是否动画
    /// - Example:
    /// ```swift
    /// navigationController.dd_hook_pushViewController(nextVC, animated: true)
    /// ```
    func dd_hook_pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 判断是否是根控制器
        if viewControllers.count <= 1 {
            Logger.info("根控制器")
        }

        // 非栈顶控制器(要入栈的控制器不是栈顶控制器, 隐藏TabBar)
        if !children.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }

        // 执行原始的push操作
        self.dd_hook_pushViewController(viewController, animated: animated)
    }
}

// MARK: - 控制器状态
public extension UIViewController {
    /// 检查当前视图控制器是否已加载并显示在窗口上
    /// - Returns: `true`表示控制器已加载并且其视图在窗口中显示
    ///
    /// 示例用法：
    /// ```swift
    /// if controller.dd_isVisible() {
    ///     print("控制器已加载并可见")
    /// }
    /// ```
    func dd_isVisible() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
}

// MARK: - 子控制器管理
public extension UIViewController {
    /// 将子控制器添加到当前控制器的视图层次结构中
    /// - Parameters:
    ///   - child: 需要添加的子控制器
    ///   - containerView: 子控制器的视图将要添加到的父视图
    ///
    /// 示例用法：
    /// ```swift
    /// let childVC = SomeChildViewController()
    /// containerViewController.dd_addChild(childVC, to: parentView)
    /// ```
    func dd_addChild(_ controller: UIViewController, to containerView: UIView) {
        self.addChild(controller)
        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
    }

    /// 从父控制器中移除当前控制器及其视图
    ///
    /// 示例用法：
    /// ```swift
    /// someChildController.dd_removeViewAndControllerFromParentViewController()
    /// ```
    func dd_removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

// MARK: - Popover
public extension UIViewController {
    /// 显示弹出框（Popover）样式的视图控制器
    ///
    /// 该方法会以弹出框（Popover）样式显示指定的视图控制器，支持自定义箭头位置、内容大小以及动画效果。
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - arrowLocation: 箭头指向的屏幕坐标点，决定弹出框箭头的位置
    ///   - preferredSize: 内容视图的大小（可选），如果不设置则使用默认大小
    ///   - popoverDelegate: `UIPopoverPresentationController`的代理（可选）
    ///   - animated: 是否使用动画显示弹出框，默认为`true`
    ///   - completion: 完成后的回调（可选）
    /// - Example:
    /// ```swift
    /// let popoverVC = MyPopoverViewController()
    /// self.dd_show(popover: popoverVC, arrowLocation: CGPoint(x: 100, y: 100), preferredSize: CGSize(width: 300, height: 200))
    /// ```
    func dd_show(
        popover viewController: UIViewController,
        arrowLocation: CGPoint,
        preferredSize: CGSize? = nil,
        popoverDelegate: UIPopoverPresentationControllerDelegate? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        // 设置`popoverViewController`的`modalPresentationStyle`为`popover`
        viewController.modalPresentationStyle = .popover

        // 如果提供了`preferredSize`，设置`preferredContentSize`
        if let preferredSize {
            viewController.preferredContentSize = preferredSize
        }

        // 配置`popoverPresentationController`
        if let popoverPresentationController = viewController.popoverPresentationController {
            // 设置弹出框的源视图和箭头位置
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(origin: arrowLocation, size: .zero)
            // 设置代理（如果有）
            popoverPresentationController.delegate = popoverDelegate
        }

        // 弹出`popoverViewController`并执行动画
        self.present(viewController, animated: animated, completion: completion)
    }
}

// MARK: - 页面跳转方法
public extension UIViewController {
    /// 以 `Modal` 形式显示控制器
    ///
    /// - Parameters:
    ///   - viewController: 要显示的控制器
    ///   - fullScreen: 是否以全屏模式展示（默认为 `true`）
    ///   - animated: 是否动画（默认为 `true`）
    ///   - completion: 完成回调（可选）
    ///
    /// 示例：
    /// ```swift
    /// let detailVC = DetailViewController()
    /// self.dd_present(detailVC, fullScreen: true, animated: true) {
    ///     print("Modal 展示完成")
    /// }
    /// ```
    func dd_present(_ viewController: UIViewController, fullScreen: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        if fullScreen {
            viewController.modalPresentationStyle = .fullScreen
        }
        present(viewController, animated: animated, completion: completion)
    }

    /// 将指定控制器 `push` 到导航栈中
    ///
    /// - Parameters:
    ///   - viewController: 要压入栈的控制器
    ///   - animated: 是否动画（默认为 `true`）
    ///
    /// 示例：
    /// ```swift
    /// let detailVC = DetailViewController()
    /// self.dd_push(detailVC, animated: true)
    /// ```
    func dd_push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    /// `pop` 栈顶控制器后 `push` 指定控制器
    ///
    /// - Parameters:
    ///   - viewController: 要压入栈的控制器
    ///   - animated: 是否动画（默认为 `true`）
    ///
    /// 示例：
    /// ```swift
    /// let newVC = NewViewController()
    /// self.dd_popLast(thenPush: newVC, animated: true)
    /// ```
    func dd_popLast(thenPush viewController: UIViewController, animated: Bool = true) {
        guard let navigationController else { return }

        var viewControllers = navigationController.viewControllers
        guard !viewControllers.isEmpty else { return }

        viewControllers.removeLast()
        viewControllers.append(viewController)
        navigationController.setViewControllers(viewControllers, animated: animated)
    }

    /// 返回（`pop`）指定数量的控制器后 `push` 新控制器
    ///
    /// - Parameters:
    ///   - count: 返回（`pop`）的控制器数量
    ///   - viewController: 要压入栈的控制器
    ///   - animated: 是否动画（默认为 `true`）
    ///
    /// 示例：
    /// ```swift
    /// let targetVC = TargetViewController()
    /// self.dd_pop(2, thenPush: targetVC, animated: true)
    /// ```
    func dd_pop(_ count: Int, thenPush viewController: UIViewController, animated: Bool = true) {
        guard let navigationController else { return }
        guard count > 0 else { return }

        let viewControllers = navigationController.viewControllers
        if count >= viewControllers.count {
            if let rootViewController = viewControllers.first {
                navigationController.setViewControllers([rootViewController, viewController], animated: animated)
            }
            return
        }

        var retainedViewControllers = viewControllers[0 ... (viewControllers.count - count - 1)]
        retainedViewControllers.append(viewController)
        viewController.hidesBottomBarWhenPushed = !retainedViewControllers.isEmpty
        navigationController.setViewControllers(Array(retainedViewControllers), animated: animated)
    }

    /// 获取当前控制器的上一个控制器
    ///
    /// - Returns: 前一个控制器（如果存在），否则返回 `nil`
    ///
    /// 示例：
    /// ```swift
    /// if let previousVC = self.dd_previousViewController() {
    ///     print("上一个控制器是: \(previousVC)")
    /// }
    /// ```
    func dd_previousViewController() -> UIViewController? {
        guard let nav = navigationController else { return nil }
        guard let index = nav.viewControllers.firstIndex(of: self), index > 0 else { return nil }
        return nav.viewControllers[index - 1]
    }
}

// MARK: - 释放与关闭控制器
public extension UIViewController {
    /// 返回到导航控制器的根控制器
    ///
    /// - Parameter animated: 是否动画（默认为 `true`）
    ///
    /// 示例：
    /// ```swift
    /// self.dd_pop2Root(animated: true)
    /// ```
    func dd_pop2Root(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }

    /// 返回到导航栈中的上一个控制器
    ///
    /// - Parameter animated: 是否动画（默认为 `true`）
    ///
    /// 示例：
    /// ```swift
    /// self.dd_pop(animated: true)
    /// ```
    func dd_pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }

    /// 返回到指定的控制器
    ///
    /// - Parameters:
    ///   - viewController: 目标控制器
    ///   - animated: 是否动画（默认为 `true`）
    ///
    /// 示例：
    /// ```swift
    /// if let targetVC = self.navigationController?.viewControllers.first(where: { $0 is TargetViewController }) {
    ///     self.dd_pop2(targetVC, animated: true)
    /// }
    /// ```
    func dd_pop2(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(viewController, animated: animated)
    }

    /// 返回到指定类型的控制器
    ///
    /// 从导航栈顶部开始逐个查找目标控制器类型，返回到目标控制器。
    ///
    /// - Parameters:
    ///   - aClass: 目标控制器类型
    ///   - animated: 是否动画（默认为 `false`）
    /// - Returns: 是否成功返回到目标控制器
    ///
    /// 示例：
    /// ```swift
    /// if self.dd_pop2(TargetViewController.self, animated: true) {
    ///     print("成功返回到目标控制器")
    /// }
    /// ```
    @discardableResult
    func dd_pop2<T: UIViewController>(_ aClass: T, animated: Bool = false) -> Bool {
        guard let navigationController else { return false }

        for viewController in navigationController.viewControllers.reversed() {
            if viewController is T {
                navigationController.popToViewController(viewController, animated: animated)
                return true
            }
        }
        return false
    }

    /// 返回指定数量的控制器
    ///
    /// - Parameters:
    ///   - count: 需要返回的控制器数量
    ///   - animated: 是否动画（默认为 `false`）
    ///
    /// 示例：
    /// ```swift
    /// // 返回两个控制器
    /// self.dd_pop(2, animated: true)
    /// ```
    func dd_pop(_ count: Int, animated: Bool = false) {
        guard let navigationController else { return }
        guard count > 0 else { return }

        let viewControllers = navigationController.viewControllers
        if count >= viewControllers.count {
            // 如果要返回的数量超过当前栈的控制器数量，返回到根控制器
            navigationController.popToRootViewController(animated: animated)
        } else {
            // 返回到指定数量前的控制器
            let targetIndex = viewControllers.count - count - 1
            let targetController = viewControllers[targetIndex]
            navigationController.popToViewController(targetController, animated: animated)
        }
    }

    /// 释放当前以`Modal`方式显示的控制器
    ///
    /// 用于关闭以`present`方式弹出的控制器。
    ///
    /// - Parameters:
    ///   - animated: 是否显示关闭动画，默认值为`true`
    ///   - completion: 关闭完成后的回调，默认值为`nil`
    ///
    /// 示例：
    /// ```swift
    /// let modalVC = UIViewController()
    /// self.present(modalVC, animated: true)
    ///
    /// // 在需要关闭时调用
    /// modalVC.dd_dismiss {
    ///     print("Modal 控制器已关闭")
    /// }
    /// ```
    func dd_dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }

    /// 关闭当前显示的控制器
    ///
    /// 根据当前控制器的显示方式自动选择返回或关闭：
    /// - 如果当前控制器在导航栈中，执行`pop`操作。
    /// - 如果当前控制器是以`Modal`方式显示，则执行`dismiss`操作。
    ///
    /// - Parameter animated: 是否显示关闭动画，默认值为`true`
    ///
    /// 示例：
    /// ```swift
    /// // 在导航栈中关闭当前控制器
    /// self.close()
    ///
    /// // 以 Modal 方式关闭当前控制器
    /// let modalVC = UIViewController()
    /// self.present(modalVC, animated: true)
    /// modalVC.dd_close()
    /// ```
    func dd_close(animated: Bool = true) {
        if let navigationController, navigationController.viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: animated)
        } else if presentingViewController != nil {
            self.dismiss(animated: animated, completion: nil)
        }
    }
}

// MARK: - 链式语法
public extension UIViewController {
    /// 设置控制器的用户界面样式（亮色/黑暗模式）
    /// - Parameter userInterfaceStyle: 用户界面样式（如 `.light`, `.dark`, `.unspecified`）
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// controller.dd_overrideUserInterfaceStyle(.dark)
    /// ```
    @discardableResult
    func dd_overrideUserInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) -> Self {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = userInterfaceStyle
        }
        return self
    }

    /// 设置是否允许滚动视图自动调整内边距（iOS 11 以下版本）
    /// - Parameter automaticallyAdjustsScrollViewInsets: 是否允许自动调整
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// controller.dd_automaticallyAdjustsScrollViewInsets(true)
    /// ```
    @discardableResult
    func dd_automaticallyAdjustsScrollViewInsets(_ automaticallyAdjustsScrollViewInsets: Bool) -> Self {
        if #available(iOS 11, *) {} else { // 仅适用于 iOS11 以下版本
            self.automaticallyAdjustsScrollViewInsets = automaticallyAdjustsScrollViewInsets
        }
        return self
    }

    /// 设置模态视图的呈现样式
    /// - Parameter style: 模态呈现样式（如 `.fullScreen`, `.pageSheet`）
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// controller.dd_modalPresentationStyle(.fullScreen)
    /// ```
    @discardableResult
    func dd_modalPresentationStyle(_ style: UIModalPresentationStyle) -> Self {
        self.modalPresentationStyle = style
        return self
    }

    /// 设置控制器根视图的背景颜色
    /// - Parameter backgroundColor: 要设置的背景颜色
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// controller.dd_backgroundColor(.white)
    /// ```
    @discardableResult
    func dd_backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.view.backgroundColor = backgroundColor
        return self
    }
}
