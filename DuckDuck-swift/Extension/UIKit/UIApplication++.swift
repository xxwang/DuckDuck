import CoreLocation
import Foundation
import StoreKit
import UIKit
import UserNotifications

// MARK: - UIApplication 扩展
public extension UIApplication {
    /// 获取 `UIApplicationDelegate` 对象
    /// - 返回: 如果可用，返回 `UIApplicationDelegate` 对象，否则返回 `nil`
    ///
    /// - Example:
    /// ```swift
    /// let appDelegate = UIApplication.shared.dd_appDelegate()
    /// ```
    func dd_appDelegate() -> UIApplicationDelegate? {
        return delegate
    }

    /// 获取 iOS 13.0 及以上版本的 `UIWindowSceneDelegate`
    /// - 返回: 如果可用，返回 `UIWindowSceneDelegate` 对象，否则返回 `nil`
    ///
    /// - Example:
    /// ```swift
    /// if let sceneDelegate = UIApplication.shared.dd_sceneDelegate() {
    ///     // 使用 sceneDelegate
    /// }
    /// ```
    @available(iOS 13.0, *)
    func dd_sceneDelegate() -> UIWindowSceneDelegate? {
        for scene in connectedScenes {
            if let windowScene = scene as? UIWindowScene,
               let windowSceneDelegate = windowScene.delegate as? UIWindowSceneDelegate
            {
                return windowSceneDelegate
            }
        }
        return nil
    }

    /// 获取屏幕的界面方向，考虑 iOS 13 及以上版本
    /// - 返回: 当前的 `UIInterfaceOrientation` 屏幕方向
    ///
    /// - Example:
    /// ```swift
    /// let orientation = UIApplication.shared.dd_interfaceOrientation()
    /// ```
    func dd_interfaceOrientation() -> UIInterfaceOrientation {
        if #available(iOS 13, *) {
            return UIWindow.dd_mainWindow()?.windowScene?.interfaceOrientation ?? .unknown
        } else {
            return statusBarOrientation
        }
    }

    /// 通过 ping 一个外部 URL 检查网络是否可达
    /// - 返回: 如果可达，返回 `true`，否则返回 `false`
    ///
    /// - Example:
    /// ```swift
    /// let isReachable = UIApplication.shared.dd_isNetworkReachable()
    /// ```
    func dd_isNetworkReachable() -> Bool {
        return NSData(contentsOf: URL(string: "https://www.baidu.com/")!) != nil
    }
}

// MARK: - App Store 操作
public extension UIApplication {
    /// 使用 App Store ID 打开应用的 App Store 页面
    /// - Parameters:
    /// - appID: 应用的 App Store ID
    ///
    /// - Example:
    /// ```swift
    /// UIApplication.shared.dd_openAppStore(with: "123456789")
    /// ```
    func dd_openAppStore(with appID: String) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)?mt=8") {
            self.dd_openURL(url)
        }
    }

    /// 打开应用的 App Store 详情页
    /// - Parameters:
    /// - controller: 显示 App Store 页面的控制器
    /// - appID: 应用的 App Store ID
    func dd_openAppDetailViewController(from controller: UIViewController & SKStoreProductViewControllerDelegate,
                                        appID: String)
    {
        guard !appID.isEmpty else { return }

        let productViewController = SKStoreProductViewController()
        productViewController.delegate = controller
        productViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appID]) { isSuccess, error in
            if !isSuccess {
                Logger.error(error?.localizedDescription ?? "")
                productViewController.dismiss(animated: true)
            }
        }
        controller.showDetailViewController(productViewController, sender: controller)
    }

    /// 打开应用的 App Store 评价页面
    /// - Parameters:
    /// - appID: 应用的 App Store ID
    func dd_openAppStoreRatingPage(appID: String) {
        let urlString = "https://itunes.apple.com/cn/app/id\(appID)?mt=12"
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        dd_openURL(url) { success in
            success ? Logger.info("成功打开 App Store 评价页面!") : Logger.error("打开 App Store 评价页面失败。")
        }
    }
}

