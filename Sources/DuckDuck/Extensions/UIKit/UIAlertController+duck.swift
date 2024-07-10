//
//  UIAlertController+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - Defaultable
public extension UIAlertController {
    typealias Associatedtype = UIAlertController
    override open class func `default`() -> Associatedtype {
        return UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    }
}

// MARK: - 链式语法
public extension UIAlertController {
    /// 设置标题
    /// - Parameter title:标题
    /// - Returns:`Self`
    @discardableResult
    func dd_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置消息(副标题)
    /// - Parameter message:消息内容
    /// - Returns:`Self`
    @discardableResult
    func dd_message(_ message: String?) -> Self {
        self.message = message
        return self
    }

    /// 添加 `UIAlertAction`
    /// - Parameter action:`UIAlertAction` 事件
    /// - Returns:`Self`
    @discardableResult
    func dd_addAction(_ action: UIAlertAction) -> Self {
        self.addAction(action)
        return self
    }

    /// 添加一个`UIAlertAction`
    /// - Parameters:
    ///   - title:标题
    ///   - style:样式
    ///   - isEnable:是否激活
    ///   - action:点击处理回调
    /// - Returns:`Self`
    @discardableResult
    func dd_addAction_(title: String, style: UIAlertAction.Style = .default, action: ((UIAlertAction) -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: action)
        self.addAction(action)
        return self
    }

    /// 添加一个`UITextField`
    /// - Parameters:
    ///   - text:输入框默认文字
    ///   - placeholder:占位文本
    ///   - target:事件响应者
    ///   - action:事件响应方法
    /// - Returns:`Self`
    @discardableResult
    func dd_addTextField(_ text: String? = nil, placeholder: String? = nil, target: Any?, action: Selector?) -> Self {
        self.addTextField { textField in
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
