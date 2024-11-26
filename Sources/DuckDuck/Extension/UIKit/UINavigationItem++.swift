//
//  UINavigationItem++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - Creatable
public extension UINavigationItem {
    /// 纯净的创建方法
    static func create<T: UINavigationItem>(_ aClass: T.Type = UINavigationItem.self) -> T {
        let navigationItem = UINavigationItem()
        return navigationItem as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UINavigationItem>(_ aClass: T.Type = UINavigationItem.self) -> T {
        let navigationItem: UINavigationItem = self.create()
        return navigationItem as! T
    }
}

// MARK: - 方法
public extension UINavigationItem {
    /// 设置导航栏 `titleView` 为图片
    /// - Parameters:
    ///   - image: 要设置的图片
    ///   - size: 设置图片的大小，默认是 (100, 30)
    /// - Example:
    /// ```swift
    /// navigationItem.dd_titleView(with: UIImage(named: "logo")!, size: CGSize(width: 150, height: 40))
    /// ```
    func dd_titleView(with image: UIImage, size: CGSize = CGSize(width: 100, height: 30)) {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: size))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.titleView = imageView
    }
}

// MARK: - 链式语法
public extension UINavigationItem {
    /// 设置大导航标题显示模式
    /// - Parameter mode: `LargeTitleDisplayMode` 模式，控制大标题的显示行为
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationItem.dd_largeTitleDisplayMode(.always)
    /// ```
    @discardableResult
    func dd_largeTitleDisplayMode(_ mode: LargeTitleDisplayMode) -> Self {
        self.largeTitleDisplayMode = mode
        return self
    }

    /// 设置导航标题
    /// - Parameter title: 要显示的标题文本
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationItem.dd_title("Home")
    /// ```
    @discardableResult
    func dd_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置自定义标题栏视图
    /// - Parameter view: 自定义的标题栏视图
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// let customTitleView = UIView()
    /// navigationItem.dd_titleView(customTitleView)
    /// ```
    @discardableResult
    func dd_titleView(_ view: UIView?) -> Self {
        self.titleView = view
        return self
    }

    /// 设置导航栏的 `backBarButtonItem`
    /// - Parameters:
    ///   - title: 返回按钮的标题
    /// - Returns: `Self`
    @discardableResult
    func dd_backBarButton(title: String?, style: UIBarButtonItem.Style = .plain) -> Self {
        let backButton = UIBarButtonItem(title: title, style: style, target: nil, action: nil)
        self.backBarButtonItem = backButton
        return self
    }

    /// 设置导航栏左侧按钮
    /// - Parameter button: 左侧按钮
    /// - Returns: `Self`
    @discardableResult
    func dd_leftBarButton(_ button: UIBarButtonItem) -> Self {
        self.leftBarButtonItem = button
        return self
    }

    /// 设置导航栏右侧按钮
    /// - Parameter button: 右侧按钮
    /// - Returns: `Self`
    @discardableResult
    func dd_rightBarButton(_ button: UIBarButtonItem) -> Self {
        self.rightBarButtonItem = button
        return self
    }
}