// MARK: - 版本管理
public extension UIApplication {
    /// 检查当前版本是否为新版本，相比于之前安装的版本
    /// - 返回: 如果当前版本是较新的版本，返回 `true`，否则返回 `false`
    ///
    /// - Example:
    /// ```swift
    /// let isNewVersion = UIApplication.shared.dd_isNewVersion
    /// ```
    var dd_isNewVersion: Bool {
        let currentVersion = Bundle.dd_version()
        let sandboxVersion = UserDefaults.standard.string(forKey: "appVersion") ?? ""
        UserDefaults.standard.set(currentVersion, forKey: "appVersion")
        UserDefaults.standard.synchronize()
        return currentVersion.compare(sandboxVersion) == .orderedDescending
    }

    /// 将应用的当前版本与指定版本字符串进行比较
    /// - Parameters:
    /// - version: 要比较的版本字符串
    /// - 返回: 如果指定版本较新，返回 `true`，否则返回 `false`
    ///
    /// - Example:
    /// ```swift
    /// let isUpdated = UIApplication.shared.dd_compareVersion("2.3.1")
    /// ```
    func dd_compareVersion(_ version: String) -> Bool {
        let newVersion = dd_parseAppVersion(version)
        guard newVersion.isValid else { return false }

        let currentVersion = dd_parseAppVersion(Bundle.dd_version())
        guard currentVersion.isValid else { return false }

        if newVersion.major > currentVersion.major {
            return true
        }
        if newVersion.major < currentVersion.major {
            return false
        }
        if newVersion.minor > currentVersion.minor {
            return true
        }
        if newVersion.minor < currentVersion.minor {
            return false
        }
        return newVersion.patch > currentVersion.patch
    }

    /// 解析版本字符串为主版本、次版本和补丁版本
    /// - Parameters:
    /// - version: 版本字符串（如 "1.2.3"）
    /// - 返回: 返回包含有效性标志和版本组件的元组
    ///
    /// - Example:
    /// ```swift
    /// let parsedVersion = UIApplication.shared.dd_parseAppVersion("1.2.3")
    /// ```
    func dd_parseAppVersion(_ version: String) -> (isValid: Bool, major: Int, minor: Int, patch: Int) {
        let versionComponents = version.dd_split(by: ".")
        if versionComponents.count != 3 {
            return (isValid: false, major: 0, minor: 0, patch: 0)
        }

        let major = versionComponents[0].dd_toInt()
        let minor = versionComponents[1].dd_toInt()
        let patch = versionComponents[2].dd_toInt()

        return (isValid: true, major: major, minor: minor, patch: patch)
    }
}

// MARK: - 清除徽标
public extension UIApplication {
    /// 清除应用程序图标的徽标数字
    ///
    /// - Example:
    /// ```swift
    /// UIApplication.shared.dd_clearApplicationIconBadge()
    /// ```
    func dd_clearApplicationIconBadge() async throws {
        if #available(iOS 17, *) {
            try await UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            self.applicationIconBadgeNumber = 0
        }
    }
}

