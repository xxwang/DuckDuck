//
//  UISearchBar+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UISearchBar {
    /// 清空搜索框内容
    ///
    /// 该方法将清空 `UISearchBar` 中的文本框内容，返回 `self` 以支持链式调用。
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd.clear()
    /// ```
    @discardableResult
    func clear() -> Self {
        self.base.text = nil
        return self
    }

    /// 设置搜索栏占位符
    /// - Parameter placeholder: 占位符文本
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd.setPlaceholder("Search here")
    /// ```
    @discardableResult
    func setPlaceholder(_ placeholder: String) -> Self {
        self.base.placeholder = placeholder
        return self
    }

    /// 设置搜索栏样式
    /// - Parameter style: 样式类型，默认为 `.prominent`
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd.setStyle(.minimal)
    /// ```
    @discardableResult
    func setStyle(_ style: UISearchBar.Style) -> Self {
        self.base.searchBarStyle = style
        return self
    }

    /// 设置搜索栏的取消按钮标题
    /// - Parameter title: 取消按钮的标题
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd.setCancelButtonTitle("Done")
    /// ```
    @discardableResult
    func setCancelButtonTitle(_ title: String) -> Self {
        if let cancelButton = self.base.value(forKey: "_cancelButton") as? UIButton {
            cancelButton.setTitle(title, for: .normal)
        }
        return self
    }

    /// 设置背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd.setBackgroundColor(.lightGray)
    /// ```
    @discardableResult
    func setBackgroundColor(_ color: UIColor) -> Self {
        self.base.barTintColor = color
        return self
    }

    /// 设置文本输入框的背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd.setTextFieldBackgroundColor(.white)
    /// ```
    @discardableResult
    func setTextFieldBackgroundColor(_ color: UIColor) -> Self {
        self.base.dd_textField?.backgroundColor = color
        return self
    }
}
