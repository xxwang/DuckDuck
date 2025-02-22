import AVFoundation
import Foundation

public extension AuthorizationManager {
    /// 获取相机的当前授权状态
    var cameraAuthorizationStatus: AuthorizationStatus {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求相机授权
    /// - Returns: 是否已授权
    /// - Example:
    /// ```swift
    /// Task {
    ///     let isGranted = await AuthorizationManager.shared.requestCameraAuthorization()
    ///     print("相机授权: \(isGranted ? "已授权" : "未授权")")
    /// }
    /// ```
    func requestCameraAuthorization() async -> Bool {
        return await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                continuation.resume(returning: granted)
            }
        }
    }
}
