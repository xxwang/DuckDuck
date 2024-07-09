//
//  UITabBarController+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - 计算属性
public extension DDExtension where Base: UITabBarController {
    /// `UITabBarController`选中索引
    static var selectIndex: Int {
        get { return self.current?.selectedIndex ?? 0 }
        set { self.current?.selectedIndex = newValue }
    }
    
    /// 当前作为`rootViewController` 
    static var current: UITabBarController? {
        guard let tabBarController = UIWindow.dd.mainWindow?.rootViewController as? UITabBarController else {
            return nil
        }
        return tabBarController
    }
}

extension UITabBarController: DDExtensionable {}

// MARK: - Defaultable
public extension UITabBarController {
    public typealias Associatedtype = UITabBarController
    open override class func `default`() -> Associatedtype {
        return UITabBarController()
    }
}

// MARK: - 链式语法
public extension UITabBarController {
    /// 设置`UITabBarController`代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    @discardableResult
    func dd_delegate(_ delegate: UITabBarControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置`UITabBarController`子控制器
    /// - Parameter viewControllers: 子控制器
    /// - Returns: `Self`
    @discardableResult
    func dd_viewControllers(_ viewControllers: [UIViewController]?) -> Self {
        self.viewControllers = viewControllers
        return self
    }

    /// 设置`UITabBarController`子控制器
    /// - Parameters:
    ///   - viewControllers: 子控制器
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dd_setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool = false) -> Self {
        self.setViewControllers(viewControllers, animated: animated)
        return self
    }

    /// 设置选中指定标签
    /// - Parameter index: 标签索引
    /// - Returns: `Self`
    @discardableResult
    func dd_selectedIndex(_ index: Int) -> Self {
        self.selectedIndex = index
        return self
    }
}



