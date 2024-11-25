//
//  UIRefreshControl+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIRefreshControl {
    /// 设置刷新控件的富文本标题
    /// - Parameters:
    ///   - title: 标题文本
    ///   - attributes: 富文本属性，默认为空
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd.title("Pull to refresh", attributes: [.foregroundColor: UIColor.gray])
    /// ```
    @discardableResult
    func title(_ title: String, attributes: [NSAttributedString.Key: Any] = [:]) -> Self {
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.base.attributedTitle = attributedTitle
        return self
    }

    /// 设置刷新控件的背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd.backgroundColor(.lightGray)
    /// ```
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        self.base.backgroundColor = color
        return self
    }

    /// 设置刷新控件的进度颜色
    /// - Parameter color: 进度颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd.tintColor(.blue)
    /// ```
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.base.tintColor = color
        return self
    }

    /// 添加刷新事件的回调
    /// - Parameters:
    ///   - target: 事件目标对象
    ///   - action: 事件方法
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd.addTarget(self, action: #selector(handleRefresh))
    /// ```
    @discardableResult
    func addTarget(_ target: Any?, action: Selector) -> Self {
        self.base.addTarget(target, action: action, for: .valueChanged)
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
    /// refreshControl.dd.startRefreshing(in: scrollView, animated: true, sendAction: true)
    /// ```
    @discardableResult
    func startRefreshing(in scrollView: UIScrollView, animated: Bool, sendAction: Bool = false) -> Self {
        guard self.base.superview == scrollView else {
            assertionFailure("Refresh control does not belong to the receiving scroll view")
            return self
        }

        self.base.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -self.base.frame.height)
        scrollView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            self.base.sendActions(for: .valueChanged)
        }
        return self
    }

    /// 停止刷新
    /// - Parameter animated: 是否以动画形式结束刷新
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// refreshControl.dd.stopRefreshing(animated: true)
    /// ```
    @discardableResult
    func stopRefreshing(animated: Bool = true) -> Self {
        self.base.endRefreshing()
        if animated, let scrollView = self.base.superview as? UIScrollView {
            UIView.animate(withDuration: 0.25) {
                scrollView.contentOffset = .zero
            }
        }
        return self
    }
}
