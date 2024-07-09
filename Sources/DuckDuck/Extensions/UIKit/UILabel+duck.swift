//
//  UILabel+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - Defaultable
public extension UILabel {
    public typealias Associatedtype = UILabel
    open override class func `default`() -> Associatedtype {
        return UILabel()
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

//MARK: - 属性文本链式语法
public extension UILabel {
    /// 设置特定范围的字体
    /// - Parameters:
    ///   - font:字体
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedFont(_ font: UIFont, for range: NSRange) -> Self {
        let attribuedString = attributedText?.dd.as2NSMutableAttributedString.dd_font(font, for: range)
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
        let attributedString = attributedText?.dd.as2NSMutableAttributedString.dd_foregroundColor(color, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 设置行间距
    /// - Parameter spacing:行间距
    /// - Returns:`Self`
    @discardableResult
    func dd_lineSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.dd.as2NSMutableAttributedString.dd_lineSpacing(spacing, for: (text ?? "").dd.fullNSRange)
        self.attributedText = attributedString
        return self
    }

    /// 设置字间距
    /// - Parameter spacing:字间距
    /// - Returns:`Self`
    @discardableResult
    func dd_wordSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.dd.as2NSMutableAttributedString.dd_wordSpacing(spacing, for: (self.text ?? "").dd.fullNSRange)
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
        let attributedString = attributedText?.dd.as2NSMutableAttributedString.dd_underline(color, stytle: style, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 设置特定范围的删除线
    /// - Parameters:
    ///   - color:删除线颜色
    ///   - range:范围
    @discardableResult
    func dd_attributedDeleteLine(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.dd.as2NSMutableAttributedString.dd_strikethrough(color, for: range)
        self.attributedText = attributedString
        return self
    }

    /// 设置首行缩进
    /// - Parameter indent:进度宽度
    /// - Returns:`Self`
    @discardableResult
    func dd_attributedFirstLineHeadIndent(_ indent: CGFloat) -> Self {
        let attributedString = attributedText?.dd.as2NSMutableAttributedString.dd_firstLineHeadIndent(indent)
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
        let attributedString = attributedText?.dd.as2NSMutableAttributedString.dd_obliqueness(inclination, for: range)
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
        let mAttributedString = attributedText?.dd.as2NSMutableAttributedString.dd_image(image, bounds: bounds, index: index)
        self.attributedText = mAttributedString
        return self
    }}
