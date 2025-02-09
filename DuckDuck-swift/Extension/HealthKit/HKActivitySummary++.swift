import HealthKit

// MARK: - 判断目标完成情况
public extension HKActivitySummary {
    /// 判断是否完成站立目标（小时数）
    /// - Returns: 是否完成站立目标
    func dd_isCompleteStandHoursGoal() -> Bool {
        return self.appleStandHoursGoal.compare(self.appleStandHours) != .orderedDescending
    }

    /// 判断是否完成锻炼时间目标
    /// - Returns: 是否完成锻炼时间目标
    func dd_isCompleteExerciseTimeGoal() -> Bool {
        return self.appleExerciseTimeGoal.compare(self.appleExerciseTime) != .orderedDescending
    }

    /// 判断是否完成活动能量目标
    /// - Returns: 是否完成活动能量目标
    func dd_isCompleteActiveEnergyBurnedGoal() -> Bool {
        return self.activeEnergyBurnedGoal.compare(self.activeEnergyBurned) != .orderedDescending
    }
}
