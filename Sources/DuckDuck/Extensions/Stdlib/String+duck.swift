//
//  String+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

extension String: DDExtensionable {}
public extension String {
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }
}

// MARK: - 计算属性
public extension DDExtension where Base == String {
    /// 转换为`Bool`
    var as2Bool: Bool {
        let trimmed = self.base.trimmingCharacters(in: .whitespacesAndNewlines)
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    /// 转换为`Int`
    var as2Int: Int {
        return Int(self.base) ?? 0
    }

    /// 转换为`Int64`
    var as2Int64: Int64 {
        return Int64(self.base) ?? 0
    }

    /// 转换为`UInt`
    var as2UInt: UInt {
        return UInt(self.base) ?? 0
    }

    /// 转换为`UInt64`
    var as2UInt64: UInt64 {
        return UInt64(self.base) ?? 0
    }

    /// 转换为`Float`
    var as2Float: Float {
        return Float(self.base) ?? 0
    }

    /// 转换为`Double`
    var as2Double: Double {
        return Double(self.base) ?? 0
    }

    /// 转换为`CGFloat`
    var as2CGFloat: CGFloat {
        return CGFloat(self.as2Double)
    }

    /// 转换为`NSNumber`
    var as2NSNumber: NSNumber {
        return NSNumber(value: self.as2Double)
    }

    /// 转换为`NSDecimalNumber`
    var as2NSDecimalNumber: NSDecimalNumber {
        return NSDecimalNumber(value: self.as2Double)
    }

    /// 转换为`Decimal`
    var as2Decimal: Decimal {
        return self.as2NSDecimalNumber.decimalValue
    }

    /// 十六进制数字字符串转换为十进制`Int`
    var hexAs2Int: Int {
        return Int(self.base, radix: 16) ?? 0
    }

    /// 转换为`Character?`
    var as2Character: Character? {
        guard let n = Int(self.base), let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    /// 转换为`[Character]`
    var as2Characters: [Character] {
        return Array(self.base)
    }

    /// 转换为`NSString`
    var as2NSString: NSString {
        return NSString(string: self.base)
    }

    /// 转换为`NSAttributedString`
    var as2NSAttributedString: NSAttributedString {
        return NSAttributedString(string: self.base)
    }

    /// 转换为`NSMutableAttributedString`
    var as2NSMutableAttributedString: NSMutableAttributedString {
        return NSMutableAttributedString(string: self.base)
    }

    /// 转换为`utf8`格式`Data`
    var as2Data: Data? {
        return self.base.data(using: .utf8)
    }

    /// 把字符串转换为`URL`(失败返回`nil`)
    var as2Url: URL? {
        if self.base.hasPrefix("http://") || self.base.hasPrefix("https://") {
            return URL(string: self.base)
        }
        return URL(fileURLWithPath: self.base)
    }

    /// 字符串转换为`URLRequest`
    var as2URLRequest: URLRequest? {
        guard let url = self.as2Url else { return nil }
        return URLRequest(url: url)
    }

    ///  字符串转换为`通知名称`
    var as2NotificationName: Notification.Name {
        return Notification.Name(self.base)
    }

    /// 返回一个本地化的字符串
    var as2L10n: String {
        return NSLocalizedString(self.base, comment: "")
    }

    /// 字符串的完整 `Range`
    var fullRange: Range<String.Index> {
        return self.base.startIndex ..< self.base.endIndex
    }

    /// 字符串的完整 `NSRange`
    var fullNSRange: NSRange {
        return NSRange(self.base.startIndex ..< self.base.endIndex, in: self.base)
    }

    /// `16进制颜色值`字符串转换为`UIColor`对象
    var hexAs2UIColor: UIColor {
        return UIColor(hex: self.base)
    }

    /// 图片资源名称转换为图片对象
    var as2UIImage: UIImage? {
        return UIImage(named: self.base)
    }
}

// MARK: - Range
public extension DDExtension where Base == String {
    /// 将 `NSRange` 转换为 `Range<String.Index>`
    /// - Parameter nsRange: 要转换的`NSRange`
    /// - Returns: 等价`NSRange`的`Range<String.Index>`
    func range(_ nsrange: NSRange) -> Range<String.Index> {
        guard let range = Range(nsrange, in: self.base) else { fatalError("Failed to find range \(nsrange) in \(self.base)") }
        return range
    }

    /// 获取`subString`在当前字符串中的`Range`
    /// - Parameter subString: 用于查找的字符串
    /// - Returns: 结果`Range<String.Index>?`
    func range(_ subString: String) -> Range<String.Index>? {
        return self.base.range(of: subString)
    }

    /// 将`Range<String.Index>`转换为`NSRange`
    /// - Parameter range: 要转换的`Range<String.Index>`
    /// - Returns: 在字符串中找到的 `Range` 的等效 `NSRange`
    func nsRange(_ range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self.base)
    }

    /// 获取`subStr`在字符串中的`NSRange`
    /// - Parameter subStr: 用于查找的字符串
    /// - Returns: 结果`NSRange`
    func nsRange(_ subString: String) -> NSRange {
        guard let range = self.base.range(of: subString) else {
            return NSRange(location: 0, length: 0)
        }
        return NSRange(range, in: self.base)
    }
}

// MARK: - 静态方法
public extension DDExtension where Base == String {
    /// 生成指定长度的随机字符串
    /// - Parameter count: 字符个数
    /// - Returns: 随机字符串
    static func random(count: Int) -> String {
        guard count > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1 ... count {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }

    /// 生成指定长度的`乱数假文`字符串
    /// - Parameter count: 限制`乱数假文`字符数(默认为` 445 - 完整`的`乱数假文`)
    /// - Returns: `乱数假文`字符串
    static func loremIpsum(count: Int = 445) -> String {
        guard count > 0 else { return "" }

        // https://www.lipsum.com/
        let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        if loremIpsum.count > count {
            return String(loremIpsum[loremIpsum.startIndex ..< loremIpsum.index(loremIpsum.startIndex, offsetBy: count)])
        }
        return loremIpsum
    }
}

public extension DDExtension where Base == String {
    /// 根据长度分割字符串
    /// - Parameter length: 每段长度
    /// - Returns: `[String]`
    func split(by length: Int) -> [String] {
        var result = [String]()
        var startIndex = self.base.startIndex

        while startIndex < self.base.endIndex {
            let endIndex = self.base.index(startIndex, offsetBy: length, limitedBy: self.base.endIndex) ?? self.base.endIndex
            result.append(String(self.base[startIndex ..< endIndex]))
            startIndex = endIndex
        }
        return result
    }
}
