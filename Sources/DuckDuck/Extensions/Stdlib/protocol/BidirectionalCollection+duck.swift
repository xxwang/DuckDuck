//
//  BidirectionalCollection+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - 下标
public extension BidirectionalCollection {
    /// 返回指定位置的元素,如果`distance`为负数,则将返回结尾处的第`n`个元素
    ///
    ///     let arr = [1, 2, 3, 4, 5]
    ///     arr[offset:1] -> 2
    ///     arr[offset:-2] -> 4
    ///
    /// - Parameter distance: 要偏移的距离
    /// - Returns: 偏移位置对应元素
    subscript(offset distance: Int) -> Element {
        let index = distance >= 0 ? startIndex : endIndex
        return self[indices.index(index, offsetBy: distance)]
    }
}
