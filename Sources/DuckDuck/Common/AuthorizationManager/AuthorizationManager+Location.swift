import CoreLocation
import Foundation

public extension AuthorizationManager {
    /// 定位服务是否已开启
    var isLocationServicesEnabled: Bool {
        CLLocationManager.locationServicesEnabled()
    }

    /// 获取定位的当前授权状态
    var locationAuthorizationStatus: AuthorizationStatus {
        let status: CLAuthorizationStatus = if #available(iOS 14, *) {
            self.locationManager.authorizationStatus
        } else {
            CLLocationManager.authorizationStatus()
        }
        switch status {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorizedAlways, .authorizedWhenInUse: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求定位授权
    /// - Parameters:
    ///   - type: 授权类型（使用时或始终授权）
    /// - Returns: 是否已授权
    /// - Example:
    /// ```swift
    /// Task {
    ///     let isGranted = await AuthorizationManager.shared.requestLocationAuthorization(type: .whenInUse)
    ///     print("定位授权: \(isGranted ? "已授权" : "未授权")")
    /// }
    /// ```
    func requestLocationAuthorization(type: LocationAuthorizationType) async -> Bool {
        return await withCheckedContinuation { continuation in
            self.locationAuthorizationResult = { granted in
                continuation.resume(returning: granted)
            }
            switch type {
            case .always: self.locationManager.requestAlwaysAuthorization()
            case .whenInUse: self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension AuthorizationManager: @preconcurrency CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let isGranted = status == .authorizedWhenInUse || status == .authorizedAlways
        self.locationAuthorizationResult?(isGranted)
        self.locationAuthorizationResult = nil
    }
}
