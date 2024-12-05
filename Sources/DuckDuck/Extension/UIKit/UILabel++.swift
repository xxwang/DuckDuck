//
//  UILabel++.swift
//  DuckDuck
//
//  Created by xxwang on 24/11/2024.
//

import UIKit

// MARK: - Creatable
public extension UILabel {
    /// 纯净的创建方法
    static func create<T: UILabel>(_ aClass: T.Type = UILabel.self) -> T {
        let label = UILabel()
        return label as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UILabel>(_ aClass: T.Type = UILabel.self) -> T {
        let label: UILabel = self.create()
        return label as! T
    }
}

// MARK: - UILabel 计算属性扩展
public extension UILabel {
    /// 当前字体的实际大小
    ///
    /// 使用 UILabel 的字体大小和缩放比例，计算出实际字体大小。
    ///
    /// 示例：
    /// ```swift
    /// let label = UILabel()
    /// label.font = UIFont.systemFont(ofSize: 16)
    /// print("实际字体大小: \(label.dd_actualFontSize)")
    /// ```
    var dd_actualFontSize: CGFloat {
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = minimumScaleFactor
        return font.pointSize * context.actualScaleFactor
    }

    /// 内容所需的高度（在宽度已固定的情况下）
    ///
    /// 根据 UILabel 的当前宽度、字体和文本内容计算出所需的高度。
    ///
    /// 示例：
    /// ```swift
    /// let label = UILabel()
    /// label.text = "多行文本示例"
    /// label.font = UIFont.systemFont(ofSize: 16)
    /// label.numberOfLines = 0
    /// label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
    /// print("内容需要的高度: \(label.dd_requiredHeight)")
    /// ```
    var dd_requiredHeight: CGFloat {
        let tempLabel = UILabel()
        tempLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: .greatestFiniteMagnitude)
        tempLabel.lineBreakMode = lineBreakMode
        tempLabel.font = font
        tempLabel.text = text
        tempLabel.attributedText = attributedText
        tempLabel.sizeToFit()
        return tempLabel.frame.height
    }

    /// 当前文本的所有行内容（需要设置宽度）
    ///
    /// 将 UILabel 的内容根据宽度和字体分割为多行文本。
    ///
    /// 示例：
    /// ```swift
    /// let label = UILabel()
    /// label.text = "多行文本内容测试"
    /// label.font = UIFont.systemFont(ofSize: 16)
    /// label.numberOfLines = 0
    /// label.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
    /// print("所有行内容: \(label.dd_allTextLines)")
    /// ```
    var dd_allTextLines: [String] {
        guard let text, let font else { return [] }
        return text.dd_splitIntoLines1(forWidth: bounds.width, usingFont: font)
    }

    /// 第一行文本内容
    ///
    /// 获取 UILabel 第一行的内容。如果没有内容，则返回 `nil`。
    ///
    /// 示例：
    /// ```swift
    /// let label = UILabel()
    /// label.text = "第一行内容示例\n第二行内容"
    /// label.font = UIFont.systemFont(ofSize: 16)
    /// label.numberOfLines = 0
    /// print("第一行内容: \(label.dd_firstLine ?? "无内容")")
    /// ```
    var dd_firstLine: String? {
        dd_allTextLines.first
    }

    /// 内容是否被截断
    ///
    /// 判断 UILabel 的内容是否超出显示区域，并被截断。
    ///
    /// 示例：
    /// ```swift
    /// let label = UILabel()
    /// label.text = "内容是否被截断的测试文本"
    /// label.font = UIFont.systemFont(ofSize: 16)
    /// label.numberOfLines = 1
    /// label.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
    /// print("内容是否被截断: \(label.dd_isTextTruncated)")
    /// ```
    var dd_isTextTruncated: Bool {
        guard let labelText = text, let font else { return false }

        // 计算理论所需尺寸
        let maxSize = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        let textSize = (labelText as NSString).boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        // 理论行数
        let requiredLines = Int(ceil(textSize.height / font.lineHeight))
        // 可显示的行数
        let availableLines = numberOfLines == 0
            ? Int(floor(bounds.height / font.lineHeight))
            : min(numberOfLines, Int(floor(bounds.height / font.lineHeight)))

        return requiredLines > availableLines
    }
}

