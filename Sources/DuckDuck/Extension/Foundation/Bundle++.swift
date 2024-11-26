//
//  Bundle++.swift
//  DuckDuck
//
//  Created by xxwang on 18/11/2024.
//

import StoreKit
import UIKit

// MARK: - 属性
public extension Bundle {
    /// 获取 `Info.plist` 文件内容
    ///
    /// - Example:
    /// ```swift
    /// let infoDict = Bundle.dd_infoDictionary()
    /// print(infoDict)
    /// ```
    /// - Returns: 返回 `Info.plist` 内容的字典，如果没有返回空字典
    static func dd_infoDictionary() -> [String: Any] {
        return Bundle.main.infoDictionary ?? [:]
    }

    /// 获取应用版本号（`CFBundleShortVersionString`）
    ///
    /// - Example:
    /// ```swift
    /// let appVersion = Bundle.dd_version()
    /// print(appVersion)
    /// ```
    /// - Returns: 应用的版本号字符串
    static func dd_version() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
    }

    /// 获取应用编译版本号（`CFBundleVersion`）
    ///
    /// - Example:
    /// ```swift
    /// let buildVersion = Bundle.dd_build()
    /// print(buildVersion)
    /// ```
    /// - Returns: 应用的编译版本号字符串
    static func dd_build() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String) ?? ""
    }

    /// 获取应用 `bundleIdentifier`
    ///
    /// - Example:
    /// ```swift
    /// let bundleIdentifier = Bundle.dd_identifier()
    /// print(bundleIdentifier)
    /// ```
    /// - Returns: 应用的 `bundleIdentifier` 字符串
    static func dd_identifier() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }

    /// 获取应用命名空间（`CFBundleExecutable`）
    ///
    /// - Example:
    /// ```swift
    /// let namespace = Bundle.dd_namespace()
    /// print(namespace)
    /// ```
    /// - Returns: 应用的命名空间字符串
    static func dd_namespace() -> String {
        let infoDictionary = self.dd_infoDictionary()
        return (infoDictionary["CFBundleExecutable"] as? String) ?? ""
    }

    /// 获取应用可执行文件名（`kCFBundleExecutableKey`）
    ///
    /// - Example:
    /// ```swift
    /// let executableName = Bundle.dd_executableName()
    /// print(executableName)
    /// ```
    /// - Returns: 应用的可执行文件名字符串
    static func dd_executableName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDictionary = self.dd_infoDictionary()
        return (infoDictionary[name] as? String) ?? ""
    }

    /// 获取应用 `bundleName`（`CFBundleName`）
    ///
    /// - Example:
    /// ```swift
    /// let bundleName = Bundle.dd_name()
    /// print(bundleName)
    /// ```
    /// - Returns: 应用的 `bundleName` 字符串
    static func dd_name() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDictionary = self.dd_infoDictionary()
        return (infoDictionary[name] as? String) ?? ""
    }

    /// 获取应用显示名称（`CFBundleDisplayName`）
    ///
    /// - Example:
    /// ```swift
    /// let displayName = Bundle.dd_displayName()
    /// print(displayName)
    /// ```
    /// - Returns: 应用的显示名称字符串
    static func dd_displayName() -> String {
        let infoDictionary = self.dd_infoDictionary()
        return (infoDictionary["CFBundleDisplayName"] as? String) ?? ""
    }

    /// 获取设备的 User-Agent 信息
    ///
    /// - Example:
    /// ```swift
    /// let userAgent = Bundle.dd_userAgent()
    /// print(userAgent)
    /// ```
    /// - Returns: 设备的 User-Agent 信息字符串
    @MainActor
    static func dd_userAgent() -> String {
        let executable = self.dd_executableName()
        let bundleID = self.dd_identifier()
        let version = self.dd_build()
        let osName = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let osNameVersion = "\(osName) \(osVersion)"

        return "\(executable)/\(bundleID) (\(version); \(osNameVersion))"
    }

    /// 获取应用的本地化信息（`kCFBundleLocalizationsKey`）
    ///
    /// - Example:
    /// ```swift
    /// let localization = Bundle.dd_localization()
    /// print(localization)
    /// ```
    /// - Returns: 应用的本地化信息字符串
    static func dd_localization() -> String {
        let infoDictionary = self.dd_infoDictionary()
        return (infoDictionary[String(kCFBundleLocalizationsKey)] as? String) ?? ""
    }
}

