import CoreLocation
import Foundation
import HealthKit

/// 授权管理器，负责统一管理各类权限请求。
/// - Example:
/// ```swift
/// Task {
///     let isGranted = await AuthorizationManager.shared.requestCameraAuthorization()
///     print("相机授权: \(isGranted ? "已授权" : "未授权")")
/// }
/// ```
@MainActor
public class AuthorizationManager: NSObject {
    /// 健康数据
    var healthStore: HKHealthStore!

    /// 定位管理器
    var locationManager: CLLocationManager!

    /// 定位授权结果回调
    var locationAuthorizationResult: AuthorizationResult?

    /// 单例实例
    public static let shared = AuthorizationManager()

    override private init() {
        super.init()

        self.healthStore = HKHealthStore()

        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
}
