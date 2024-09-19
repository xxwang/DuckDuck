//
//  UISearchBar+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 计算属性
public extension UISearchBar {
    /// 搜索栏中的`UITextField`(如果适用)
    var dd_textField: UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        }
        let subViews = self.subviews.flatMap(\.subviews)
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
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
