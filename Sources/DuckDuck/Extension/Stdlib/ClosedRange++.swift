//
//  ClosedRange++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 15/11/2024.
//

import Foundation

// MARK: - ClosedRange<Int> 常用方法
public extension ClosedRange<Int> {
    /// 从区间内随机生成一个整数。
    /// - Returns: 随机生成的整数
    ///
    /// - Example:
    /// ```swift
    /// let range = 1...5
    /// print(range.dd_random()) // 随机输出 1 到 5 的整数
    /// ```
    func dd_random() -> Int {
        return Int.random(in: self)
    }

    /// 根据偏移量调整区间范围。
    /// - Parameter offset: 偏移量。
    /// - Returns: 偏移后的区间。
    ///
    /// - Example:
    /// ```swift
    /// let range = 1...5
    /// print(range.dd_offset(by: 2)) // 输出: 3...7
    /// ```
    func dd_offset(by offset: Int) -> Range<Int> {
        return (self.lowerBound + offset) ..< (self.upperBound + offset)
    }
}

// MARK: - ClosedRange<Int> 计算
public extension ClosedRange<Int> {
    /// 获取两个范围的交集。
    /// - Parameter other: 要计算交集的另一个范围。
    /// - Returns: 两个范围的交集，如果没有交集则返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// let range1 = 1...10
    /// let range2 = 5...15
    /// print(range1.dd_intersection(with: range2)) // 输出: 5...10
    /// ```
    func dd_intersection(with other: ClosedRange<Int>) -> ClosedRange<Int>? {
        let lower = Swift.max(self.lowerBound, other.lowerBound)
        let upper = Swift.min(self.upperBound, other.upperBound)
        return lower <= upper ? lower ... upper : nil
    }

    /// 获取两个范围的并集。
    /// - Parameter other: 要计算并集的另一个范围。
    /// - Returns: 包含两个范围的最小闭合范围。
    ///
    /// - Example:
    /// ```swift
    /// let range1 = 1...10
    /// let range2 = 5...15
    /// print(range1.dd_union(with: range2)) // 输出: 1...15
    /// ```
    func dd_union(with other: ClosedRange<Int>) -> ClosedRange<Int> {
        let lower = Swift.min(self.lowerBound, other.lowerBound)
        let upper = Swift.max(self.upperBound, other.upperBound)
        return lower ... upper
    }

    /// 获取两个范围的差集。
    /// - Parameter other: 要计算差集的另一个范围。
    /// - Returns: 差集组成的区间数组（可能为空）。
    ///
    /// - Example:
    /// ```swift
    /// let range1 = 1...10
    /// let range2 = 5...15
    /// print(range1.dd_difference(with: range2)) // 输出: [1...4]
    /// ```
    func dd_difference(with other: ClosedRange<Int>) -> [ClosedRange<Int>] {
        guard let intersection = self.dd_intersection(with: other) else {
            return [self] // 如果没有交集，整个范围即为差集。
        }

        var result = [ClosedRange<Int>]()
        if self.lowerBound < intersection.lowerBound {
            result.append(self.lowerBound ... (intersection.lowerBound - 1))
        }
        if self.upperBound > intersection.upperBound {
            result.append((intersection.upperBound + 1) ... self.upperBound)
        }
        return result
    }
}