// MARK: - URL 操作
public extension UIApplication {
    /// 打开 URL
    /// - Parameters:
    /// - url: 要打开的 URL
    /// - completion: 完成处理程序，指示是否成功打开 URL
    ///
    /// - Example:
    /// ```swift
    /// UIApplication.shared.dd_openURL(URL(string: "https://example.com")!)
    /// ```
    func dd_openURL(_ url: URL, completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        if #available(iOS 10.0, *) {
            self.open(url, options: [:]) { success in
                completion?(success)
            }
        } else {
            completion?(openURL(url))
        }
    }

    /// 拨打电话
    /// - 参数 phoneNumber: 要拨打的电话号码
    /// - 参数 completion: 完成处理程序，指示是否成功拨打电话
    ///
    /// - Example:
    /// ```swift
    /// UIApplication.shared.dd_call(with: "1234567890") { success in
    ///     // 处理结果
    /// }
    /// ```
    func dd_call(with phoneNumber: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let callAddress = "tel://" + phoneNumber
        guard let url = URL(string: callAddress), canOpenURL(url) else {
            completion(false)
            return
        }
        dd_openURL(url, completion: completion)
    }

    /// 打开应用的设置页面
    func dd_openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        dd_openURL(url) { success in
            success ? Logger.info("成功打开设置应用!") : Logger.error("打开设置应用失败。")
        }
    }

    /// 提示用户打开应用设置页面以修改权限
    /// - Parameters:
    /// - title: 警告框标题
    /// - message: 警告框消息
    /// - cancelTitle: 取消按钮标题
    /// - confirmTitle: 确认按钮标题
    /// - parentController: 显示警告框的父视图控制器
    ///
    /// - Example:
    /// ```swift
    /// UIApplication.shared.dd_promptToOpenSettings(title: "权限不足", message: "请允许应用访问位置", parentController: self)
    /// ```
    func dd_promptToOpenSettings(title: String? = nil,
                                 message: String? = nil,
                                 cancelTitle: String? = nil,
                                 confirmTitle: String? = nil,
                                 parentController: UIViewController?)
    {
        let alertController = UIAlertController(title: title ?? "提示", message: message ?? "打开设置", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle ?? "取消", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: confirmTitle ?? "确认", style: .default) { _ in
            self.dd_openSettings()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)

        parentController?.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - 通知
public extension UIApplication {
    /// 注册 APNs 远程推送
    /// - Parameter delegate: 推送代理对象，符合 `UNUserNotificationCenterDelegate` 协议
    ///
    /// - Example:
    /// ```swift
    /// UIApplication.shared.dd_registerAPNsWithDelegate(self)
    /// ```
    func dd_registerAPNsWithDelegate(_ delegate: Any) {
        if #available(iOS 10.0, *) {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            let center = UNUserNotificationCenter.current()
            center.delegate = delegate as? UNUserNotificationCenterDelegate
            center.requestAuthorization(options: options) { (granted: Bool, error: Error?) in
                Logger.info("远程推送注册\(granted ? "成功" : "失败")!")
            }
            self.registerForRemoteNotifications()
        } else {
            // 请求授权
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            registerUserNotificationSettings(settings)
            // 需要通过设备 UDID 和 bundleID，发送请求获取 deviceToken
            registerForRemoteNotifications()
        }
    }

    /// 添加本地通知
    /// - Parameters:
    ///   - trigger: 通知触发器，支持 `Date`, `DateComponents`, 或 `CLCircularRegion` 类型
    ///   - content: 通知内容
    ///   - identifier: 通知标识符
    ///   - categories: 通知分类
    ///   - repeats: 是否重复触发，默认为 `true`
    ///   - handler: 处理回调，通知添加结果回调
    ///
    /// - Example:
    /// ```swift
    /// let content = UNMutableNotificationContent()
    /// content.title = "提醒"
    /// content.body = "这是一个本地通知"
    /// UIApplication.shared.dd_addLocalUserNotification(trigger: Date(), content: content, identifier: "localNotif_1", categories: nil)
    /// ```
    @available(iOS 10.0, *)
    func dd_addLocalUserNotification(trigger: AnyObject,
                                     content: UNMutableNotificationContent,
                                     identifier: String,
                                     categories: AnyObject,
                                     repeats: Bool = true,
                                     handler: ((UNUserNotificationCenter, UNNotificationRequest, Error?) -> Void)?)
    {
        // 通知触发器
        var notiTrigger: UNNotificationTrigger?

        if let date = trigger as? Date { // 日期触发
            var interval = date.timeIntervalSince1970 - Date().timeIntervalSince1970
            interval = interval < 0 ? 1 : interval // 防止时间差为负
            notiTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        } else if let components = trigger as? DateComponents { // 日历触发
            notiTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        } else if let region = trigger as? CLCircularRegion { // 区域触发
            notiTrigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        }

        // 通知请求
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notiTrigger)
        let center = UNUserNotificationCenter.current()

        // 添加通知请求
        center.add(request) { error in
            // 回调结果
            handler?(center, request, error)
            if error == nil {
                Logger.info("通知添加成功!")
            } else {
                Logger.error("通知添加失败: \(error?.localizedDescription ?? "未知错误")")
            }
        }
    }
}
