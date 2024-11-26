//
//  Comparable++.swift
//  DuckDuck
//
//  Created by xxwang on 16/11/2024.
//

import Foundation

// MARK: - Comparable 扩展
public extension Comparable {
    /// 判断值是否在闭区间范围内
    /// - Parameter range: 闭区间范围（`x...y`）
    /// - Returns: 如果值在范围内，则返回 `true`；否则返回 `false`
    ///
    /// - Example:
    /// ```swift
    /// let value = 5
    /// print(value.dd_isWithin(1...10)) // 输出：true
    /// print(value.dd_isWithin(6...10)) // 输出：false
    /// ```
    func dd_isWithin(_ range: ClosedRange<Self>) -> Bool {
        return range ~= self
    }

    /// 判断值是否在开区间范围内
    /// - Parameter range: 开区间范围（`x..<y`）
    /// - Returns: 如果值在范围内，则返回 `true`；否则返回 `false`
    ///
    /// - Example:
    /// ```swift
    /// let value = 5
    /// print(value.dd_isWithin(1..<10)) // 输出：true
    /// print(value.dd_isWithin(10..<20)) // 输出：false
    /// ```
    func dd_isWithin(_ range: Range<Self>) -> Bool {
        return range.contains(self)
    }

    /// 判断值是否在数组的最小值和最大值范围内
    /// - Parameter array: 用于计算范围的数组
    /// - Returns: 如果值在范围内，则返回 `true`；否则返回 `false`
    ///
    /// - Example:
    /// ```swift
    /// let value = 7
    /// print(value.dd_isWithin(array: [1, 3, 7, 10])) // 输出：true
    /// print(value.dd_isWithin(array: [10, 20, 30]))  // 输出：false
    /// ```
    func dd_isWithin(array: [Self]) -> Bool {
        guard let minValue = array.min(), let maxValue = array.max() else {
            return false
        }
        return self >= minValue && self <= maxValue
    }

    /// 限制值在指定闭区间内
    /// - Parameter range: 允许的范围（闭区间 `x...y`）
    /// - Returns: 如果值小于范围下限，返回下限；如果大于范围上限，返回上限；否则返回自身
    ///
    /// - Example:
    /// ```swift
    /// let value = 12
    /// print(value.dd_clamped(to: 1...10)) // 输出：10
    /// let value2 = -5
    /// print(value2.dd_clamped(to: 0...5)) // 输出：0
    /// ```
    func dd_clamped(to range: ClosedRange<Self>) -> Self {
        return Swift.max(range.lowerBound, Swift.min(self, range.upperBound))
    }

    /// 限制值在最小值范围内
    /// - Parameter min: 最小值
    /// - Returns: 如果值小于 `min`，返回 `min`；否则返回自身
    ///
    /// - Example:
    /// ```swift
    /// let value = 5
    /// print(value.dd_clamped(min: 10)) // 输出：10
    /// let value2 = 15
    /// print(value2.dd_clamped(min: 10)) // 输出：15
    /// ```
    func dd_clamped(min: Self) -> Self {
        return Swift.max(self, min)
    }

    /// 限制值在最大值范围内
    /// - Parameter max: 最大值
    /// - Returns: 如果值大于 `max`，返回 `max`；否则返回自身
    ///
    /// - Example:
    /// ```swift
    /// let value = 20
    /// print(value.dd_clamped(max: 15)) // 输出：15
    /// let value2 = 5
    /// print(value2.dd_clamped(max: 15)) // 输出：5
    /// ```
    func dd_clamped(max: Self) -> Self {
        return Swift.min(self, max)
    }
}

// MARK: - Comparable 扩展 (适用于 BinaryInteger)
public extension Comparable where Self: Strideable, Self.Stride: SignedInteger {
    /// 限制值在开闭区间内
    /// - Parameter range: 开闭区间范围（`x..<y`）
    /// - Returns: 限制后的值
    ///
    /// - Example:
    /// ```swift
    /// let value = 12
    /// print(value.dd_clamped(to: 5..<10)) // 输出：10
    ///
    /// let value2 = 3
    /// print(value2.dd_clamped(to: 5..<10)) // 输出：5
    /// ```
    func dd_clamped(to range: Range<Self>) -> Self {
        if self < range.lowerBound {
            return range.lowerBound
        } else if self >= range.upperBound {
            return range.upperBound.advanced(by: -1)
        }
        return self
    }
}

// MARK: - Comparable 扩展 (SignedNumeric)
public extension Comparable where Self: SignedNumeric {
    /// 获取值与目标值的绝对差值
    /// - Parameter target: 目标值
    /// - Returns: 值与目标值之间的绝对差值
    ///
    /// - Example:
    /// ```swift
    /// let value = 7
    /// print(value.dd_distance(to: 10)) // 输出：3
    /// let value2 = -5
    /// print(value2.dd_distance(to: 5)) // 输出：10
    /// ```
    func dd_distance(to target: Self) -> Self {
        return Swift.abs(self - target)
    }
}
