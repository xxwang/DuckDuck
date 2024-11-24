//
//  NSMutableParagraphStyle++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 22/11/2024.
//

import UIKit

public extension NSMutableParagraphStyle {
    /// 返回一个默认的 `NSMutableParagraphStyle`，包含基本设置
    /// - Returns: 一个设置了基本属性的 `NSMutableParagraphStyle` 实例
    static func `default`() -> NSMutableParagraphStyle {
        return NSMutableParagraphStyle()
            .dd_hyphenationFactor(1.0) // 设置连字符系数
            .dd_firstLineHeadIndent(0.0) // 设置第一行缩进
            .dd_paragraphSpacingBefore(0.0) // 设置段落前间距
            .dd_headIndent(0) // 设置头部缩进
            .dd_tailIndent(0) // 设置尾部缩进
    }
}

// MARK: - 链式语法
public extension NSMutableParagraphStyle {
    /// 设置对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd_alignment(.center)
    /// ```
    @discardableResult
    func dd_alignment(_ alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }

    /// 设置换行方式
    /// - Parameter lineBreakMode: 换行方式
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd_lineBreakMode(.byWordWrapping)
    /// ```
    @discardableResult
    func dd_lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }

    /// 设置行间距
    /// - Parameter lineSpacing: 行间距
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd_lineSpacing(10.0)
    /// ```
    @discardableResult
    func dd_lineSpacing(_ lineSpacing: CGFloat) -> Self {
        self.lineSpacing = lineSpacing
        return self
    }

    /// 设置段落间距
    /// - Parameter paragraphSpacing: 段落间距
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd_paragraphSpacing(20.0)
    /// ```
    @discardableResult
    func dd_paragraphSpacing(_ paragraphSpacing: CGFloat) -> Self {
        self.paragraphSpacing = paragraphSpacing
        return self
    }

    /// 设置连字符系数
    /// - Parameter hyphenationFactor: 连字符系数
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd_hyphenationFactor(0.8)
    /// ```
    @discardableResult
    func dd_hyphenationFactor(_ hyphenationFactor: Float) -> Self {
        self.hyphenationFactor = hyphenationFactor
        return self
    }

    /// 设置第一行缩进
    /// - Parameter firstLineHeadIndent: 缩进
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd_firstLineHeadIndent(15.0)
    /// ```
    @discardableResult
    func dd_firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> Self {
        self.firstLineHeadIndent = firstLineHeadIndent
        return self
    }

    /// 设置段落前间距
    /// - Parameter paragraphSpacingBefore: 段落前间距
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd_paragraphSpacingBefore(5.0)
    /// ```
    @discardableResult
    func dd_paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> Self {
        self.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }

    /// 设置头部缩进
    /// - Parameter headIndent: 头部缩进
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd_headIndent(10.0)
    /// ```
    @discardableResult
    func dd_headIndent(_ headIndent: CGFloat) -> Self {
        self.headIndent = headIndent
        return self
    }

    /// 设置尾部缩进
    /// - Parameter tailIndent: 尾部缩进
    /// - Returns: `Self`
    ///
    /// ### 示例：
    /// ```swift
    /// let style = NSMutableParagraphStyle().dd_tailIndent(10.0)
    /// ```
    @discardableResult
    func dd_tailIndent(_ tailIndent: CGFloat) -> Self {
        self.tailIndent = tailIndent
        return self
    }

    /// 设置行高倍数（基于字体大小的倍数）
    /// - Parameter lineHeightMultiple: 行高倍数
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd_lineHeightMultiple(1.5)  // 设置行高倍数为1.5倍字体大小
    /// ```
    @discardableResult
    func dd_lineHeightMultiple(_ lineHeightMultiple: CGFloat) -> Self {
        self.lineHeightMultiple = lineHeightMultiple
        return self
    }

    /// 设置最小行高
    /// - Parameter minimumLineHeight: 最小行高
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd_minimumLineHeight(20.0)  // 设置最小行高为20.0
    /// ```
    @discardableResult
    func dd_minimumLineHeight(_ minimumLineHeight: CGFloat) -> Self {
        self.minimumLineHeight = minimumLineHeight
        return self
    }

    /// 设置最大行高
    /// - Parameter maximumLineHeight: 最大行高
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd_maximumLineHeight(30.0)  // 设置最大行高为30.0
    /// ```
    @discardableResult
    func dd_maximumLineHeight(_ maximumLineHeight: CGFloat) -> Self {
        self.maximumLineHeight = maximumLineHeight
        return self
    }

    /// 设置是否允许断字
    /// - Parameter allowsBreak: 是否允许断字
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd_allowsBreak(true)  // 启用断字
    /// ```
    @discardableResult
    func dd_allowsBreak(_ allowsBreak: Bool) -> Self {
        // `hyphenationFactor` 控制是否启用连字符
        self.hyphenationFactor = allowsBreak ? 1.0 : 0.0
        return self
    }

    /// 设置段落中的字符间距
    /// - Parameter characterSpacing: 字符间距
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd_characterSpacing(1.5)  // 设置字符间距为1.5
    /// ```
    @discardableResult
    func dd_characterSpacing(_ characterSpacing: CGFloat) -> Self {
        self.minimumLineHeight = characterSpacing
        return self
    }

    /// 设置文本是否以单词为单位换行
    /// - Parameter isWordWrapping: 是否以单词为单位换行
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let paragraphStyle = NSMutableParagraphStyle()
    ///     .dd_wordWrapping(true)  // 设置为按单词换行
    /// ```
    @discardableResult
    func dd_wordWrapping(_ isWordWrapping: Bool) -> Self {
        if isWordWrapping {
            self.lineBreakMode = .byWordWrapping
        } else {
            self.lineBreakMode = .byCharWrapping
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
    ///     .dd_alignmentAndLineBreakMode(alignment: .center, lineBreakMode: .byWordWrapping)
    ///     // 设置文本对齐方式为居中，换行方式为按单词换行
    /// ```
    @discardableResult
    func dd_alignmentAndLineBreakMode(alignment: NSTextAlignment, lineBreakMode: NSLineBreakMode) -> Self {
        self.alignment = alignment
        self.lineBreakMode = lineBreakMode
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
    ///     .dd_firstLineHeadIndentAndHyphenation(firstLineHeadIndent: 20.0, hyphenationFactor: 0.8)
    ///     // 设置首行缩进为20.0，允许连字符系数为0.8
    /// ```
    @discardableResult
    func dd_firstLineHeadIndentAndHyphenation(firstLineHeadIndent: CGFloat, hyphenationFactor: Float) -> Self {
        self.firstLineHeadIndent = firstLineHeadIndent
        self.hyphenationFactor = hyphenationFactor
        return self
    }
}
