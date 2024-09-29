//
//  UITextView+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 关联键
private class DDAssociateKeys {
    static var placeholder: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDEL".hashValue)
    static var placeholderLabel: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDELABEL".hashValue)
    static var placeholdFont: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDFONT".hashValue)
    static var placeholdColor: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDCOLOR".hashValue)
    static var placeholderOrigin: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDERORIGIN".hashValue)
}

// MARK: - 方法
public extension UITextView {
    /// 限制输入的字数
    ///
    /// 调用位置
    /// `func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool`
    ///
    /// - Parameters:
    ///   - range:范围
    ///   - text:输入的文字
    ///   - maxCharacters:限制字数
    ///   - regex:可输入内容(正则)
    /// - Returns:返回是否可输入
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

    /// 添加链接文本(链接为空时则表示普通文本)
    /// - Parameters:
    ///   - string:文本
    ///   - withURLString:链接
    func dd_appendLinkString(_ linkString: String, font: UIFont, linkAddr: String? = nil) {
        // 新增的文本内容(使用默认设置的字体样式)
        let addAttributes = [NSAttributedString.Key.font: font]
        let linkAttributedString = NSMutableAttributedString(string: linkString, attributes: addAttributes)

        // 判断是否是链接文字
        if let linkAddr {
            linkAttributedString.beginEditing()
            linkAttributedString.addAttribute(NSAttributedString.Key.link,
                                              value: linkAddr,
                                              range: linkString.dd_fullNSRange())
            linkAttributedString.endEditing()
        }

        self.attributedText = self.attributedText
            .dd_NSMutableAttributedString()
            .dd_append(linkAttributedString)
    }

    /// 转换特殊符号标签字段
    func dd_resolveHashTags() {
        let nsText: NSString = self.text! as NSString

        // 使用默认设置的字体样式
        let m_attributedText = (self.text ?? "").dd_NSMutableAttributedString().dd_font(self.font)

        // 用来记录遍历字符串的索引位置
        var bookmark = 0
        // 用于拆分的特殊符号
        let charactersSet = CharacterSet(charactersIn: "@#")

        // 先将字符串按空格和分隔符拆分
        let sentences: [String] = self.text.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for sentence in sentences {
            // 如果是url链接则跳过
            if !sentence.dd_isValidURL() {
                // 再按特殊符号拆分
                let words: [String] = sentence.components(separatedBy: charactersSet)
                var bookmark2 = bookmark
                for i in 0 ..< words.count {
                    let word = words[i]
                    let keyword = dd_chopOffNonAlphaNumericCharacters(word as String) ?? ""
                    if keyword != "", i > 0 {
                        // 使用自定义的scheme来表示各种特殊链接,比如:mention:hangge
                        // 使得这些字段会变蓝色且可点击
                        // 匹配的范围
                        let remainingRangeLength = min(nsText.length - bookmark2 + 1, word.count + 2)
                        let remainingRange = NSRange(location: bookmark2 - 1, length: remainingRangeLength)
                        // print(keyword, bookmark2, remainingRangeLength)
                        // 获取转码后的关键字,用于url里的值
                        // (确保链接的正确性,比如url链接直接用中文就会有问题)
                        let encodeKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                        // 匹配@某人
                        var matchRange = nsText.range(of: "@\(keyword)", options: .literal, range: remainingRange)
                        m_attributedText.addAttribute(NSAttributedString.Key.link, value: "test1:\(encodeKeyword)", range: matchRange)
                        // 匹配#话题#
                        matchRange = nsText.range(of: "#\(keyword)#", options: .literal, range: remainingRange)
                        m_attributedText.addAttribute(NSAttributedString.Key.link, value: "test2:\(encodeKeyword)", range: matchRange)
                        // attrString.addAttributes([NSAttributedString.Key.link :"test2:\(encodeKeyword)"], range:matchRange)
                    }
                    // 移动坐标索引记录
                    bookmark2 += word.count + 1
                }
            }
            // 移动坐标索引记录
            bookmark += sentence.count + 1
        }
        // print(nsText.length, bookmark)
        // 最终赋值
        self.attributedText = m_attributedText
    }

