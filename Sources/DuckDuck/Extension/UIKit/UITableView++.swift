//
//  UITableView++.swift
//  DuckDuck
//
//  Created by xxwang on 24/11/2024.
//

import UIKit

// MARK: - 方法
public extension UITableView {
    /// 重新加载数据后调用 `completion` 回调
    /// - Parameter completion: 完成回调
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_reloadData {
    ///     print("Reload complete")
    /// }
    /// ```
    func dd_reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}

// MARK: - UITableViewCell复用相关
public extension UITableView {
    /// 使用类名注册 `UITableViewCell`
    /// - Parameters:
    ///   - nib: 用于创建 `UITableViewCell` 的 nib 文件
    ///   - name: `UITableViewCell` 类型
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_register(nib: customNib, withCellClass: CustomCell.self)
    /// ```
    func dd_register(nib: UINib?, withCellClass name: (some UITableViewCell).Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }

    /// 注册 `UITableViewCell`，使用其对应类的 xib 文件
    /// 假设 `xib` 文件名和 cell 类具有相同的名称
    /// - Parameters:
    ///   - name: `UITableViewCell` 类型
    ///   - bundleClass: `bundle` 实例基于的类
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_register(nibWithCellClass: CustomCell.self, at: SomeClass.self)
    /// ```
    func dd_register(nibWithCellClass name: (some UITableViewCell).Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        self.register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }

    /// 使用类名获取可重用的 `UITableViewCell`
    /// - Parameter name: `UITableViewCell` 类型
    /// - Returns: 类名关联的 `UITableViewCell` 对象
    ///
    /// 示例：
    /// ```swift
    /// let cell: CustomCell = tableView.dd_dequeueReusableCell(withClass: CustomCell.self)
    /// ```
    func dd_dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

    /// 使用类名和 `indexPath` 获取可重用的 `UITableViewCell`
    /// - Parameters:
    ///   - name: `UITableViewCell` 类型
    ///   - indexPath: 单元格在 `tableView` 中的位置
    /// - Returns: 类名关联的 `UITableViewCell` 对象
    ///
    /// 示例：
    /// ```swift
    /// let cell: CustomCell = tableView.dd_dequeueReusableCell(withClass: CustomCell.self, for: indexPath)
    /// ```
    func dd_dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }
}

// MARK: - UITableViewHeaderFooterView复用相关
public extension UITableView {
    /// 使用类名注册 `UITableViewHeaderFooterView`
    /// - Parameters:
    ///   - nib: 用于创建页眉或页脚视图的 `nib` 文件
    ///   - name: `UITableViewHeaderFooterView` 类型
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_register(nib: customNib, withHeaderFooterViewClass: CustomHeaderFooterView.self)
    /// ```
    func dd_register(nib: UINib?, withHeaderFooterViewClass name: (some UITableViewHeaderFooterView).Type) {
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    /// 使用类名注册 `UITableViewHeaderFooterView`
    /// - Parameter name: `UITableViewHeaderFooterView` 类型
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_register(headerFooterViewClassWith: CustomHeaderFooterView.self)
    /// ```
    func dd_register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    /// 使用类名获取可重用的 `UITableViewHeaderFooterView`
    /// - Parameter name: `UITableViewHeaderFooterView` 类型
    /// - Returns: 类名关联的 `UITableViewHeaderFooterView` 对象
    ///
    /// 示例：
    /// ```swift
    /// let headerFooterView: CustomHeaderFooterView = tableView.dd_dequeueReusableHeaderFooterView(withClass: CustomHeaderFooterView.self)
    /// ```
    func dd_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewHeaderFooterView for \(String(describing: name)), make sure the view is registered with table view")
        }
        return headerFooterView
    }
}