// MARK: - 构造方法
public extension UILabel {
    /// 使用内容字符串创建一个 `UILabel`
    ///
    /// 此构造方法可以快速创建一个带有指定文本内容的 `UILabel`，默认使用系统的字体和样式。
    ///
    /// - Parameter text: 内容字符串
    ///
    /// - 使用示例:
    /// ```swift
    /// let label = UILabel(text: "Hello, World!")
    /// ```
    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    /// 使用内容字符串和字体样式创建一个 `UILabel`
    ///
    /// 此构造方法允许在创建 `UILabel` 时，指定显示的文本内容和字体样式。
    ///
    /// - Parameters:
    ///   - text: 内容字符串
    ///   - style: 字体样式，类型为 `UIFont.TextStyle`，例如 `.headline`、`.body` 等
    ///
    /// - 使用示例:
    /// ```swift
    /// let label = UILabel(text: "Hello, World!", style: .headline)
    /// ```
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        self.font = UIFont.preferredFont(forTextStyle: style)
        self.text = text
    }
}

// MARK: - 获取 UILabel 中内容大小
public extension UILabel {
    /// 获取 `UILabel` 中字符串的大小 (`CGSize`)
    ///
    /// 此方法根据 `UILabel` 的字体属性和提供的最大宽度，计算内容的理想尺寸。
    ///
    /// - Parameter lineWidth: 最大宽度，默认为无限大 (`Double.greatestFiniteMagnitude`)
    /// - Returns: 计算出的 `CGSize` 值，包含内容的宽度和高度。如果 `text` 为 `nil`，返回 `.zero`
    ///
    /// - 使用示例:
    /// ```swift
    /// let label = UILabel(text: "This is a test")
    /// let textSize = label.dd_calculateSize(forWidth: 200)
    /// print("Text size: \(textSize)") // 输出内容大小
    /// ```
    func dd_calculateSize(forWidth lineWidth: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        return self.text?.dd_calculateSize(forWidth: lineWidth, font: self.font) ?? .zero
    }

    /// 获取 `UILabel` 中属性字符串的大小 (`CGSize`)
    ///
    /// 此方法根据 `UILabel` 的 `attributedText` 属性和提供的最大宽度，计算内容的理想尺寸。
    ///
    /// - Parameter lineWidth: 最大宽度，默认为无限大 (`Double.greatestFiniteMagnitude`)
    /// - Returns: 计算出的 `CGSize` 值，包含内容的宽度和高度。如果 `attributedText` 为 `nil`，返回 `.zero`
    ///
    /// - 使用示例:
    /// ```swift
    /// let attributedString = NSAttributedString(
    ///     string: "Test with attributes",
    ///     attributes: [.font: UIFont.systemFont(ofSize: 14)]
    /// )
    /// let label = UILabel()
    /// label.attributedText = attributedString
    /// let attributedTextSize = label.dd_calculateAttributedSize(forWidth: 200)
    /// print("Attributed text size: \(attributedTextSize)") // 输出内容大小
    /// ```
    func dd_calculateAttributedSize(forWidth lineWidth: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        return self.attributedText?.dd_calculateAttributedSize(forWidth: lineWidth) ?? .zero
    }
}

// MARK: - UILabel内容设置
public extension UILabel {
    /// 设置图文混排的属性字符串
    ///
    /// 此方法支持将图片插入到文本中，提供插入位置、缩放比例、间距及是否保留图片原始大小的选项。
    ///
    /// - Parameters:
    ///   - text: 原始文本
    ///   - images: 图片数组
    ///   - spacing: 图文间距，默认为 5
    ///   - scale: 图片的缩放比例（基于字体高度）
    ///   - position: 图片插入的位置索引，默认为 0
    ///   - isOriginalSize: 是否保留图片的原始大小，默认为 `false`
    /// - Returns: 配置完成的 `NSMutableAttributedString`
    ///
    /// - 使用示例:
    /// ```swift
    /// let label = UILabel()
    /// let images = [UIImage(named: "icon1"), UIImage(named: "icon2")]
    /// label.dd_blend("SwiftUI & UIKit", images: images, spacing: 8, scale: 1.0, position: 7)
    /// print("图文混排设置成功")
    /// ```
    @discardableResult
    func dd_blend(_ text: String?,
                  images: [UIImage?] = [],
                  spacing: CGFloat = 5,
                  scale: CGFloat,
                  position: Int = 0,
                  isOriginalSize: Bool = false) -> NSMutableAttributedString
    {
        guard let font = self.font else {
            assertionFailure("UILabel 的字体未设置")
            return NSMutableAttributedString(string: text ?? "")
        }

        let attributedString = NSMutableAttributedString()

        // 插入前缀文本
        let prefixText = String(text?.prefix(position) ?? "")
        attributedString.append(NSAttributedString(string: prefixText))

        // 插入图片
        for image in images {
            guard let image else { continue }
            let attachment = NSTextAttachment()

            // 计算图片大小
            let imageHeight = isOriginalSize ? image.size.height : font.pointSize * scale
            let imageWidth = image.size.width / image.size.height * imageHeight
            let verticalOffset = (font.lineHeight - imageHeight) / 2

            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: verticalOffset, width: imageWidth, height: imageHeight)
            attributedString.append(NSAttributedString(attachment: attachment))

            // 插入图片后的间距
            attributedString.append(NSAttributedString(string: " "))
        }

