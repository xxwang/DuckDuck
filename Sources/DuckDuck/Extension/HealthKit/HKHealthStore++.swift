//
//  HKHealthStore++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import HealthKit

// MARK: - 数据同步
public extension HKHealthStore {
    /// 同步健康数据到健康应用
    /// - Parameters:
    ///   - sample: 健康数据样本
    ///   - completion: 数据同步结果回调
    func dd_saveSample(_ sample: HKSample, completion: @escaping @Sendable (Bool, Error?) -> Void) {
        save(sample) { success, error in
            completion(success, error)
        }
    }
}

// MARK: - 步数监控
public extension HKHealthStore {
    /// 开始监听步数的变化
    /// - Parameter handler: 变化回调
    func dd_startStepCountUpdates(handler: @escaping @Sendable (HKQuantity?, Error?) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            handler(nil, NSError(domain: "HealthKitError", code: 1, userInfo: [NSLocalizedDescriptionKey: "步数数据类型不可用"]))
            return
        }

        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { _, _, error in
            if let error {
                handler(nil, error)
                return
            }

            // 获取最新的步数数据
            let now = Date()
            let predicate = HKQuery.predicateForSamples(withStart: now.addingTimeInterval(-60), end: now, options: .strictEndDate)

            let statisticsQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                if let error {
                    handler(nil, error)
                    return
                }

                guard let result else {
                    handler(nil, NSError(domain: "HealthKitError", code: 2, userInfo: [NSLocalizedDescriptionKey: "步数数据查询失败"]))
                    return
                }

                handler(result.sumQuantity(), nil)
            }

            self.execute(statisticsQuery)
        }

        self.execute(query)
    }
}

// MARK: - 获取健康数据类型
public extension HKHealthStore {
    /// 获取指定标识符的健康数据类型
    /// - Parameter identifier: 健康数据类型标识符
    /// - Returns: 对应的 `HKObjectType` 类型
    func dd_getObjectType(forIdentifier identifier: HKQuantityTypeIdentifier) -> HKQuantityType? {
        switch identifier {
        case .stepCount:
            return HKQuantityType.quantityType(forIdentifier: .stepCount)
        case .distanceWalkingRunning:
            return HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
        case .activeEnergyBurned:
            return HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        case .heartRate:
            return HKQuantityType.quantityType(forIdentifier: .heartRate)
        default:
            return nil
        }
    }
}

// MARK: - 查询健康数据样本
public extension HKHealthStore {
    /// 查询健康数据样本
    /// - Parameters:
    ///   - type: 健康数据类型
    ///   - predicate: 查询谓词
    ///   - limit: 查询数据限制
    ///   - completion: 查询结果回调
    func dd_querySamples(ofType type: HKSampleType, predicate: NSPredicate?, limit: Int = HKObjectQueryNoLimit, completion: @escaping @Sendable ([HKSample]?, Error?) -> Void) {
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: limit, sortDescriptors: nil) { _, results, error in
            completion(results, error)
        }

        self.execute(query)
    }
}
