//
//  DarkModeManager.swift
//  DuckDuck
//
//  Created by xxwang on 21/11/2024.
//

import UIKit

// MARK: - 深色模式管理器
/// 管理应用的深色模式相关逻辑，包括动态颜色、动态图片和智能换肤功能。
@MainActor
public class DarkModeManager {
    // MARK: - UserDefaults Keys
    /// 是否跟随系统模式的标识
    private let followSystemModeKey = "kFollowSystemMode"
    /// 浅色模式的标识
    private let lightModeKey = "kLightMode"
    /// 智能换肤模式的标识
    private let smartSkinModeKey = "kSmartSkinMode"
    /// 智能换肤的时间区间
    private let smartSkinTimeIntervalKey = "kSmartSkinTimeInterval"

    // MARK: - UserDefaults
    private var userDefaults: UserDefaults = .standard

    // 单例模式
    public static let shared = DarkModeManager()
    private init() {
        if #available(iOS 13.0, *) {
            if self.isFollowSystemEnabled {
                // 设置跟随系统模式
                self.setDarkModeToFollowSystem(true)
            } else {
                // 根据当前的浅色/深色模式设置
                self.applyDarkMode(isLightMode: self.isLightModeEnabled)
            }
        }
    }
}

// MARK: - 公共属性
public extension DarkModeManager {
    /// 当前是否为浅色模式
    ///
    /// - 当启用智能换肤模式时，会根据时间区间判断。
    /// - 否则，根据用户设置的浅色模式决定。
    /// - Example:
    /// ```swift
    /// let isLightMode = DarkModeManager.shared.isLightModeEnabled
    /// print("当前模式: \(isLightMode ? "浅色模式" : "深色模式")")
    /// ```
    var isLightModeEnabled: Bool {
        if self.isSmartSkinEnabled {
            return !self.isWithinSmartSkinTimeInterval()
        }
        return userDefaults.bool(forKey: lightModeKey)
    }

    /// 当前是否跟随系统模式
    ///
    /// - Returns: 如果设备支持深色模式（iOS 13+），则返回用户设置。
    /// - Example:
    /// ```swift
    /// let isFollowSystem = DarkModeManager.shared.isFollowSystemEnabled
    /// print("是否跟随系统模式: \(isFollowSystem ? "是" : "否")")
    /// ```
    var isFollowSystemEnabled: Bool {
        guard #available(iOS 13.0, *) else { return false }
        return userDefaults.bool(forKey: followSystemModeKey)
    }

    /// 是否启用了智能换肤功能
    ///
    /// - Returns: 智能换肤功能的启用状态。
    /// - Example:
    /// ```swift
    /// let isSmartSkin = DarkModeManager.shared.isSmartSkinEnabled
    /// print("智能换肤启用: \(isSmartSkin ? "是" : "否")")
    /// ```
    var isSmartSkinEnabled: Bool {
        userDefaults.bool(forKey: smartSkinModeKey)
    }

    /// 智能换肤时间区间，格式为 `"HH:mm~HH:mm"`。
    ///
    /// - Example: `"21:00~08:00"`
    var smartSkinTimeInterval: String {
        get { userDefaults.string(forKey: smartSkinTimeIntervalKey) ?? "21:00~08:00" }
        set { userDefaults.set(newValue, forKey: smartSkinTimeIntervalKey) }
    }
}

