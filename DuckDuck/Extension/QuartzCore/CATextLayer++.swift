import QuartzCore
import UIKit

// MARK: - 链式语法
public extension CATextLayer {
    /// 设置文字的内容
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd_toString("Hello, World!")
    /// ```
    /// - Parameter string: 文字内容
    /// - Returns: `Self`
    @discardableResult
    func dd_toString(_ string: String) -> Self {
        self.string = string
        return self
    }

    /// 设置是否自动换行，默认 `false`
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd_isWrapped(true)
    /// ```
    /// - Parameter isWrapped: 是否自动换行
    /// - Returns: `Self`
    @discardableResult
    func dd_isWrapped(_ isWrapped: Bool) -> Self {
        self.isWrapped = isWrapped
        return self
    }

    /// 设置文本截断方式
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd_truncationMode(.end)
    /// ```
    /// - Parameter truncationMode: 截断方式
    /// - Returns: `Self`
    @discardableResult
    func dd_truncationMode(_ truncationMode: CATextLayerTruncationMode) -> Self {
        self.truncationMode = truncationMode
        return self
    }

    /// 设置文本对齐模式
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd_alignmentMode(.center)
    /// ```
    /// - Parameter alignmentMode: 对齐模式
    /// - Returns: `Self`
    @discardableResult
    func dd_alignmentMode(_ alignmentMode: CATextLayerAlignmentMode) -> Self {
        self.alignmentMode = alignmentMode
        return self
    }

    /// 设置字体的颜色
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd_foregroundColor(.red)
    /// ```
    /// - Parameter foregroundColor: 字体的颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_foregroundColor(_ foregroundColor: UIColor) -> Self {
        self.foregroundColor = foregroundColor.cgColor
        return self
    }

    /// 设置内容缩放
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd_contentsScale(UIScreen.main.scale)
    /// ```
    /// - Parameter scale: 内容缩放（默认：`UIScreen.main.scale`）
    /// - Returns: `Self`
    @discardableResult
    func dd_contentsScale(_ scale: CGFloat = UIScreen.main.scale) -> Self {
        self.contentsScale = scale
        return self
    }

    /// 设置字体
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd_font(UIFont.systemFont(ofSize: 16))
    /// ```
    /// - Parameter font: 字体
    /// - Returns: `Self`
    @discardableResult
    func dd_font(_ font: UIFont) -> Self {
        self.font = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        return self
    }

    /// 设置字体大小
    /// - Parameter fontSize: 字体大小
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let textLayer = CATextLayer()
    /// textLayer.dd_fontSize(18)
    /// ```
    @discardableResult
    func dd_fontSize(_ fontSize: CGFloat) -> Self {
        self.fontSize = fontSize
        return self
    }

    /// 设置阴影属性
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - opacity: 阴影不透明度
    ///   - offset: 阴影偏移量
    ///   - radius: 阴影模糊半径
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let textLayer = CATextLayer()
    /// textLayer.dd_shadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4.0)
    /// ```
    @discardableResult
    func dd_shadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) -> Self {
        self.shadowColor = color.cgColor
        self.shadowOpacity = opacity
        self.shadowOffset = offset
        self.shadowRadius = radius
        return self
    }

    /// 设置文本内边距（调整框架实现）
    /// - Parameter insets: 内边距
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let textLayer = CATextLayer()
    /// textLayer.dd_padding(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    /// ```
    @discardableResult
    func dd_padding(_ insets: UIEdgeInsets) -> Self {
        let newFrame = self.frame.inset(by: UIEdgeInsets(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right))
        self.frame = newFrame
        return self
    }
}
