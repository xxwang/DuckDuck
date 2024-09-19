//
//  UITableViewCell+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 计算属性
public extension UITableViewCell {
    /// 标识符(使用类名注册时)
    func dd_identifier() -> String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Self.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }

    /// `cell`所在`UITableView`
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
    /// 设置`UITableViewCell`选中样式
    /// - Parameter style:样式
    /// - Returns:`Self`
    @discardableResult
    func dd_selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        self.selectionStyle = style
        return self
    }
}
