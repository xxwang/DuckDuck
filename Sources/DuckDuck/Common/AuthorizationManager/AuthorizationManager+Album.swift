import Photos

// MARK: - 相册
public extension AuthorizationManager {
    /// 获取相册权限状态
    ///
    /// 返回当前相册权限的状态，可能的返回值有：
    /// - `.notDetermined`: 用户尚未做出选择。
    /// - `.denied`: 用户拒绝了应用的相册权限请求。
    /// - `.authorized`: 用户授权了应用访问相册。
    ///
    /// - Example:
    /// ```swift
    /// let status = await AuthorizationManager.shared.albumAuthorizationStatus
    /// switch status {
    /// case .notDetermined:
    ///     print("权限未确定")
    /// case .denied:
    ///     print("权限被拒绝")
    /// case .authorized:
    ///     print("权限已授权")
    /// }
    /// ```
    var albumAuthorizationStatus: AuthorizationStatus {
        let status: PHAuthorizationStatus = if #available(iOS 14, *) {
            PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            PHPhotoLibrary.authorizationStatus()
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
    ///
    /// 请求用户授权访问相册，并返回是否授权的结果。
    ///
    /// - Returns: 授权结果，`true` 表示授权成功，`false` 表示拒绝。
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     let granted = await AuthorizationManager.shared.requestAlbumAuthorization()
    ///     if granted {
    ///         print("相册权限已授权")
    ///     } else {
    ///         print("相册权限被拒绝")
    ///     }
    /// }
    /// ```
    func requestAlbumAuthorization() async -> Bool {
        // 请求相册权限，支持 iOS 14 及以上版本
        if #available(iOS 14, *) {
            // 使用 async/await 版本的权限请求方法
            return await withCheckedContinuation { continuation in
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    let granted = status == .authorized || status == .limited
                    continuation.resume(returning: granted)
                }
            }
        } else {
            // 对于 iOS 14 以下版本，继续使用原方法
            return await withCheckedContinuation { continuation in
                PHPhotoLibrary.requestAuthorization { status in
                    let granted = status == .authorized
                    continuation.resume(returning: granted)
                }
            }
        }
    }
}
