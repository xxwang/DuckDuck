//
//  UITableViewCell+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 计算属性
public extension DDExtension where Base: UITableViewCell {
    /// 标识符(使用类名注册时)
    var identifier: String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Base.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }

    /// `cell`所在`UITableView`
    var tableView: UITableView? {
        for view in sequence(first: self.base.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}

// MARK: - Defaultable
public extension UITableViewCell {
    typealias Associatedtype = UITableViewCell
    override open class func `default`() -> Associatedtype {
        return UITableViewCell()
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
