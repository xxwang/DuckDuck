//
//  UIRefreshControl++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 24/11/2024.
//

import UIKit

// MARK: - UIRefreshControl 扩展
public extension UIRefreshControl {
    /// 设置刷新控件的富文本标题
    /// - Parameters:
    ///   - title: 标题文本
    ///   - attributes: 富文本属性，默认为空
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd_title("Pull to refresh", attributes: [.foregroundColor: UIColor.gray])
    /// ```
    @discardableResult
    func dd_title(_ title: String, attributes: [NSAttributedString.Key: Any] = [:]) -> Self {
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.attributedTitle = attributedTitle
        return self
    }

    /// 设置刷新控件的背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd_backgroundColor(.lightGray)
    /// ```
    @discardableResult
    override func dd_backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }

    /// 设置刷新控件的进度颜色
    /// - Parameter color: 进度颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd_tintColor(.blue)
    /// ```
    @discardableResult
    override func dd_tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }

    /// 添加刷新事件的回调
    /// - Parameters:
    ///   - target: 事件目标对象
    ///   - action: 事件方法
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd_addTarget(self, action: #selector(handleRefresh))
    /// ```
    @discardableResult
    func dd_addTarget(_ target: Any?, action: Selector) -> Self {
        self.addTarget(target, action: action, for: .valueChanged)
        return self
    }

    /// 开始刷新并显示刷新控件
    /// - Parameters:
    ///   - scrollView: 包含刷新控件的 `UIScrollView` 或其子类
    ///   - animated: 是否需要动画设置内容偏移
    ///   - sendAction: 是否为 `valueChanged` 事件触发 `sendActions` 方法
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd_startRefreshing(in: scrollView, animated: true, sendAction: true)
    /// ```
    @discardableResult
    func dd_startRefreshing(in scrollView: UIScrollView, animated: Bool, sendAction: Bool = false) -> Self {
        guard superview == scrollView else {
            assertionFailure("Refresh control does not belong to the receiving scroll view")
            return self
        }

        self.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -frame.height)
        scrollView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            sendActions(for: .valueChanged)
        }
        return self
    }

    /// 停止刷新
    /// - Parameter animated: 是否以动画形式结束刷新
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd_stopRefreshing(animated: true)
    /// ```
    @discardableResult
    func dd_stopRefreshing(animated: Bool = true) -> Self {
        self.endRefreshing()
        if animated, let scrollView = superview as? UIScrollView {
            UIView.animate(withDuration: 0.25) {
                scrollView.contentOffset = .zero
            }
        }
        return self
    }
}
