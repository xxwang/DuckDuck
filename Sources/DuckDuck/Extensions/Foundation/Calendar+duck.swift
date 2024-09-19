//
//  Calendar+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - 方法
public extension Calendar {
    /// 指定`Date`月份的`天数`
    /// - Parameter date: 日期 (默认:`Date.nowDate`)
    /// - Returns: 当月天数
    func dd_daysInMonth(for date: Date = Date()) -> Int {
        return self.range(of: .day, in: .month, for: date)!.count
    }
}
