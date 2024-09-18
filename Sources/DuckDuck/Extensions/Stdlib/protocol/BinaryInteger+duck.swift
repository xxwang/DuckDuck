//
//  BinaryInteger+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

public extension BinaryInteger {
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }
}

// MARK: - 计算属性
public extension DDExtension where Base: BinaryInteger {
    /// 转换为`Bool`
    var as2Bool: Bool {
        return self.base > 0 ? true : false
    }
    
    /// 转换为`Int`
    var as2Int: Int {
        return Int(self.base)
    }

    /// 转换为`Int64`
    var as2Int64: Int64 {
        return Int64(self.base)
    }

    /// 转换为`UInt`
    var as2UInt: UInt {
        return UInt(self.base)
    }

    /// 转换为`UInt64`
    var as2UInt64: UInt64 {
        return UInt64(self.base)
    }

    /// 转换为`Float`
    var as2Float: Float {
        return Float(self.base)
    }

    /// 转换为`Double`
    var as2Double: Double {
        return Double(self.base)
    }

    /// 转换为`CGFloat`
    var as2CGFloat: CGFloat {
        return CGFloat(self.base)
    }

    /// 转换为`NSNumber`
    var as2NSNumber: NSNumber {
        return NSNumber(value: self.as2Int)
    }

    /// 转换为`NSDecimalNumber`
    var as2NSDecimalNumber: NSDecimalNumber {
        return NSDecimalNumber(value: self.as2Int)
    }

    /// 转换为`Decimal`
    var as2Decimal: Decimal {
        return self.as2NSDecimalNumber.decimalValue
    }

    /// 转换为`String`
    var as2String: String {
        return String(self.base)
    }

    /// 转换为`Character`
    var as2Character: Character? {
        return Character(self.as2String)
    }

    /// 转换为`ASCII`
    var as2ASCII: Character? {
        let n = self.as2Int
        guard let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    /// 转换为`CGPoint`
    var as2CGPoint: CGPoint {
        return CGPoint(x: self.as2CGFloat, y: self.as2CGFloat)
    }

    /// 转换为`CGSize`
    var as2CGSize: CGSize {
        return CGSize(width: self.as2CGFloat, height: self.as2CGFloat)
    }

    /// `角度`转换为`弧度`(0-360) -> (0-2PI)
    var as2radians: Double {
        return self.as2Double / 180.0 * Double.pi
    }

    /// `弧度`转换为`角度`(0-2PI) -> (0-360)
    var as2degrees: Double {
        return self.as2Double * (180.0 / Double.pi)
    }

    /// 判断整数是否是奇数
    var isOdd: Bool {
        return (self.base % 2) != 0
    }

    /// 判断整数是否是偶数
    var isEven: Bool {
        return (self.base % 2) == 0
    }

    /// 转字节数组(`UInt8`数组)
    ///
    ///     var number = Int16(-128)
    ///     print(number.dd.bytes) ->  "[255, 128]"
    ///
    var bytes: [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Base>.size)
        var value = self.base
        for _ in 0 ..< MemoryLayout<Self>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }
}

// MARK: - 方法
public extension DDExtension where Base: BinaryInteger {
    /// 整形类型时间戳转换为`Date`对象
    /// - Parameter isUnix: 是否是Unix格式
    /// - Returns: `Date`对象
    func as2Date(isUnix: Bool = true) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.as2Double / (isUnix ? 1.0 : 1000.0)))
    }

    /// 生成`from-self`的半开区间
    /// - Parameter from: 开始位置
    /// - Returns: `CountableRange<Int>`
    func countableRange(from: some BinaryInteger) -> CountableRange<Int> {
        return from.dd.as2Int ..< self.as2Int
    }

    /// 生成`self-to`的半开区间
    /// - Parameter to: 结束位置
    /// - Returns: `CountableRange<Int>`
    func countableRange(to: some BinaryInteger) -> CountableRange<Int> {
        return self.as2Int ..< to.dd.as2Int
    }

    /// 生成`from-self`的全开区间
    /// - Parameter from: 开始位置
    /// - Returns: `ClosedRange<Int>`
    func closedRange(from: some BinaryInteger) -> ClosedRange<Int> {
        return from.dd.as2Int ... self.as2Int
    }

    /// 生成`self-to`的全开区间
    /// - Parameter to: 结束位置
    /// - Returns: `ClosedRange<Int>`
    func closedRange(to: some BinaryInteger) -> ClosedRange<Int> {
        return self.as2Int ... to.dd.as2Int
    }
}
