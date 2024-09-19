//
//  Bundle+duck.swift
//
//
//  Created by 王哥 on 2024/6/18.
//

import UIKit

// MARK: - 属性
public extension Bundle {
    /// 返回`Info.plist`的内容字典
    static func dd_infoDict() -> [String: Any] {
        return Bundle.main.infoDictionary ?? [:]
    }

    /// 返回`App`的版本号`CFBundleShortVersionString`
    static func dd_appVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
    }

    /// 返回`App`的编译版本号`CFBundleVersion`
    static func dd_buildVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String) ?? ""
    }

    /// 返回`App`的`bundleIdentifier`
    static func dd_bundleIdentifier() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }

    /// 返回`App`工程的命名空间`CFBundleExecutable`
    static func dd_namespace() -> String {
        let infoDictionary = self.dd_infoDict()
        return (infoDictionary["CFBundleExecutable"] as? String) ?? ""
    }

    /// 返回`App`的可执行文件名`kCFBundleExecutableKey`
    static func dd_executableName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDictionary = self.dd_infoDict()
        return (infoDictionary[name] as? String) ?? ""
    }

    /// 返回`App`的`bundleName``CFBundleName`
    static func dd_bundleName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDictionary = self.dd_infoDict()
        return (infoDictionary[name] as? String) ?? ""
    }

    /// 返回`App`在桌面显示的名称`CFBundleDisplayName`
    static func dd_displayName() -> String {
        let infoDictionary = self.dd_infoDict()
        return (infoDictionary["CFBundleDisplayName"] as? String) ?? ""
    }

    /// 获取设备`UA`信息
    static func dd_userAgent() -> String {
        // 可执行程序名称
        let executable = self.dd_executableName()
        // 应用标识
        let bundleID = self.dd_bundleIdentifier()
        // 应用版本
        let version = self.dd_buildVersion()
        // 操作系统名称
        let osName = UIDevice.current.systemName
        // 操作系统版本
        let osVersion = UIDevice.current.systemVersion
        let osNameVersion = "\(osName) \(osVersion)"

        return "\(executable)/\(bundleID) (\(version); \(osNameVersion))"
    }

    /// 获取设备的本地化信息`kCFBundleLocalizationsKey`
    static func dd_l10n() -> String {
        let infoDictionary = self.dd_infoDict()
        return (infoDictionary[String(kCFBundleLocalizationsKey)] as? String) ?? ""
    }

    /// 获取应用商店的收据信息
    static var appStoreReceiptInfo: [String: Any] {
//        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
//           let data = try? Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped),
        // TODO: - 待完善
//           let res = data.jsonObject(for: [String: Any].self)
//        {
//            return res
//        }
        return [:]
    }
}

// MARK: - 静态方法
public extension Bundle {
    /// 获取项目中文件的`path`
    /// - Parameters:
    ///   - fileName: 文件名称
    ///   - extension: 扩展名
    /// - Returns: 结果`path`字符串
    static func dd_path(for fileName: String?, with extension: String? = nil) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: `extension`) else {
            return nil
        }
        return path
    }

    /// 获取项目中文件的`URL`
    /// - Parameters:
    ///   - fileName: 文件名称
    ///   - extension: 扩展名
    /// - Returns: 结果`URL`
    static func dd_url(for fileName: String?, with extension: String? = nil) -> URL? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: `extension`) else {
            return nil
        }
        return url
    }
}
