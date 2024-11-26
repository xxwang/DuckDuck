//
//  RangeExpression++.swift
//  DuckDuck
//
//  Created by xxwang on 15/11/2024.
//

import Foundation

// MARK: - RangeExpression<Int> 的便捷扩展
public extension RangeExpression where Bound == Int {
    /// 将区间内的整数转换为数组。
    /// - Returns: 包含区间内所有整数的数组。
    ///
    /// - Example:
    /// ```swift
    /// let range = 1...5
    /// print(range.dd_toArray()) // 输出: [1, 2, 3, 4, 5]
    /// ```
    func dd_toArray() -> [Int] {
        if let range = self as? Range<Int> {
            return Array(range)
        } else if let closedRange = self as? ClosedRange<Int> {
            return Array(closedRange)
        }
        return []
    }

    /// 获取区间的长度（整数数量）。
    /// - Returns: 区间内整数的数量。
    /// - 注意：`ClosedRange` 包含上界，`Range` 不包含上界。
    ///
    /// - Example:
    /// ```swift
    /// let closedRange = 1...5
    /// print(closedRange.dd_length()) // 输出: 5
    ///
    /// let range = 1..<5
    /// print(range.dd_length()) // 输出: 4
    /// ```
    func dd_length() -> Int {
        if let range = self as? Range<Int> {
            return range.upperBound - range.lowerBound
        } else if let closedRange = self as? ClosedRange<Int> {
            return closedRange.upperBound - closedRange.lowerBound + 1
        }
        return 0
    }

    /// 检查区间是否包含数组中的所有元素。
    /// - Parameter elements: 要检查的整数数组。
    /// - Returns: 如果数组中的所有元素都在区间内，则返回 `true`，否则返回 `false`。
    ///
    /// - Example:
    /// ```swift
    /// let range = 1...5
    /// print(range.dd_containsAll([2, 3])) // 输出: true
    /// print(range.dd_containsAll([2, 6])) // 输出: false
    /// ```
    func dd_containsAll(_ elements: [Int]) -> Bool {
        return elements.allSatisfy { self.contains($0) }
    }
}