public extension DarkModeManager {
    /// 设置应用是否跟随系统的暗黑模式
    /// - Parameter followSystem: 是否跟随系统
    /// - Example:
    /// ```swift
    /// DarkModeManager.shared.setDarkModeToFollowSystem(true)
    /// ```
    func setDarkModeToFollowSystem(_ followSystem: Bool) {
        if #available(iOS 13.0, *) {
            // 保存是否跟随系统的设置
            self.userDefaults.set(followSystem, forKey: self.followSystemModeKey)

            // 根据当前的系统界面样式设置浅色或深色
            self.userDefaults.set(UITraitCollection.current.userInterfaceStyle == .light, forKey: self.lightModeKey)

            // 关闭智能换肤模式
            self.userDefaults.set(false, forKey: self.smartSkinModeKey)

            // 设置窗口的界面样式为跟随系统
            UIWindow.dd_mainWindow()?.overrideUserInterfaceStyle = followSystem ? .unspecified : .light
        }
    }

    /// 设置应用为自定义的浅色或深色模式
    /// - Parameter isLightMode: 是否为浅色模式
    /// - Example:
    /// ```swift
    /// DarkModeManager.shared.setCustomDarkMode(isLightMode: false)
    /// ```
    func setCustomDarkMode(isLightMode: Bool) {
        if #available(iOS 13.0, *) {
            // 根据传入的模式设置窗口的界面样式
            self.applyDarkMode(isLightMode: self.isLightModeEnabled)

            // 禁用跟随系统模式和智能换肤模式
            self.userDefaults.set(false, forKey: self.followSystemModeKey)
            self.userDefaults.set(false, forKey: self.smartSkinModeKey)
        } else {
            // iOS 13 以下，直接设置浅色或深色模式
            self.userDefaults.set(false, forKey: smartSkinModeKey)
            self.userDefaults.set(isLightMode, forKey: lightModeKey)

            SkinManager.shared.updateSkin() // 通知皮肤更新
        }
    }

    /// 启用或禁用智能换肤模式
    /// - Parameter isEnabled: 是否启用智能换肤模式
    /// - Example:
    /// ```swift
    /// DarkModeManager.shared.setSmartSkinMode(true)
    /// ```
    func setSmartSkinMode(_ isEnabled: Bool) {
        self.userDefaults.set(isEnabled, forKey: self.smartSkinModeKey)

        if #available(iOS 13.0, *) {
            // 根据智能换肤模式设置当前界面样式
            self.applyDarkMode(isLightMode: self.isLightModeEnabled)

            // 禁用跟随系统模式
            self.userDefaults.set(false, forKey: self.followSystemModeKey)
        } else {
            // 更新皮肤
            SkinManager.shared.updateSkin()
        }
    }

    /// 设置智能换肤的时间区间
    /// - Parameters:
    ///   - startTime: 智能换肤开始时间
    ///   - endTime: 智能换肤结束时间
    /// - Example:
    /// ```swift
    /// DarkModeManager.shared.setSmartSkinTimeInterval(startTime: "21:00", endTime: "08:00")
    /// ```
    func setSmartSkinTimeInterval(startTime: String, endTime: String) {
        // 设置新的智能换肤时间区间
        self.smartSkinTimeInterval = "\(startTime)~\(endTime)"

        if #available(iOS 13.0, *) {
            // 判断当前时间是否在智能换肤时间区间内，并应用相应的模式
            let lightMode = self.isWithinSmartSkinTimeInterval() ? false : true
            self.applyDarkMode(isLightMode: lightMode)
        } else {
            // 更新皮肤
            SkinManager.shared.updateSkin()
        }
    }

    /// 设置为浅色模式
    ///
    /// - Example:
    /// ```swift
    /// DarkModeManager.shared.setLightMode()
    /// ```
    func setLightMode() {
        self.setCustomDarkMode(isLightMode: true)
    }

    /// 设置为深色模式
    ///
    /// - Example:
    /// ```swift
    /// DarkModeManager.shared.setDarkMode()
    /// ```
    func setDarkMode() {
        self.setCustomDarkMode(isLightMode: false)
    }
}

// MARK: - 辅助方法
public extension DarkModeManager {
    /// 根据是否为浅色模式，应用相应的界面样式
    /// - Parameter isLightMode: 是否为浅色模式
    /// - Example:
    /// ```swift
    /// DarkModeManager.shared.applyDarkMode(isLightMode: true)
    /// ```
    private func applyDarkMode(isLightMode: Bool) {
        UIWindow.dd_mainWindow()?.overrideUserInterfaceStyle = isLightMode ? .light : .dark
        self.userDefaults.set(isLightMode, forKey: self.lightModeKey)
    }
}

