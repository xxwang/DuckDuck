//
//  AuthorizationManager+Microphone.swift
//  DuckDuck
//
//  Created by xxwang on 19/11/2024.
//

import AVFoundation
import Foundation

public extension AuthorizationManager {
    /// 获取麦克风的当前授权状态
    var microphoneAuthorizationStatus: AuthorizationStatus {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求麦克风授权
    /// - Returns: 是否已授权
    /// - Example:
    /// ```swift
    /// Task {
    ///     let isGranted = await AuthorizationManager.shared.requestMicrophoneAuthorization()
    ///     print("麦克风授权: \(isGranted ? "已授权" : "未授权")")
    /// }
    /// ```
    func requestMicrophoneAuthorization() async -> Bool {
        return await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                continuation.resume(returning: granted)
            }
        }
    }
}
