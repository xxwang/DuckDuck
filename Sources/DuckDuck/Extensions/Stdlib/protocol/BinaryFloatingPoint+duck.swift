//
//  BinaryFloatingPoint+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

public extension BinaryFloatingPoint {
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }
}

// MARK: - 计算属性
public extension DDExtension where Base: BinaryFloatingPoint {
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

    /// 转换为`String`
    var as2String: String {
        return String(self.as2Double)
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

    /// 绝对值
    var abs: Base {
        return Swift.abs(self.base)
    }

    /// 向上取整
    var ceil: Base {
        return Foundation.ceil(self.base)
    }

    /// 向下取整
    var floor: Base {
        return Foundation.floor(self.base)
    }

    /// 四舍五入取整
    var roundAs2Int: Int {
        return Foundation.lround(self.as2Double)
    }
}

// MARK: - 小数截断及四舍五入操作
public extension DDExtension where Base: BinaryFloatingPoint {
    /// 截断小数点后指定小数位置
    /// - Parameter places: 小数点后位置
    /// - Returns: `Self`
    func truncate(_ places: Int) -> Base {
        let divisor = pow(10.0, (Swift.max(0, places)).dd.as2Double)
        let res = (self.as2Double * divisor).dd.floor / divisor
        return res as! Base
    }

    /// 对小数点后指定小数位置进行四舍五入
    /// - Parameter places: 小数点后位置
    /// - Returns: `Self`
    func round(_ places: Int) -> Base {
        let divisor = pow(10.0, (Swift.max(0, places)).dd.as2Double)
        let res = (self.as2Double * divisor).rounded() / divisor
        return res as! Base
    }

    /// 对小数点后指定小数位置进行指定规则的四舍五入
    /// - Parameters:
    ///   - places: 小数点后位置
    ///   - rule: 传入规则
    /// - Returns: `Self`
    func rounded(_ places: Int, rule: FloatingPointRoundingRule) -> Base {
        let divisor = pow(10.0, (Swift.max(0, places)).dd.as2Double)
        let res = (self.base.dd.as2Double * divisor).rounded(rule) / divisor
        return res as! Base
    }
}
