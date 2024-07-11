//
//  NSAttributedString+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 计算属性
public extension DDExtension where Base: NSAttributedString {
    /// 不可变属性字符串转可变属性字符串
    var as2NSMutableAttributedString: NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self.base)
    }

    /// 获取属性字符串的属性字典
    var attributes: [NSAttributedString.Key: Any] {
        guard self.base.length > 0 else { return [:] }
        return self.base.attributes(at: 0, effectiveRange: nil)
    }

    /// 获取整个属性字符串的`NSRange`
    var fullNSRange: NSRange {
        return NSRange(location: 0, length: self.base.length)
    }
}

// MARK: - 方法
public extension DDExtension where Base: NSAttributedString {
    /// 获取`subStr`在属性字符串中的`NSRange`
    /// - Parameter subStr: 用于查找的字符串
    /// - Returns: 结果`NSRange`
    func nsRange(_ subStr: String) -> NSRange {
        return self.base.string.dd.nsRange(subStr)
    }

    /// 获取`texts`在属性字符串中的所有`NSRange`
    /// - Parameter texts: 用于查找的字符串数组
    /// - Returns: 结果`[NSRange]`
    func nsRanges(with texts: [String]) -> [NSRange] {
        var ranges = [NSRange]()
        for str in texts {
            if self.base.string.contains(str) {
                let subStrArr = self.base.string.components(separatedBy: str)
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

    /// 计算属性字符串在指定的宽度下的`CGSize`
    /// - Parameter lineWidth: 宽度
    /// - Returns: 结果`CGSize`
    func attributedSize(_ lineWidth: CGFloat = kScreenWidth) -> CGSize {
        let constraint = CGSize(width: lineWidth, height: .greatestFiniteMagnitude)
        // .usesDeviceMetrics, .truncatesLastVisibleLine
        let size = self.base.boundingRect(
            with: constraint,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size
        return CGSize(width: size.width.dd.ceil, height: size.height.dd.ceil)
    }
}

// MARK: - 运算符
public extension NSAttributedString {
    /// 向`lhs`属性字符串中追加一个属性字符串`rhs`
    /// - Parameters:
    ///   - lhs: 目标`NSAttributedString`
    ///   - rhs: 要追加的`NSAttributedString`
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// 在`lhs`属性字符串中追加一个`rhs`字符串
    /// - Parameters:
    ///   - lhs: 目标`NSAttributedString`
    ///   - rhs: 要追加的`String`
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// 合并两个属性字符串,并返回一个新的
    /// - Parameters:
    ///   - lhs: 左值属性字符串
    ///   - rhs: 右值属性字符串
    /// - Returns: 新的属性字符串
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
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        lhs + NSAttributedString(string: rhs)
    }
}

// MARK: - Defaultable
extension NSAttributedString: Defaultable {
    public typealias Associatedtype = NSAttributedString

    @objc open class func `default`() -> Associatedtype {
        return NSAttributedString()
    }
}
