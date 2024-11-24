//
//  UIFont++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 23/11/2024.
//

import CoreGraphics
import CoreText
import UIKit

// MARK: - 构造方法
public extension UIFont {
    /// 创建`苹方`字体
    ///
    /// 该初始化方法用于根据指定的字体类型（如简体中文字体）和大小创建一个 `UIFont` 对象。
    /// 支持通过 `PingFang` 枚举指定字体类型，默认大小为 12。
    ///
    /// - Parameters:
    ///   - font: 字体类型，使用 `PingFang` 枚举来选择不同的字体（如 `sc` 表示简体中文字体）。
    ///   - size: 字体大小，默认为 12。
    /// - Example:
    ///   ```swift
    ///   let pingFangFont = UIFont( .sc(.semibold), size: 14)
    ///   ```
    convenience init(_ font: PingFang, size: CGFloat = 12) {
        switch font {
        case let .sc(sc):
            // 根据传入的字体类型 `sc`（简体中文）初始化对应的 `UIFont`
            self.init(name: sc.name, size: size)!
        }
    }
}

// MARK: - 方法
public extension UIFont {
    /// 打印所有字体到控制台
    ///
    /// 该方法将打印所有可用的字体和字体家族名称到控制台。
    ///
    /// 示例:
    /// ```swift
    /// UIFont.dd_printAllFonts()
    /// ```
    static func dd_printAllFonts() {
        print("────────────────────────────────────────────────────────────")
        for fontFamilyName in UIFont.familyNames {
            print("字体家族名称:\(fontFamilyName)")
            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName) {
                print("├────── \(fontName)")
            }
            print("────────────────────────────────────────────────────────────")
        }
    }
}

// MARK: - 字体方法
public extension UIFont {
    /// 把字体转换为粗体
    ///
    /// 该方法将当前字体转化为粗体字体。
    ///
    /// 示例:
    /// ```swift
    /// let boldFont = UIFont.preferredFont(forTextStyle:.body).dd_bold()
    /// ```
    func dd_bold() -> UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
    }

    /// 把字体转换为斜体
    ///
    /// 该方法将当前字体转化为斜体字体。
    ///
    /// 示例:
    /// ```swift
    /// let italicFont = UIFont.preferredFont(forTextStyle:.body).dd_italic()
    /// ```
    func dd_italic() -> UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitItalic)!, size: 0)
    }

    /// 把字体转换为等距字体
    ///
    /// 该方法将当前字体转换为等宽字体。
    ///
    /// 示例:
    /// ```swift
    /// let monoFont = UIFont.preferredFont(forTextStyle:.body).dd_monospaced()
    /// ```
    func dd_monospaced() -> UIFont {
        let settings = [
            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
            UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector,
        ]

        let attributes = [UIFontDescriptor.AttributeName.featureSettings: settings]
        let newDescriptor = fontDescriptor.addingAttributes(attributes)
        return UIFont(descriptor: newDescriptor, size: 0)
    }

    /// 预设字体
    /// - Parameters:
    ///   - textStyle: 文本样式
    ///   - compatibleWith: 特征集合
    /// - Returns: 返回对应的预设字体
    ///
    /// 示例:
    /// ```swift
    /// let bodyFont = UIFont.preferred(for: .body)
    /// ```
    static func preferred(for textStyle: TextStyle, compatibleWith: UITraitCollection? = nil) -> UIFont {
        return UIFont.preferredFont(forTextStyle: textStyle, compatibleWith: compatibleWith)
    }

    /// 苹方字体
    /// - Parameters:
    ///   - type: 字体类型
    ///   - size: 字体字号
    /// - Returns: `UIFont` 对象
    ///
    /// 示例:
    /// ```swift
    /// let font = UIFont.dd_pingFang(.sc(.semibold), size: 14)
    /// ```
    static func dd_pingFang(_ font: PingFang, size: CGFloat) -> UIFont {
        switch font {
        case let .sc(sc):
            if let font = UIFont(name: sc.name, size: size) {
                return font
            }
        }
        return UIFont.systemFont(ofSize: size)
    }

    /// 系统字体
    /// - Parameters:
    ///   - type: 字体字重（不传 `type` 为默认字体）
    ///   - size: 字体字号
    /// - Returns: `UIFont` 对象
    ///
    /// 示例:
    /// ```swift
    /// let systemFont = UIFont.dd_system(.bold, size: 16)
    /// ```
    static func dd_system(_ weight: UIFont.Weight? = nil, size: CGFloat) -> UIFont {
        guard let weight else { return .systemFont(ofSize: size) }
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}

// MARK: - 链式语法
public extension UIFont {
    /// 设置字体大小
    /// - Parameter size: 字体大小
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let newFont = UIFont.preferredFont(forTextStyle: .body).dd_fontSize(18)
    /// ```
    @discardableResult
    func dd_fontSize(_ fontSize: CGFloat) -> UIFont {
        return self.withSize(fontSize)
    }
}

// MARK: - 苹方枚举
public enum PingFang {
    case sc(PingFang.SC) // sc字体
}

public extension PingFang {
    // MARK: - SC字体
    enum SC {
        case semibold // 半粗
        case medium // 中等
        case regular // 常规
        case light // 细
        case thin // 薄
        case ultralight // 超细/特细

        var name: String {
            return switch self {
            case .semibold:
                "PingFangSC-Semibold"
            case .medium:
                "PingFangSC-Medium"
            case .regular:
                "PingFangSC-Regular"
            case .light:
                "PingFangSC-Light"
            case .thin:
                "PingFangSC-Thin"
            case .ultralight:
                "PingFangSC-Ultralight"
            }
        }
    }
}