// MARK: - Creatable
public extension Creatable where Self: UITableView {
    @MainActor
    static func create() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }

    @MainActor
    static func `default`() -> UITableView {
        let tableView = self.create()
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
    /// - Parameter delegate: `UITableViewDelegate` 实例
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_delegate(self)
    /// ```
    @discardableResult
    func dd_delegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 `dataSource` 代理
    /// - Parameter dataSource: `UITableViewDataSource` 实例
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_dataSource(self)
    /// ```
    @discardableResult
    func dd_dataSource(_ dataSource: UITableViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    /// 注册 `UITableViewCell`
    /// - Parameter name: `UITableViewCell` 类型
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_register(cellWithClass: CustomCell.self)
    /// ```
    @discardableResult
    func dd_register<T: UITableViewCell>(cellWithClass name: T.Type) -> Self {
        self.register(T.self, forCellReuseIdentifier: String(describing: name))
        return self
    }

    /// 设置行高
    /// - Parameter height: 行高
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_rowHeight(50)
    /// ```
    @discardableResult
    func dd_rowHeight(_ height: CGFloat) -> Self {
        self.rowHeight = height
        return self
    }

    /// 设置段头(`sectionHeaderHeight`)的高度
    /// - Parameter height: 组头的高度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_sectionHeaderHeight(30)
    /// ```
    @discardableResult
    func dd_sectionHeaderHeight(_ height: CGFloat) -> Self {
        self.sectionHeaderHeight = height
        return self
    }

    /// 设置组脚(`sectionFooterHeight`)的高度
    /// - Parameter height: 组脚的高度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_sectionFooterHeight(20)
    /// ```
    @discardableResult
    func dd_sectionFooterHeight(_ height: CGFloat) -> Self {
        self.sectionFooterHeight = height
        return self
    }

    /// 设置一个默认（预估）`cell` 高度
    /// - Parameter height: 默认 `cell` 高度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_estimatedRowHeight(44)
    /// ```
    @discardableResult
    func dd_estimatedRowHeight(_ height: CGFloat) -> Self {
        self.estimatedRowHeight = height
        return self
    }

    /// 设置默认段头（`estimatedSectionHeaderHeight`）高度
    /// - Parameter height: 组头高度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_estimatedSectionHeaderHeight(30)
    /// ```
    @discardableResult
    func dd_estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionHeaderHeight = height
        return self
    }

    /// 设置默认组脚（`estimatedSectionFooterHeight`）高度
    /// - Parameter height: 组脚高度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_estimatedSectionFooterHeight(20)
    /// ```
    @discardableResult
    func dd_estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionFooterHeight = height
        return self
    }

    /// 设置键盘消息模式
    /// - Parameter mode: `UIScrollView.KeyboardDismissMode` 模式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_keyboardDismissMode(.onDrag)
    /// ```
    @discardableResult
    func dd_keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        self.keyboardDismissMode = mode
        return self
    }

    /// 设置 `Cell` 是否自动缩进
    /// - Parameter cellLayoutMarginsFollowReadableWidth: 是否留白
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_cellLayoutMarginsFollowReadableWidth(true)
    /// ```
    @discardableResult
    func dd_cellLayoutMarginsFollowReadableWidth(_ cellLayoutMarginsFollowReadableWidth: Bool) -> Self {
        self.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth
        return self
    }

    /// 设置分割线的样式
    /// - Parameter style: `UITableViewCell.SeparatorStyle` 样式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_separatorStyle(.singleLine)
    /// ```
    @discardableResult
    func dd_separatorStyle(_ style: UITableViewCell.SeparatorStyle = .none) -> Self {
        self.separatorStyle = style
        return self
    }

    /// 设置 `UITableView` 的头部 `tableHeaderView`
    /// - Parameter head: 头部视图
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_tableHeaderView(customHeaderView)
    /// ```
    @discardableResult
    func dd_tableHeaderView(_ head: UIView?) -> Self {
        self.tableHeaderView = head
        return self
    }

    /// 设置 `UITableView` 的尾部 `tableFooterView`
    /// - Parameter foot: 尾部视图
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_tableFooterView(customFooterView)
    /// ```
    @discardableResult
    func dd_tableFooterView(_ foot: UIView?) -> Self {
        self.tableFooterView = foot
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
        self.tableHeaderView = nil
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
        self.tableFooterView = nil
        return self
    }

    /// 设置内容调整行为
    /// - Parameter behavior: 行为
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_contentInsetAdjustmentBehavior(.always)
    /// ```
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
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_sectionHeaderTopPadding(10)
    /// ```
    @discardableResult
    func dd_sectionHeaderTopPadding(_ topPadding: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = topPadding
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
    /// tableView.dd_scrollTo(IndexPath(row: 2, section: 0))
    /// ```
    @discardableResult
    func dd_scrollTo(_ indexPath: IndexPath, at scrollPosition: ScrollPosition = .middle, animated: Bool = true) -> Self {
        if indexPath.section < 0
            || indexPath.row < 0
            || indexPath.section >= self.numberOfSections
            || indexPath.row >= self.numberOfRows(inSection: indexPath.section)
        {
            return self
        }
        self.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
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
    /// tableView.dd_scrollToNearestSelectedRow()
    /// ```
    @discardableResult
    func dd_scrollToNearestSelectedRow(at scrollPosition: ScrollPosition = .middle, animated: Bool = true) -> Self {
        self.scrollToNearestSelectedRow(at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到顶部
    /// - Parameter animated: 是否要动画
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_scrollToTop(animated: true)
    /// ```
    @discardableResult
    func dd_scrollToTop(animated: Bool) -> Self {
        self.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        return self
    }

    /// 滚动到底部
    /// - Parameter animated: 是否要动画
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tableView.dd_scrollToBottom(animated: true)
    /// ```
    @discardableResult
    func dd_scrollToBottom(animated: Bool) -> Self {
        let y = self.contentSize.height - frame.size.height
        if y < 0 { return self }
        self.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
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
    /// tableView.dd_scrollToContentOffset(CGPoint(x: 0, y: 100), animated: true)
    /// ```
    @discardableResult
    func dd_scrollToContentOffset(_ contentOffset: CGPoint, animated: Bool) -> Self {
        self.setContentOffset(contentOffset, animated: animated)
        return self
    }
}
