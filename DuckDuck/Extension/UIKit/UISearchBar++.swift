import UIKit

// MARK: - 计算属性
public extension UISearchBar {
    /// 搜索栏中的`UITextField`(如果适用)
    ///
    /// 该计算属性返回 `UISearchBar` 中的 `UITextField`。iOS 13 及以上版本直接访问 `searchTextField`，低于 iOS 13 会遍历子视图查找 `UITextField`。
    ///
    /// 示例:
    /// ```swift
    /// let textField = searchBar.dd_textField
    /// ```
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
    /// 清空搜索框内容
    ///
    /// 该方法将清空 `UISearchBar` 中的文本框内容，返回 `self` 以支持链式调用。
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd_clear()
    /// ```
    @discardableResult
    func dd_clear() -> Self {
        self.text = nil
        return self
    }

    /// 设置搜索栏占位符
    /// - Parameter placeholder: 占位符文本
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd_placeholder("Search here")
    /// ```
    @discardableResult
    func dd_placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }

    /// 设置搜索栏样式
    /// - Parameter style: 样式类型，默认为 `.prominent`
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd_searchBarStyle(.minimal)
    /// ```
    @discardableResult
    func dd_searchBarStyle(_ style: UISearchBar.Style) -> Self {
        self.searchBarStyle = style
        return self
    }

    /// 设置搜索栏的取消按钮标题
    /// - Parameter title: 取消按钮的标题
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd_cancelButtonTitle("Done")
    /// ```
    @discardableResult
    func dd_cancelButtonTitle(_ title: String) -> Self {
        if let cancelButton = self.value(forKey: "_cancelButton") as? UIButton {
            cancelButton.setTitle(title, for: .normal)
        }
        return self
    }

    /// 设置文本输入框的背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// searchBar.dd_textFieldBackgroundColor(.white)
    /// ```
    @discardableResult
    func dd_textFieldBackgroundColor(_ color: UIColor) -> Self {
        self.dd_textField?.backgroundColor = color
        return self
    }

    /// 设置代理并返回当前的 UISearchBar 实例，支持链式调用
    /// - Parameter delegate: 一个符合 `UISearchBarDelegate` 协议的代理对象。
    /// - Returns: 当前的 `UISearchBar` 实例，支持链式调用。
    ///
    /// 示例用法：
    /// ```swift
    /// let searchBar = UISearchBar()
    /// searchBar.dd_delegate(self)
    /// ```
    @discardableResult
    func dd_delegate(_ delegate: (any UISearchBarDelegate)?) -> Self {
        self.delegate = delegate
        return self
    }
}
