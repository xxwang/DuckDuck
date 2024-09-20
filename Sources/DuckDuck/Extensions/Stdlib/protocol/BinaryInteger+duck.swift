//
//  BinaryInteger+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

// MARK: - 类型转换
public extension BinaryInteger {
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
        return NSNumber(value: self.dd_Int())
    }

    /// 转换为`NSDecimalNumber`
    func dd_NSDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: self.dd_Int())
    }

    /// 转换为`Decimal`
    func dd_Decimal() -> Decimal {
        return self.dd_NSDecimalNumber().decimalValue
    }

    /// 转换为`String`
    func dd_String() -> String {
        return String(self)
    }

    /// 转换为`Character`
    func dd_Character() -> Character? {
        return Character(self.dd_String())
    }

    /// 转换为`ASCII`
    func dd_ASCII() -> Character? {
        let n = self.dd_Int()
        guard let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
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

    /// 判断整数是否是奇数
    func dd_isOdd() -> Bool {
        return (self % 2) != 0
    }

    /// 判断整数是否是偶数
    func dd_isEven() -> Bool {
        return (self % 2) == 0
    }

    /// 转字节数组(`UInt8`数组)
    ///
    ///     var number = Int16(-128)
    ///     print(number.dd_bytes()) ->  "[255, 128]"
    ///
    func dd_bytes() -> [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Self>.size)
        var value = self
        for _ in 0 ..< MemoryLayout<Self>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }

    /// `byte(字节)`转换存储单位
    /// - Returns: `String`单位大小
    func dd_storeUnit() -> String {
        var value = self.dd_Double()
        var index = 0
        let units = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while value > 1024 {
            value /= 1024
            index += 1
        }
        return String(format: "%4.2f %@", value, units[index])
    }

    /// 数字转罗马数字
    /// - Returns: `String?`罗马数字
    func dd_romanNumeral() -> String? {
        guard self > 0 else { return nil }

        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = self.dd_Int()

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

// MARK: - 方法
public extension BinaryInteger {
    /// 整形类型时间戳转换为`Date`对象
    /// - Parameter isUnix: 是否是Unix格式
    /// - Returns: `Date`对象
    func dd_Date(isUnix: Bool = true) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.dd_Double() / (isUnix ? 1.0 : 1000.0)))
    }

    /// 生成`from-self`的半开区间
    /// - Parameter from: 开始位置
    /// - Returns: `CountableRange<Int>`
    func dd_countableRange(from: some BinaryInteger) -> CountableRange<Int> {
        return from.dd_Int() ..< self.dd_Int()
    }

    /// 生成`self-to`的半开区间
    /// - Parameter to: 结束位置
    /// - Returns: `CountableRange<Int>`
    func dd_ountableRange(to: some BinaryInteger) -> CountableRange<Int> {
        return self.dd_Int() ..< to.dd_Int()
    }

    /// 生成`from-self`的全开区间
    /// - Parameter from: 开始位置
    /// - Returns: `ClosedRange<Int>`
    func dd_closedRange(from: some BinaryInteger) -> ClosedRange<Int> {
        return from.dd_Int() ... self.dd_Int()
    }

    /// 生成`self-to`的全开区间
    /// - Parameter to: 结束位置
    /// - Returns: `ClosedRange<Int>`
    func dd_closedRange(to: some BinaryInteger) -> ClosedRange<Int> {
        return self.dd_Int() ... to.dd_Int()
    }

    /// 秒转换成播放时间条的格式
    /// - Parameters:
    ///   - component:格式类型`nil`为默认类型
    /// - Returns:返回时间条
    func dd_mediaTimeString(component: Calendar.Component? = nil) -> String {
        if self <= 0 { return "00:00" }

        // 秒
        let second = self.dd_Int() % 60
        if component == .second {
            return String(format: "%02d", self.dd_Int())
        }

        // 分钟
        var minute = Int(self / 60)
        if component == .minute {
            return String(format: "%02d:%02d", minute, second)
        }

        // 小时
        var hour = 0
        if minute >= 60 {
            hour = Int(minute / 60)
            minute = minute - hour * 60
        }

        if component == .hour {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }

        // normal 类型
        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }

        if minute > 0 {
            return String(format: "%02d:%02d", minute, second)
        }
        return String(format: "%02d", second)
    }
}
