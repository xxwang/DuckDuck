//
//  UINavigationItem+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UINavigationItem {
    /// 设置大导航标题显示模式
    /// - Parameter mode: `LargeTitleDisplayMode` 模式，控制大标题的显示行为
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationItem.dd.largeTitleDisplayMode(.always)
    /// ```
    @discardableResult
    func largeTitleDisplayMode(_ mode: UINavigationItem.LargeTitleDisplayMode) -> Self {
        self.base.largeTitleDisplayMode = mode
        return self
    }

    /// 设置导航标题
    /// - Parameter title: 要显示的标题文本
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationItem.dd.title("Home")
    /// ```
    @discardableResult
    func title(_ title: String?) -> Self {
        self.base.title = title
        return self
    }

    /// 设置自定义标题栏视图
    /// - Parameter view: 自定义的标题栏视图
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// let customTitleView = UIView()
    /// navigationItem.dd.titleView(customTitleView)
    /// ```
    @discardableResult
    func titleView(_ view: UIView?) -> Self {
        self.base.titleView = view
        return self
    }

    /// 设置导航栏的 `backBarButtonItem`
    /// - Parameters:
    ///   - title: 返回按钮的标题
    /// - Returns: `Self`
    @discardableResult
    func backBarButton(title: String?, style: UIBarButtonItem.Style = .plain) -> Self {
        let backButton = UIBarButtonItem(title: title, style: style, target: nil, action: nil)
        self.base.backBarButtonItem = backButton
        return self
    }

    /// 设置导航栏左侧按钮
    /// - Parameter button: 左侧按钮
    /// - Returns: `Self`
    @discardableResult
    func leftBarButton(_ button: UIBarButtonItem) -> Self {
        self.base.leftBarButtonItem = button
        return self
    }

    /// 设置导航栏右侧按钮
    /// - Parameter button: 右侧按钮
    /// - Returns: `Self`
    @discardableResult
    func rightBarButton(_ button: UIBarButtonItem) -> Self {
        self.base.rightBarButtonItem = button
        return self
    }
}
