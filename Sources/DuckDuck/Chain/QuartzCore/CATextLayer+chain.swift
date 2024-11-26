//
//  CATextLayer+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import QuartzCore
import UIKit

// MARK: - 链式语法
public extension DDExtension where Base: CATextLayer {
    /// 设置文字的内容
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd.string("Hello, World!")
    /// ```
    /// - Parameter string: 文字内容
    /// - Returns: `Self`
    @discardableResult
    func string(_ string: String) -> Self {
        self.base.string = string
        return self
    }

    /// 设置是否自动换行，默认 `false`
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd.isWrapped(true)
    /// ```
    /// - Parameter isWrapped: 是否自动换行
    /// - Returns: `Self`
    @discardableResult
    func isWrapped(_ isWrapped: Bool) -> Self {
        self.base.isWrapped = isWrapped
        return self
    }

    /// 设置文本截断方式
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd.truncationMode(.end)
    /// ```
    /// - Parameter truncationMode: 截断方式
    /// - Returns: `Self`
    @discardableResult
    func truncationMode(_ truncationMode: CATextLayerTruncationMode) -> Self {
        self.base.truncationMode = truncationMode
        return self
    }

    /// 设置文本对齐模式
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd.alignmentMode(.center)
    /// ```
    /// - Parameter alignmentMode: 对齐模式
    /// - Returns: `Self`
    @discardableResult
    func alignmentMode(_ alignmentMode: CATextLayerAlignmentMode) -> Self {
        self.base.alignmentMode = alignmentMode
        return self
    }

    /// 设置字体的颜色
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd.foregroundColor(.red)
    /// ```
    /// - Parameter foregroundColor: 字体的颜色
    /// - Returns: `Self`
    @discardableResult
    func foregroundColor(_ foregroundColor: UIColor) -> Self {
        self.base.foregroundColor = foregroundColor.cgColor
        return self
    }

    /// 设置内容缩放
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd.contentsScale(UIScreen.main.scale)
    /// ```
    /// - Parameter scale: 内容缩放（默认：`UIScreen.main.scale`）
    /// - Returns: `Self`
    @discardableResult
    @MainActor func contentsScale(_ scale: CGFloat = UIScreen.main.scale) -> Self {
        self.base.contentsScale = scale
        return self
    }

    /// 设置字体
    ///
    /// 示例：
    /// ```swift
    /// let textLayer = CATextLayer().dd.font(UIFont.systemFont(ofSize: 16))
    /// ```
    /// - Parameter font: 字体
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.base.font = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        return self
    }

    /// 设置字体大小
    /// - Parameter fontSize: 字体大小
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let textLayer = CATextLayer()
    /// textLayer.dd.fontSize(18)
    /// ```
    @discardableResult
    func fontSize(_ fontSize: CGFloat) -> Self {
        self.base.fontSize = fontSize
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
    /// textLayer.dd.shadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4.0)
    /// ```
    @discardableResult
    func shadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) -> Self {
        self.base.shadowColor = color.cgColor
        self.base.shadowOpacity = opacity
        self.base.shadowOffset = offset
        self.base.shadowRadius = radius
        return self
    }

    /// 设置文本内边距（调整框架实现）
    /// - Parameter insets: 内边距
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let textLayer = CATextLayer()
    /// textLayer.dd.padding(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    /// ```
    @discardableResult
    func padding(_ insets: UIEdgeInsets) -> Self {
        let newFrame = self.base.frame.inset(by: UIEdgeInsets(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right))
        self.base.frame = newFrame
        return self
    }
}
