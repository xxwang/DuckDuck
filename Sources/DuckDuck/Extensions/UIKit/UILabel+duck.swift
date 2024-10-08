//
//  UILabel+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 计算属性
public extension UILabel {
    static func `default`() -> UILabel {
        return UILabel()
    }

    /// 获取字体的大小
    func dd_fontSize() -> CGFloat {
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = self.minimumScaleFactor
        return self.font.pointSize * context.actualScaleFactor
    }

    /// 获取内容需要的高度(需要在`UILabel`宽度确定的情况下)
    func dd_requiredHeight() -> CGFloat {
        let label = UILabel.default()
            .dd_frame(CGRect(x: 0, y: 0, width: self.frame.width, height: .greatestFiniteMagnitude))
            .dd_lineBreakMode(.byWordWrapping)
            .dd_font(self.font)
            .dd_text(self.text)
            .dd_attributedText(self.attributedText)
            .dd_sizeToFit()
        return label.dd_height
    }

    /// 获取`UILabel`的每一行字符串(需要`UILabel`具有宽度值)
    func dd_textLines() -> [String] {
        return (self.text ?? "").dd_lines(self.dd_width, font: self.font!)
    }

    /// 获取`UILabel`第一行内容
    func dd_firstLineString() -> String? {
        return self.dd_linesContent().first
    }

    /// 判断`UILabel`中的内容是否被截断
    func dd_isTruncated() -> Bool {
        guard let labelText = self.text else { return false }
        // 计算理论上显示所有文字需要的尺寸
        let theorySize = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        // 计算文本大小
        let labelTextSize = (labelText as NSString)
            .boundingRect(
                with: theorySize,
                options: .usesLineFragmentOrigin,
                attributes: [.font: self.font!],
                context: nil
            )

        // 计算理论上需要的行数
        let labelTextLines = Int(Foundation.ceil(labelTextSize.height / self.font.lineHeight))
        // 实际可显示的行数
        var labelShowLines = Int(Foundation.floor(bounds.size.height / self.font.lineHeight))
        if self.numberOfLines != 0 {
            labelShowLines = min(labelShowLines, self.numberOfLines)
        }
        // 比较两个行数来判断是否被截断
        return labelTextLines > labelShowLines
    }
}

// MARK: - 构造方法
public extension UILabel {
    /// 使用内容字符串来创建一个`UILabel`
    /// - Parameter text:内容字符串
    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    /// 使用内容字符串和字体样式来创建一个`UILabel`
    /// - Parameters:
    ///   - text:内容字符串
    ///   - style:字体样式
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        self.font = UIFont.preferredFont(forTextStyle: style)
        self.text = text
    }
}

// MARK: - 获取UILabel中内容大小
public extension UILabel {
    /// 获取`UILabel`中`字符串`的CGSize
    /// - Parameter lineWidth:最大宽度
    /// - Returns:`CGSize`
    func dd_textSize(_ lineWidth: CGFloat = Double.greatestFiniteMagnitude) -> CGSize {
        return self.text?.dd_stringSize(lineWidth, font: self.font) ?? .zero
    }

    /// 获取`UILabel`中`属性字符串`的CGSize
    /// - Parameter lineWidth:最大宽度
    /// - Returns:`CGSize`
    func dd_attributedTextSize(_ lineWidth: CGFloat = Double.greatestFiniteMagnitude) -> CGSize {
        return self.attributedText?.dd_attributedSize(lineWidth) ?? .zero
    }
}

