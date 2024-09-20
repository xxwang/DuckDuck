//
//  NSMutableAttributedString+duck.swift
//
//
//  Created by 王哥 on 2024/7/4.
//

import UIKit

// MARK: - 类型
public extension NSMutableAttributedString {
    /// 可变字符串转不可变字符串
    func dd_NSAttributedString() -> NSAttributedString {
        return self
    }
}

// MARK: - 链式语法
public extension NSMutableAttributedString {
    /// 设置字符串内容
    /// - Parameter string: 内容
    /// - Returns: `Self`
    @discardableResult
    func dd_string(_ string: String) -> Self {
        self.dd_attributedString(string.dd_NSAttributedString())
        return self
    }

    /// 设置不可变字符串内容
    /// - Parameters:
    ///   - attributedString: 内容
    /// - Returns: `Self`
    @discardableResult
    func dd_attributedString(_ attributedString: NSAttributedString) -> Self {
        self.setAttributedString(attributedString)
        return self
    }

    /// 追加属性字符串到当前属性字符串尾部
    /// - Parameter attributedString: 要追加的属性字符串
    /// - Returns: `Self`
    @discardableResult
    func dd_append(_ attributedString: NSAttributedString) -> Self {
        self.append(attributedString)
        return self
    }

    /// 设置指定`range`内的`字体`
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func dd_font(_ font: UIFont?, for range: NSRange? = nil) -> Self {
        if let font {
            let range = range ?? self.dd_fullNSRange()
            return self.dd_addAttributes([NSAttributedString.Key.font: font], for: range)
        }
        return self
    }

    /// 设置字间距
    /// - Parameters:
    ///   - wordSpacing: 字间距
    ///   - range: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func dd_wordSpacing(_ wordSpacing: CGFloat, for range: NSRange? = nil) -> Self {
        let range = range ?? self.dd_fullNSRange()
        self.dd_addAttributes([.kern: wordSpacing], for: range)
        return self
    }

    /// 设置行间距
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - alignment: 对齐方式
    ///   - range: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func dd_lineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> Self {
        let range = range ?? self.dd_fullNSRange()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        return self.dd_addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: range)
    }

    /// 设置文字颜色
    /// - Parameters:
    ///   - color: 颜色
    ///   - range: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func dd_foregroundColor(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let range = range ?? self.dd_fullNSRange()
        return self.dd_addAttributes([NSAttributedString.Key.foregroundColor: color], for: range)
    }

    /// 设置文字下划线
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式
    ///   - range: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func dd_underline(_ color: UIColor, stytle: NSUnderlineStyle = .single, for range: NSRange? = nil) -> Self {
        let range = range ?? self.dd_fullNSRange()

        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return self.dd_addAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: range)
    }

    /// 设置删除线
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - range: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func dd_strikethrough(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let lineStytle = NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.strikethroughStyle] = lineStytle
        attributes[NSAttributedString.Key.strikethroughColor] = color

        if #available(iOS 10.3, *) {
            attributes[NSAttributedString.Key.baselineOffset] = 0
        } else {
            attributes[NSAttributedString.Key.strikethroughStyle] = 0
        }
        let range = range ?? self.dd_fullNSRange()
        return self.dd_addAttributes(attributes, for: range)
    }

    /// 设置首行缩进
    /// - Parameter indent: 缩进宽度
    /// - Returns: `Self`
    @discardableResult
    func dd_firstLineHeadIndent(_ indent: CGFloat) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return self.dd_addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: self.dd_fullNSRange())
    }

    /// 设置文字倾斜
    /// - Parameters:
    ///   - obliqueness: 倾斜程度
    ///   - range: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func dd_obliqueness(_ obliqueness: Float = 0, for range: NSRange? = nil) -> Self {
        let range = range ?? self.dd_fullNSRange()
        return self.dd_addAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: range)
    }

    /// 插入图片附件
    ///
    /// - Note: 资源类型可为(`图片名称`/`图片URL`/`图片路径`/`网络图片`)
    ///         网络图片需指定`bounds`
    /// - Parameters:
    ///   - image: 图片附件
    ///   - bounds: 图片的大小,默认`.zero`(以底部基线为基准`y>0:图片向上移动 y<0:图片向下移动`)
    ///   - index: 图片的位置,默认插入到开头
    /// - Returns: `Self`
    @discardableResult
    func dd_image(_ image: String, bounds: CGRect = .zero, index: Int = 0) -> Self {
        // NSTextAttachment可以将要插入的图片作为特殊字符处理
        let attch = NSTextAttachment()
        // TODO: -
//        attch.image = UIImage.dd_loadImage(with: image)
        attch.bounds = bounds

        // 创建带有图片的富文本
        let string = NSAttributedString(attachment: attch)
        // 将图片添加到富文本
        self.insert(string, at: index)

        return self
    }

    /// 向属性字符串添加属性
    /// - Parameters:
    ///   - attributes: 属性列表
    ///   - range: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func dd_addAttributes(_ attributes: [NSAttributedString.Key: Any], for range: NSRange? = nil) -> Self {
        for name in attributes.keys {
            self.addAttribute(name, value: attributes[name] ?? "", range: range ?? self.dd_fullNSRange())
        }
        return self
    }

    /// 向属性字符串添加属性
    /// - Parameters:
    ///   - attributes: 属性列表
    ///   - text: 目标文字
    /// - Returns: `Self`
    @discardableResult
    func dd_addAttributes(_ attributes: [NSAttributedString.Key: Any], for text: String) -> Self {
        let ranges = self.dd_NSRanges(with: [text])
        if !ranges.isEmpty {
            for name in attributes.keys {
                for range in ranges {
                    self.addAttribute(name, value: attributes[name] ?? "", range: range)
                }
            }
        }
        return self
    }

    /// 向属性字符串添加属性
    /// - Parameters:
    ///   - attributes: 属性列表
    ///   - pattern: 匹配目标内容的正则表达式
    ///   - options: 匹配选项
    /// - Returns: `Self`
    @discardableResult
    func dd_addAttributes(_ attributes: [Key: Any], toRangesMatching pattern: String, options: NSRegularExpression.Options = []) -> Self {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else { return self }
        let matches = pattern.matches(in: string, options: [], range: NSRange(0 ..< length))
        for match in matches {
            self.dd_addAttributes(attributes, for: match.range)
        }

        return self
    }

    /// 向属性字符串添加属性
    /// - Parameters:
    ///   - attributes: 属性列表
    ///   - target: 匹配目标
    /// - Returns: `Self`
    @discardableResult
    func dd_addAttributes(_ attributes: [Key: Any], toOccurrencesOf target: some StringProtocol) -> Self {
        let pattern = "\\Q\(target)\\E"
        return self.dd_addAttributes(attributes, toRangesMatching: pattern)
    }
}
