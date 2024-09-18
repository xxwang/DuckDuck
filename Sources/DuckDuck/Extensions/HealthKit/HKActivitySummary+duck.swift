//
//  HKActivitySummary+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import HealthKit

// MARK: - 判断
public extension HKActivitySummary {
    /// 是否完成设定的站立目标(小时数)
    func dd_isCompleteStandHoursGoal() -> Bool {
        return self.appleStandHoursGoal.compare(self.appleStandHours) != .orderedDescending
    }

    /// 检查是否达到设置的锻炼时间
    func dd_isCompleteExerciseTimeGoal() -> Bool {
        return self.appleExerciseTimeGoal.compare(self.appleExerciseTime) != .orderedDescending
    }

    /// 检查是否达到设置的活动能量
    func dd_isCompleteActiveEnergyBurnedGoal() -> Bool {
        return self.activeEnergyBurnedGoal.compare(self.activeEnergyBurned) != .orderedDescending
    }
}
