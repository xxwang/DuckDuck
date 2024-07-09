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

// MARK: - 状态回调
public typealias AuthenticationBlock = (_ granted: Bool) -> Void

// MARK: - AuthorizationStatus
public enum AuthorizationStatus {
    case notDetermined
    case denied
    case authorized
}

public class AuthorizationManager: NSObject {
    private var locationAuthorizationStatusBlock: AuthenticationBlock?
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
    case front
    case back
}

// MARK: - 定位
public extension AuthorizationManager {
    var locationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }

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

