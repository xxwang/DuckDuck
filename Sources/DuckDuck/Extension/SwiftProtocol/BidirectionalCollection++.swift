//
//  BidirectionalCollection++.swift
//  DuckDuck
//
//  Created by xxwang on 16/11/2024.
//

import Foundation

// MARK: - BidirectionalCollection 扩展
public extension BidirectionalCollection {
    /// 根据偏移量返回指定位置的元素
    /// - Parameters:
    ///   - distance: 偏移量，正数从头部开始偏移，负数从尾部开始偏移
    ///   - safe: 是否进行越界安全检查，默认为 `false`
    /// - Returns: 偏移位置对应的元素；若越界且 `safe` 为 `true` 时返回 `nil`
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array[dd_offset: 1])         // 输出：2
    /// print(array[dd_offset: -2])        // 输出：4
    /// print(array[dd_offset: 10, safe: true]) // 输出：nil
    /// ```
    subscript(dd_offset distance: Int, safe: Bool = false) -> Element? {
        if safe {
            guard let idx = self.dd_offsetIndex(distance) else { return nil }
            return self[idx]
        } else {
            let index = distance >= 0 ? startIndex : endIndex
            return self[indices.index(index, offsetBy: distance)]
        }
    }

    /// 返回偏移后的索引，若越界则返回 `nil`
    /// - Parameter distance: 偏移量，正数从头部开始偏移，负数从尾部开始偏移
    /// - Returns: 偏移后的索引，若越界返回 `nil`
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.dd_offsetIndex(1))   // 输出：Optional(1)
    /// print(array.dd_offsetIndex(-10)) // 输出：nil
    /// ```
    func dd_offsetIndex(_ distance: Int) -> Index? {
        let index = distance >= 0 ? startIndex : endIndex
        return indices.index(index, offsetBy: distance, limitedBy: distance >= 0 ? endIndex : startIndex)
    }
}

// MARK: - 常用方法
public extension BidirectionalCollection {
    /// 返回集合从头部截取指定数量的元素
    /// - Parameter count: 要截取的元素数量
    /// - Returns: 截取后的集合
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.dd_prefix(count: 3)) // 输出：[1, 2, 3]
    /// ```
    func dd_prefix(count: Int) -> SubSequence {
        guard count > 0 else { return self[startIndex ..< startIndex] }
        return prefix(count)
    }

    /// 返回集合从尾部截取指定数量的元素
    /// - Parameter count: 要截取的元素数量
    /// - Returns: 截取后的集合
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.dd_suffix(count: 3)) // 输出：[3, 4, 5]
    /// ```
    func dd_suffix(count: Int) -> SubSequence {
        guard count > 0 else { return self[endIndex ..< endIndex] }
        return suffix(count)
    }

    /// 将集合的元素以指定大小进行分组
    /// - Parameter size: 每组的大小
    /// - Returns: 分组后的二维数组
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.dd_chunked(by: 2)) // 输出：[[1, 2], [3, 4], [5]]
    /// ```
    func dd_chunked(by size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        var result: [[Element]] = []
        var startIndex = self.startIndex

        while startIndex != endIndex {
            let endIndex = indices.index(startIndex, offsetBy: size, limitedBy: self.endIndex) ?? self.endIndex
            result.append(Array(self[startIndex ..< endIndex]))
            startIndex = endIndex
        }

        return result
    }
}