        // 插入后缀文本
        let suffixText = String(text?.dropFirst(position) ?? "")
        attributedString.append(NSAttributedString(string: suffixText))

        // 调整图文间距
        if spacing != 0 {
            let fullRange = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(.kern, value: spacing, range: fullRange)
        }

        self.attributedText = attributedString
        return attributedString
    }

    /// 设置带行间距和字间距的属性字符串
    ///
    /// 配置 `UILabel` 的文本内容并指定行间距和字间距。
    ///
    /// - Parameters:
    ///   - text: 文本内容
    ///   - lineSpacing: 行间距
    ///   - wordSpacing: 字间距，默认为 1
    /// - Returns: 配置完成的 `NSMutableAttributedString`
    ///
    /// - 使用示例:
    /// ```swift
    /// let label = UILabel()
    /// label.dd_text("Swift makes programming fun!", lineSpacing: 6, wordSpacing: 1.5)
    /// ```
    @discardableResult
    func dd_text(_ text: String, lineSpacing: CGFloat, wordSpacing: CGFloat = 1) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = self.textAlignment

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .kern: wordSpacing,
            .font: self.font ?? UIFont.systemFont(ofSize: 14),
        ]

        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
        self.attributedText = attributedString
        return attributedString
    }

    /// 获取 UILabel 的文本行数及每一行内容
    ///
    /// 根据指定的行间距、字间距和段落间距，返回 `UILabel` 的每行内容。
    ///
    /// - Parameters:
    ///   - labelWidth: `UILabel` 的宽度，默认为控件的宽度
    ///   - lineSpacing: 行间距，默认为 0
    ///   - wordSpacing: 字间距，默认为 0
    ///   - paragraphSpacing: 段落间距，默认为 0
    /// - Returns: 每行内容的字符串数组
    ///
    /// - 使用示例:
    /// ```swift
    /// let label = UILabel()
    /// label.text = "This is a long text example for UILabel."
    /// let lines = label.dd_lineContents(lineSpacing: 4)
    /// print("每行内容: \(lines)")
    /// ```
    func dd_lineContents(_ labelWidth: CGFloat? = nil,
                         lineSpacing: CGFloat = 0.0,
                         wordSpacing: CGFloat = 0.0,
                         paragraphSpacing: CGFloat = 0.0) -> [String]
    {
        guard let text = self.text, let font = self.font else { return [] }

        let width = labelWidth ?? self.bounds.width
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle,
            .kern: wordSpacing,
        ]

        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)

        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))

        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame) as? [CTLine] ?? []

        return lines.compactMap { line in
            let range = CTLineGetStringRange(line)
            let startIndex = text.index(text.startIndex, offsetBy: range.location)
            let endIndex = text.index(startIndex, offsetBy: range.length)
            return String(text[startIndex ..< endIndex])
        }
    }
}

// MARK: - 链式语法
public extension UILabel {
    /// 设置文字内容
    /// - Parameter text: 文字内容
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_text("Hello, World!")
    /// ```
    @discardableResult
    func dd_text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    /// 设置富文本文字
    /// - Parameter attributedText: 富文本文字
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_attributedText(NSAttributedString(string: "Hello, World!", attributes: [.foregroundColor: UIColor.red]))
    /// ```
    @discardableResult
    func dd_attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    }

    /// 设置文字行数
    /// - Parameter lines: 行数
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_numberOfLines(2)
    /// ```
    @discardableResult
    func dd_numberOfLines(_ lines: Int) -> Self {
        self.numberOfLines = lines
        return self
    }

    /// 设置换行模式
    /// - Parameter mode: 换行模式
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_lineBreakMode(.byWordWrapping)
    /// ```
    @discardableResult
    func dd_lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        self.lineBreakMode = mode
        return self
    }

    /// 设置文字对齐方式
    /// - Parameter alignment: 文字对齐方式
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_textAlignment(.center)
    /// ```
    @discardableResult
    func dd_textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color: 文字颜色
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_textColor(.red)
    /// ```
    @discardableResult
    func dd_textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }

    /// 设置文本高亮颜色
    /// - Parameter color: 高亮文字颜色
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_highlightedTextColor(.blue)
    /// ```
    @discardableResult
    func dd_highlightedTextColor(_ color: UIColor) -> Self {
        self.highlightedTextColor = color
        return self
    }

    /// 设置字体的大小
    /// - Parameter font: 字体大小
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_font(.systemFont(ofSize: 14))
    /// ```
    @discardableResult
    func dd_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    /// 是否调整字体大小以适配宽度
    /// - Parameter adjusts: 是否调整字体大小
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_adjustsFontSizeToFitWidth(true)
    /// ```
    @discardableResult
    func dd_adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjusts
        return self
    }

    /// 根据内容调整尺寸
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_sizeToFit()
    /// ```
    @discardableResult
    func dd_sizeToFit() -> Self {
        self.sizeToFit()
        return self
    }
}

