//
//  CATextLayer+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import QuartzCore
import UIKit

// MARK: - 链式语法
public extension CATextLayer {
    /// 设置文字的内容
    /// - Parameter string: 文字内容
    /// - Returns: `Self`
    @discardableResult
    func dd_String(_ string: String) -> Self {
        self.string = string
        return self
    }

    /// 自动换行,默认`NO`
    /// - Parameter isWrapped: 是否自动换行
    /// - Returns: `Self`
    @discardableResult
    func dd_isWrapped(_ isWrapped: Bool) -> Self {
        self.isWrapped = isWrapped
        return self
    }

    /// 当文本过长时的裁剪方式
    /// - Parameter truncationMode: 截断方式
    /// - Returns: `Self`
    @discardableResult
    func dd_truncationMode(_ truncationMode: CATextLayerTruncationMode) -> Self {
        self.truncationMode = truncationMode
        return self
    }

    /// 文本对齐模式
    /// - Parameter alignmentMode: 对齐模式
    /// - Returns: `Self`
    @discardableResult
    func dd_alignmentMode(_ alignmentMode: CATextLayerAlignmentMode) -> Self {
        self.alignmentMode = alignmentMode
        return self
    }

    /// 设置字体的颜色
    /// - Parameter foregroundColor: 字体的颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_foregroundColor(_ foregroundColor: UIColor) -> Self {
        self.foregroundColor = foregroundColor.cgColor
        return self
    }

    /// 设置内容缩放
    /// - Parameter scale: 内容缩放(默认:`UIScreen.main.scale`)
    /// - Returns: `Self`
    @discardableResult
    func dd_contentsScale(_ scale: CGFloat = UIScreen.main.scale) -> Self {
        self.contentsScale = scale
        return self
    }

    /// 设置字体
    /// - Parameter font: 字体
    /// - Returns: `Self`
    @discardableResult
    func dd_font(_ font: UIFont) -> Self {
        self.font = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        return self
    }
}
