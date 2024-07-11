//
//  UISearchBar+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 计算属性
public extension DDExtension where Base: UISearchBar {
    /// 搜索栏中的`UITextField`(如果适用)
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return self.base.searchTextField
        }
        let subViews = self.base.subviews.flatMap(\.subviews)
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
}

// MARK: - Defaultable
public extension UISearchBar {
    typealias Associatedtype = UISearchBar

    @objc override class func `default`() -> Associatedtype {
        return UISearchBar()
    }
}

// MARK: - 链式语法
public extension UISearchBar {
    /// 清空输入框内容
    /// - Returns: `Self`
    @discardableResult
    func dd_clear() -> Self {
        self.text = nil
        return self
    }
}
