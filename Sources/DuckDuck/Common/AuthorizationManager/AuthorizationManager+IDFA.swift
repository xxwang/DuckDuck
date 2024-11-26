//
//  AuthorizationManager+IDFA.swift
//  DuckDuck
//
//  Created by xxwang on 19/11/2024.
//

import AdSupport
import AppTrackingTransparency
import Foundation

public extension AuthorizationManager {
    /// 获取 IDFA 的当前授权状态
    var idfaAuthorizationStatus: AuthorizationStatus {
        if #available(iOS 14, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .notDetermined: return .notDetermined
            case .denied, .restricted: return .denied
            case .authorized: return .authorized
            @unknown default: return .denied
            }
        } else {
            return ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? .authorized : .denied
        }
    }

    /// 请求 IDFA 授权
    /// - Returns: 是否已授权
    /// - Example:
    /// ```swift
    /// Task {
    ///     let isAuthorized = await AuthorizationManager.shared.requestIDFAAuthorization()
    ///     print("IDFA 授权: \(isAuthorized ? "已授权" : "未授权")")
    /// }
    /// ```
    @available(iOS 14, *)
    func requestIDFAAuthorization() async -> Bool {
        return await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}
