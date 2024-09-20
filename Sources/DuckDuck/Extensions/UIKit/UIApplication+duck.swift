//
//  UIApplication+duck.swift
//  DuckDuck
//
//  Created by 王哥 on 2024/9/20.
//

import CoreLocation
import Foundation
import StoreKit
import UIKit
import UserNotifications

// MARK: - 方法
public extension UIApplication {
    /// 获取`UIApplicationDelegate`
    func dd_appDelegate() -> UIApplicationDelegate? {
        let delegate = delegate
        return delegate
    }

    /// 获取`UIWindowSceneDelegate`
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

    /// 获取屏幕的方向
    func dd_interfaceOrientation() -> UIInterfaceOrientation {
        if #available(iOS 13, *) {
            return UIWindow.dd_window()?.windowScene?.interfaceOrientation ?? .unknown
        } else {
            return statusBarOrientation
        }
    }

    /// 网络状态是否可用
    static func dd_reachable() -> Bool {
        NSData(contentsOf: URL(string: "https://www.baidu.com/")!) != nil
    }
}

// MARK: - 商店
public extension UIApplication {
    /// 应用在商店中的链接地址
    /// - Parameter appID: 应用在商店中的ID
    /// - Returns: 地址字符串
    func dd_homeUrlInAppStore(with appID: String) -> String {
        "itms-apps://itunes.apple.com/app/id\(appID)?mt=8"
    }

    /// 应用在商店中的详情链接地址
    /// - Parameter appID: 应用在商店中的ID
    /// - Returns: 地址字符串
    func dd_detailUrlInAppStore(with appID: String) -> String {
        "http://itunes.apple.com/cn/lookup?id=\(appID)"
    }
}

// MARK: - 版本号
public extension UIApplication {
    /// 判断当前版本是否为新版本
    var dd_isNewVersion: Bool {
        // 当前应用版本
        let currentVersion = Bundle.dd_appVersion()
        // 获取存储的版本
        let sandboxVersion = UserDefaults.standard.string(forKey: "appVersion") ?? ""
        // 存储当前版本
        UserDefaults.standard.set(currentVersion, forKey: "appVersion")
        UserDefaults.standard.synchronize()
        // 返回比较结果
        return currentVersion.compare(sandboxVersion) == .orderedDescending
    }

    /// 指定版本号与应用当前版本号进行比较
    /// - Parameter version:传进来的版本号码
    /// - Returns:返回对比加过,true:比当前的版本大,false:比当前的版本小
    func dd_compareVersion(_ version: String) -> Bool {
        // 获取要比较的(主版本号、次版本号、补丁版本号)
        let newVersion = dd_splitAppVersion(version)
        guard newVersion.isOk else { return false }

        // 获取当前应用的(主版本号、次版本号、补丁版本号)
        let currentVersion = dd_splitAppVersion(Bundle.dd_appVersion())
        guard currentVersion.isOk else { return false }

        // 主版本大于
        if newVersion.versions.major > currentVersion.versions.major {
            return true
        }

        // 主版本小于
        if newVersion.versions.major < currentVersion.versions.major {
            return false
        }

        // 次版本号大于
        if newVersion.versions.minor > currentVersion.versions.minor {
            return true
        }

        // 次版本号小于
        if newVersion.versions.minor < currentVersion.versions.minor {
            return false
        }

        // 补丁版本大于
        if newVersion.versions.patch > currentVersion.versions.patch {
            return true
        }

        // 补丁版本小于
        if newVersion.versions.patch < currentVersion.versions.patch {
            return false
        }

        // 相等
        return false
    }

    /// 分割版本号
    /// - Parameter version:要分割的版本号
    /// - Returns:(isOk:是否成功, versions:(major:主版本号, minor:次版本号, patch:补丁版本号))
    func dd_splitAppVersion(_ version: String) -> (isOk: Bool, versions: (major: Int, minor: Int, patch: Int)) {
        // 获取(主版本号、次版本号、补丁版本号)字符串数组
        let versionNumbers = version.dd_split(with: ".")
        if versionNumbers.count != 3 {
            return (isOk: false, versions: (major: 0, minor: 0, patch: 0))
        }

        // 主版本号
        let majorString = versionNumbers[0]
        let majorNumber = majorString.dd_Int()

        // 次版本号
        let minorString = versionNumbers[1]
        let minorNumber = minorString.dd_Int()

        // 补丁版本号
        let patchString = versionNumbers[2]
        let patchNumber = patchString.dd_Int()

        return (isOk: true, versions: (major: majorNumber, minor: minorNumber, patch: patchNumber))
    }
}

// MARK: - 方法
public extension UIApplication {
    /// 清理图标上的角标
    func dd_clearApplicationIconBadge() {
        applicationIconBadgeNumber = 0
    }
}