// MARK: - 属性文本链式语法
public extension UILabel {
    /// 设置特定范围的字体
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 设置字体的文本范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_attributedFont(.boldSystemFont(ofSize: 18), for: NSRange(location: 0, length: 5))
    /// ```
    @discardableResult
    func dd_attributedFont(_ font: UIFont, for range: NSRange) -> Self {
        let attributedString = attributedText?.dd_toNSMutableAttributedString().dd_font(font, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 设置特定区域的文字颜色
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - range: 设置颜色的文本范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_attributedColor(.red, for: NSRange(location: 0, length: 5))
    /// ```
    @discardableResult
    func dd_attributedColor(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.dd_toNSMutableAttributedString().dd_foregroundColor(color, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 设置行间距
    /// - Parameter spacing: 行间距
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_lineSpacing(5)
    /// ```
    @discardableResult
    func dd_lineSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.dd_toNSMutableAttributedString().dd_lineSpacing(spacing, for: (self.text ?? "").dd_fullNSRange())
        self.attributedText = attributedString
        return self
    }

    /// 设置字间距
    /// - Parameter spacing: 字间距
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_wordSpacing(2)
    /// ```
    @discardableResult
    func dd_wordSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.dd_toNSMutableAttributedString().dd_wordSpacing(spacing, for: (self.text ?? "").dd_fullNSRange())
        self.attributedText = attributedString
        return self
    }

    /// 设置特定范围的下划线
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - style: 下划线样式（默认 `.single`）
    ///   - range: 设置下划线的文本范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_attributedUnderLine(.blue, style: .double, for: NSRange(location: 0, length: 5))
    /// ```
    @discardableResult
    func dd_attributedUnderLine(_ color: UIColor, style: NSUnderlineStyle = .single, for range: NSRange) -> Self {
        let attributedString = attributedText?.dd_toNSMutableAttributedString().dd_underline(color, stytle: style, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 设置特定范围的删除线
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - range: 设置删除线的文本范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_attributedDeleteLine(.red, for: NSRange(location: 0, length: 5))
    /// ```
    @discardableResult
    func dd_attributedDeleteLine(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.dd_toNSMutableAttributedString().dd_strikethrough(color, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 设置首行缩进
    /// - Parameter indent: 首行缩进的宽度
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_attributedFirstLineHeadIndent(10)
    /// ```
    @discardableResult
    func dd_attributedFirstLineHeadIndent(_ indent: CGFloat) -> Self {
        let attributedString = attributedText?.dd_toNSMutableAttributedString().dd_firstLineHeadIndent(indent)
        self.attributedText = attributedString
        return self
    }

    /// 设置特定范围的倾斜效果
    /// - Parameters:
    ///   - inclination: 倾斜度
    ///   - range: 设置倾斜效果的文本范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_attributedBliqueness(0.3, for: NSRange(location: 0, length: 5))
    /// ```
    @discardableResult
    func dd_attributedBliqueness(_ inclination: Float = 0, for range: NSRange) -> Self {
        let attributedString = attributedText?.dd_toNSMutableAttributedString().dd_obliqueness(inclination, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 往字符串中插入图片（属性字符串）
    /// - Parameters:
    ///   - image: 图片资源（图片名称或 URL 地址）
    ///   - bounds: 图片的大小（默认为 `.zero`，即自动根据图片大小设置，y > 0：图片向上移动，y < 0：图片向下移动）
    ///   - index: 图片的位置（默认为放在开头）
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd_attributedImage("image_name", bounds: CGRect(x: 0, y: -5, width: 20, height: 20))
    /// ```
    @discardableResult
    func dd_attributedImage(
        _ image: String,
        bounds: CGRect = .zero,
        index: Int = 0
    ) -> Self {
        let mAttributedString = attributedText?.dd_toNSMutableAttributedString().dd_image(image, bounds: bounds, index: index)
        self.attributedText = mAttributedString
        return self
    }
}