// MARK: - IAP交易凭证
public extension Bundle {
    /// 获取应用商店收据信息 (兼容 iOS 18.0 以下和以上版本)
    ///
    /// 此方法根据系统版本自动选择获取收据的方式：
    /// - iOS 18.0 及以上：使用 `StoreKit` 提供的交易 API 获取收据。
    /// - iOS 18.0 以下：使用传统方式通过 `Bundle.main.appStoreReceiptURL` 获取收据文件。
    ///
    /// 返回值为 Base64 编码的收据信息字符串，如果无法获取则返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// Task {
    ///     if let receipt = await Bundle.dd_fetchAppStoreReceipt() {
    ///         print("成功获取收据信息: \(receipt)")
    ///     } else {
    ///         print("获取收据信息失败")
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: 收据信息的 Base64 编码字符串，或者 `nil`。
    static func dd_fetchAppStoreReceipt() async -> String? {
        if #available(iOS 18.0, *) {
            return await dd_fetchReceiptFromTransaction()
        } else {
            return dd_fetchLegacyAppStoreReceipt()
        }
    }

    /// 使用传统方法获取应用商店收据信息 (适用于 iOS 18.0 以下版本)
    ///
    /// 使用 `Bundle.main.appStoreReceiptURL` 获取收据文件路径并读取其内容，
    /// 如果文件存在则返回 Base64 编码的收据字符串。
    ///
    /// - Example:
    /// ```swift
    /// if let legacyReceipt = Bundle.dd_fetchLegacyAppStoreReceipt() {
    ///     print("获取到传统收据信息: \(legacyReceipt)")
    /// } else {
    ///     print("传统收据信息获取失败")
    /// }
    /// ```
    ///
    /// - Returns: 收据信息的 Base64 编码字符串，或者 `nil`。
    static func dd_fetchLegacyAppStoreReceipt() -> String? {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: appStoreReceiptURL.path),
              let data = try? Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
        else {
            print("未找到传统收据文件")
            return nil
        }
        return data.base64EncodedString()
    }

    /// 使用 StoreKit 获取交易凭证 (适用于 iOS 18.0 及以上版本)
    ///
    /// 遍历所有的交易 (`Transaction.all`)，查找已验证的交易，
    /// 并返回交易的 JWS 表示 (收据信息)。
    ///
    /// - Example:
    /// ```swift
    /// if #available(iOS 18.0, *) {
    ///     Task {
    ///         if let transactionReceipt = await Bundle.dd_fetchReceiptFromTransaction() {
    ///             print("StoreKit 收据信息: \(transactionReceipt)")
    ///         } else {
    ///             print("未找到有效的交易收据信息")
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: 收据信息的 Base64 编码字符串，或者 `nil`。
    @available(iOS 18.0, *)
    static func dd_fetchReceiptFromTransaction() async -> String? {
        // 遍历所有交易
        for await result in Transaction.all {
            switch result {
            case .verified:
                // 如果验证通过，直接返回 `VerificationResult` 的 JWS 表示
                return result.jwsRepresentation
            case let .unverified(_, error):
                // 打印未验证交易的错误信息
                print("未通过验证的交易: \(error.localizedDescription)")
            }
        }
        return nil
    }
}

// MARK: - 静态方法
public extension Bundle {
    /// 获取项目中文件的路径
    /// - Parameters:
    ///   - fileName: 文件名称
    ///   - extension: 扩展名
    /// - Returns: 文件的路径字符串，如果未找到返回 `nil`
    static func dd_filePath(for fileName: String?, with extension: String? = nil) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: `extension`) else {
            return nil
        }
        return path
    }

    /// 获取项目中文件的 URL
    /// - Parameters:
    ///   - fileName: 文件名称
    ///   - extension: 扩展名
    /// - Returns: 文件的 URL，如果未找到返回 `nil`
    static func dd_fileURL(for fileName: String?, with extension: String? = nil) -> URL? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: `extension`) else {
            return nil
        }
        return url
    }
}
