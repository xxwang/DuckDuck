//
//  BinaryInteger++.swift
//  DuckDuck
//
//  Created by xxwang on 16/11/2024.
//

import CoreGraphics
import Foundation

// MARK: - 类型转换
public extension BinaryInteger {
    /// 转换为 `Bool` (大于 0 为 `true`)
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 1
    /// let result = value.dd_toBool() // true
    /// ```
    func dd_toBool() -> Bool {
        return self > 0
    }

    /// 转换为 `Int`
    ///
    /// - Example:
    /// ```swift
    /// let value: UInt = 42
    /// let result = value.dd_toInt() // 42
    /// ```
    func dd_toInt() -> Int {
        return Int(self)
    }

    /// 转换为 `Int64`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 99
    /// let result = value.dd_toInt64() // 99
    /// ```
    func dd_toInt64() -> Int64 {
        return Int64(self)
    }

    /// 转换为 `UInt`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 7
    /// let result = value.dd_toUInt() // 7
    /// ```
    func dd_toUInt() -> UInt {
        return UInt(self)
    }

    /// 转换为 `UInt64`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 100
    /// let result = value.dd_toUInt64() // 100
    /// ```
    func dd_toUInt64() -> UInt64 {
        return UInt64(self)
    }

    /// 转换为 `Float`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 10
    /// let result = value.dd_toFloat() // 10.0
    /// ```
    func dd_toFloat() -> Float {
        return Float(self)
    }

    /// 转换为 `Double`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 15
    /// let result = value.dd_toDouble() // 15.0
    /// ```
    func dd_toDouble() -> Double {
        return Double(self)
    }

    /// 转换为 `CGFloat`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 25
    /// let result = value.dd_toCGFloat() // 25.0
    /// ```
    func dd_toCGFloat() -> CGFloat {
        return CGFloat(self)
    }

    /// 转换为 `NSNumber`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 50
    /// let result = value.dd_toNSNumber() // NSNumber(value: 50)
    /// ```
    func dd_toNSNumber() -> NSNumber {
        return NSNumber(value: self.dd_toInt())
    }

    /// 转换为 `NSDecimalNumber`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 100
    /// let result = value.dd_toNSDecimalNumber() // NSDecimalNumber(value: 100)
    /// ```
    func dd_toNSDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: self.dd_toInt())
    }

    /// 转换为 `Decimal`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 88
    /// let result = value.dd_toDecimal() // Decimal(88)
    /// ```
    func dd_toDecimal() -> Decimal {
        return self.dd_toNSDecimalNumber().decimalValue
    }

    /// 转换为 `String`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 123
    /// let result = value.dd_toString() // "123"
    /// ```
    func dd_toString() -> String {
        return "\(self)"
    }

    /// 转换为 `Character`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 65
    /// let result = value.dd_toCharacter() // Optional("6")
    /// ```
    func dd_toCharacter() -> Character? {
        return Character(self.dd_toString())
    }

    /// 转换为 ASCII `Character`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 65
    /// let result = value.dd_toASCII() // Optional("A")
    /// ```
    func dd_toASCII() -> Character? {
        let n = self.dd_toInt()
        guard let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    /// 转换为 `CGPoint`，x 和 y 值均使用当前值
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 10
    /// let result = value.dd_toCGPoint() // CGPoint(x: 10.0, y: 10.0)
    /// ```
    func dd_toCGPoint() -> CGPoint {
        return CGPoint(x: self.dd_toCGFloat(), y: self.dd_toCGFloat())
    }

    /// 转换为 `CGSize`，width 和 height 均使用当前值
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 20
    /// let result = value.dd_toCGSize() // CGSize(width: 20.0, height: 20.0)
    /// ```
    func dd_toCGSize() -> CGSize {
        return CGSize(width: self.dd_toCGFloat(), height: self.dd_toCGFloat())
    }
}

// MARK: - 角度与弧度转换 (BinaryInteger)
public extension BinaryInteger {
    /// 将角度 (0-360) 转换为弧度 (0-2π)
    ///
    /// - Example:
    /// ```swift
    /// let degrees: Int = 180
    /// print(degrees.dd_toRadians()) // 输出: 3.141592653589793
    /// ```
    /// - Returns: 弧度值
    func dd_toRadians() -> Double {
        return Double(self) / 180.0 * Double.pi
    }