// MARK: - 打开操作
public extension UIApplication {
    /// 打开指定URL地址
    /// - Parameters:
    ///   - url:要打开的URL地址
    ///   - complete:完成回调
    func dd_openURL(_ url: URL, completion: ((_ isOk: Bool) -> Void)? = nil) {
        if #available(iOS 10.0, *) {
            self.open(url, options: [:]) { success in
                completion?(success)
            }
        } else {
            completion?(openURL(url))
        }
    }

    /// 拨打电话操作
    /// - Parameters:
    ///   - phoneNumber:要拨打的电话号码
    ///   - completion:完成回调
    func dd_call(with phoneNumber: String, completion: @escaping (_ isOk: Bool) -> Void) {
        let callAddress = ("tel://" + phoneNumber)
        guard let url = URL(string: callAddress) else { completion(false); return }
        guard canOpenURL(url) else { completion(false); return }
        dd_openURL(url, completion: completion)
    }

    /// 在应用中打开指定应用在`AppStore`中的详情页面
    /// - Parameters:
    ///   - controller: 是哪个控制器来弹出的
    ///   - appID: 应用在商店中的ID
    func dd_openAppDetailViewController(from controller: some UIViewController & SKStoreProductViewControllerDelegate,
                                        appID: String)
    {
        guard appID.count > 0 else { return }

        // 商店产品页面
        let productViewController = SKStoreProductViewController()
        productViewController.delegate = controller
        productViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appID]) { isOk, error in
            if !isOk {
                DDLog.error(error?.localizedDescription ?? "")
                productViewController.dismiss(animated: true)
            }
        }
        controller.showDetailViewController(productViewController, sender: controller)
    }

    /// 打开应用在`AppStore`中的打分页面
    /// - Parameter appID: 应用在商店中的ID
    func openEvaluateInAppStore(_ appID: String) {
        let urlString = "https://itunes.apple.com/cn/app/id\(appID)?mt=12"
        guard let url = URL(string: urlString) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        dd_openURL(url) { $0 ? DDLog.info("打开应用商店评分页成功!") : DDLog.error("打开应用商店评分页失败!") }
    }

    /// 打开`设置App`并跳转至当前App权限相关界面
    func dd_openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        dd_openURL(url) { $0 ? DDLog.info("打开设置App成功!") : DDLog.error("打开设置App失败!") }
    }

    /// 让用户自己决定是否打开`设置App`并跳转至当前App权限相关界面
    /// - Parameters:
    ///   - title:提示标题
    ///   - message:提示内容
    ///   - cancel:取消按钮标题
    ///   - confirm:确认按钮标题
    ///   - parent:来源控制器(谁来弹出提示窗)
    func dd_openSettings(_ title: String?,
                         message: String?,
                         cancel: String = "取消",
                         confirm: String = "设置",
                         parent: UIViewController? = nil)
    {
        UIAlertController()
            .dd_title(title)
            .dd_message(message)
            .dd_addAction_(title: cancel, style: .cancel) { _ in
                DDLog.info("取消!")
            }
            .dd_addAction_(title: confirm, style: .default) { _ in
                // 打开系统设置App
                self.dd_openSettings()
            }.dd_show()
    }
}

// MARK: - 推送
public extension UIApplication {
    /// 注册APNs远程推送
    /// - Parameter delegate:代理对象
    func dd_registerAPNsWithDelegate(_ delegate: Any) {
        if #available(iOS 10.0, *) {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            let center = UNUserNotificationCenter.current()
            center.delegate = (delegate as! UNUserNotificationCenterDelegate)
            center.requestAuthorization(options: options) { (granted: Bool, error: Error?) in
                DDLog.info("远程推送注册\(granted ? "成功" : "失败")!")
            }
            self.registerForRemoteNotifications()
        } else {
            // 请求授权
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            registerUserNotificationSettings(settings)
            // 需要通过设备UDID,和bundleID,发送请求,获取deviceToken
            registerForRemoteNotifications()
        }
    }

    /// 添加本地通知
    /// - Parameters:
    ///   - trigger:触发器
    ///   - content:内容
    ///   - identifier:标识
    ///   - categories:分类
    ///   - repeats:是否重复
    ///   - handler:处理回调
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
            interval = interval < 0 ? 1 : interval
            notiTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        } else if let components = trigger as? DateComponents { // 日历触发
            notiTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        } else if let region = trigger as? CLCircularRegion { // 区域触发
            notiTrigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        }

        // 通知请求
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notiTrigger)
        // 通知中心
        let center = UNUserNotificationCenter.current()

        // 添加通知请求
        center.add(request) { error in
            // 回调结果
            handler?(center, request, error)
            if error == nil {
                return
            }
            print("通知添加成功!")
        }
    }
}
