//
//  AuthorizationManager.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import AdSupport
import AppTrackingTransparency
import Contacts
import CoreLocation
import Foundation
import Photos
import UserNotifications

// MARK: - 状态回调
public typealias AuthenticationBlock = (_ granted: Bool) -> Void

// MARK: - AuthorizationStatus
public enum AuthorizationStatus {
    case notDetermined // 未授权
    case denied // 已拒绝
    case authorized // 已授权
}

public class AuthorizationManager: NSObject {
    // 定位状态回调
    private var locationAuthorizationStatusBlock: AuthenticationBlock?
    // 定位对象
    private var locationManager: CLLocationManager!

    public static let shared = AuthorizationManager()
    override private init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
}

// MARK: - IDFA
public extension AuthorizationManager {
    /// idfa状态
    var idfaStatus: AuthorizationStatus {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            switch status {
            case .notDetermined:
                return .notDetermined
            case .denied, .restricted:
                return .denied
            case .authorized:
                return .authorized
            default:
                return .denied
            }
        } else {
            let isEnabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            if isEnabled {
                return .authorized
            } else {
                return .denied
            }
        }
    }

    /// 请求idfa授权
    func requestIDFA(resultBlock: AuthenticationBlock?) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                let granted = status == .authorized
                DispatchQueue.main.async {
                    resultBlock?(granted)
                }
            }
        } else {
            let granted = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            DispatchQueue.main.async {
                resultBlock?(granted)
            }
        }
    }
}

import AVFoundation

// MARK: - 麦克风
public extension AuthorizationManager {
    /// 麦克风权限
    var microphoneStatus: AuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        case .authorized:
            return .authorized
        default:
            return .denied
        }
    }

    /// 请求麦克风权限
    func requestMicrophone(resultBlock: AuthenticationBlock?) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                resultBlock?(granted)
            }
        }
    }
}

// MARK: - 相机
public extension AuthorizationManager {
    /// 相机权限
    var cameraStatus: AuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        case .authorized:
            return .authorized
        default:
            return .denied
        }
    }

    /// 请求相机权限
    func requestCamera(resultBlock: AuthenticationBlock?) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                resultBlock?(granted)
            }
        }
    }
}

// MARK: - 相册
public extension AuthorizationManager {
    /// 相册权限
    var photoLibraryStatus: AuthorizationStatus {
        var status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }

        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        case .authorized, .limited:
            return .authorized
        default:
            return .notDetermined
        }
    }

    /// 请求相册权限
    func requestPhotoLibrary(resultBlock: AuthenticationBlock?) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                let granted = status == .authorized || status == .limited
                DispatchQueue.main.async {
                    resultBlock?(granted)
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                let granted = status == .authorized
                DispatchQueue.main.async {
                    resultBlock?(granted)
                }
            }
        }
    }
}

// MARK: - 通讯录
public extension AuthorizationManager {
    /// 通讯录权限
    var contactsStatus: AuthorizationStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        case .authorized:
            return .authorized
        default:
            return .denied
        }
    }

    /// 请求通讯录权限
    func requestContacts(resultBlock: AuthenticationBlock?) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if error != nil {
                DispatchQueue.main.async {
                    resultBlock?(false)
                }
            } else {
                DispatchQueue.main.async {
                    resultBlock?(granted)
                }
            }
        }
    }
}

// MARK: - LocationAuthorizationAction
public enum LocationAuthorizationAction {
    case front // 前台
    case back // 后台
}

// MARK: - 定位
public extension AuthorizationManager {
    /// 是否开启定位服务
    var locationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }

    /// 定位权限
    var locationStatus: AuthorizationStatus {
        var status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = self.locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            return .authorized
        default:
            return .denied
        }
    }

    /// 请求定位权限
    func requestLocation(action: LocationAuthorizationAction, completion: AuthenticationBlock?) {
        self.locationAuthorizationStatusBlock = completion

        if action == .back {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension AuthorizationManager: CLLocationManagerDelegate {
    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        self.locationBlockHandle(status: status)
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationBlockHandle(status: status)
    }

    /// 获取到状态之后的回调处理
    /// - Parameter status: 授权状态
    private func locationBlockHandle(status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        let granted = status == .authorizedAlways || status == .authorizedWhenInUse

        if let block = self.locationAuthorizationStatusBlock {
            DispatchQueue.main.async {
                block(granted)
                self.locationAuthorizationStatusBlock = nil
            }
        }
    }
}

public extension AuthorizationManager {
    /// 通知授权状态
    func fetchNotificationStatus(completion: @escaping (_ status: AuthorizationStatus) -> Void) {
        var status: AuthorizationStatus = .notDetermined
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                status = .notDetermined
            case .denied:
                status = .denied
            case .authorized, .provisional, .ephemeral:
                status = .authorized
            @unknown default:
                status = .denied
            }

            completion(status)
        }
    }

    /// 请求通知权限
    func requestNotification(options: UNAuthorizationOptions = [.alert, .sound, .badge], resultBlock: AuthenticationBlock?) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if error != nil {
                resultBlock?(false)
            } else {
                resultBlock?(granted)
            }
        }
    }
}
