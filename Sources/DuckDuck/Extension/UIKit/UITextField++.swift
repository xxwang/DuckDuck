//
//  UITextField++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 24/11/2024.
//

import UIKit

// MARK: - 计算属性
public extension UITextField {
    /// 内容是否为空
    /// - Returns: `true` 如果内容为空，`false` 如果有内容
    ///
    /// 示例：
    /// ```swift
    /// if textField.dd_isEmpty() {
    ///     print("内容为空")
    /// }
    /// ```
    func dd_isEmpty() -> Bool {
        return self.text.dd_isNilOrEmpty
    }
}

// MARK: - 方法
public extension UITextField {
    /// 清空内容
    /// 将 `UITextField` 的文本和富文本内容清空
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_clear()
    /// ```
    func dd_clear() {
        self.text = nil
        self.attributedText = nil
    }

    /// 将工具栏添加到 `UITextField` 的 `inputAccessoryView`
    /// - Parameters:
    ///   - items: 工具栏中的选项（例如：`UIBarButtonItem`）
    ///   - height: 工具栏高度，默认值为 44
    /// - Returns: 返回创建的 `UIToolbar`
    ///
    /// 示例：
    /// ```swift
    /// let toolBar = textField.dd_addToolbar(items: [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))])
    /// ```
    @discardableResult
    func dd_addToolbar(items: [UIBarButtonItem]?, height: CGFloat = 44) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: ScreenInfo.screenWidth, height: height)))
        toolBar.setItems(items, animated: false)
        self.inputAccessoryView = toolBar
        return toolBar
    }

    /// 限制字数的输入
    /// 用于 `UITextFieldDelegate` 方法 `textField(_:shouldChangeCharactersIn:replacementString:)`
    /// - Parameters:
    ///   - range: 当前编辑位置的范围
    ///   - text: 输入的文字
    ///   - maxCharacters: 最大字数限制
    ///   - regex: 可输入的内容的正则表达式
    /// - Returns: `true` 如果可以继续输入，`false` 如果输入不符合限制
    ///
    /// 示例：
    /// ```swift
    /// func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    ///     return textField.dd_inputRestrictions(shouldChangeTextIn: range, replacementText: string, maxCharacters: 10, regex: "[a-zA-Z0-9]")
    /// }
    /// ```
    func dd_inputRestrictions(shouldChangeTextIn range: NSRange, replacementText text: String, maxCharacters: Int, regex: String?) -> Bool {
        guard !text.isEmpty else { return true }
        guard let oldContent = self.text else { return false }

        if let _ = self.markedTextRange {
            // 有高亮联想中
            guard range.length != 0 else { return oldContent.count + 1 <= maxCharacters }
            // 无高亮
            // 正则的判断
            if let weakRegex = regex, !text.dd_isMatchRegexp(weakRegex) { return false }
            // 联想选中键盘
            let allContent = oldContent.dd_subString(to: range.location) + text
            if allContent.count > maxCharacters {
                let newContent = allContent.dd_subString(to: maxCharacters)
                self.text = newContent
                return false
            }
        } else {
            guard !text.dd_isNineKeyBoard() else { return true }
            // 正则的判断
            if let weakRegex = regex, !text.dd_isMatchRegexp(weakRegex) { return false }
            // 如果数字大于指定位数,不能输入
            guard oldContent.count + text.count <= maxCharacters else { return false }
        }
        return true
    }
}

// MARK: - 链式语法
public extension UITextField {
    /// 设置文字
    /// - Parameter text: 文字
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_text("Hello, World!")
    /// ```
    @discardableResult
    func dd_text(_ text: String) -> Self {
        self.text = text
        return self
    }

