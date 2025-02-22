import UIKit

// MARK: - 链式语法
public extension DDExtension where Base: UITextView {
    /// 设置是否可以编辑
    /// - Parameter isEditable: 是否可以编辑
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.isEditable(true)
    /// ```
    @discardableResult
    func isEditable(_ isEditable: Bool) -> Self {
        self.base.isEditable = isEditable
        return self
    }

    /// 清空内容
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.clear()
    /// ```
    @discardableResult
    func clear() -> Self {
        self.base.text = ""
        self.base.attributedText = "".dd_toNSAttributedString()
        return self
    }

    /// 设置文字
    /// - Parameter text: 文字内容
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.text("Hello World")
    /// ```
    @discardableResult
    func text(_ text: String) -> Self {
        self.base.text = text
        return self
    }

    /// 设置富文本
    /// - Parameter attributedText: 富文本文字
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.attributedText(NSAttributedString(string: "Styled Text"))
    /// ```
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString) -> Self {
        self.base.attributedText = attributedText
        return self
    }

    /// 设置文本格式
    /// - Parameter textAlignment: 文本对齐方式
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.textAlignment(.center)
    /// ```
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.base.textAlignment = textAlignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color: 文本颜色
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.textColor(.red)
    /// ```
    @discardableResult
    func textColor(_ textColor: UIColor) -> Self {
        self.base.textColor = textColor
        return self
    }

    /// 设置文本字体
    /// - Parameter font: 字体样式
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.font(UIFont.systemFont(ofSize: 16))
    /// ```
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.base.font = font
        return self
    }

    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.delegate(self)
    /// ```
    @discardableResult
    func delegate(_ delegate: UITextViewDelegate) -> Self {
        self.base.delegate = delegate
        return self
    }

    /// 设置键盘类型
    /// - Parameter keyboardType: 键盘样式
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.keyboardType(.numberPad)
    /// ```
    @discardableResult
    func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.base.keyboardType = keyboardType
        return self
    }

    /// 设置键盘 `return` 键类型
    /// - Parameter returnKeyType: `return` 键按钮样式
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.returnKeyType(.done)
    /// ```
    @discardableResult
    func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.base.returnKeyType = returnKeyType
        return self
    }

    /// 设置 `Return` 键是否有内容才可以点击
    /// - Parameter enable: 是否开启
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.enablesReturnKeyAutomatically(true)
    /// ```
    @discardableResult
    func enablesReturnKeyAutomatically(_ enable: Bool) -> Self {
        self.base.enablesReturnKeyAutomatically = enable
        return self
    }

    /// 设置内容容器的外间距
    /// - Parameter textContainerInset: 外间距
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.textContainerInset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    /// ```
    @discardableResult
    func textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
        self.base.textContainerInset = textContainerInset
        return self
    }

    /// 设置文本容器左右内间距
    /// - Parameter lineFragmentPadding: 左右内间距
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd.lineFragmentPadding(10)
    /// ```
    @discardableResult
    func lineFragmentPadding(_ lineFragmentPadding: CGFloat) -> Self {
        self.base.textContainer.lineFragmentPadding = lineFragmentPadding
        return self
    }

    /// 滚动到文本视图的顶部
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.scrollToTop()
    /// ```
    @discardableResult
    func scrollToTop() -> Self {
        let range = NSRange(location: 0, length: 1)
        self.base.scrollRangeToVisible(range)
        return self
    }

    /// 滚动到文本视图的底部
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.scrollToBottom()
    /// ```
    @discardableResult
    func scrollToBottom() -> Self {
        let range = NSRange(location: (self.base.text as NSString).length - 1, length: 1)
        self.base.scrollRangeToVisible(range)
        return self
    }

    /// 调整大小到内容的大小
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.wrapToContent()
    /// ```
    @discardableResult
    func wrapToContent() -> Self {
        self.base.contentInset = .zero
        self.base.scrollIndicatorInsets = .zero
        self.base.contentOffset = .zero
        self.base.textContainerInset = .zero
        self.base.textContainer.lineFragmentPadding = 0
        self.base.sizeToFit()
        return self
    }
}
