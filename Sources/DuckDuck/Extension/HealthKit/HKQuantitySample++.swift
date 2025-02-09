import HealthKit

// MARK: - 日期格式化
public extension HKQuantitySample {
    /// 获取健康数据记录的本地时间字符串
    /// - Returns: 格式化后的日期字符串
    func dd_formattedStartDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self.startDate)
    }
}

// MARK: - 心率数据分析
public extension HKQuantitySample {
    /// 获取心率的区间
    /// - Returns: 心率区间
    func dd_heartRateZone() -> String {
        let heartRate = self.quantity.doubleValue(for: HKUnit(from: "count/min"))

        switch heartRate {
        case 0 ..< 60:
            return "低"
        case 60 ..< 100:
            return "正常"
        case 100 ..< 140:
            return "轻度运动"
        case 140 ..< 180:
            return "中度运动"
        default:
            return "高强度运动"
        }
    }
}