    /// 过滤部多余的非数字和字符的部分
    /// - Parameter text:@hangge.123 -> @hangge
    /// - Returns:返回过滤后的字符串
    private func dd_chopOffNonAlphaNumericCharacters(_ text: String) -> String? {
        let nonAlphaNumericCharacters = CharacterSet.alphanumerics.inverted
        return text.components(separatedBy: nonAlphaNumericCharacters).first
    }
}

// MARK: - 占位符Label
public extension UITextView {
    /// 设置占位符
    var dd_placeholder: String? {
        get { AssociatedObject.get(self, &DDAssociateKeys.placeholder) as? String }
        set {
            AssociatedObject.set(self, &DDAssociateKeys.placeholder, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)

            guard let dd_placeholderLabel else {
                self.dd_initPlaceholder(dd_placeholder!)
                return
            }
            dd_placeholderLabel.dd_text(dd_placeholder)
            self.dd_constraintPlaceholder()
        }
    }

    /// 占位文本字体
    var dd_placeholderFont: UIFont? {
        get {
            return (AssociatedObject.get(self, &DDAssociateKeys.placeholdFont) as? UIFont).dd_or(.systemFont(ofSize: 13))
        }
        set {
            AssociatedObject.set(self, &DDAssociateKeys.placeholdFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let dd_placeholderLabel = self.dd_placeholderLabel else { return }
            dd_placeholderLabel.dd_font(dd_placeholderFont!)
            self.dd_constraintPlaceholder()
        }
    }

    /// 占位文本的颜色
    var dd_placeholderColor: UIColor? {
        get {
            return (AssociatedObject.get(self, DDAssociateKeys.placeholdColor) as? UIColor).dd_or(.lightGray)
        }
        set {
            AssociatedObject.set(self, DDAssociateKeys.placeholdColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            dd_placeholderLabel?.textColor = dd_placeholderColor
        }
    }

    /// 设置占位文本的`Origin`
    var dd_placeholderOrigin: CGPoint? {
        get {
            return (AssociatedObject.get(self, DDAssociateKeys.placeholderOrigin) as? CGPoint).dd_or(.zero)
        }
        set {
            AssociatedObject.set(self, DDAssociateKeys.placeholderOrigin, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let dd_placeholderLabel, let dd_placeholderOrigin else { return }
            dd_placeholderLabel.frame.origin = dd_placeholderOrigin
        }
    }
}

// MARK: - 私有(占位符)
private extension UITextView {
    /// 默认文本
    var dd_placeholderLabel: UILabel? {
        set {
            AssociatedObject.set(self, DDAssociateKeys.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { AssociatedObject.get(self, DDAssociateKeys.placeholderLabel) as? UILabel }
    }

    /// 初始化占位符Label
    /// - Parameter placeholder:占位符
    func dd_initPlaceholder(_ placeholder: String) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dd_textChangeHandler(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)

        self.dd_placeholderLabel = UILabel.default()
            .dd_text(self.dd_placeholder)
            .dd_font(self.dd_placeholderFont ?? .systemFont(ofSize: 14))
            .dd_textColor(self.dd_placeholderColor ?? .gray)
            .dd_numberOfLines(0)
            .dd_add2(self)
            .dd_isHidden(text.count > 0)
        self.dd_constraintPlaceholder()
    }

    /// 为占位Label添加约束
    func dd_constraintPlaceholder() {
        guard let dd_placeholderLabel else { return }
        let placeholderSize = dd_placeholderLabel.dd_textSize(self.dd_width)
        dd_placeholderLabel.dd_frame(CGRect(origin: self.dd_placeholderOrigin.dd_or(.zero), size: placeholderSize))
    }

    /// 文本框输入内容变化通知处理
    /// - Parameter notification:动态监听
    @objc func dd_textChangeHandler(_ notification: Notification) {
        self.dd_placeholderLabel?.dd_isHidden(text.count > 0)
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
        self.attributedText = "".dd_NSAttributedString()
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