// MARK: - 属性字符串
public extension UILabel {
    /// 设置图片/文字的混合内容
    /// - Parameters:
    ///   - text: 文本字符串
    ///   - images: 图片数组
    ///   - spacing: 间距
    ///   - scale: 缩放比例
    ///   - position: 图片插入位置
    ///   - isOrgin: 是否使用图片原始大小
    /// - Returns: `NSMutableAttributedString`
    @discardableResult
    func dd_blend(_ text: String?,
                  images: [UIImage?] = [],
                  spacing: CGFloat = 5,
                  scale: CGFloat,
                  position: Int = 0,
                  isOrgin: Bool = false) -> NSMutableAttributedString
    {
        // 头部字符串
        let headString = text?.dd_subString(to: position) ?? ""
        let attributedString = NSMutableAttributedString(string: headString)

        for image in images {
            guard let image else { continue }

            // 计算图片宽高
            let imageHeight = (isOrgin ? image.size.height : self.font.pointSize) * scale
            let imageWidth = (image.size.width / image.size.height) * imageHeight
            // 附件的Y坐标位置
            let attachTop = (self.font.lineHeight - self.font.pointSize) / 2

            // 使用图片附件创建属性字符串
            let imageAttributedString = NSTextAttachment()
                .dd_image(image)
                .dd_bounds(CGRect(x: -3, y: -attachTop, width: imageWidth, height: imageHeight))
                .dd_NSAttributedString()

            // 将图片属性字符串追加到`attribuedString`
            attributedString.append(imageAttributedString)
            // 文字间距只对文字有效
            attributedString.append(NSAttributedString(string: " "))
        }

        // 尾部字符串
        let tailString = text?.dd_subString(from: position) ?? ""
        attributedString.append(NSAttributedString(string: tailString))

        // 图文间距需要减去默认的空格宽度
        let spaceW = " ".dd_stringSize(.greatestFiniteMagnitude, font: self.font).width
        let range = NSRange(location: 0, length: images.count * 2)
        attributedString.addAttribute(.kern, value: spacing - spaceW, range: range)

        // 设置属性字符串到`UILabel`
        self.attributedText = attributedString

        return attributedString
    }

    /// 设置`text`属性
    /// - Parameters:
    ///   - text: 要设置的字符串
    ///   - lineSpacing: 行间距
    ///   - wordSpacing: 字间距
    /// - Returns: `NSMutableAttributedString`
    @discardableResult
    func dd_setText(_ text: String, lineSpacing: CGFloat, wordSpacing: CGFloat = 1) -> NSMutableAttributedString {
        // 段落样式
        let style = NSMutableParagraphStyle.default()
            .dd_lineBreakMode(.byCharWrapping)
            .dd_alignment(.left)
            .dd_lineSpacing(lineSpacing)
            .dd_hyphenationFactor(1.0)
            .dd_firstLineHeadIndent(0.0)
            .dd_paragraphSpacingBefore(0.0)
            .dd_headIndent(0)
            .dd_tailIndent(0)

        let attrString = text.dd_NSMutableAttributedString()
            .dd_addAttributes([
                .paragraphStyle: style,
                .kern: wordSpacing,
                .font: self.font ?? .systemFont(ofSize: 14),
            ])
        self.attributedText = attrString
        return attrString
    }

    /// 获取`UILabel`的文本行数及每一行的内容
    /// - Parameters:
    ///   - labelWidth:`UILabel`的宽度
    ///   - lineSpacing:行间距
    ///   - wordSpacing:字间距
    ///   - paragraphSpacing:段落间距
    /// - Returns:行数及每行内容
    func dd_linesContent(_ labelWidth: CGFloat? = nil,
                         lineSpacing: CGFloat = 0.0,
                         wordSpacing: CGFloat = 0.0,
                         paragraphSpacing: CGFloat = 0.0) -> [String]
    {
        guard let text = self.text, let font = self.font else { return [] }
        // UILabel的宽度
        let labelWidth: CGFloat = labelWidth ?? bounds.width

        // 段落样式
        let style = NSMutableParagraphStyle.default()
            .dd_lineBreakMode(self.lineBreakMode)
            .dd_alignment(self.textAlignment)
            .dd_lineSpacing(lineSpacing)
            .dd_paragraphSpacing(paragraphSpacing)

        // 属性列表
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: style,
            .kern: wordSpacing,
        ]

        // 创建属性字符串并设置属性
        let attributedString = text.dd_NSMutableAttributedString().dd_addAttributes(attributes)
        // 创建框架设置器
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)

        let path = CGMutablePath()
        // 2.5 是经验误差值
        path.addRect(CGRect(x: 0, y: 0, width: labelWidth - 2.5, height: CGFloat(MAXFLOAT)))
        let framef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        // 从框架设置器中获取行内容(Element == CTLine)
        let lines = CTFrameGetLines(framef) as NSArray

        // 结果
        var result = [String]()
        // 获取每行内容
        for line in lines {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            result.append(text.dd_subString(from: lineRange.location, length: lineRange.length))
        }
        return result
    }
}

