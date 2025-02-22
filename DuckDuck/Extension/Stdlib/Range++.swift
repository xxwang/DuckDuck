import Foundation

// MARK: - Range<String.Index> 的便捷扩展
public extension Range<String.Index> {
    /// 将 `Range<String.Index>` 转换为 `NSRange`。
    /// - Parameter string: 所在的字符串。
    /// - Returns: 转换后的 `NSRange`，如果 `Range` 无效，则返回 `NSNotFound`。
    ///
    /// - Example:
    /// ```swift
    /// let text = "Hello, world!"
    /// if let range = text.range(of: "world") {
    ///     let nsRange = range.dd_toNSRange(in: text)
    ///     print(nsRange) // 输出: {7, 5}
    /// }
    /// ```
    func dd_toNSRange(in string: String) -> NSRange {
        return NSRange(self, in: string)
    }
}

// MARK: - Range<Int> 常用方法
public extension Range<Int> {
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

// MARK: - Range 计算
public extension Range where Bound: Comparable {
    /// 获取两个范围的交集。
    /// - Parameter other: 另一个范围。
    /// - Returns: 两个范围的交集，如果没有交集，则返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// let range1 = 1..<10
    /// let range2 = 5..<15
    /// if let intersection = range1.dd_intersection(with: range2) {
    ///     print(intersection) // 输出: 5..<10
    /// }
    /// ```
    func dd_intersection(with other: Range<Bound>) -> Range<Bound>? {
        let lower = Swift.max(self.lowerBound, other.lowerBound)
        let upper = Swift.min(self.upperBound, other.upperBound)
        return lower < upper ? lower ..< upper : nil
    }

    /// 获取两个范围的并集。
    /// - Parameter other: 另一个范围。
    /// - Returns: 包含两个范围的最小范围。
    ///
    /// - Example:
    /// ```swift
    /// let range1 = 1..<10
    /// let range2 = 5..<15
    /// if let union = range1.dd_union(with: range2) {
    ///     print(union) // 输出: 1..<15
    /// }
    /// ```
    func dd_union(with other: Range<Bound>) -> Range<Bound> {
        let lower = Swift.min(self.lowerBound, other.lowerBound)
        let upper = Swift.max(self.upperBound, other.upperBound)
        return lower ..< upper
    }

    /// 获取两个范围的差集。
    /// - Parameter other: 另一个范围。
    /// - Returns: 差集组成的范围数组，可能为空。
    ///
    /// - Example:
    /// ```swift
    /// let range1 = 1..<10
    /// let range2 = 4..<6
    /// let difference = range1.dd_difference(with: range2)
    /// print(difference) // 输出: [1..<4, 6..<10]
    /// ```
    func dd_difference(with other: Range<Bound>) -> [Range<Bound>] {
        guard let intersection = self.dd_intersection(with: other) else {
            return [self] // 如果没有交集，整个范围即为差集
        }
        var result = [Range<Bound>]()
        if self.lowerBound < intersection.lowerBound {
            result.append(self.lowerBound ..< intersection.lowerBound)
        }
        if self.upperBound > intersection.upperBound {
            result.append(intersection.upperBound ..< self.upperBound)
        }
        return result
    }
}
