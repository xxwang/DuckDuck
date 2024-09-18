//
//  Comparable+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

public extension  Comparable {
    /// 判断数据是否在指定范围内
    /// - Parameter range: `x...y || x..<y`
    /// - Returns: 是否在范围内
    func dd_isBetween(_ range: ClosedRange<Self>) -> Bool {
        return range ~= self
    }

    /// 限制数据在指定范围内
    /// - Parameter range: 值允许的范围
    /// - Returns: `>`返回`range.upperBound`, `<`返回`range.lowerBound`,`==`返回`self
    func dd_clamped(to range: ClosedRange<Self>) -> Self {
        return Swift.max(range.lowerBound, Swift.min(self, range.upperBound))
    }
}
