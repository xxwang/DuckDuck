//
//  AuthorizationManager+Contacts.swift
//  DuckDuck
//
//  Created by xxwang on 19/11/2024.
//

import Contacts

public extension AuthorizationManager {
    /// 获取通讯录权限状态
    ///
    /// 返回当前通讯录权限的状态，可能的返回值有：
    /// - `.notDetermined`: 用户尚未做出选择。
    /// - `.denied`: 用户拒绝了应用的通讯录权限请求。
    /// - `.authorized`: 用户授权了应用访问通讯录。
    ///
    /// - Example:
    /// ```swift
    /// let status = await AuthorizationManager.shared.contactsAuthorizationStatus
    /// switch status {
    /// case .notDetermined:
    ///     print("权限未确定")
    /// case .denied:
    ///     print("权限被拒绝")
    /// case .authorized:
    ///     print("权限已授权")
    /// }
    /// ```
    var contactsAuthorizationStatus: AuthorizationStatus {
        // 直接返回通讯录权限状态
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
    ///
    /// 请求用户授权访问通讯录，并返回是否授权的结果。
    ///
    /// - Returns: 授权结果，`true` 表示授权成功，`false` 表示拒绝。
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     let granted = await AuthorizationManager.shared.requestContactsAuthorization()
    ///     if granted {
    ///         print("通讯录权限已授权")
    ///     } else {
    ///         print("通讯录权限被拒绝")
    ///     }
    /// }
    /// ```
    func requestContactsAuthorization() async -> Bool {
        let store = CNContactStore()

        // 使用async/await请求访问通讯录权限
        do {
            let status = try await store.requestAccess(for: .contacts)
            return status
        } catch {
            return false
        }
    }
}
