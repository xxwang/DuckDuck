//
//  HKStatistics++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import HealthKit

// MARK: - 活动数据计算
public extension HKStatistics {
    /// 获取统计数据的总和（适用于步数、距离等）
    /// - Returns: 数据总和
    func dd_totalQuantity() -> Double? {
        guard let quantity = sumQuantity() else { return nil }
        return quantity.doubleValue(for: HKUnit.count())
    }

    /// 获取统计数据的平均值
    /// - Returns: 数据平均值
    func dd_averageQuantity() -> Double? {
        guard let quantity = averageQuantity() else { return nil }
        return quantity.doubleValue(for: HKUnit.count())
    }
}
