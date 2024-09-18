//
//  String+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 类型转换
public extension  String {
    /// 转换为`Bool`
    func dd_Bool() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    /// 转换为`Int`
    func dd_Int() -> Int {
        return Int(self) ?? 0
    }

    /// 转换为`Int64`
    func dd_Int64() -> Int64 {
        return Int64(self) ?? 0
    }

    /// 转换为`UInt`
    func dd_UInt() -> UInt {
        return UInt(self) ?? 0
    }

    /// 转换为`UInt64`
    func dd_UInt64() -> UInt64 {
        return UInt64(self) ?? 0
    }

    /// 转换为`Float`
    func dd_Float() -> Float {
        return Float(self) ?? 0
    }

    /// 转换为`Double`
    func dd_Double() -> Double {
        return Double(self) ?? 0
    }

    /// 转换为`CGFloat`
    func dd_CGFloat() -> CGFloat {
        return CGFloat(self.dd_Double())
    }

    /// 转换为`NSNumber`
    func dd_NSNumber() -> NSNumber {
        return NSNumber(value: self.dd_Double())
    }

    /// 转换为`NSDecimalNumber`
    func dd_NSDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: self.dd_Double())
    }

    /// 转换为`Decimal`
    func dd_Decimal() -> Decimal {
        return self.dd_NSDecimalNumber().decimalValue
    }

    /// 十六进制数字字符串转换为十进制`Int`
    func dd_hex2Int() -> Int {
        return Int(self, radix: 16) ?? 0
    }

    /// 转换为`Character?`
    func dd_Character() -> Character? {
        guard let n = Int(self), let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    /// 转换为`[Character]`
    func dd_Characters() -> [Character] {
        return Array(self)
    }

    /// 转换为`NSString`
    func dd_NSString() -> NSString {
        return NSString(string: self)
    }

    /// 转换为`NSAttributedString`
    func dd_NSAttributedString() -> NSAttributedString {
        return NSAttributedString(string: self)
    }

    /// 转换为`NSMutableAttributedString`
    func dd_NSMutableAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }

    /// 转换为`utf8`格式`Data`
    func dd_Data() -> Data? {
        return self.data(using: .utf8)
    }

    /// 把字符串转换为`URL`(失败返回`nil`)
    func dd_URL() -> URL? {
        if self.hasPrefix("http://") || self.hasPrefix("https://") {
            return URL(string: self)
        }
        return URL(fileURLWithPath: self)
    }

    /// 字符串转换为`URLRequest`
    func dd_URLRequest() -> URLRequest? {
        guard let url = self.dd_URL() else { return nil }
        return URLRequest(url: url)
    }

    ///  字符串转换为`通知名称`
    func dd_NotificationName() -> Notification.Name {
        return Notification.Name(self)
    }

    /// 返回一个本地化的字符串
    func dd_L10n() -> String {
        return NSLocalizedString(self, comment: "")
    }

    /// 字符串的完整 `Range`
    func dd_fullRange() -> Range<String.Index> {
        return self.startIndex ..< self.endIndex
    }

    /// 字符串的完整 `NSRange`
    func dd_fullNSRange() -> NSRange {
        return NSRange(self.startIndex ..< self.endIndex, in: self)
    }

    /// `16进制颜色值`字符串转换为`UIColor`对象
    func dd_hexUIColor() -> UIColor {
        return UIColor(hex: self)
    }

    /// 图片资源名称转换为图片对象
    func dd_UIImage() -> UIImage? {
        return UIImage(named: self)
    }
}

// MARK: - Range
public extension String {
    /// 将 `NSRange` 转换为 `Range<String.Index>`
    /// - Parameter nsRange: 要转换的`NSRange`
    /// - Returns: 等价`NSRange`的`Range<String.Index>`
    func dd_range(_ nsrange: NSRange) -> Range<String.Index> {
        guard let range = Range(nsrange, in: self) else { fatalError("Failed to find range \(nsrange) in \(self)") }
        return range
    }

    /// 获取`subString`在当前字符串中的`Range`
    /// - Parameter subString: 用于查找的字符串
    /// - Returns: 结果`Range<String.Index>?`
    func dd_range(_ subString: String) -> Range<String.Index>? {
        return self.range(of: subString)
    }

    /// 将`Range<String.Index>`转换为`NSRange`
    /// - Parameter range: 要转换的`Range<String.Index>`
    /// - Returns: 在字符串中找到的 `Range` 的等效 `NSRange`
    func dd_NSRange(_ range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    /// 获取`subStr`在字符串中的`NSRange`
    /// - Parameter subStr: 用于查找的字符串
    /// - Returns: 结果`NSRange`
    func dd_NSRange(_ subString: String) -> NSRange {
        guard let range = self.range(of: subString) else {
            return NSRange(location: 0, length: 0)
        }
        return NSRange(range, in: self)
    }
}

// MARK: - 静态方法
public extension String {
    /// 生成指定长度的随机字符串
    /// - Parameter count: 字符个数
    /// - Returns: 随机字符串
    static func dd_random(count: Int) -> String {
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
    static func dd_loremIpsum(count: Int = 445) -> String {
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

public extension String {
    /// 根据长度分割字符串
    /// - Parameter length: 每段长度
    /// - Returns: `[String]`
    func dd_split(by length: Int) -> [String] {
        var result = [String]()
        var startIndex = self.startIndex

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            result.append(String(self[startIndex ..< endIndex]))
            startIndex = endIndex
        }
        return result
    }
}
