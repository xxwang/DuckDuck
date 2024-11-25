//
//  UITableView+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UITableView {
    /// 设置 `delegate`
    /// - Parameter delegate: `UITableViewDelegate` 实例
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.delegate(self)
    /// ```
    @discardableResult
    func delegate(_ delegate: UITableViewDelegate) -> Self {
        self.base.delegate = delegate
        return self
    }

    /// 设置 `dataSource` 代理
    /// - Parameter dataSource: `UITableViewDataSource` 实例
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.dataSource(self)
    /// ```
    @discardableResult
    func dataSource(_ dataSource: UITableViewDataSource) -> Self {
        self.base.dataSource = dataSource
        return self
    }

    /// 注册 `UITableViewCell`
    /// - Parameter name: `UITableViewCell` 类型
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.register(cellWithClass: CustomCell.self)
    /// ```
    @discardableResult
    func register<T: UITableViewCell>(cellWithClass name: T.Type) -> Self {
        self.base.register(T.self, forCellReuseIdentifier: String(describing: name))
        return self
    }

    /// 设置行高
    /// - Parameter height: 行高
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.rowHeight(50)
    /// ```
    @discardableResult
    func rowHeight(_ height: CGFloat) -> Self {
        self.base.rowHeight = height
        return self
    }

    /// 设置段头(`sectionHeaderHeight`)的高度
    /// - Parameter height: 组头的高度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.sectionHeaderHeight(30)
    /// ```
    @discardableResult
    func sectionHeaderHeight(_ height: CGFloat) -> Self {
        self.base.sectionHeaderHeight = height
        return self
    }

    /// 设置组脚(`sectionFooterHeight`)的高度
    /// - Parameter height: 组脚的高度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.sectionFooterHeight(20)
    /// ```
    @discardableResult
    func sectionFooterHeight(_ height: CGFloat) -> Self {
        self.base.sectionFooterHeight = height
        return self
    }

    /// 设置一个默认（预估）`cell` 高度
    /// - Parameter height: 默认 `cell` 高度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.estimatedRowHeight(44)
    /// ```
    @discardableResult
    func estimatedRowHeight(_ height: CGFloat) -> Self {
        self.base.estimatedRowHeight = height
        return self
    }

    /// 设置默认段头（`estimatedSectionHeaderHeight`）高度
    /// - Parameter height: 组头高度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.estimatedSectionHeaderHeight(30)
    /// ```
    @discardableResult
    func estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        self.base.estimatedSectionHeaderHeight = height
        return self
    }

    /// 设置默认组脚（`estimatedSectionFooterHeight`）高度
    /// - Parameter height: 组脚高度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.estimatedSectionFooterHeight(20)
    /// ```
    @discardableResult
    func estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        self.base.estimatedSectionFooterHeight = height
        return self
    }

    /// 设置键盘消息模式
    /// - Parameter mode: `UIScrollView.KeyboardDismissMode` 模式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.keyboardDismissMode(.onDrag)
    /// ```
    @discardableResult
    func keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        self.base.keyboardDismissMode = mode
        return self
    }

    /// 设置 `Cell` 是否自动缩进
    /// - Parameter cellLayoutMarginsFollowReadableWidth: 是否留白
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.cellLayoutMarginsFollowReadableWidth(true)
    /// ```
    @discardableResult
    func cellLayoutMarginsFollowReadableWidth(_ cellLayoutMarginsFollowReadableWidth: Bool) -> Self {
        self.base.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth
        return self
    }

    /// 设置分割线的样式
    /// - Parameter style: `UITableViewCell.SeparatorStyle` 样式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.separatorStyle(.singleLine)
    /// ```
    @discardableResult
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle = .none) -> Self {
        self.base.separatorStyle = style
        return self
    }

    /// 设置 `UITableView` 的头部 `tableHeaderView`
    /// - Parameter head: 头部视图
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.tableHeaderView(customHeaderView)
    /// ```
    @discardableResult
    func tableHeaderView(_ head: UIView?) -> Self {
        self.base.tableHeaderView = head
        return self
    }

    /// 设置 `UITableView` 的尾部 `tableFooterView`
    /// - Parameter foot: 尾部视图
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.tableFooterView(customFooterView)
    /// ```
    @discardableResult
    func tableFooterView(_ foot: UIView?) -> Self {
        self.base.tableFooterView = foot
        return self
    }

    /// 移除 `tableHeaderView`
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.removeTableHeaderView()
    /// ```
    @discardableResult
    func removeTableHeaderView() -> Self {
        self.base.tableHeaderView = nil
        return self
    }

    /// 移除 `tableFooterView`
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.removeTableFooterView()
    /// ```
    @discardableResult
    func removeTableFooterView() -> Self {
        self.base.tableFooterView = nil
        return self
    }

    /// 设置内容调整行为
    /// - Parameter behavior: 行为
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.contentInsetAdjustmentBehavior(.always)
    /// ```
    @discardableResult
    func contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        if #available(iOS 11, *) {
            self.base.contentInsetAdjustmentBehavior = behavior
        }
        return self
    }

    /// 设置组头间距
    /// - Parameter topPadding: 间距
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.sectionHeaderTopPadding(10)
    /// ```
    @discardableResult
    func sectionHeaderTopPadding(_ topPadding: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            self.base.sectionHeaderTopPadding = topPadding
        }
        return self
    }

    /// 滚动到指定 `IndexPath`
    /// - Parameters:
    ///   - indexPath: 要滚动到的 `cell` `IndexPath`
    ///   - scrollPosition: 滚动的方式
    ///   - animated: 是否要动画
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.scrollTo(IndexPath(row: 2, section: 0))
    /// ```
    @discardableResult
    func scrollTo(_ indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        if indexPath.section < 0
            || indexPath.row < 0
            || indexPath.section >= self.base.numberOfSections
            || indexPath.row >= self.base.numberOfRows(inSection: indexPath.section)
        {
            return self
        }
        self.base.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到最近选中的 `cell` (选中的 `cell` 消失在屏幕中，触发事件可以滚动到选中的 `cell`)
    /// - Parameters:
    ///   - scrollPosition: 滚动的方式
    ///   - animated: 是否要动画
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.scrollToNearestSelectedRow()
    /// ```
    @discardableResult
    func scrollToNearestSelectedRow(at scrollPosition: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        self.base.scrollToNearestSelectedRow(at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到顶部
    /// - Parameter animated: 是否要动画
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.scrollToTop(animated: true)
    /// ```
    @discardableResult
    func scrollToTop(animated: Bool) -> Self {
        self.base.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        return self
    }

    /// 滚动到底部
    /// - Parameter animated: 是否要动画
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.scrollToBottom(animated: true)
    /// ```
    @discardableResult
    func scrollToBottom(animated: Bool) -> Self {
        let y = self.base.contentSize.height - self.base.frame.size.height
        if y < 0 { return self }
        self.base.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        return self
    }

    /// 滚动到指定内容位置 (`contentOffset`)
    /// - Parameters:
    ///   - contentOffset: 要滚动到的 `CGPoint` 内容位置
    ///   - animated: 是否要动画
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd.scrollToContentOffset(CGPoint(x: 0, y: 100), animated: true)
    /// ```
    @discardableResult
    func scrollToContentOffset(_ contentOffset: CGPoint, animated: Bool) -> Self {
        self.base.setContentOffset(contentOffset, animated: animated)
        return self
    }
}
