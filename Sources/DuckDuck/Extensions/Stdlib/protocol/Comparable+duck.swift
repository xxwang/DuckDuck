//
//  Comparable+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

public extension Comparable {
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }
}

public extension DDExtension where Base: Comparable {
    /// 判断数据是否在指定范围内
    /// - Parameter range: `x...y || x..<y`
    /// - Returns: 是否在范围内
    func isBetween(_ range: ClosedRange<Base>) -> Bool {
        return range ~= self.base
    }

    /// 限制数据在指定范围内
    /// - Parameter range: 值允许的范围
    /// - Returns: `>`返回`range.upperBound`, `<`返回`range.lowerBound`,`==`返回`self
    func clamped(to range: ClosedRange<Base>) -> Base {
        return Swift.max(range.lowerBound, Swift.min(self.base, range.upperBound))
    }
}
