//
//  UITextField+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UITextField {
    /// 设置文字
    /// - Parameter text: 文字
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.text("Hello, World!")
    /// ```
    @discardableResult
    func text(_ text: String) -> Self {
        self.base.text = text
        return self
    }

    /// 设置富文本
    /// - Parameter attributedText: 富文本文字
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSAttributedString(string: "Hello", attributes: [.foregroundColor: UIColor.red])
    /// textField.dd.attributedText(attributedString)
    /// ```
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString) -> Self {
        self.base.attributedText = attributedText
        return self
    }

    /// 设置占位符
    /// - Parameter placeholder: 占位符文字
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.placeholder("Enter your name")
    /// ```
    @discardableResult
    func placeholder(_ placeholder: String) -> Self {
        self.base.placeholder = placeholder
        return self
    }

    /// 设置富文本占位符
    /// - Parameter attributedPlaceholder: 富文本占位符
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let attributedPlaceholder = NSAttributedString(string: "Enter your name", attributes: [.foregroundColor: UIColor.gray])
    /// textField.dd.attributedPlaceholder(attributedPlaceholder)
    /// ```
    @discardableResult
    func attributedPlaceholder(_ attributedPlaceholder: NSAttributedString) -> Self {
        self.base.attributedPlaceholder = attributedPlaceholder
        return self
    }

    /// 设置文本格式
    /// - Parameter textAlignment: 文本格式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.textAlignment(.center)
    /// ```
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.base.textAlignment = textAlignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter textColor: 文本颜色
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.textColor(.blue)
    /// ```
    @discardableResult
    func textColor(_ textColor: UIColor) -> Self {
        self.base.textColor = textColor
        return self
    }

    /// 设置文本字体
    /// - Parameter font: 字体
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.font(.systemFont(ofSize: 18))
    /// ```
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.base.font = font
        return self
    }

    /// 设置字体根据控件大小自动调整
    /// - Parameter adjustsFontSizeToFitWidth: 是否自动适配宽度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.adjustsFontSizeToFitWidth(true)
    /// ```
    func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        self.base.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }

    /// 设置代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.delegate(self)
    /// ```
    @discardableResult
    func delegate(_ delegate: UITextFieldDelegate) -> Self {
        self.base.delegate = delegate
        return self
    }

    /// 设置键盘类型
    /// - Parameter keyboardType: 键盘样式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.keyboardType(.emailAddress)
    /// ```
    @discardableResult
    func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.base.keyboardType = keyboardType
        return self
    }

    /// 设置键盘`return`键类型
    /// - Parameter returnKeyType: 按钮样式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.returnKeyType(.done)
    /// ```
    @discardableResult
    func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.base.returnKeyType = returnKeyType
        return self
    }

    /// 设置是否开启安全模式
    /// - Parameter isEnable: 是否开启
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.secureTextEntry(true)
    /// ```
    @discardableResult
    func secureTextEntry(_ isEnable: Bool) -> Self {
        self.base.isSecureTextEntry = isEnable
        return self
    }

    /// 设置左侧`view`模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.leftViewMode(.always)
    /// ```
    @discardableResult
    func leftViewMode(_ mode: UITextField.ViewMode) -> Self {
        self.base.leftViewMode = mode
        return self
    }

    /// 设置右侧`view`模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.rightViewMode(.whileEditing)
    /// ```
    @discardableResult
    func rightViewMode(_ mode: UITextField.ViewMode) -> Self {
        self.base.rightViewMode = mode
        return self
    }

    /// 添加左边的内边距
    /// - Parameter padding: 边距
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.leftPadding(10)
    /// ```
    @discardableResult
    func leftPadding(_ padding: CGFloat) -> Self {
        self.base.leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.base.frame.height))
        self.base.leftViewMode = .always
        return self
    }

    /// 添加右边的内边距
    /// - Parameter padding: 边距
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd.rightPadding(10)
    /// ```
    @discardableResult
    func rightPadding(_ padding: CGFloat) -> Self {
        self.base.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.base.frame.height))
        self.base.rightViewMode = .always
        return self
    }

    /// 添加左边的`view`
    /// - Parameters:
    ///   - leftView: 要添加的 view
    ///   - containerRect: 容器大小
    ///   - contentRect: 内容大小
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let leftView = UIImageView(image: UIImage(named: "icon"))
    /// textField.dd.leftView(leftView, containerRect: CGRect(x: 0, y: 0, width: 40, height: 40), contentRect: CGRect(x: 0, y: 0, width: 20, height: 20))
    /// ```
    @discardableResult
    func leftView(_ leftView: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        let containerView = UIView(frame: containerRect)
        if let contentRect { leftView?.frame = contentRect }
        if let leftView { containerView.addSubview(leftView) }
        self.base.leftView = containerView
        self.base.leftViewMode = .always
        return self
    }

    /// 添加右边的`view`
    /// - Parameters:
    ///   - view: 要添加的 view
    ///   - containerRect: 容器大小
    ///   - contentRect: 内容大小
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let rightView = UIImageView(image: UIImage(named: "icon"))
    /// textField.dd.rightView(rightView, containerRect: CGRect(x: 0, y: 0, width: 40, height: 40), contentRect: CGRect(x: 0, y: 0, width: 20, height: 20))
    /// ```
    @discardableResult
    func rightView(_ rightView: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        let containerView = UIView(frame: containerRect)
        if let contentRect { rightView?.frame = contentRect }
        if let rightView { containerView.addSubview(rightView) }
        self.base.rightView = containerView
        self.base.rightViewMode = .always
        return self
    }

    /// 添加输入框辅助视图
    /// - Parameter inputAccessoryView: 要添加的 view
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let toolbar = UIToolbar()
    /// textField.dd.inputAccessoryView(toolbar)
    /// ```
    @discardableResult
    func inputAccessoryView(_ inputAccessoryView: UIView?) -> Self {
        self.base.inputAccessoryView = inputAccessoryView
        return self
    }

    /// 添加输入框视图
    /// - Parameters:
    ///   - inputView: 要添加的 view
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let customInputView = UIView()
    /// textField.dd.inputView(customInputView)
    /// ```
    @discardableResult
    func inputView(_ inputView: UIView) -> Self {
        self.base.inputView = inputView
        return self
    }

    /// 将`UIToolbar`添加到`UITextField`的`inputAccessoryView`
    /// - Parameters:
    ///   - toobar: 工具栏
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let toolbar = UIToolbar()
    /// textField.dd.toolbar(toolbar)
    /// ```
    @discardableResult
    func toolbar(_ toobar: UIToolbar) -> Self {
        self.base.inputAccessoryView = toobar
        return self
    }
}