    /// 设置富文本
    /// - Parameter attributedText: 富文本文字
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSAttributedString(string: "Hello", attributes: [.foregroundColor: UIColor.red])
    /// textField.dd_attributedText(attributedString)
    /// ```
    @discardableResult
    func dd_attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }

    /// 设置占位符
    /// - Parameter placeholder: 占位符文字
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_placeholder("Enter your name")
    /// ```
    @discardableResult
    func dd_placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }

    /// 设置富文本占位符
    /// - Parameter attributedPlaceholder: 富文本占位符
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let attributedPlaceholder = NSAttributedString(string: "Enter your name", attributes: [.foregroundColor: UIColor.gray])
    /// textField.dd_attributedPlaceholder(attributedPlaceholder)
    /// ```
    @discardableResult
    func dd_attributedPlaceholder(_ attributedPlaceholder: NSAttributedString) -> Self {
        self.attributedPlaceholder = attributedPlaceholder
        return self
    }

    /// 设置文本格式
    /// - Parameter textAlignment: 文本格式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_textAlignment(.center)
    /// ```
    @discardableResult
    func dd_textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter textColor: 文本颜色
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_textColor(.blue)
    /// ```
    @discardableResult
    func dd_textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }

    /// 设置文本字体
    /// - Parameter font: 字体
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_font(.systemFont(ofSize: 18))
    /// ```
    @discardableResult
    func dd_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    /// 设置字体根据控件大小自动调整
    /// - Parameter adjustsFontSizeToFitWidth: 是否自动适配宽度
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_adjustsFontSizeToFitWidth(true)
    /// ```
    func dd_adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }

    /// 设置代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_delegate(self)
    /// ```
    @discardableResult
    func dd_delegate(_ delegate: UITextFieldDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置键盘类型
    /// - Parameter keyboardType: 键盘样式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_keyboardType(.emailAddress)
    /// ```
    @discardableResult
    func dd_keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }

    /// 设置键盘`return`键类型
    /// - Parameter returnKeyType: 按钮样式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_returnKeyType(.done)
    /// ```
    @discardableResult
    func dd_returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.returnKeyType = returnKeyType
        return self
    }

    /// 设置是否开启安全模式
    /// - Parameter isEnable: 是否开启
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_secureTextEntry(true)
    /// ```
    @discardableResult
    func dd_secureTextEntry(_ isEnable: Bool) -> Self {
        self.isSecureTextEntry = isEnable
        return self
    }

    /// 设置左侧`view`模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_leftViewMode(.always)
    /// ```
    @discardableResult
    func dd_leftViewMode(_ mode: ViewMode) -> Self {
        self.leftViewMode = mode
        return self
    }

    /// 设置右侧`view`模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_rightViewMode(.whileEditing)
    /// ```
    @discardableResult
    func dd_rightViewMode(_ mode: ViewMode) -> Self {
        self.rightViewMode = mode
        return self
    }

    /// 添加左边的内边距
    /// - Parameter padding: 边距
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_leftPadding(10)
    /// ```
    @discardableResult
    func dd_leftPadding(_ padding: CGFloat) -> Self {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        self.leftViewMode = .always
        return self
    }

    /// 添加右边的内边距
    /// - Parameter padding: 边距
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// textField.dd_rightPadding(10)
    /// ```
    @discardableResult
    func dd_rightPadding(_ padding: CGFloat) -> Self {
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        self.rightViewMode = .always
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
    /// textField.dd_leftView(leftView, containerRect: CGRect(x: 0, y: 0, width: 40, height: 40), contentRect: CGRect(x: 0, y: 0, width: 20, height: 20))
    /// ```
    @discardableResult
    func dd_leftView(_ leftView: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        let containerView = UIView(frame: containerRect)
        if let contentRect { leftView?.frame = contentRect }
        if let leftView { containerView.addSubview(leftView) }
        self.leftView = containerView
        self.leftViewMode = .always
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
    /// textField.dd_rightView(rightView, containerRect: CGRect(x: 0, y: 0, width: 40, height: 40), contentRect: CGRect(x: 0, y: 0, width: 20, height: 20))
    /// ```
    @discardableResult
    func dd_rightView(_ rightView: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        let containerView = UIView(frame: containerRect)
        if let contentRect { rightView?.frame = contentRect }
        if let rightView { containerView.addSubview(rightView) }
        self.rightView = containerView
        self.rightViewMode = .always
        return self
    }

    /// 添加输入框辅助视图
    /// - Parameter inputAccessoryView: 要添加的 view
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let toolbar = UIToolbar()
    /// textField.dd_inputAccessoryView(toolbar)
    /// ```
    @discardableResult
    func dd_inputAccessoryView(_ inputAccessoryView: UIView?) -> Self {
        self.inputAccessoryView = inputAccessoryView
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
    /// textField.dd_inputView(customInputView)
    /// ```
    @discardableResult
    func dd_inputView(_ inputView: UIView) -> Self {
        self.inputView = inputView
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
    /// textField.dd_toolbar(toolbar)
    /// ```
    @discardableResult
    func dd_toolbar(_ toobar: UIToolbar) -> Self {
        self.inputAccessoryView = toobar
        return self
    }
}
