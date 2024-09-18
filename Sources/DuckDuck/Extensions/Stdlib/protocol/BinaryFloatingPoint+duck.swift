//
//  BinaryFloatingPoint+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

// MARK: - 类型转换
public extension BinaryFloatingPoint {
    /// 转换为`Bool`
    func dd_Bool() -> Bool {
        return self > 0 ? true : false
    }

    /// 转换为`Int`
    func dd_Int() -> Int {
        return Int(self)
    }

    /// 转换为`Int64`
    func dd_Int64() -> Int64 {
        return Int64(self)
    }

    /// 转换为`UInt`
    func dd_UInt() -> UInt {
        return UInt(self)
    }

    /// 转换为`UInt64`
    func dd_UInt64() -> UInt64 {
        return UInt64(self)
    }

    /// 转换为`Float`
    func dd_Float() -> Float {
        return Float(self)
    }

    /// 转换为`Double`
    func dd_Double() -> Double {
        return Double(self)
    }

    /// 转换为`CGFloat`
    func dd_CGFloat() -> CGFloat {
        return CGFloat(self)
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

    /// 转换为`String`
    func dd_String() -> String {
        return String(self.dd_Double())
    }

    /// 转换为`CGPoint`
    func dd_CGPoint() -> CGPoint {
        return CGPoint(x: self.dd_CGFloat(), y: self.dd_CGFloat())
    }

    /// 转换为`CGSize`
    func dd_CGSize() -> CGSize {
        return CGSize(width: self.dd_CGFloat(), height: self.dd_CGFloat())
    }

    /// `角度`转换为`弧度`(0-360) -> (0-2PI)
    func dd_radians() -> Double {
        return self.dd_Double() / 180.0 * Double.pi
    }

    /// `弧度`转换为`角度`(0-2PI) -> (0-360)
    func dd_degrees() -> Double {
        return self.dd_Double() * (180.0 / Double.pi)
    }

    /// 绝对值
    func dd_abs() -> Self {
        return Swift.abs(self)
    }

    /// 向上取整
    func dd_ceil() -> Self {
        return Foundation.ceil(self)
    }

    /// 向下取整
    func dd_floor() -> Self {
        return Foundation.floor(self)
    }

    /// 四舍五入取整
    func dd_roundAs2Int() -> Int {
        return Foundation.lround(self.dd_Double())
    }
}

// MARK: - 小数截断及四舍五入操作
public extension BinaryFloatingPoint {
    /// 截断小数点后指定小数位置
    /// - Parameter places: 小数点后位置
    /// - Returns: `Self`
    func dd_truncate(_ places: Int) -> Self {
        let divisor = pow(10.0, (Swift.max(0, places)).dd.as2Double)
        let res = (self.dd_Double() * divisor).dd_floor() / divisor
        return res as! Self
    }

    /// 对小数点后指定小数位置进行四舍五入
    /// - Parameter places: 小数点后位置
    /// - Returns: `Self`
    func dd_round(_ places: Int) -> Self {
        let divisor = pow(10.0, (Swift.max(0, places)).dd.as2Double)
        let res = (self.dd_Double() * divisor).rounded() / divisor
        return res as! Self
    }

    /// 对小数点后指定小数位置进行指定规则的四舍五入
    /// - Parameters:
    ///   - places: 小数点后位置
    ///   - rule: 传入规则
    /// - Returns: `Self`
    func dd_rounded(_ places: Int, rule: FloatingPointRoundingRule) -> Self {
        let divisor = pow(10.0, (Swift.max(0, places)).dd.as2Double)
        let res = (self.dd_Double() * divisor).rounded(rule) / divisor
        return res as! Self
    }
}
