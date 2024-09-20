//
//  UIFont+duck.swift
//  DuckDuck
//
//  Created by 王哥 on 2024/9/20.
//

import CoreGraphics
import CoreText
import UIKit

// MARK: - 属性
public extension UIFont {
    /// 把字体转换为粗体
    ///
    ///     UIFont.preferredFont(forTextStyle:.body).dd_bold()
    ///
    func dd_bold() -> UIFont {
        UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
    }

    /// 把字体转换为斜体
    ///
    ///     UIFont.preferredFont(forTextStyle:.body).dd_italic()
    ///
    func dd_italic() -> UIFont {
        UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitItalic)!, size: 0)
    }

    /// 把字体转换为等距字体
    ///
    ///     UIFont.preferredFont(forTextStyle:.body).dd_monospaced()
    ///
    func dd_monospaced() -> UIFont {
        let settings = [[
            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
            UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector,
        ]]

        let attributes = [UIFontDescriptor.AttributeName.featureSettings: settings]
        let newDescriptor = fontDescriptor.addingAttributes(attributes)
        return UIFont(descriptor: newDescriptor, size: 0)
    }
}

// MARK: - 构造方法
public extension UIFont {
    /// 创建`苹方`字体
    /// - Parameters:
    ///   - type:类型
    ///   - size:大小
    convenience init(PingFang type: DDPingFangSCFont, size: CGFloat = 12) {
        self.init(name: type.rawValue, size: size)!
    }
}

// MARK: - 方法
public extension UIFont {
    /// 打印所有字体到控制台
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

    /// 预设字体
    /// - Parameters:
    ///   - textStyle: 文本样式
    ///   - compatibleWith: 特征集合
    static func dd_preset(for textStyle: TextStyle,
                          compatibleWith: UITraitCollection? = nil) -> UIFont
    {
        UIFont.preferredFont(forTextStyle: textStyle, compatibleWith: compatibleWith)
    }

    /// 苹方字体
    /// - Parameters:
    ///   - type:字体类型
    ///   - size:字体字号
    /// - Returns:UIFont
    static func dd_pingFangSC(_ type: DDPingFangSCFont, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    /// 系统字体
    /// - Parameters:
    ///   - type:字体字重(不传`type`为默认字体)
    ///   - size:字体字号
    /// - Returns:`UIFont`
    static func dd_system(_ type: DDSystemFont? = nil, size: CGFloat) -> UIFont {
        guard let type else { return .systemFont(ofSize: size) }
        return UIFont.systemFont(ofSize: size, weight: type.weight)
    }
}

// MARK: - 链式语法
public extension UIFont {
    /// 设置字体大小
    /// - Parameter size:字体大小
    /// - Returns:`Self`
    @discardableResult
    func dd_fontSize(_ fontSize: CGFloat) -> UIFont {
        return self.withSize(fontSize)
    }
}

// MARK: - 苹方枚举
public enum DDPingFangSCFont: String {
    /// 半粗
    case semibold = "PingFangSC-Semibold"
    /// 中等
    case medium = "PingFangSC-Medium"
    /// 常规
    case regular = "PingFangSC-Regular"
    /// 细
    case light = "PingFangSC-Light"
    /// 薄
    case thin = "PingFangSC-Thin"
    /// 超细/特细
    case ultralight = "PingFangSC-Ultralight"
}

// MARK: - 系统字体枚举
public enum DDSystemFont {
    /// 常规字体
    case regular
    /// 中等的字体
    case medium
    /// 加粗的字体
    case bold
    /// 半粗体的字体
    case semibold
    /// 超细的字体
    case ultraLight
    /// 纤细的字体
    case thin
    /// 亮字体
    case light
    /// 介于Bold和Black之间
    case heavy
    /// 最粗字体
    case black

    var weight: UIFont.Weight {
        switch self {
        /// 常规字体
        case .regular:
            return UIFont.Weight.regular
        /// 中等的字体
        case .medium:
            return UIFont.Weight.medium
        /// 加粗的字体
        case .bold:
            return UIFont.Weight.bold
        /// 半粗体的字体
        case .semibold:
            return UIFont.Weight.semibold
        /// 超细的字体
        case .ultraLight:
            return UIFont.Weight.ultraLight
        /// 纤细的字体
        case .thin:
            return UIFont.Weight.thin
        /// 亮字体
        case .light:
            return UIFont.Weight.light
        /// 介于Bold和Black之间
        case .heavy:
            return UIFont.Weight.heavy
        /// 最粗字体
        case .black:
            return UIFont.Weight.black
        }
    }
}
