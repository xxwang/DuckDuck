//
//  NSMutableAttributedString+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import UIKit

extension NSMutableAttributedString: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base: NSMutableAttributedString {
    /// 设置字符串内容
    ///
    /// 替换 `NSMutableAttributedString` 的内容为新的字符串。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString()
    /// attributedString.dd.string("Hello World")
    /// ```
    /// - Parameter string: 新的字符串内容
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func string(_ string: String) -> Self {
        self.setAttributedString(string.dd_toNSAttributedString())
        return self
    }

    /// 设置不可变字符串内容
    ///
    /// 设置属性字符串的内容为不可变的 `NSAttributedString`。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString()
    /// let newAttributedString = NSAttributedString(string: "New Content")
    /// attributedString.dd.setAttributedString(newAttributedString)
    /// ```
    /// - Parameter attributedString: 新的不可变字符串
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func setAttributedString(_ attributedString: NSAttributedString) -> Self {
        self.base.setAttributedString(attributedString)
        return self
    }

    /// 追加属性字符串到当前字符串
    ///
    /// 向当前的属性字符串追加新的属性字符串。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello")
    /// let newAttributedString = NSAttributedString(string: " World")
    /// attributedString.dd.append(newAttributedString)
    /// ```
    /// - Parameter attributedString: 要追加的属性字符串
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func append(_ attributedString: NSAttributedString) -> Self {
        self.base.append(attributedString)
        return self
    }

    /// 设置指定范围内的字体
    ///
    /// 设置指定 `range` 范围内的字体样式。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.font(UIFont.systemFont(ofSize: 16), for: NSRange(location: 0, length: 5))
    /// ```
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func font(_ font: UIFont?, for range: NSRange? = nil) -> Self {
        if let font {
            let range = range ?? self.base.dd_fullNSRange()
            return self.addAttributes([NSAttributedString.Key.font: font], for: range)
        }
        return self
    }

    /// 设置字间距
    ///
    /// 设置指定范围内的字间距。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.wordSpacing(1.5, for: NSRange(location: 0, length: 5))
    /// ```
    /// - Parameters:
    ///   - wordSpacing: 字间距
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func wordSpacing(_ wordSpacing: CGFloat, for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()
        self.addAttributes([.kern: wordSpacing], for: range)
        return self
    }

    /// 设置字母间距
    /// - Parameters:
    ///   - letterSpacing: 字母间距的值，正值表示字母之间的间距增大，负值表示字母之间的间距减小。
    ///   - range: 目标范围，默认为整个字符串范围。可以通过传入特定的 `NSRange` 来控制应用范围。
    /// - Returns: `Self`，支持链式调用。返回当前的 `NSMutableAttributedString` 对象，方便进行连续的属性设置。
    ///
    /// 示例:
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.letterSpacing(2) // 设置字母间距为 2
    /// attributedString.dd.letterSpacing(-1, for: NSRange(location: 0, length: 5)) // 设置前5个字符的字母间距为 -1
    /// ```
    @discardableResult
    func letterSpacing(_ letterSpacing: CGFloat, for range: NSRange? = nil) -> Self {
        // 使用默认范围或传入的范围来设置字母间距
        let range = range ?? self.base.dd_fullNSRange()

        // 调用 dd_addAttributes 方法，将字母间距应用到指定的范围
        return self.addAttributes([.kern: letterSpacing], for: range)
    }

