//
//  LocalAuthenticationManager.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 21/11/2024.
//

import LocalAuthentication

/// 本地身份认证管理器
@MainActor
public class LocalAuthenticationManager {
    /// 身份认证上下文
    private lazy var context: LAContext = {
        let context = LAContext()
        context.localizedCancelTitle = "取消" // 取消按钮的文本
        context.localizedFallbackTitle = "使用密码解锁" // 回退按钮的文本
        return context
    }()

    /// 认证提示文本
    private var localizedReason: String {
        switch authenticationType {
        case .touchID:
            return "使用指纹解锁，若错误次数过多，可使用密码解锁"
        case .faceID:
            return "使用面部识别解锁，若错误次数过多，可使用密码解锁"
        case .none, .unknown:
            return "使用密码解锁"
        }
    }

    /// 认证类型
    private var authenticationType: AuthenticationType {
        if #available(iOS 8.0, *) {
            switch context.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        } else {
            return .none
        }
    }

    /// 单例实例
    public static let shared = LocalAuthenticationManager()

    private init() {}
}

// MARK: - 公共方法
public extension LocalAuthenticationManager {
    /// 判断设备是否支持身份认证
    /// - Returns: 返回是否支持身份认证
    ///
    /// 检查设备是否支持指纹识别（Touch ID）或面容识别（Face ID）。若设备支持，则返回 `true`，否则返回 `false`。
    ///
    /// - Example:
    /// ```swift
    /// if LocalAuthenticationManager.shared.isAuthenticationAvailable {
    ///     print("设备支持身份认证")
    /// } else {
    ///     print("设备不支持身份认证")
    /// }
    /// ```
    var isAuthenticationAvailable: Bool {
        if #available(iOS 8.0, *) {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        }
        return false
    }

    /// 开始身份认证
    /// - Returns: 返回认证结果
    ///
    /// 启动身份认证流程，支持指纹、面容识别或密码解锁。根据设备的支持情况，返回认证结果。
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     let result = await LocalAuthenticationManager.shared.startAuthentication()
    ///     switch result {
    ///     case .success:
    ///         print("认证成功")
    ///     case .authenticationFailed:
    ///         print("认证失败")
    ///     case .versionNotSupport:
    ///         print("设备不支持身份认证")
    ///     default:
    ///         print("其他错误")
    ///     }
    /// }
    /// ```
    func startAuthentication() async -> AuthenticationResult {
        guard isAuthenticationAvailable else {
            return .versionNotSupport
        }

        var error: NSError?

        // 判断身份认证是否可用
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return handleAuthenticationError(errorCode: error?.code ?? 0)
        }

        // 唤起认证
        return await withCheckedContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { success, evaluateError in
                if success {
                    continuation.resume(returning: .success)
                } else {
                    if let error = evaluateError as NSError? {
                        let result = self.handleAuthenticationError(errorCode: error.code)
                        DispatchQueue.main.async {
                            continuation.resume(returning: result)
                        }
                    } else {
                        DispatchQueue.main.async {
                            continuation.resume(returning: .authenticationFailed)
                        }
                    }
                }
            }
        }
    }

    /// 处理认证错误
    /// - Parameter errorCode: 错误代码
    /// - Returns: 认证错误的结果
    ///
    /// 根据错误代码返回相应的认证错误类型。如果错误代码对应已知错误类型，则返回特定错误。
    ///
    /// - Example:
    /// ```swift
    /// let errorCode = LAError.authenticationFailed.rawValue
    /// let result = LocalAuthenticationManager.shared.handleAuthenticationError(errorCode: errorCode)
    /// print(result)  // 输出: authenticationFailed
    /// ```
    private func handleAuthenticationError(errorCode: Int) -> AuthenticationResult {
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            return .authenticationFailed
        case LAError.userCancel.rawValue:
            return .userCancel
        case LAError.userFallback.rawValue:
            return .userFallback
        case LAError.systemCancel.rawValue:
            return .systemCancel
        case LAError.passcodeNotSet.rawValue:
            return .passcodeNotSet
        default:
            if #available(iOS 11.0, *) {
                switch errorCode {
                case LAError.biometryNotAvailable.rawValue:
                    return .biometryNotAvailable
                case LAError.biometryNotEnrolled.rawValue:
                    return .biometryNotEnrolled
                case LAError.biometryLockout.rawValue:
                    return .biometryLockout
                default:
                    return .unknownError
                }
            } else {
                return .unknownError
            }
        }
    }
}

// MARK: - 身份认证类型枚举
/// 表示设备支持的身份认证类型
public enum AuthenticationType {
    case touchID // 指纹认证
    case faceID // 面容认证
    case none // 不支持身份认证
    case unknown // 未知类型（如设备无法识别）
}

// MARK: - 身份认证结果枚举
/// 表示身份认证的结果
public enum AuthenticationResult {
    case success // 认证成功
    case versionNotSupport // 设备不支持身份认证
    case authenticationFailed // 认证失败
    case userCancel // 用户取消认证
    case userFallback // 用户选择使用密码
    case systemCancel // 系统取消认证
    case passcodeNotSet // 用户未设置密码
    case biometryNotAvailable // 身份认证硬件不可用
    case biometryNotEnrolled // 未配置身份认证
    case biometryLockout // 身份认证被锁定
    case unknownError // 发生了未知错误
}
