import UIKit

extension NSMutableParagraphStyle: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base: NSMutableParagraphStyle {
    /// 设置对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd.alignment(.center)
    /// ```
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Self {
        self.base.alignment = alignment
        return self
    }

    /// 设置换行方式
    /// - Parameter lineBreakMode: 换行方式
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd.lineBreakMode(.byWordWrapping)
    /// ```
    @discardableResult
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        self.base.lineBreakMode = lineBreakMode
        return self
    }

    /// 设置行间距
    /// - Parameter lineSpacing: 行间距
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd.lineSpacing(10.0)
    /// ```
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat) -> Self {
        self.base.lineSpacing = lineSpacing
        return self
    }

    /// 设置段落间距
    /// - Parameter paragraphSpacing: 段落间距
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd.paragraphSpacing(20.0)
    /// ```
    @discardableResult
    func paragraphSpacing(_ paragraphSpacing: CGFloat) -> Self {
        self.base.paragraphSpacing = paragraphSpacing
        return self
    }

    /// 设置连字符系数
    /// - Parameter hyphenationFactor: 连字符系数
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd.hyphenationFactor(0.8)
    /// ```
    @discardableResult
    func hyphenationFactor(_ hyphenationFactor: Float) -> Self {
        self.base.hyphenationFactor = hyphenationFactor
        return self
    }

    /// 设置第一行缩进
    /// - Parameter firstLineHeadIndent: 缩进
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd.firstLineHeadIndent(15.0)
    /// ```
    @discardableResult
    func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> Self {
        self.base.firstLineHeadIndent = firstLineHeadIndent
        return self
    }

    /// 设置段落前间距
    /// - Parameter paragraphSpacingBefore: 段落前间距
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd.paragraphSpacingBefore(5.0)
    /// ```
    @discardableResult
    func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> Self {
        self.base.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }

    /// 设置头部缩进
    /// - Parameter headIndent: 头部缩进
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd.headIndent(10.0)
    /// ```
    @discardableResult
    func headIndent(_ headIndent: CGFloat) -> Self {
        self.base.headIndent = headIndent
        return self
    }

    /// 设置尾部缩进
    /// - Parameter tailIndent: 尾部缩进
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd.tailIndent(10.0)
    /// ```
    @discardableResult
    func tailIndent(_ tailIndent: CGFloat) -> Self {
        self.base.tailIndent = tailIndent
        return self
    }

    /// 设置行高倍数（基于字体大小的倍数）
    /// - Parameter lineHeightMultiple: 行高倍数
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd.lineHeightMultiple(1.5)  // 设置行高倍数为1.5倍字体大小
    /// ```
    @discardableResult
    func lineHeightMultiple(_ lineHeightMultiple: CGFloat) -> Self {
        self.base.lineHeightMultiple = lineHeightMultiple
        return self
    }

    /// 设置最小行高
    /// - Parameter minimumLineHeight: 最小行高
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd.minimumLineHeight(20.0)  // 设置最小行高为20.0
    /// ```
    @discardableResult
    func minimumLineHeight(_ minimumLineHeight: CGFloat) -> Self {
        self.base.minimumLineHeight = minimumLineHeight
        return self
    }

    /// 设置最大行高
    /// - Parameter maximumLineHeight: 最大行高
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd.maximumLineHeight(30.0)  // 设置最大行高为30.0
    /// ```
    @discardableResult
    func maximumLineHeight(_ maximumLineHeight: CGFloat) -> Self {
        self.base.maximumLineHeight = maximumLineHeight
        return self
    }

    /// 设置是否允许断字
    /// - Parameter allowsBreak: 是否允许断字
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd.allowsBreak(true)  // 启用断字
    /// ```
    @discardableResult
    func allowsBreak(_ allowsBreak: Bool) -> Self {
        // `hyphenationFactor` 控制是否启用连字符
        self.base.hyphenationFactor = allowsBreak ? 1.0 : 0.0
        return self
    }

    /// 设置段落中的字符间距
    /// - Parameter characterSpacing: 字符间距
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd.characterSpacing(1.5)  // 设置字符间距为1.5
    /// ```
    @discardableResult
    func characterSpacing(_ characterSpacing: CGFloat) -> Self {
        self.base.minimumLineHeight = characterSpacing
        return self
    }

    /// 设置文本是否以单词为单位换行
    /// - Parameter isWordWrapping: 是否以单词为单位换行
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd.wordWrapping(true)  // 设置为按单词换行
    /// ```
    @discardableResult
    func wordWrapping(_ isWordWrapping: Bool) -> Self {
        if isWordWrapping {
            self.base.lineBreakMode = .byWordWrapping
        } else {
            self.base.lineBreakMode = .byCharWrapping
        }
        return self
    }

    /// 设置段落的对齐方式与换行方式
    /// - Parameters:
    ///   - alignment: 对齐方式
    ///   - lineBreakMode: 换行方式
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd.alignmentAndLineBreakMode(alignment: .center, lineBreakMode: .byWordWrapping)
    ///     // 设置文本对齐方式为居中，换行方式为按单词换行
    /// ```
    @discardableResult
    func alignmentAndLineBreakMode(alignment: NSTextAlignment, lineBreakMode: NSLineBreakMode) -> Self {
        self.base.alignment = alignment
        self.base.lineBreakMode = lineBreakMode
        return self
    }

    /// 设置首行缩进并控制是否有连字符
    /// - Parameters:
    ///   - firstLineHeadIndent: 首行缩进
    ///   - hyphenationFactor: 连字符系数
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd.firstLineHeadIndentAndHyphenation(firstLineHeadIndent: 20.0, hyphenationFactor: 0.8)
    ///     // 设置首行缩进为20.0，允许连字符系数为0.8
    /// ```
    @discardableResult
    func firstLineHeadIndentAndHyphenation(firstLineHeadIndent: CGFloat, hyphenationFactor: Float) -> Self {
        self.base.firstLineHeadIndent = firstLineHeadIndent
        self.base.hyphenationFactor = hyphenationFactor
        return self
    }
}