    /// 将弧度 (0-2π) 转换为角度 (0-360)
    ///
    /// - Example:
    /// ```swift
    /// let radians: Int = 3
    /// print(radians.dd_toDegrees()) // 输出: 171.88733853924697
    /// ```
    /// - Returns: 角度值
    func dd_toDegrees() -> Double {
        return Double(self) * (180.0 / Double.pi)
    }
}

// MARK: - 数值操作
public extension BinaryInteger {
    /// 判断是否是奇数
    ///
    /// - Example:
    /// ```swift
    /// let value = 3
    /// let result = value.dd_isOdd() // true
    /// ```
    func dd_isOdd() -> Bool {
        return (self % 2) != 0
    }

    /// 判断是否是偶数
    ///
    /// - Example:
    /// ```swift
    /// let value = 4
    /// let result = value.dd_isEven() // true
    /// ```
    func dd_isEven() -> Bool {
        return (self % 2) == 0
    }

    /// 转换为字节数组 (`UInt8` 数组)
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 256
    /// let result = value.dd_toBytes() // [0, 0, 0, 1]
    /// ```
    func dd_toBytes() -> [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Self>.size)
        var value = self
        for _ in 0 ..< MemoryLayout<Self>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }

    /// 转换为存储单位 (如 KB, MB, GB)
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 1048576
    /// let result = value.dd_toStorageUnit() // "1.00 MB"
    /// ```
    func dd_toStorageUnit() -> String {
        var value = self.dd_toDouble()
        var index = 0
        let units = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while value > 1024 {
            value /= 1024
            index += 1
        }
        return String(format: "%.2f %@", value, units[index])
    }

    /// 转换为罗马数字
    ///
    /// - Example:
    /// ```swift
    /// let value: Int = 1987
    /// let result = value.dd_toRomanNumeral() // "MCMLXXXVII"
    /// ```
    func dd_toRomanNumeral() -> String? {
        guard self > 0 else { return nil }

        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = self.dd_toInt()

        for (index, romanChar) in romanValues.enumerated() {
            let arabicValue = arabicValues[index]
            let div = startingValue / arabicValue
            for _ in 0 ..< div {
                romanValue.append(romanChar)
            }
            startingValue -= arabicValue * div
        }
        return romanValue
    }
}

// MARK: - 时间与区间
public extension BinaryInteger {
    /// 转换为 `Date` 对象
    /// - Parameter isUnix: 是否是 Unix 时间戳
    ///
    /// - Example:
    /// ```swift
    /// let timestamp: Int = 1609459200
    /// let date = timestamp.dd_toDate() // 2021-01-01 00:00:00 +0000
    /// ```
    func dd_toDate(isUnix: Bool = true) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.dd_toDouble() / (isUnix ? 1.0 : 1000.0)))
    }

    /// 生成从起点到自身的半开区间
    ///
    /// - Example:
    /// ```swift
    /// let range = 10.dd_toCountableRange(from: 5)
    /// print(range) // 5..<10
    /// ```
    func dd_toCountableRange(from: some BinaryInteger) -> CountableRange<Int> {
        return from.dd_toInt() ..< self.dd_toInt()
    }

    /// 生成从自身到终点的半开区间
    ///
    /// - Example:
    /// ```swift
    /// let range = 5.dd_toCountableRange(to: 10)
    /// print(range) // 5..<10
    /// ```
    func dd_toCountableRange(to: some BinaryInteger) -> CountableRange<Int> {
        return self.dd_toInt() ..< to.dd_toInt()
    }

    /// 秒转换成播放时间字符串
    /// - Parameter component: 需要特定时间单位的格式（可选）
    ///
    /// - Example:
    /// ```swift
    /// let duration = 3661
    /// let fullTime = duration.dd_toMediaTimeString() // "01:01:01"
    /// let minutes = duration.dd_toMediaTimeString(component: .minute) // "61:01"
    /// ```
    func dd_toMediaTimeString(component: Calendar.Component? = nil) -> String {
        if self <= 0 { return "00:00" }

        let second = self.dd_toInt() % 60
        if component == .second {
            return String(format: "%02d", second)
        }

        var minute = self.dd_toInt() / 60
        if component == .minute {
            return String(format: "%02d:%02d", minute, second)
        }

        var hour = 0
        if minute >= 60 {
            hour = minute / 60
            minute %= 60
        }

        if component == .hour {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }

        return hour > 0 ? String(format: "%02d:%02d:%02d", hour, minute, second)
            : String(format: "%02d:%02d", minute, second)
    }
}
