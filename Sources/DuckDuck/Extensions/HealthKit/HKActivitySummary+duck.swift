//
//  HKActivitySummary+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import HealthKit

// MARK: - 判断
public extension DDExtension where Base: HKActivitySummary {
    /// 是否完成设定的站立目标(小时数)
    var isCompleteStandHoursGoal: Bool {
        return self.base.appleStandHoursGoal.compare(self.base.appleStandHours) != .orderedDescending
    }

    /// 检查是否达到设置的锻炼时间
    var isCompleteExerciseTimeGoal: Bool {
        return self.base.appleExerciseTimeGoal.compare(self.base.appleExerciseTime) != .orderedDescending
    }

    /// 检查是否达到设置的活动能量
    var isCompleteActiveEnergyBurnedGoal: Bool {
        return self.base.activeEnergyBurnedGoal.compare(self.base.activeEnergyBurned) != .orderedDescending
    }
}