// MARK: - 智能换肤时间段
private extension DarkModeManager {
    /// 检查当前时间是否在智能换肤时间区间内
    ///
    /// - Returns: 如果在时间区间内，则返回 `true`。
    /// - Example:
    /// ```swift
    /// if DarkModeManager.shared.isWithinSmartSkinTimeInterval() {
    ///     print("当前在智能换肤时间段内")
    /// }
    /// ```
    func isWithinSmartSkinTimeInterval() -> Bool {
        let timeInterval = smartSkinTimeInterval.split(separator: "~").map { String($0) }
        guard timeInterval.count == 2 else { return false }

        let startTimestamp = timeToTimestamp(time: timeInterval[0])
        let endTimestamp = timeToTimestamp(time: timeInterval[1])
        let currentTimestamp = Date().timeIntervalSince1970

        // 如果结束时间小于开始时间，表示时间段跨天
        if endTimestamp < startTimestamp {
            return currentTimestamp >= startTimestamp || currentTimestamp <= endTimestamp
        } else {
            return currentTimestamp >= startTimestamp && currentTimestamp <= endTimestamp
        }
    }

    /// 时间字符串转换为时间戳
    ///
    /// - Parameter time: 时间字符串，格式为 "HH:mm"
    /// - Returns: 时间戳
    /// - Example:
    /// ```swift
    /// let timestamp = DarkModeManager.shared.timeToTimestamp(time: "21:00")
    /// print("时间戳: \(timestamp)")
    /// ```
    func timeToTimestamp(time: String) -> TimeInterval {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let date = formatter.date(from: time) else { return 0 }
        return date.timeIntervalSince1970
    }
}

