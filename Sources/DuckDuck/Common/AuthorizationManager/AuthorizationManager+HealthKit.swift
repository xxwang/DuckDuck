import Foundation
import HealthKit

public extension AuthorizationManager {
    /// 请求授权以读取和写入健康数据
    /// - Parameters:
    ///   - readTypes: 需要读取的健康数据类型
    ///   - writeTypes: 需要写入的健康数据类型
    /// - Returns: 授权结果，成功为 `true`，失败为 `false`
    /// - Throws: 如果发生错误，将抛出异常
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     do {
    ///         let readTypes: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .stepCount)!]
    ///         let writeTypes: Set<HKSampleType> = [HKSampleType.quantityType(forIdentifier: .stepCount)!]
    ///         let success = try await AuthorizationManager.shared.requestHealthAuthorization(readTypes: readTypes, writeTypes: writeTypes)
    ///         if success {
    ///             print("授权成功")
    ///         } else {
    ///             print("授权失败")
    ///         }
    ///     } catch {
    ///         print("授权请求失败: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    func requestHealthAuthorization(readTypes: Set<HKObjectType>,
                                    writeTypes: Set<HKSampleType>) async throws -> Bool
    {
        try await withCheckedThrowingContinuation { continuation in
            self.healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }

    /// 获取指定数据类型的授权状态
    /// - Parameter type: 需要查询授权状态的数据类型
    /// - Returns: 授权状态
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
    ///     let status = await AuthorizationManager.shared.healthAuthorizationStatus(for: stepCountType)
    ///     switch status {
    ///     case .notDetermined:
    ///         print("尚未请求授权")
    ///     case .denied:
    ///         print("授权被拒绝")
    ///     case .authorized:
    ///         print("授权已批准")
    ///     }
    /// }
    /// ```
    func healthAuthorizationStatus(for type: HKObjectType) async -> AuthorizationStatus {
        let status = self.healthStore.authorizationStatus(for: type)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .sharingDenied:
            return .denied
        case .sharingAuthorized:
            return .authorized
        @unknown default:
            return .denied
        }
    }
}
