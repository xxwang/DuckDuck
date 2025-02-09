import Foundation

/// 授权状态枚举
public enum AuthorizationStatus {
    case notDetermined // 未决定
    case denied // 已拒绝
    case authorized // 已授权
}

/// 授权回调
public typealias AuthorizationResult = (_ granted: Bool) -> Void

/// 定位授权类型
public enum LocationAuthorizationType {
    case whenInUse // 使用时授权
    case always // 始终授权
}
