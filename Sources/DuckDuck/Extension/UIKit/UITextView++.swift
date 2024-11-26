//
//  UITextView++.swift
//  DuckDuck
//
//  Created by xxwang on 24/11/2024.
//

import UIKit

// MARK: - Creatable
public extension UITextView {
    /// 纯净的创建方法
    static func create<T: UITextView>(_ aClass: T.Type = UITextView.self) -> T {
        let textView = UITextView()
        return textView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITextView>(_ aClass: T.Type = UITextView.self) -> T {
        let textView: UITextView = self.create()
        return textView as! T
    }
}

// MARK: - 方法
public extension UITextView {
    /// 限制输入的字数
    ///
    /// 该方法在 `textView(_:shouldChangeTextIn:replacementText:)` 中调用，用于限制 `UITextView` 中输入的字符数，并可以指定正则表达式来限制输入的内容。
    ///
    /// - Parameters:
    ///   - range: 当前编辑的文本范围
    ///   - text: 输入的文本
    ///   - maxCharacters: 限制的最大字符数
    ///   - regex: 可输入内容的正则表达式，默认为 `nil`，不限制正则表达式
    /// - Returns: 返回是否允许继续输入（`true` 表示允许，`false` 表示不允许）
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_inputRestrictions(shouldChangeTextIn: range, replacementText: text, maxCharacters: 100, regex: "^[a-zA-Z]+$")
    /// ```
    func dd_inputRestrictions(shouldChangeTextIn range: NSRange, replacementText text: String, maxCharacters: Int, regex: String?) -> Bool {
        guard !text.isEmpty else { return true }
        guard let oldContent = self.text else { return false }

        if let _ = self.markedTextRange {
            // 有高亮联想中，正则判断
            guard range.length != 0 else { return oldContent.count + 1 <= maxCharacters }
            if let weakRegex = regex, !text.dd_isMatchRegexp(weakRegex) { return false }

            let allContent = oldContent.dd_subString(to: range.location) + text
            if allContent.count > maxCharacters {
                let newContent = allContent.dd_subString(to: maxCharacters)
                self.text = newContent
                return false
            }
        } else {
            guard !text.dd_isNineKeyBoard() else { return true }
            if let weakRegex = regex, !text.dd_isMatchRegexp(weakRegex) { return false }
            guard oldContent.count + text.count <= maxCharacters else { return false }
        }
        return true
    }

    /// 添加链接文本 (链接为空时则表示普通文本)
    ///
    /// 该方法将文本内容添加到 `UITextView` 中，并在文本中添加一个超链接（如果提供了 `linkAddr`）。如果没有提供链接地址，则只是普通文本。
    ///
    /// - Parameters:
    ///   - linkString: 要添加的文本
    ///   - font: 字体样式
    ///   - linkAddr: 链接地址，默认为 `nil`，如果有该地址则会将其作为超链接插入
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_appendLinkString("Click Here", font: UIFont.systemFont(ofSize: 14), linkAddr: "http://example.com")
    /// ```
    func dd_appendLinkString(_ linkString: String, font: UIFont, linkAddr: String? = nil) {
        let addAttributes = [NSAttributedString.Key.font: font]
        let linkAttributedString = NSMutableAttributedString(string: linkString, attributes: addAttributes)

        // 如果提供了链接地址，则将其添加为超链接
        if let linkAddr {
            linkAttributedString.beginEditing()
            linkAttributedString.addAttribute(NSAttributedString.Key.link,
                                              value: linkAddr,
                                              range: linkString.dd_fullNSRange())
            linkAttributedString.endEditing()
        }

        // 将新文本与现有的文本合并
        self.attributedText = self.attributedText
            .dd_toNSMutableAttributedString()
            .dd_append(linkAttributedString)
    }

    /// 转换特殊符号标签字段（如 `@` 或 `#`），并将其转化为可点击的超链接
    ///
    /// 该方法会查找文本中的 `@` 和 `#` 符号，并将其转换为超链接，使得用户点击时可以跳转到特定的地址。通过这种方式，您可以轻松将文本中的标签（如用户提及、话题标签等）转化为可点击的链接。
    ///
    /// - Example:
    ///   - 输入: "@hangge" 会被转换为可点击的链接
    ///   - 输入: "#topic#" 会被转换为可点击的链接
    ///   - 输入: "@user1 @user2 #topic1 #topic2" 会分别转换为可点击的用户和话题链接
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_resolveHashTags()
    /// // 输入文本: "Hello @hangge! Check out #topic#."
    /// // 结果: "@hangge" 会变成一个可点击的链接，"#topic#" 会变成另一个可点击的链接。
    /// ```
    func dd_resolveHashTags() {
        let nsText: NSString = self.text! as NSString
        let m_attributedText = (self.text ?? "").dd_toNSMutableAttributedString().dd_font(self.font)

        var bookmark = 0
        let charactersSet = CharacterSet(charactersIn: "@#")
        let sentences: [String] = self.text.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for sentence in sentences {
            // 跳过有效的 URL 链接
            if !sentence.dd_isValidURL() {
                let words: [String] = sentence.components(separatedBy: charactersSet)
                var bookmark2 = bookmark
                for i in 0 ..< words.count {
                    let word = words[i]
                    let keyword = dd_chopOffNonAlphaNumericCharacters(word) ?? ""
                    if keyword != "", i > 0 {
                        let remainingRangeLength = min(nsText.length - bookmark2 + 1, word.count + 2)
                        let remainingRange = NSRange(location: bookmark2 - 1, length: remainingRangeLength)
                        let encodeKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

                        // 匹配 @某人
                        var matchRange = nsText.range(of: "@\(keyword)", options: .literal, range: remainingRange)
                        m_attributedText.addAttribute(NSAttributedString.Key.link, value: "test1:\(encodeKeyword)", range: matchRange)

                        // 匹配 #话题#
                        matchRange = nsText.range(of: "#\(keyword)#", options: .literal, range: remainingRange)
                        m_attributedText.addAttribute(NSAttributedString.Key.link, value: "test2:\(encodeKeyword)", range: matchRange)
                    }
                    bookmark2 += word.count + 1
                }
            }
            bookmark += sentence.count + 1
        }

        self.attributedText = m_attributedText
    }

