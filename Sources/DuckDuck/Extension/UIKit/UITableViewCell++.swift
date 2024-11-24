//
//  UITableViewCell++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 23/11/2024.
//

import UIKit

// MARK: - 计算属性
public extension UITableViewCell {
    /// 标识符(使用类名注册时)
    /// - Returns: 返回 `UITableViewCell` 的类名
    ///
    /// 示例：
    /// ```swift
    /// let identifier = cell.dd_identifier()
    /// ```
    func dd_identifier() -> String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Self.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }

    /// `cell`所在的 `UITableView`
    /// - Returns: 返回包含当前 `UITableViewCell` 的 `UITableView`，如果没有找到则返回 `nil`
    ///
    /// 示例：
    /// ```swift
    /// if let tableView = cell.dd_tableView() {
    ///     // 找到所在的 UITableView
    /// }
    /// ```
    func dd_tableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}

// MARK: - 链式语法
public extension UITableViewCell {
    /// 设置 `UITableViewCell` 的选中样式
    /// - Parameter style: 样式，选择一种选中样式
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// cell.dd_selectionStyle(.none)
    /// ```
    @discardableResult
    func dd_selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        self.selectionStyle = style
        return self
    }
}