// MARK: - 图片与颜色适配
public extension DarkModeManager {
    /// 根据当前模式返回动态颜色
    ///
    /// - Parameters:
    ///   - lightColor: 浅色模式下使用的颜色。
    ///   - darkColor: 深色模式下使用的颜色。
    /// - Returns: 当前模式下的适配颜色。
    ///
    /// - Example:
    /// ```swift
    /// let adaptiveColor = DarkModeManager.shared.colorForCurrentMode(
    ///     lightColor: .white,
    ///     darkColor: .black
    /// )
    /// view.backgroundColor = adaptiveColor
    /// ```
    func colorForCurrentMode(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                if self.isFollowSystemEnabled {
                    return traitCollection.userInterfaceStyle == .light ? lightColor : darkColor
                } else if self.isSmartSkinEnabled {
                    return self.isWithinSmartSkinTimeInterval() ? darkColor : lightColor
                } else {
                    return self.isLightModeEnabled ? lightColor : darkColor
                }
            }
        } else {
            return self.isLightModeEnabled ? lightColor : darkColor
        }
    }

    /// 根据当前模式（浅色或深色）返回对应的图片
    ///
    /// - Parameters:
    ///   - light: 浅色模式下的图片
    ///   - dark: 深色模式下的图片
    /// - Returns: 当前模式下的图片
    ///
    /// - Example:
    /// ```swift
    /// let lightImage = UIImage(named: "lightModeImage")
    /// let darkImage = UIImage(named: "darkModeImage")
    /// let image = DarkModeManager.shared.imageForCurrentMode(light: lightImage, dark: darkImage)
    /// imageView.image = image
    /// ```
    func imageForCurrentMode(light: UIImage?, dark: UIImage?) -> UIImage? {
        // 检查系统版本，确保支持深色模式
        if #available(iOS 13.0, *) {
            // 检查是否提供了浅色和深色模式图片
            guard let light, let dark else {
                return light
            }

            // 创建特征配置
            guard let lightConfig = light.configuration?.withTraitCollection(UITraitCollection(userInterfaceStyle: .light)),
                  let darkConfig = dark.configuration?.withTraitCollection(UITraitCollection(userInterfaceStyle: .dark))
            else {
                return light
            }

            // 为图片应用特征配置
            let lightImage = light.withConfiguration(lightConfig)
            let darkImage = light.withConfiguration(darkConfig)

            // 将深色模式图片注册到浅色图片的 imageAsset 中
            lightImage.imageAsset?.register(darkImage, with: UITraitCollection(userInterfaceStyle: .dark))

            // 根据当前系统界面模式返回适当的图片（浅色或深色）
            return lightImage.imageAsset?.image(with: UITraitCollection.current) ?? light
        } else {
            return isLightModeEnabled ? light : dark
        }
    }

    /// 通过图片名称或系统图标名称返回当前模式下的图片
    ///
    /// - Parameters:
    ///   - light: 浅色模式下的图片名称
    ///   - dark: 深色模式下的图片名称
    /// - Returns: 当前模式下的图片
    ///
    /// - Example:
    /// ```swift
    /// let image = DarkModeManager.shared.imageForCurrentMode(light: "lightModeImage", dark: "darkModeImage")
    /// imageView.image = image
    /// ```
    func imageForCurrentMode(light: String, dark: String) -> UIImage? {
        if #available(iOS 17.0, *) {
            // 获取当前的界面模式（浅色或深色模式）
            let userInterfaceStyle = UITraitCollection.current.userInterfaceStyle

            // 用字符串创建图片，先尝试从图片资源中获取，如果没有，再尝试用系统图片
            let lightImage = UIImage(named: light) ?? UIImage(systemName: light)
            let darkImage = UIImage(named: dark) ?? UIImage(systemName: dark)

            // 根据当前模式设置图片
            let lightTraitCollection = UITraitCollection(userInterfaceStyle: .light)
            let darkTraitCollection = UITraitCollection(userInterfaceStyle: .dark)

            let lightImageConfig = lightImage?.withConfiguration(UIImage.SymbolConfiguration(traitCollection: lightTraitCollection))
            let darkImageConfig = darkImage?.withConfiguration(UIImage.SymbolConfiguration(traitCollection: darkTraitCollection))

            if userInterfaceStyle == .dark {
                return darkImageConfig ?? darkImage
            } else {
                return lightImageConfig ?? lightImage
            }

        } else if #available(iOS 13.0, *) {
            // iOS 13 至 iOS 16，直接根据界面模式返回适当的图片
            let userInterfaceStyle = UITraitCollection.current.userInterfaceStyle

            let lightImage = UIImage(named: light) ?? UIImage(systemName: light)
            let darkImage = UIImage(named: dark) ?? UIImage(systemName: dark)

            if userInterfaceStyle == .dark {
                return darkImage
            } else {
                return lightImage
            }

        } else {
            // iOS 13 以下，直接返回 light 或 dark 图片
            return isLightModeEnabled ? UIImage(systemName: light) : UIImage(systemName: dark)
        }
    }

    /// 返回根据当前模式选择的动态图片（浅色模式或深色模式）
    ///
    /// - Parameters:
    ///   - lightImage: 浅色模式下的图片
    ///   - darkImage: 深色模式下的图片
    /// - Returns: 当前模式下的图片
    ///
    /// - Example:
    /// ```swift
    /// let lightImage = UIImage(named: "lightModeImage")
    /// let darkImage = UIImage(named: "darkModeImage")
    /// let image = DarkModeManager.shared.dynamicImage(lightImage: lightImage, darkImage: darkImage)
    /// imageView.image = image
    /// ```
    @available(iOS 13.0, *)
    func dynamicImage(lightImage: UIImage, darkImage: UIImage) -> UIImage {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return darkImage
        } else {
            return lightImage
        }
    }
}
