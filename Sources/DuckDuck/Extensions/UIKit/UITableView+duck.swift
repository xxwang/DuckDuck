//
//  UITableView+duck.swift
//
//
//  Created by 王哥 on 2024/7/4.
//

import UIKit

public extension UITableView {
    static func `default`() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
            .dd_rowHeight(UITableView.automaticDimension)
            .dd_estimatedRowHeight(50)
            .dd_backgroundColor(.clear)
            .dd_sectionHeaderHeight(0.001)
            .dd_sectionFooterHeight(0.001)
            .dd_showsHorizontalScrollIndicator(false)
            .dd_showsVerticalScrollIndicator(false)
            .dd_cellLayoutMarginsFollowReadableWidth(false)
            .dd_separatorStyle(.none)
            .dd_keyboardDismissMode(.onDrag)
            .dd_showsHorizontalScrollIndicator(false)
            .dd_showsVerticalScrollIndicator(false)
            .dd_contentInsetAdjustmentBehavior(.never)
            .dd_sectionHeaderTopPadding(0)
        return tableView
    }
}

// MARK: - 链式语法
public extension UITableView {
    /// 设置 `delegate`
    /// - Parameter delegate:`delegate`
    /// - Returns:`Self`
    @discardableResult
    func dd_delegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 `dataSource` 代理
    /// - Parameter dataSource:`dataSource`
    /// - Returns:`Self`
    @discardableResult
    func dd_dataSource(_ dataSource: UITableViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    /// 注册`cell`
    /// - Returns:`Self`
    @discardableResult
    func dd_register<T: UITableViewCell>(cellWithClass name: T.Type) -> Self {
        self.register(T.self, forCellReuseIdentifier: String(describing: name))
        return self
    }

    /// 设置行高
    /// - Parameter height:行高
    /// - Returns:`Self`
    @discardableResult
    func dd_rowHeight(_ height: CGFloat) -> Self {
        self.rowHeight = height
        return self
    }

    /// 设置段头(`sectionHeaderHeight`)的高度
    /// - Parameter height:组头的高度
    /// - Returns:`Self`
    @discardableResult
    func dd_sectionHeaderHeight(_ height: CGFloat) -> Self {
        self.sectionHeaderHeight = height
        return self
    }

    /// 设置组脚(`sectionFooterHeight`)的高度
    /// - Parameter height:组脚的高度
    /// - Returns:`Self`
    @discardableResult
    func dd_sectionFooterHeight(_ height: CGFloat) -> Self {
        self.sectionFooterHeight = height
        return self
    }

    /// 设置一个默认(预估)`cell`高度
    /// - Parameter height:默认`cell`高度
    /// - Returns:`Self`
    @discardableResult
    func dd_estimatedRowHeight(_ height: CGFloat) -> Self {
        self.estimatedRowHeight = height
        return self
    }

    /// 设置默认段头(`estimatedSectionHeaderHeight`)高度
    /// - Parameter height:组头高度
    /// - Returns:`Self`
    @discardableResult
    func dd_estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionHeaderHeight = height
        return self
    }

    /// 设置默认组脚(`estimatedSectionFooterHeight`)高度
    /// - Parameter height:组脚高度
    /// - Returns:`Self`
    @discardableResult
    func dd_estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionFooterHeight = height
        return self
    }

    /// 键盘消息模式
    /// - Parameter mode:模式
    /// - Returns:`Self`
    @discardableResult
    func dd_keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        self.keyboardDismissMode = mode
        return self
    }

    /// `Cell`是否自动缩进
    /// - Parameter cellLayoutMarginsFollowReadableWidth:是否留白
    /// - Returns:`Self`
    @discardableResult
    func dd_cellLayoutMarginsFollowReadableWidth(_ cellLayoutMarginsFollowReadableWidth: Bool) -> Self {
        self.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth
        return self
    }

    /// 设置分割线的样式
    /// - Parameter style:分割线的样式
    /// - Returns:`Self`
    @discardableResult
    func dd_separatorStyle(_ style: UITableViewCell.SeparatorStyle = .none) -> Self {
        self.separatorStyle = style
        return self
    }

    /// 设置 `UITableView` 的头部 `tableHeaderView`
    /// - Parameter head:头部 View
    /// - Returns:`Self`
    @discardableResult
    func dd_tableHeaderView(_ head: UIView?) -> Self {
        self.tableHeaderView = head
        return self
    }

    /// 设置 `UITableView` 的尾部 `tableFooterView`
    /// - Parameter foot:尾部 `View`
    /// - Returns:`Self`
    @discardableResult
    func dd_tableFooterView(_ foot: UIView?) -> Self {
        self.tableFooterView = foot
        return self
    }

    /// 移除`tableHeaderView`
    /// - Returns:`Self`
    @discardableResult
    func removeTableHeaderView() -> Self {
        self.tableHeaderView = nil
        return self
    }

    /// 移除`tableFooterView`
    /// - Returns:`Self`
    @discardableResult
    func removeTableFooterView() -> Self {
        self.tableFooterView = nil
        return self
    }

    /// 设置内容调整行为
    /// - Parameter behavior: 行为
    /// - Returns: `Self`
    @discardableResult
    func dd_contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        if #available(iOS 11, *) {
            self.contentInsetAdjustmentBehavior = behavior
        }
        return self
    }

    /// 设置组头间距
    /// - Parameter topPadding: 间距
    /// - Returns: `Self`
    @discardableResult
    func dd_sectionHeaderTopPadding(_ topPadding: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = topPadding
        }
        return self
    }

    /// 滚动到指定`IndexPath`
    /// - Parameters:
    ///   - indexPath:要滚动到的`cell``IndexPath`
    ///   - scrollPosition:滚动的方式
    ///   - animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollTo(_ indexPath: IndexPath, at scrollPosition: ScrollPosition = .middle, animated: Bool = true) -> Self {
        if indexPath.section < 0
            || indexPath.row < 0
            || indexPath.section > self.numberOfSections
            || indexPath.row > self.numberOfRows(inSection: indexPath.section)
        {
            return self
        }
        self.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到最近选中的`cell`(选中的`cell`消失在屏幕中,触发事件可以滚动到选中的`cell`)
    /// - Parameters:
    ///   - scrollPosition:滚动的方式
    ///   - animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollToNearestSelectedRow(at scrollPosition: ScrollPosition = .middle, animated: Bool = true) -> Self {
        self.scrollToNearestSelectedRow(at: scrollPosition, animated: animated)
        return self
    }

    /// 是否滚动到顶部
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollToTop(animated: Bool) -> Self {
        self.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        return self
    }

    /// 是否滚动到底部
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollToBottom(animated: Bool) -> Self {
        let y = self.contentSize.height - frame.size.height
        if y < 0 { return self }
        self.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        return self
    }

    /// 滚动到什么位置(CGPoint)
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollToContentOffset(_ contentOffset: CGPoint, animated: Bool) -> Self {
        self.setContentOffset(contentOffset, animated: animated)
        return self
    }
}
