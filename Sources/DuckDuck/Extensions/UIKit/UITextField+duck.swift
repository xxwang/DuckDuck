//
//  UITextField+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - Defaultable
public extension UITextField {
    typealias Associatedtype = UITextField
    override open class func `default`() -> Associatedtype {
        return UITextField()
    }
}

// MARK: - 链式语法
public extension UITextField {
    /// 设置文字
    /// - Parameter text:文字
    /// - Returns:`Self`
    @discardableResult
    func dd_text(_ text: String) -> Self {
        self.text = text
        return self
    }

    /// 设置富文本
    /// - Parameter attributedText:富文本文字
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }

    /// 设置占位符
    /// - Parameter placeholder:占位符文字
    /// - Returns:`Self`
    @discardableResult
    func dd_placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }

    /// 设置富文本占位符
    /// - Parameter attributedPlaceholder:富文本占位符
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedPlaceholder(_ attributedPlaceholder: NSAttributedString) -> Self {
        self.attributedPlaceholder = attributedPlaceholder
        return self
    }

    /// 设置文本格式
    /// - Parameter textAlignment:文本格式
    /// - Returns:`Self`
    @discardableResult
    func dd_textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter textColor:文本颜色
    /// - Returns:`Self`
    @discardableResult
    func dd_textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }

    /// 设置文本字体
    /// - Parameter font:字体
    /// - Returns:`Self`
    @discardableResult
    func dd_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    /// 设置字体根据控件大小自动调整
    /// - Parameter adjustsFontSizeToFitWidth: 是否自动适配宽度
    /// - Returns: `Self`
    func dd_adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }

    /// 设置代理
    /// - Parameter delegate:代理
    /// - Returns:`Self`
    @discardableResult
    func dd_delegate(_ delegate: UITextFieldDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置键盘类型
    /// - Parameter keyboardType:键盘样式
    /// - Returns:`Self`
    @discardableResult
    func dd_keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }

    /// 设置键盘`return`键类型
    /// - Parameter returnKeyType:按钮样式
    /// - Returns:`Self`
    @discardableResult
    func dd_returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.returnKeyType = returnKeyType
        return self
    }

    /// 设置左侧`view`模式
    /// - Parameter mode:模式
    /// - Returns:`Self`
    @discardableResult
    func dd_leftViewMode(_ mode: ViewMode) -> Self {
        self.leftViewMode = mode
        return self
    }

    /// 设置右侧`view`模式
    /// - Parameter mode:模式
    /// - Returns:`Self`
    @discardableResult
    func dd_rightViewMode(_ mode: ViewMode) -> Self {
        self.rightViewMode = mode
        return self
    }

    /// 添加左边的内边距
    /// - Parameter padding:边距
    /// - Returns:`Self`
    @discardableResult
    func dd_leftPadding(_ padding: CGFloat) -> Self {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        self.leftViewMode = .always
        return self
    }

    /// 添加右边的内边距
    /// - Parameter padding:边距
    /// - Returns:`Self`
    @discardableResult
    func dd_rightPadding(_ padding: CGFloat) -> Self {
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        self.rightViewMode = .always
        return self
    }

    /// 添加左边的`view`
    /// - Parameters:
    ///   - leftView:要添加的view
    ///   - containerRect:容器大小
    ///   - contentRect:内容大小
    /// - Returns:`Self`
    @discardableResult
    func dd_leftView(_ leftView: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        // 容器
        let containerView = UIView(frame: containerRect)
        // 内容
        if let contentRect { leftView?.frame = contentRect }
        // 添加内容
        if let leftView { containerView.addSubview(leftView) }

        self.leftView = containerView
        self.leftViewMode = .always

        return self
    }

    /// 添加右边的`view`
    /// - Parameters:
    ///   - view:要添加的view
    ///   - containerRect:容器大小
    ///   - contentRect:内容大小
    /// - Returns:`Self`
    @discardableResult
    func dd_rightView(_ rightView: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        // 容器
        let containerView = UIView(frame: containerRect)
        // 内容
        if let contentRect { rightView?.frame = contentRect }
        // 添加内容
        if let rightView { containerView.addSubview(rightView) }

        self.rightView = containerView
        self.rightViewMode = .always

        return self
    }

    /// 添加输入框辅助视图
    /// - Parameters:
    ///   - view:要添加的view
    /// - Returns:`Self`
    @discardableResult
    func dd_inputAccessoryView(_ inputAccessoryView: UIView?) -> Self {
        self.inputAccessoryView = inputAccessoryView
        return self
    }

    /// 添加输入框视图
    /// - Parameters:
    ///   - view:要添加的view
    /// - Returns:`Self`
    @discardableResult
    func dd_inputView(_ inputView: UIView) -> Self {
        self.inputView = inputView
        return self
    }

    /// 将`UIToolbar`添加到`UITextField`的`inputAccessoryView`
    /// - Parameters:
    ///   - toobar: 工具栏
    /// - Returns: `Self`
    @discardableResult
    func dd_toolbar(_ toobar: UIToolbar) -> Self {
        self.inputAccessoryView = toobar
        return self
    }
}