    /// 设置行间距
    ///
    /// 设置指定范围内的行间距和对齐方式。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.lineSpacing(5.0, alignment: .center)
    /// ```
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - alignment: 对齐方式，默认为 `.left`
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        return self.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: range)
    }

    /// 设置文字颜色
    ///
    /// 设置指定范围内的文字颜色。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.foregroundColor(.red)
    /// ```
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func foregroundColor(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()
        return self.addAttributes([NSAttributedString.Key.foregroundColor: color], for: range)
    }

    /// 设置文字下划线
    ///
    /// 设置指定范围内的文字下划线样式和颜色。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.underline(.blue)
    /// ```
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式，默认为 `.single`
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func underline(_ color: UIColor, stytle: NSUnderlineStyle = .single, for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()

        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return self.addAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: range)
    }

    /// 设置删除线
    ///
    /// 设置指定范围内的文字删除线样式和颜色。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.strikethrough(.red)
    /// ```
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func strikethrough(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let lineStytle = NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.strikethroughStyle] = lineStytle
        attributes[NSAttributedString.Key.strikethroughColor] = color

        if #available(iOS 10.3, *) {
            attributes[NSAttributedString.Key.baselineOffset] = 0
        } else {
            attributes[NSAttributedString.Key.strikethroughStyle] = 0
        }
        let range = range ?? self.base.dd_fullNSRange()
        return self.addAttributes(attributes, for: range)
    }

    /// 设置首行缩进
    ///
    /// 设置整个属性字符串的首行缩进。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.firstLineHeadIndent(10.0)
    /// ```
    /// - Parameter indent: 缩进宽度
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func firstLineHeadIndent(_ indent: CGFloat) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return self.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: self.base.dd_fullNSRange())
    }

    /// 设置文字倾斜
    ///
    /// 设置指定范围内的文字倾斜程度。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.obliqueness(0.2)
    /// ```
    /// - Parameters:
    ///   - obliqueness: 倾斜程度，默认为 0 (无倾斜)
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func obliqueness(_ obliqueness: Float = 0, for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()
        return self.addAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: range)
    }

    /// 设置行高
    /// - Parameters:
    ///   - lineHeight: 行高
    ///   - alignment: 对齐方式，默认左对齐
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.lineHeight(20) // 设置行高为 20
    /// attributedString.dd.lineHeight(30, alignment: .center) // 设置行高为 30，并将文本居中对齐
    /// ```
    @discardableResult
    func lineHeight(_ lineHeight: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = alignment
        return self.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: range)
    }

    /// 设置段落间距
    /// - Parameters:
    ///   - spacing: 段落间距
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World\nThis is a test")
    /// attributedString.dd.paragraphSpacing(10) // 设置段落间距为 10
    /// attributedString.dd.paragraphSpacing(15, for: NSRange(location: 0, length: 12)) // 只对前12个字符设置段落间距
    /// ```
    @discardableResult
    func paragraphSpacing(_ spacing: CGFloat, for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = spacing
        return self.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: range)
    }

    /// 设置文字背景颜色
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.backgroundColor(.yellow) // 设置背景颜色为黄色
    /// attributedString.dd.backgroundColor(.green, for: NSRange(location: 0, length: 5)) // 只为前五个字符设置背景颜色
    /// ```
    @discardableResult
    func backgroundColor(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()
        return self.addAttributes([NSAttributedString.Key.backgroundColor: color], for: range)
    }

    /// 设置文字缩放
    /// - Parameters:
    ///   - scale: 缩放因子
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.scale(1.5) // 设置缩放因子为 1.5
    /// attributedString.dd.scale(2.0, for: NSRange(location: 0, length: 5)) // 只为前五个字符设置缩放因子为 2
    /// ```
    @discardableResult
    func scale(_ scale: Float = 1.0, for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()
        return self.addAttributes([NSAttributedString.Key.expansion: scale], for: range)
    }

    /// 设置文本阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移
    ///   - radius: 阴影模糊半径
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.textShadow(color: .black, offset: CGSize(width: 2, height: 2), radius: 3) // 设置黑色阴影，偏移量为(2,2)，模糊半径为3
    /// attributedString.dd.textShadow(color: .red, offset: CGSize(width: 0, height: 0), radius: 5, for: NSRange(location: 6, length: 5)) // 只对"World"一词设置阴影
    /// ```
    @discardableResult
    func textShadow(color: UIColor, offset: CGSize, radius: CGFloat, for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()

        let shadow = NSShadow()
        shadow.shadowColor = color
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = radius

        return self.addAttributes([NSAttributedString.Key.shadow: shadow], for: range)
    }

    /// 插入图片附件
    ///
    /// 向属性字符串插入图片附件。支持本地图片名称、图片路径、图片URL和网络图片。
    /// 网络图片需指定 `bounds` 参数来调整图片大小和位置。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.image("image.png", bounds: CGRect(x: 0, y: 0, width: 50, height: 50))
    /// ```
    /// - Parameters:
    ///   - image: 图片的资源名称、路径或URL
    ///   - bounds: 图片的显示大小，默认为 `.zero`，使用基线为基准
    ///   - index: 图片插入的位置，默认为开头
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func image(_ image: String, bounds: CGRect = .zero, index: Int = 0) -> Self {
        // 创建文本附件
        let attachment = NSTextAttachment()
        attachment.image = UIImage.dd_loadImage(with: image)
        attachment.bounds = bounds

        // 将图片转为富文本并插入
        let imageString = NSAttributedString(attachment: attachment)
        self.base.insert(imageString, at: index)

        return self
    }

    /// 向属性字符串添加多个属性
    ///
    /// 为指定范围添加多个属性，范围默认为整个字符串。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.addAttributes([.foregroundColor: UIColor.red], for: range)
    /// ```
    /// - Parameters:
    ///   - attributes: 要添加的属性字典
    ///   - range: 目标范围，默认为整个字符串范围
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], for range: NSRange? = nil) -> Self {
        let range = range ?? self.base.dd_fullNSRange()
        for (key, value) in attributes {
            self.base.addAttribute(key, value: value, range: range)
        }
        return self
    }

    /// 向指定文本添加多个属性
    ///
    /// 在指定文本出现的所有范围内添加多个属性。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.addAttributes([.foregroundColor: UIColor.red], for: "World")
    /// ```
    /// - Parameters:
    ///   - attributes: 要添加的属性字典
    ///   - text: 目标文本
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], for text: String) -> Self {
        let ranges = self.base.dd_subNSRanges(with: [text])
        for range in ranges {
            self.addAttributes(attributes, for: range)
        }
        return self
    }

    /// 向匹配正则表达式的所有范围添加多个属性
    ///
    /// 使用正则表达式匹配目标内容并为匹配的所有范围添加属性。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.addAttributes([.foregroundColor: UIColor.red], toRangesMatching: "\\bWorld\\b")
    /// ```
    /// - Parameters:
    ///   - attributes: 要添加的属性字典
    ///   - pattern: 匹配目标内容的正则表达式
    ///   - options: 正则表达式选项，默认为空
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], toRangesMatching pattern: String, options: NSRegularExpression.Options = []) -> Self {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return self }
        let matches = regex.matches(in: self.base.string, options: [], range: NSRange(0 ..< self.base.length))
        for match in matches {
            self.addAttributes(attributes, for: match.range)
        }
        return self
    }

    /// 向目标字符串出现的所有位置添加多个属性
    ///
    /// 根据目标字符串在文本中的出现位置，为其添加多个属性。
    ///
    /// 示例：
    /// ```swift
    /// let attributedString = NSMutableAttributedString(string: "Hello World")
    /// attributedString.dd.addAttributes([.foregroundColor: UIColor.red], toOccurrencesOf: "World")
    /// ```
    /// - Parameters:
    ///   - attributes: 要添加的属性字典
    ///   - target: 匹配目标字符串
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], toOccurrencesOf target: some StringProtocol) -> Self {
        let pattern = "\\Q\(target)\\E"
        return self.addAttributes(attributes, toRangesMatching: pattern)
    }
}
