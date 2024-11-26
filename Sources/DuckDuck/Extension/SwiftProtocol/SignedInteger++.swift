//
//  SignedInteger++.swift
//  DuckDuck
//
//  Created by xxwang on 16/11/2024.
//

import Foundation

// MARK: - 判断
public extension SignedInteger {
    /// 判断是否为正数
    /// - Returns: 如果是正数，返回 `true`
    ///
    /// - Example:
    /// ```swift
    /// let value = 5
    /// print(value.dd_isPositive()) // true
    /// ```
    func dd_isPositive() -> Bool {
        return self > 0
    }

    /// 判断是否为负数
    /// - Returns: 如果是负数，返回 `true`
    ///
    /// - Example:
    /// ```swift
    /// let value = -3
    /// print(value.dd_isNegative()) // true
    /// ```
    func dd_isNegative() -> Bool {
        return self < 0
    }

    /// 判断是否为质数
    /// - Returns: 如果是质数，返回 `true`
    ///
    /// - Example:
    /// ```swift
    /// let value = 7
    /// print(value.dd_isPrime()) // true
    /// let nonPrime = 8
    /// print(nonPrime.dd_isPrime()) // false
    /// ```
    func dd_isPrime() -> Bool {
        guard self > 1 else { return false }
        let maxDivider = Int(Double(self).squareRoot())
        for i in 2 ... maxDivider {
            if Int(self) % i == 0 {
                return false
            }
        }
        return true
    }
}

// MARK: - 数值操作
public extension SignedInteger {
    /// 转换为罗马数字表示法
    /// - Returns: 罗马数字字符串；若数值小于等于 0，返回 `nil`
    ///
    /// - Example:
    /// ```swift
    /// let value = 1994
    /// print(value.dd_toRomanNumeral()) // Optional("MCMXCIV")
    /// let negative = -5
    /// print(negative.dd_toRomanNumeral()) // nil
    /// ```
    func dd_toRomanNumeral() -> String? {
        guard self > 0 else { return nil }

        let romanSymbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let romanValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var value = self
        var result = ""

        for (index, symbol) in romanSymbols.enumerated() {
            let count = Int(value / Self(romanValues[index]))
            if count > 0 {
                result += String(repeating: symbol, count: count)
                value -= Self(count * romanValues[index])
            }
        }
        return result
    }

    /// 返回绝对值
    /// - Returns: 绝对值
    ///
    /// - Example:
    /// ```swift
    /// let value = -42
    /// print(value.dd_abs()) // 42
    /// ```
    func dd_abs() -> Self {
        return Swift.abs(self)
    }

    /// 最大公约数 (GCD)
    /// - Parameter other: 另一个整数
    /// - Returns: 最大公约数
    ///
    /// - Example:
    /// ```swift
    /// let a = 12
    /// let b = 15
    /// print(a.dd_gcd(with: b)) // 3
    /// ```
    func dd_gcd(with other: Self) -> Self {
        var a = Swift.abs(self)
        var b = Swift.abs(other)
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return a
    }

    /// 最小公倍数 (LCM)
    /// - Parameter other: 另一个整数
    /// - Returns: 最小公倍数
    ///
    /// - Example:
    /// ```swift
    /// let a = 12
    /// let b = 15
    /// print(a.dd_lcm(with: b)) // 60
    /// ```
    func dd_lcm(with other: Self) -> Self {
        guard self != 0, other != 0 else { return 0 }
        return Swift.abs(self * other) / self.dd_gcd(with: other)
    }

    /// 计算阶乘
    /// - Returns: 阶乘结果；若数值小于 0，则返回 `nil`
    ///
    /// - Example:
    /// ```swift
    /// let value = 5
    /// print(value.dd_factorial()) // Optional(120)
    /// let negative = -3
    /// print(negative.dd_factorial()) // nil
    /// ```
    func dd_factorial() -> Self? {
        guard self >= 0 else { return nil }
        var result: Self = 1
        var current = self
        while current > 1 {
            result *= current
            current -= 1
        }
        return result
    }

    /// 重复执行某个操作
    /// - Parameter action: 执行的闭包
    ///
    /// - Example:
    /// ```swift
    /// 3.dd_repeat {
    ///     print("Hello!")
    /// }
    /// // 输出:
    /// // Hello!
    /// // Hello!
    /// // Hello!
    /// ```
    func dd_repeat(action: () -> Void) {
        guard self > 0 else { return }
        var count = self
        while count > 0 {
            action()
            count -= 1
        }
    }
}