// MARK: - 链式语法
public extension UILabel {
    /// 设置文字
    /// - Parameter text:文字内容
    /// - Returns:`Self`
    @discardableResult
    func dd_text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    /// 设置富文本文字
    /// - Parameter attributedText:富文本文字
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    }

    /// 设置文字行数
    /// - Parameter lines:行数
    /// - Returns:`Self`
    @discardableResult
    func dd_numberOfLines(_ lines: Int) -> Self {
        self.numberOfLines = lines
        return self
    }

    /// 设置换行模式
    /// - Parameter mode:模式
    /// - Returns:`Self`
    @discardableResult
    func dd_lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        self.lineBreakMode = mode
        return self
    }

    /// 设置文字对齐方式
    /// - Parameter alignment:对齐方式
    /// - Returns:`Self`
    @discardableResult
    func dd_textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func dd_textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }

    /// 设置文本高亮颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func dd_highlightedTextColor(_ color: UIColor) -> Self {
        self.highlightedTextColor = color
        return self
    }

    /// 设置字体的大小
    /// - Parameter font:字体的大小
    /// - Returns:`Self`
    @discardableResult
    func dd_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    /// 是否调整字体大小到适配宽度
    /// - Parameter adjusts:是否调整
    /// - Returns:`Self`
    @discardableResult
    func dd_adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjusts
        return self
    }

    /// 根据内容调整尺寸
    /// - Returns: `Self`
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
    ///   - font:字体
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedFont(_ font: UIFont, for range: NSRange) -> Self {
        let attribuedString = attributedText?.dd_NSMutableAttributedString().dd_font(font, for: range)
        self.attributedText = attribuedString
        return self
    }

    /// 设置特定区域的文字颜色
    /// - Parameters:
    ///   - color:文字颜色
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedColor(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.dd_NSMutableAttributedString().dd_foregroundColor(color, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 设置行间距
    /// - Parameter spacing:行间距
    /// - Returns:`Self`
    @discardableResult
    func dd_lineSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.dd_NSMutableAttributedString().dd_lineSpacing(spacing, for: (self.text ?? "").dd_fullNSRange())
        self.attributedText = attributedString
        return self
    }

    /// 设置字间距
    /// - Parameter spacing:字间距
    /// - Returns:`Self`
    @discardableResult
    func dd_wordSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.dd_NSMutableAttributedString().dd_wordSpacing(spacing, for: (self.text ?? "").dd_fullNSRange())
        self.attributedText = attributedString
        return self
    }

    /// 设置特定范围的下划线
    /// - Parameters:
    ///   - color:下划线颜色
    ///   - style:下划线样式
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedUnderLine(_ color: UIColor, style: NSUnderlineStyle = .single, for range: NSRange) -> Self {
        let attributedString = attributedText?.dd_NSMutableAttributedString().dd_underline(color, stytle: style, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 设置特定范围的删除线
    /// - Parameters:
    ///   - color:删除线颜色
    ///   - range:范围
    @discardableResult
    func dd_attributedDeleteLine(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.dd_NSMutableAttributedString().dd_strikethrough(color, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 设置首行缩进
    /// - Parameter indent:进度宽度
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedFirstLineHeadIndent(_ indent: CGFloat) -> Self {
        let attributedString = attributedText?.dd_NSMutableAttributedString().dd_firstLineHeadIndent(indent)
        self.attributedText = attributedString
        return self
    }

    /// 设置特定范围的倾斜
    /// - Parameters:
    ///   - inclination:倾斜度
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedBliqueness(_ inclination: Float = 0, for range: NSRange) -> Self {
        let attributedString = attributedText?.dd_NSMutableAttributedString().dd_obliqueness(inclination, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 往字符串中插入图片(属性字符串)
    /// - Parameters:
    ///   - image:图片资源(图片名称/URL地址)
    ///   - bounds:图片的大小,默认为.zero,即自动根据图片大小设置,并以底部基线为标准. y > 0 :图片向上移动；y < 0 :图片向下移动
    ///   - index:图片的位置,默认放在开头
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedImage(
        _ image: String,
        bounds: CGRect = .zero,
        index: Int = 0
    ) -> Self {
        let mAttributedString = attributedText?.dd_NSMutableAttributedString().dd_image(image, bounds: bounds, index: index)
        self.attributedText = mAttributedString
        return self
    }
}
