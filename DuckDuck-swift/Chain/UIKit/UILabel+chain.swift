import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UILabel {
    /// 设置文字内容
    /// - Parameter text: 文字内容
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.text("Hello, World!")
    /// ```
    @discardableResult
    func text(_ text: String?) -> Self {
        self.base.text = text
        return self
    }

    /// 设置富文本文字
    /// - Parameter attributedText: 富文本文字
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.attributedText(NSAttributedString(string: "Hello, World!", attributes: [.foregroundColor: UIColor.red]))
    /// ```
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.base.attributedText = attributedText
        return self
    }

    /// 设置文字行数
    /// - Parameter lines: 行数
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.numberOfLines(2)
    /// ```
    @discardableResult
    func numberOfLines(_ lines: Int) -> Self {
        self.base.numberOfLines = lines
        return self
    }

    /// 设置换行模式
    /// - Parameter mode: 换行模式
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.lineBreakMode(.byWordWrapping)
    /// ```
    @discardableResult
    func lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        self.base.lineBreakMode = mode
        return self
    }

    /// 设置文字对齐方式
    /// - Parameter alignment: 文字对齐方式
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.textAlignment(.center)
    /// ```
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.base.textAlignment = alignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color: 文字颜色
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.textColor(.red)
    /// ```
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        self.base.textColor = color
        return self
    }

    /// 设置文本高亮颜色
    /// - Parameter color: 高亮文字颜色
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.highlightedTextColor(.blue)
    /// ```
    @discardableResult
    func highlightedTextColor(_ color: UIColor) -> Self {
        self.base.highlightedTextColor = color
        return self
    }

    /// 设置字体的大小
    /// - Parameter font: 字体大小
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.font(.systemFont(ofSize: 14))
    /// ```
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.base.font = font
        return self
    }

    /// 是否调整字体大小以适配宽度
    /// - Parameter adjusts: 是否调整字体大小
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.adjustsFontSizeToFitWidth(true)
    /// ```
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        self.base.adjustsFontSizeToFitWidth = adjusts
        return self
    }

    /// 根据内容调整尺寸
    /// - Returns: `Self`，以便进行链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.sizeToFit()
    /// ```
    @discardableResult
    func sizeToFit() -> Self {
        self.base.sizeToFit()
        return self
    }
}

// MARK: - 属性文本链式语法
@MainActor
public extension DDExtension where Base: UILabel {
    /// 设置特定范围的字体
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 设置字体的文本范围
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.attributedFont(.boldSystemFont(ofSize: 18), for: NSRange(location: 0, length: 5))
    /// ```
    @discardableResult
    func attributedFont(_ font: UIFont, for range: NSRange) -> Self {
        let attributedString = self.base.attributedText?.dd_toNSMutableAttributedString().dd_font(font, for: range)
        self.base.attributedText = attributedString
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
    /// label.dd.attributedColor(.red, for: NSRange(location: 0, length: 5))
    /// ```
    @discardableResult
    func attributedColor(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = self.base.attributedText?.dd_toNSMutableAttributedString().dd_foregroundColor(color, for: range)
        self.base.attributedText = attributedString
        return self
    }

    /// 设置行间距
    /// - Parameter spacing: 行间距
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.lineSpacing(5)
    /// ```
    @discardableResult
    func lineSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = self.base.attributedText?
            .dd_toNSMutableAttributedString()
            .dd_lineSpacing(spacing, for: (self.base.text ?? "").dd_fullNSRange())
        self.base.attributedText = attributedString
        return self
    }

    /// 设置字间距
    /// - Parameter spacing: 字间距
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.wordSpacing(2)
    /// ```
    @discardableResult
    func wordSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = self.base.attributedText?
            .dd_toNSMutableAttributedString()
            .dd_wordSpacing(spacing, for: (self.base.text ?? "").dd_fullNSRange())
        self.base.attributedText = attributedString
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
    /// label.dd.attributedUnderLine(.blue, style: .double, for: NSRange(location: 0, length: 5))
    /// ```
    @discardableResult
    func attributedUnderLine(_ color: UIColor, style: NSUnderlineStyle = .single, for range: NSRange) -> Self {
        let attributedString = self.base.attributedText?.dd_toNSMutableAttributedString()
            .dd_underline(color, stytle: style, for: range)
        self.base.attributedText = attributedString
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
    /// label.dd.attributedDeleteLine(.red, for: NSRange(location: 0, length: 5))
    /// ```
    @discardableResult
    func attributedDeleteLine(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = self.base.attributedText?
            .dd_toNSMutableAttributedString()
            .dd_strikethrough(color, for: range)
        self.base.attributedText = attributedString
        return self
    }

    /// 设置首行缩进
    /// - Parameter indent: 首行缩进的宽度
    /// - Returns: `Self`，支持链式调用
    ///
    /// - 示例:
    /// ```swift
    /// label.dd.attributedFirstLineHeadIndent(10)
    /// ```
    @discardableResult
    func attributedFirstLineHeadIndent(_ indent: CGFloat) -> Self {
        let attributedString = self.base.attributedText?
            .dd_toNSMutableAttributedString()
            .dd_firstLineHeadIndent(indent)
        self.base.attributedText = attributedString
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
    /// label.dd.attributedBliqueness(0.3, for: NSRange(location: 0, length: 5))
    /// ```
    @discardableResult
    func attributedBliqueness(_ inclination: Float = 0, for range: NSRange) -> Self {
        let attributedString = self.base.attributedText?
            .dd_toNSMutableAttributedString()
            .dd_obliqueness(inclination, for: range)
        self.base.attributedText = attributedString
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
    /// label.dd.attributedImage("image_name", bounds: CGRect(x: 0, y: -5, width: 20, height: 20))
    /// ```
    @discardableResult
    func attributedImage(
        _ image: String,
        bounds: CGRect = .zero,
        index: Int = 0
    ) -> Self {
        let mAttributedString = self.base.attributedText?
            .dd_toNSMutableAttributedString()
            .dd_image(image, bounds: bounds, index: index)
        self.base.attributedText = mAttributedString
        return self
    }
}
