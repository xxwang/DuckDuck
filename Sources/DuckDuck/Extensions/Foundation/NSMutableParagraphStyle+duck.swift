//
//  NSMutableParagraphStyle+duck.swift
//
//
//  Created by 王哥 on 2024/7/4.
//

import UIKit

// MARK: - Defaultable
extension NSMutableParagraphStyle: Defaultable {
    public typealias Associatedtype = NSMutableParagraphStyle
    @objc open class func `default`() -> Associatedtype {
        return NSMutableParagraphStyle()
            .dd_hyphenationFactor(1.0)
            .dd_firstLineHeadIndent(0.0)
            .dd_paragraphSpacingBefore(0.0)
            .dd_headIndent(0)
            .dd_tailIndent(0)
    }
}

// MARK: - 链式语法
public extension NSMutableParagraphStyle {
    /// 设置对齐方式
    /// - Parameter alignment: 对方方式
    /// - Returns: `Self`
    @discardableResult
    func dd_alignment(_ alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }

    /// 设置换行方式
    /// - Parameter lineBreakMode: 换行方式
    /// - Returns: `Self`
    @discardableResult
    func dd_lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }

    /// 设置行间距
    /// - Parameter lineSpacing: 行间距
    /// - Returns: `Self`
    @discardableResult
    func dd_lineSpacing(_ lineSpacing: CGFloat) -> Self {
        self.lineSpacing = lineSpacing
        return self
    }

    /// 设置段落间距
    /// - Parameter paragraphSpacing: 段落间距
    /// - Returns: `Self`
    @discardableResult
    func dd_paragraphSpacing(_ paragraphSpacing: CGFloat) -> Self {
        self.paragraphSpacing = paragraphSpacing
        return self
    }

    /// 设置连字符系数
    /// - Parameter hyphenationFactor: 连字符系数
    /// - Returns: `Self`
    @discardableResult
    func dd_hyphenationFactor(_ hyphenationFactor: Float) -> Self {
        self.hyphenationFactor = hyphenationFactor
        return self
    }

    /// 设置第一行缩进
    /// - Parameter firstLineHeadIndent: 缩进
    /// - Returns: `Self`
    @discardableResult
    func dd_firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> Self {
        self.firstLineHeadIndent = firstLineHeadIndent
        return self
    }

    /// 设置段落前间距
    /// - Parameter paragraphSpacingBefore: 段落前间距
    /// - Returns: `Self`
    @discardableResult
    func dd_paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> Self {
        self.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }

    /// 设置头部缩进
    /// - Parameter headIndent: 头部缩进
    /// - Returns: `Self`
    @discardableResult
    func dd_headIndent(_ headIndent: CGFloat) -> Self {
        self.headIndent = headIndent
        return self
    }

    /// 设置尾部缩进
    /// - Parameter tailIndent: 尾部缩进
    /// - Returns: `Self`
    @discardableResult
    func dd_tailIndent(_ tailIndent: CGFloat) -> Self {
        self.tailIndent = tailIndent
        return self
    }
}