    /// 过滤掉多余的非字母数字字符部分
    ///
    /// 该方法会过滤掉文本中的非字母和数字字符，只保留字母和数字字符。
    ///
    /// - Parameter text: 需要处理的文本
    /// - Returns: 返回过滤后的字符串，移除特殊字符
    ///
    /// 示例：
    /// ```swift
    /// let result = textView.dd_chopOffNonAlphaNumericCharacters("@hangge.123") // 返回 "hangge"
    /// ```
    private func dd_chopOffNonAlphaNumericCharacters(_ text: String) -> String? {
        let nonAlphaNumericCharacters = CharacterSet.alphanumerics.inverted
        return text.components(separatedBy: nonAlphaNumericCharacters).first
    }
}

// MARK: - 链式语法
public extension UITextView {
    /// 设置是否可以编辑
    /// - Parameter isEditable: 是否可以编辑
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_isEditable(true)
    /// ```
    @discardableResult
    func dd_isEditable(_ isEditable: Bool) -> Self {
        self.isEditable = isEditable
        return self
    }

    /// 清空内容
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_clear()
    /// ```
    @discardableResult
    func dd_clear() -> Self {
        self.text = ""
        self.attributedText = "".dd_toNSAttributedString()
        return self
    }

    /// 设置文字
    /// - Parameter text: 文字内容
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_text("Hello World")
    /// ```
    @discardableResult
    func dd_text(_ text: String) -> Self {
        self.text = text
        return self
    }

    /// 设置富文本
    /// - Parameter attributedText: 富文本文字
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_attributedText(NSAttributedString(string: "Styled Text"))
    /// ```
    @discardableResult
    func dd_attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }

    /// 设置文本格式
    /// - Parameter textAlignment: 文本对齐方式
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_textAlignment(.center)
    /// ```
    @discardableResult
    func dd_textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color: 文本颜色
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_textColor(.red)
    /// ```
    @discardableResult
    func dd_textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }

    /// 设置文本字体
    /// - Parameter font: 字体样式
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_font(UIFont.systemFont(ofSize: 16))
    /// ```
    @discardableResult
    func dd_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_delegate(self)
    /// ```
    @discardableResult
    func dd_delegate(_ delegate: UITextViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置键盘类型
    /// - Parameter keyboardType: 键盘样式
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_keyboardType(.numberPad)
    /// ```
    @discardableResult
    func dd_keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }

    /// 设置键盘 `return` 键类型
    /// - Parameter returnKeyType: `return` 键按钮样式
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_returnKeyType(.done)
    /// ```
    @discardableResult
    func dd_returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.returnKeyType = returnKeyType
        return self
    }

    /// 设置 `Return` 键是否有内容才可以点击
    /// - Parameter enable: 是否开启
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_enablesReturnKeyAutomatically(true)
    /// ```
    @discardableResult
    func dd_enablesReturnKeyAutomatically(_ enable: Bool) -> Self {
        self.enablesReturnKeyAutomatically = enable
        return self
    }

    /// 设置内容容器的外间距
    /// - Parameter textContainerInset: 外间距
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_textContainerInset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    /// ```
    @discardableResult
    func dd_textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
        self.textContainerInset = textContainerInset
        return self
    }

    /// 设置文本容器左右内间距
    /// - Parameter lineFragmentPadding: 左右内间距
    /// - Returns: `Self`，以便链式调用
    ///
    /// 示例：
    /// ```swift
    /// textView.dd_lineFragmentPadding(10)
    /// ```
    @discardableResult
    func dd_lineFragmentPadding(_ lineFragmentPadding: CGFloat) -> Self {
        self.textContainer.lineFragmentPadding = lineFragmentPadding
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
        self.scrollRangeToVisible(range)
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
        let range = NSRange(location: (text as NSString).length - 1, length: 1)
        self.scrollRangeToVisible(range)
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
        self.contentInset = .zero
        self.scrollIndicatorInsets = .zero
        self.contentOffset = .zero
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
        self.sizeToFit()
        return self
    }
}
