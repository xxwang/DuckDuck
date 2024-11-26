//
//  NSAttributedString++.swift
//  DuckDuck
//
//  Created by xxwang on 22/11/2024.
//

import UIKit

// MARK: - 属性
public extension NSAttributedString {
    /// 将不可变属性字符串转换为可变属性字符串
    /// - Returns: 可变的 `NSMutableAttributedString`
    /// - Example:
    /// ```swift
    /// let mutableStr = attributedStr.dd_toNSMutableAttributedString()
    /// ```
    func dd_toNSMutableAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }

    /// 获取属性字符串的属性字典
    /// - Returns: 属性字典
    /// - Example:
    /// ```swift
    /// let attributes = attributedStr.dd_attributes()
    /// ```
    func dd_attributes() -> [NSAttributedString.Key: Any] {
        guard self.length > 0 else { return [:] }
        return self.attributes(at: 0, effectiveRange: nil)
    }

    /// 获取整个属性字符串的 `NSRange`
    /// - Returns: `NSRange`
    /// - Example:
    /// ```swift
    /// let fullRange = attributedStr.dd_fullNSRange()
    /// ```
    func dd_fullNSRange() -> NSRange {
        return NSRange(location: 0, length: self.length)
    }
}

// MARK: - 方法
public extension NSAttributedString {
    /// 获取 `subStr` 在属性字符串中的 `NSRange`
    /// - Parameter subStr: 用于查找的字符串
    /// - Returns: 结果 `NSRange`
    /// - Example:
    /// ```swift
    /// let range = attributedStr.dd_subNSRange("text")
    /// ```
    func dd_subNSRange(_ subStr: String) -> NSRange {
        return self.string.dd_subNSRange(subStr)
    }

    /// 获取 `texts` 在属性字符串中的所有 `NSRange`
    /// - Parameter texts: 用于查找的字符串数组
    /// - Returns: 结果 `[NSRange]`
    /// - Example:
    /// ```swift
    /// let ranges = attributedStr.dd_subNSRanges(with: ["text1", "text2"])
    /// ```
    func dd_subNSRanges(with texts: [String]) -> [NSRange] {
        var ranges = [NSRange]()
        for str in texts {
            if self.string.contains(str) {
                let subStrArr = self.string.components(separatedBy: str)
                var subStrIndex = 0
                for i in 0 ..< (subStrArr.count - 1) {
                    let subDivisionStr = subStrArr[i]
                    if i == 0 {
                        subStrIndex += (subDivisionStr.lengthOfBytes(using: .unicode) / 2)
                    } else {
                        subStrIndex += (subDivisionStr.lengthOfBytes(using: .unicode) / 2 + str.lengthOfBytes(using: .unicode) / 2)
                    }
                    ranges.append(NSRange(location: subStrIndex, length: str.count))
                }
            }
        }
        return ranges
    }
}

// MARK: - 尺寸计算
public extension NSAttributedString {
    /// 计算属性字符串在指定宽度下的 `CGSize`
    /// - Parameter lineWidth: 宽度，默认为 `.greatestFiniteMagnitude`
    /// - Returns: 计算出的 `CGSize`
    /// - Example:
    /// ```swift
    /// let size = attributedStr.dd_calculateAttributedSize(forWidth: 200)
    /// ```
    func dd_calculateAttributedSize(forWidth lineWidth: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        let constraint = CGSize(width: lineWidth, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(
            with: constraint,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size
        return CGSize(width: size.width.dd_ceil(), height: size.height.dd_ceil())
    }
}

// MARK: - 运算符
public extension NSAttributedString {
    /// 向 `lhs` 属性字符串中追加一个属性字符串 `rhs`
    /// - Parameters:
    ///   - lhs: 目标 `NSAttributedString`
    ///   - rhs: 要追加的 `NSAttributedString`
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// 在 `lhs` 属性字符串中追加一个 `rhs` 字符串
    /// - Parameters:
    ///   - lhs: 目标 `NSAttributedString`
    ///   - rhs: 要追加的 `String`
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// 合并两个属性字符串，并返回一个新的
    /// - Parameters:
    ///   - lhs: 左值属性字符串
    ///   - rhs: 右值属性字符串
    /// - Returns: 新的合并后的属性字符串
    /// - Example:
    /// ```swift
    /// let combined = attributedStr1 + attributedStr2
    /// ```
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    /// 将一个属性字符串和一个字符串合并起来
    /// - Parameters:
    ///   - lhs: 属性字符串
    ///   - rhs: 字符串
    /// - Returns: 新的属性字符串
    /// - Example:
    /// ```swift
    /// let combined = attributedStr + "more text"
    /// ```
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        lhs + NSAttributedString(string: rhs)
    }
}
