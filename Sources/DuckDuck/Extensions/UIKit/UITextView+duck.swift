//
//  UITextView+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - Defaultable
public extension UITextView {
    typealias Associatedtype = UITextView
    override open class func `default`() -> Associatedtype {
        return UITextView()
    }
}

// MARK: - 链式语法
public extension UITextView {
    /// 设置是否可以编辑
    /// - Parameter isEditable: 是否可以编辑
    /// - Returns:`Self`
    @discardableResult
    func dd_isEditable(_ isEditable: Bool) -> Self {
        self.isEditable = isEditable
        return self
    }

    /// 清空内容
    /// - Returns:`Self`
    @discardableResult
    func dd_clear() -> Self {
        self.text = ""
        self.attributedText = "".dd.as2NSAttributedString
        return self
    }

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

    /// 设置文本格式
    /// - Parameter textAlignment:文本格式
    /// - Returns:`Self`
    @discardableResult
    func dd_textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color:文本颜色
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

    /// 设置代理
    /// - Parameter delegate:代理
    /// - Returns:`Self`
    @discardableResult
    func dd_delegate(_ delegate: UITextViewDelegate) -> Self {
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

    /// 设置`Return`键是否有内容才可以点击
    /// - Parameter enable:是否开启
    /// - Returns:`Self`
    @discardableResult
    func dd_enablesReturnKeyAutomatically(_ enable: Bool) -> Self {
        self.enablesReturnKeyAutomatically = enable
        return self
    }

    /// 设置内容容器的外间距
    /// - Parameter textContainerInset: 外间距
    /// - Returns: `Self`
    @discardableResult
    func dd_textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
        self.textContainerInset = textContainerInset
        return self
    }

    /// 设置文本容器左右内间距
    /// - Parameter lineFragmentPadding: 左右内间距
    /// - Returns: `Self`
    @discardableResult
    func dd_lineFragmentPadding(_ lineFragmentPadding: CGFloat) -> Self {
        self.textContainer.lineFragmentPadding = lineFragmentPadding
        return self
    }

    /// 滚动到文本视图的顶部
    /// - Returns: `Self`
    @discardableResult
    func scrollToTop() -> Self {
        let range = NSRange(location: 0, length: 1)
        self.scrollRangeToVisible(range)
        return self
    }

    /// 滚动到文本视图的底部
    /// - Returns: `Self`
    @discardableResult
    func scrollToBottom() -> Self {
        let range = NSRange(location: (text as NSString).length - 1, length: 1)
        self.scrollRangeToVisible(range)
        return self
    }

    /// 调整大小到内容的大小
    @discardableResult
    func wrapToContent() -> Self {
        self.contentInset = .zero
        self.scrollIndicatorInsets = .zero
        self.contentOffset = .zero
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
        self.sizeToFit()
        return self
    }
}

// MARK: - 占位符链式语法
extension UITextView {
    /// 设置占位符
    /// - Parameter placeholder:占位符文字
    /// - Returns:`Self`
    @discardableResult
    func dd_placeholder(_ placeholder: String) -> Self {
        self.dd_placeholder = placeholder
        return self
    }

    /// 设置占位符颜色
    /// - Parameter textColor:文字颜色
    /// - Returns:`Self`
    @discardableResult
    func dd_placeholderColor(_ textColor: UIColor) -> Self {
        self.dd_placeholderColor = textColor
        return self
    }

    /// 设置占位符字体
    /// - Parameter font:文字字体
    /// - Returns:`Self`
    @discardableResult
    func dd_placeholderFont(_ font: UIFont) -> Self {
        self.dd_placeholderFont = font
        return self
    }

    /// 设置占位符`Origin`
    /// - Parameter origin:`CGPoint`
    /// - Returns:`Self`
    @discardableResult
    func dd_placeholderOrigin(_ origin: CGPoint) -> Self {
        self.dd_placeholderOrigin = origin
        return self
    }
}
