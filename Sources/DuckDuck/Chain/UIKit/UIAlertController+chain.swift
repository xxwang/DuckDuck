//
//  UIAlertController+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIAlertController {
    /// 设置标题
    /// - Parameter title: 标题
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let alert = UIAlertController().dd.title("警告")
    /// ```
    @discardableResult
    func title(_ title: String?) -> Self {
        self.base.title = title
        return self
    }

    /// 设置消息(副标题)
    /// - Parameter message: 消息内容
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let alert = UIAlertController().dd.message("请确认您的操作")
    /// ```
    @discardableResult
    func message(_ message: String?) -> Self {
        self.base.message = message
        return self
    }

    /// 添加 `UIAlertAction`
    /// - Parameter action: `UIAlertAction` 事件
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let action = UIAlertAction(title: "确定", style: .default, handler: nil)
    /// let alert = UIAlertController().dd.addAction(action)
    /// ```
    @discardableResult
    func addAction(_ action: UIAlertAction) -> Self {
        self.base.addAction(action)
        return self
    }

    /// 添加一个 `UIAlertAction`
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - action: 点击处理回调
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let alert = UIAlertController().dd.addAction_(title: "确定", style: .default) { _ in
    ///     print("点击确定")
    /// }
    /// ```
    @discardableResult
    func addAction_(title: String, style: UIAlertAction.Style = .default, action: ((UIAlertAction) -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: action)
        self.base.addAction(action)
        return self
    }

    /// 添加一个 `UITextField`
    /// - Parameters:
    ///   - text: 输入框默认文字
    ///   - placeholder: 占位文本
    ///   - target: 事件响应者
    ///   - action: 事件响应方法
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let alert = UIAlertController().dd.addTextField(text: "默认文字", placeholder: "请输入", target: self, action: #selector(textFieldChanged))
    /// ```
    @discardableResult
    func addTextField(_ text: String? = nil, placeholder: String? = nil, target: Any?, action: Selector?) -> Self {
        self.base.addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
            if let target,
               let action
            {
                textField.addTarget(target, action: action, for: .editingChanged)
            }
        }
        return self
    }
}
