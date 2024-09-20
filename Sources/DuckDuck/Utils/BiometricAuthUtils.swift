//
//  BiometricAuthUtils.swift
//
//
//  Created by xxwang on 2023/5/29.
//

import Foundation
import LocalAuthentication

class BiometricAuthUtils {
    /// 代理
    public weak var delegate: BiometricAuthUtilsDelegate?
    /// 生物识别上下文
    private lazy var context: LAContext = {
        let context = LAContext()
        context.localizedCancelTitle = "取消"
        context.localizedFallbackTitle = "使用密码解锁"
        return context
    }()

    /// 使用说明
    var localizedReason: String {
        if biometricMode == .touchID {
            return "使用指纹解锁,若错误次数过多,可使用密码解锁"
        } else {
            return "使用面部识别解锁,若错误次数过多,可使用密码解锁"
        }
    }

    public static let shared = BiometricAuthUtils()
    private init() {}
}

// MARK: - 判断
extension BiometricAuthUtils {
    /// 判断生物识别是否可用
    public var isAvaliable: Bool {
        if #available(iOS 8.0, *) {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        } else {
            return false
        }
    }

    /// 获取生物识别类型
    public var biometricMode: BiometricAuthMode {
        if #available(iOS 8.0, *) {
            if context.biometryType == .touchID {
                return .touchID
            } else if context.biometryType == .faceID {
                return .faceID
            } else {
                return .none
            }
        } else {
            return .none
        }
    }
}

// MARK: - 方法
extension BiometricAuthUtils {
    /// 唤起生物识别
    public func evokeAuth() {
        guard #available(iOS 8.0, *) else {
            // 设备不支持 - 版本过低
            delegate?.biometricAuthResult(result: .versionNotSupport, mode: biometricMode)
            return
        }

        var error: NSError?
        // 判断可用性
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            authErrorHandler(errorCode: error?.code ?? 0, context: context)
            return
        }

        // 唤起认证
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { success, evaluateError in
            DispatchQueue.dd_async_main {
                if success {
                    self.delegate?.biometricAuthResult(result: .success, mode: self.biometricMode)
                } else {
                    if let error = evaluateError as NSError? {
                        self.authErrorHandler(errorCode: error.code, context: self.context)
                    }
                }
            }
        }
    }

    /// 识别错误信息处理
    /// - Parameters:
    ///   - errorCode: 错误代码
    ///   - context: 上下文
    private func authErrorHandler(errorCode: Int, context: LAContext) {
        if errorCode == LAError.authenticationFailed.rawValue {
            delegate?.biometricAuthResult(result: .authenticationFailed, mode: biometricMode)
        } else if errorCode == LAError.userCancel.rawValue {
            delegate?.biometricAuthResult(result: .userCancel, mode: biometricMode)
        } else if errorCode == LAError.userFallback.rawValue {
            delegate?.biometricAuthResult(result: .userFallback, mode: biometricMode)
        } else if errorCode == LAError.systemCancel.rawValue {
            delegate?.biometricAuthResult(result: .systemCancel, mode: biometricMode)
        } else if errorCode == LAError.passcodeNotSet.rawValue {
            delegate?.biometricAuthResult(result: .passcodeNotSet, mode: biometricMode)
        } else {
            if #available(iOS 11.0, *) {
                if errorCode == LAError.biometryNotAvailable.rawValue {
                    delegate?.biometricAuthResult(result: .biometryNotAvailable, mode: self.biometricMode)
                } else if errorCode == LAError.biometryNotEnrolled.rawValue {
                    delegate?.biometricAuthResult(result: .biometryNotEnrolled, mode: self.biometricMode)
                } else if errorCode == LAError.biometryLockout.rawValue {
                    // 错误次数过多, 使用deviceOwnerAuthentication触发输入密码
                    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: localizedReason, reply: { success, evaluateError in
                        DispatchQueue.dd_async_main {
                            if success {
                                self.delegate?.biometricAuthResult(result: .success, mode: self.biometricMode)
                            } else {
                                if let error = evaluateError as NSError? {
                                    self.authErrorHandler(errorCode: error.code, context: self.context)
                                }
                            }
                        }

                    })
                }
            }
        }
    }
}

// MARK: - 生物识别代理
public protocol BiometricAuthUtilsDelegate: NSObjectProtocol {
    /// 识别结果
    func biometricAuthResult(result: BiometricAuthResult, mode: BiometricAuthMode)
}

// MARK: - 生物识别方式
public enum BiometricAuthMode {
    /// 指纹识别
    case touchID
    /// 面容识别
    case faceID
    /// 无或不支持
    case none
}

// MARK: - 生物识别结果枚举
public enum BiometricAuthResult {
    // 自定
    /// 解锁成功
    case success
    /// 设备不支持 - 版本过低
    case versionNotSupport
    /// 设备不支持 - 硬件已损坏
    case deviceNotSupport

    // 通用
    /// 验证失败 - 提示指纹不匹配 可再次点击（还没有达到最大错误次数）
    case authenticationFailed
    /// 用户取消【通常-可点击按钮再次触发指纹/面容解锁】
    case userCancel
    /// 用户选择使用密码 - 【通常-跳转到登录页使用密码进行解锁】
    case userFallback
    /// 系统取消 - 保持在TouchID解锁界面，点击按钮重新弹出TouchID进行解锁
    case systemCancel
    /// 用户没有设置密码，无法使用TouchID/FaceID
    case passcodeNotSet

    // iOS11+
    /// TouchID/FaceID的硬件不可用
    case biometryNotAvailable
    /// 用户没有设置TouchID/FaceID，无法使用
    case biometryNotEnrolled
    /// 面容识别错误达到一定次数，被锁定
    case biometryLockout

    // iOS9+
    /// TouchID错误达到了一定次数，被锁定
    case touchIDLockout
    /// 被应用取消，比如当身份验证正在进行时，调用了invalidate
    case appCancel
    /// 传入的LAContext已经无效，如应用被挂起已取消了授权
    case invalidContext

    // iOS8+
    /// TouchID的硬件不可用
    case touchIdNotAvailable
    /// 指纹识别未开启
    case touchIDNotEnrolled
}
