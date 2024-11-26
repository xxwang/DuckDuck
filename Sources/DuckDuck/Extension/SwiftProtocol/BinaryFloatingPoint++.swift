//
//  BinaryFloatingPoint++.swift
//  DuckDuck
//
//  Created by xxwang on 16/11/2024.
//

import Foundation

// MARK: - 类型转换
public extension BinaryFloatingPoint {
    /// 转换为 `Bool`
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 5.0
    /// let result = value.dd_toBool() // true
    /// ```
    func dd_toBool() -> Bool {
        return self > 0
    }

    /// 转换为 `Int`
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 3.14
    /// let result = value.dd_toInt() // 3
    /// ```
    func dd_toInt() -> Int {
        return Int(self)
    }

    /// 转换为 `Int64`
    ///
    /// - Example:
    /// ```swift
    /// let value: Float = 2.718
    /// let result = value.dd_toInt64() // 2
    /// ```
    func dd_toInt64() -> Int64 {
        return Int64(self)
    }

    /// 转换为 `UInt`
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 42.99
    /// let result = value.dd_toUInt() // 42
    /// ```
    func dd_toUInt() -> UInt {
        return UInt(self)
    }

    /// 转换为 `UInt64`
    ///
    /// - Example:
    /// ```swift
    /// let value: Float = 10.5
    /// let result = value.dd_toUInt64() // 10
    /// ```
    func dd_toUInt64() -> UInt64 {
        return UInt64(self)
    }

    /// 转换为 `Float`
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 123.456
    /// let result = value.dd_toFloat() // 123.456 (转换为 Float 类型)
    /// ```
    func dd_toFloat() -> Float {
        return Float(self)
    }

    /// 转换为 `Double`
    ///
    /// - Example:
    /// ```swift
    /// let value: Float = 78.9
    /// let result = value.dd_toDouble() // 78.9 (转换为 Double 类型)
    /// ```
    func dd_toDouble() -> Double {
        return Double(self)
    }

    /// 转换为 `CGFloat`
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 55.5
    /// let result = value.dd_toCGFloat() // 55.5 (转换为 CGFloat 类型)
    /// ```
    func dd_toCGFloat() -> CGFloat {
        return CGFloat(self)
    }

    /// 转换为 `NSNumber`
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 100.5
    /// let result = value.dd_toNSNumber() // NSNumber(value: 100.5)
    /// ```
    func dd_toNSNumber() -> NSNumber {
        return NSNumber(value: self.dd_toDouble())
    }

    /// 转换为 `NSDecimalNumber`
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 45.67
    /// let result = value.dd_toNSDecimalNumber() // NSDecimalNumber(value: 45.67)
    /// ```
    func dd_toNSDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: self.dd_toDouble())
    }

    /// 转换为 `Decimal`
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 99.9
    /// let result = value.dd_toDecimal() // Decimal(99.9)
    /// ```
    func dd_toDecimal() -> Decimal {
        return self.dd_toNSDecimalNumber().decimalValue
    }

    /// 转换为 `String`
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 3.1415
    /// let result = value.dd_toString() // "3.1415"
    /// ```
    func dd_toString() -> String {
        return "\(self)"
    }

    /// 转换为 `CGPoint`，x 和 y 均使用当前值
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 10.5
    /// let result = value.dd_toCGPoint() // CGPoint(x: 10.5, y: 10.5)
    /// ```
    func dd_toCGPoint() -> CGPoint {
        return CGPoint(x: self.dd_toCGFloat(), y: self.dd_toCGFloat())
    }

    /// 转换为 `CGSize`，width 和 height 均使用当前值
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 20.0
    /// let result = value.dd_toCGSize() // CGSize(width: 20.0, height: 20.0)
    /// ```
    func dd_toCGSize() -> CGSize {
        return CGSize(width: self.dd_toCGFloat(), height: self.dd_toCGFloat())
    }
}

// MARK: - 角度与弧度转换
public extension BinaryFloatingPoint {
    /// 将角度 (0-360) 转换为弧度 (0-2π)
    /// - Returns: 弧度值
    ///
    /// - Example:
    /// ```swift
    /// let degrees: Double = 180
    /// print(degrees.dd_toRadians()) // 输出：3.141592653589793
    /// ```
    func dd_toRadians() -> Double {
        return self.dd_toDouble() / 180.0 * Double.pi
    }

    /// 将弧度 (0-2π) 转换为角度 (0-360)
    /// - Returns: 角度值
    ///
    /// - Example:
    /// ```swift
    /// let radians: Double = Double.pi
    /// print(radians.dd_toDegrees()) // 输出：180.0
    /// ```
    func dd_toDegrees() -> Double {
        return self.dd_toDouble() * (180.0 / Double.pi)
    }
}

// MARK: - 数值操作
public extension BinaryFloatingPoint {
    /// 返回绝对值
    /// - Returns: 绝对值结果
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = -5.5
    /// print(value.dd_abs()) // 输出：5.5
    /// ```
    func dd_abs() -> Self {
        return Swift.abs(self)
    }

    /// 向上取整
    /// - Returns: 向上取整的结果
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 5.1
    /// print(value.dd_ceil()) // 输出：6.0
    /// ```
    func dd_ceil() -> Self {
        return Foundation.ceil(self)
    }

    /// 向下取整
    /// - Returns: 向下取整的结果
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 5.9
    /// print(value.dd_floor()) // 输出：5.0
    /// ```
    func dd_floor() -> Self {
        return Foundation.floor(self)
    }

    /// 四舍五入为 `Int`
    /// - Returns: 四舍五入后的整数
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 5.4
    /// print(value.dd_roundToInt()) // 输出：5
    /// ```
    func dd_roundToInt() -> Int {
        return Foundation.lround(self.dd_toDouble())
    }
}

// MARK: - 小数截断及四舍五入操作
public extension BinaryFloatingPoint {
    /// 截断小数点后指定小数位数
    /// - Parameter places: 小数点后位数
    /// - Returns: 截断结果
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 5.6789
    /// print(value.dd_truncate(2)) // 输出：5.67
    /// ```
    func dd_truncate(_ places: Int) -> Self {
        let divisor = pow(10.0, Self(places).dd_toDouble())
        let result = (self.dd_toDouble() * divisor).dd_floor() / divisor
        return result as! Self
    }

    /// 对小数点后指定小数位数进行四舍五入
    /// - Parameter places: 小数点后位数
    /// - Returns: 四舍五入结果
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 5.6789
    /// print(value.dd_round(2)) // 输出：5.68
    /// ```
    func dd_round(_ places: Int) -> Self {
        let divisor = pow(10.0, Self(places).dd_toDouble())
        let result = (self.dd_toDouble() * divisor).rounded() / divisor
        return result as! Self
    }

    /// 对小数点后指定小数位数进行指定规则的四舍五入
    /// - Parameters:
    ///   - places: 小数点后位数
    ///   - rule: 四舍五入规则
    /// - Returns: 结果
    ///
    /// - Example:
    /// ```swift
    /// let value: Double = 5.6789
    /// print(value.dd_rounded(2, rule: .down)) // 输出：5.67
    /// ```
    func dd_rounded(_ places: Int, rule: FloatingPointRoundingRule) -> Self {
        let divisor = pow(10.0, Self(places).dd_toDouble())
        let result = (self.dd_toDouble() * divisor).rounded(rule) / divisor
        return result as! Self
    }
}
