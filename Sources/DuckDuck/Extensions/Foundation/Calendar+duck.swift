//
//  Calendar+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

extension Calendar: DDExtensionable {}

// MARK: - 方法
public extension DDExtension where Base == Calendar {
    /// 指定`Date`月份的`天数`
    /// - Parameter date: 日期 (默认:`Date.nowDate`)
    /// - Returns: 当月天数
    func daysInMonth(for date: Date = Date()) -> Int {
        return self.base.range(of: .day, in: .month, for: date)!.count
    }
}
