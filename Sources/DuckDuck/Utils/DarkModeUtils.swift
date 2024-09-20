import UIKit

/*
 默认开启:跟随系统模式

 1、跟随系统
 1.1、需要设置:
 UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.overrideUserInterfaceStyle = .unspecified
 2、不跟随系统
 2.1、浅色,UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.overrideUserInterfaceStyle = .light
 2.2、深色,UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.overrideUserInterfaceStyle = .dark
 */

// MARK: - 关联键
private class AssociateKeys {
    /// 智能换肤的时间区间的key
    static let SmartPeelingTimeIntervalKey = "SmartPeelingTimeIntervalKey"
    /// 跟随系统的key
    static let DarkToSystemKey = "DarkToSystemKey"
    /// 是否浅色模式的key
    static let LightDarkKey = "LightDarkKey"
    /// 智能换肤的key
    static let SmartPeelingKey = "SmartPeelingKey"
}

public class DarkModeUtils: NSObject {
    /// 是否浅色
    public static var isLight: Bool {
        if isSmartPeeling {
            return isSmartPeelingTime() ? false : true
        }
        if let value = UserDefaults.standard.value(forKey: AssociateKeys.LightDarkKey) as? Bool {
            return value
        }
        UserDefaults.resetStandardUserDefaults()
        return true
    }

    /// 是否跟随系统
    public static var isFollowSystem: Bool {
        if #available(iOS 13, *) {
            if let value = UserDefaults.standard.value(forKey: AssociateKeys.DarkToSystemKey) as? Bool {
                return value
            }
            return true
        }
        return false
    }

    /// 默认不是智能换肤
    public static var isSmartPeeling: Bool {
        if let value = UserDefaults.standard.value(forKey: AssociateKeys.SmartPeelingKey) as? Bool {
            return value
        }
        return false
    }

    /// 智能换肤的时间段:默认是:21:00~8:00
    public static var SmartPeelingTimeIntervalValue: String {
        get {
            if let value = UserDefaults.standard.value(forKey: AssociateKeys.SmartPeelingTimeIntervalKey) as? String {
                return value
            }
            return "21:00~8:00"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AssociateKeys.SmartPeelingTimeIntervalKey)
            UserDefaults.standard.synchronize()
        }
    }
}

// MARK: - 方法的调用
extension DarkModeUtils: Skinable {
    public func apply() {}
}

public extension DarkModeUtils {
    /// 初始化的调用
    static func defaultDark() {
        if #available(iOS 13.0, *) {
            // 默认跟随系统暗黑模式开启监听
            if DarkModeUtils.isFollowSystem {
                DarkModeUtils.setDarkModeFollowSystem(isFollowSystem: true)
            } else {
                UIWindow.dd_window()?.overrideUserInterfaceStyle = DarkModeUtils.isLight ? .light : .dark
            }
        }
    }

    /// 设置系统是否跟随
    static func setDarkModeFollowSystem(isFollowSystem: Bool) {
        if #available(iOS 13.0, *) {
            // 设置是否跟随系统
            UserDefaults.standard.set(isFollowSystem, forKey: AssociateKeys.DarkToSystemKey)

            let result = UITraitCollection.current.userInterfaceStyle == .light ? true : false
            UserDefaults.standard.set(result, forKey: AssociateKeys.LightDarkKey)
            UserDefaults.standard.set(false, forKey: AssociateKeys.SmartPeelingKey)

            UserDefaults.standard.synchronize()

            // 设置模式的保存
            if isFollowSystem {
                UIWindow.dd_window()?.overrideUserInterfaceStyle = .unspecified
            } else {
                UIWindow.dd_window()?.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            }
        }
    }

    /// 设置:浅色 / 深色
    static func setDarkModeCustom(isLight: Bool) {
        if #available(iOS 13.0, *) {
            // 只要设置了模式:就是黑或者白
            UIWindow.dd_window()?.overrideUserInterfaceStyle = isLight ? .light : .dark
            // 设置跟随系统和智能换肤:否
            UserDefaults.standard.set(false, forKey: AssociateKeys.DarkToSystemKey)
            UserDefaults.standard.set(false, forKey: AssociateKeys.SmartPeelingKey)
            // 黑白模式的设置
            UserDefaults.standard.set(isLight, forKey: AssociateKeys.LightDarkKey)
        } else {
            UserDefaults.standard.set(false, forKey: AssociateKeys.SmartPeelingKey)
            // 模式存储
            UserDefaults.standard.set(isLight, forKey: AssociateKeys.LightDarkKey)
            // 通知模式更新
            SkinManager.shared.updateSkin()
        }
        UserDefaults.standard.synchronize()
    }

    /// 智能换肤
    /// - Parameter isSmartPeeling:是否智能换肤
    static func setSmartPeelingDarkMode(isSmartPeeling: Bool) {
        if #available(iOS 13.0, *) {
            // 设置智能换肤
            UserDefaults.standard.set(isSmartPeeling, forKey: AssociateKeys.SmartPeelingKey)
            // 智能换肤根据时间段来设置:黑或者白
            UIWindow.dd_window()?.overrideUserInterfaceStyle = isLight ? .light : .dark
            // 设置跟随系统:否
            UserDefaults.standard.set(false, forKey: AssociateKeys.DarkToSystemKey)
            UserDefaults.standard.set(isLight, forKey: AssociateKeys.LightDarkKey)
        } else {
            // 模式存储
            // 设置智能换肤
            UserDefaults.standard.set(isSmartPeeling, forKey: AssociateKeys.SmartPeelingKey)
            // 设置跟随系统:否
            UserDefaults.standard.set(isLight, forKey: AssociateKeys.LightDarkKey)
            // 通知模式更新
            SkinManager.shared.updateSkin()
        }
    }

    /// 智能换肤时间选择后
    static func setSmartPeelingTimeChange(startTime: String, endTime: String) {
        /// 是否是浅色
        var light = false
        if DarkModeUtils.isSmartPeelingTime(startTime: startTime, endTime: endTime), DarkModeUtils.isLight {
            light = false
        } else {
            if !DarkModeUtils.isLight {
                light = true
            } else {
                DarkModeUtils.SmartPeelingTimeIntervalValue = startTime + "~" + endTime
                return
            }
        }
        DarkModeUtils.SmartPeelingTimeIntervalValue = startTime + "~" + endTime

        if #available(iOS 13.0, *) {
            // 只要设置了模式:就是黑或者白
            UIWindow.dd_window()?.overrideUserInterfaceStyle = light ? .light : .dark
            // 黑白模式的设置
            UserDefaults.standard.set(light, forKey: AssociateKeys.LightDarkKey)
        } else {
            // 模式存储
            UserDefaults.standard.set(light, forKey: AssociateKeys.LightDarkKey)
            // 通知模式更新
            SkinManager.shared.updateSkin()
        }
    }
}

// MARK: - 动态颜色的使用
public extension DarkModeUtils {
    /// 深色模式和浅色模式颜色设置,非layer颜色设置
    /// - Parameters:
    ///   - lightColor:浅色模式的颜色
    ///   - darkColor:深色模式的颜色
    /// - Returns:返回一个颜色(UIColor)
    static func darkModeColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                if DarkModeUtils.isFollowSystem {
                    if traitCollection.userInterfaceStyle == .light {
                        return lightColor
                    } else {
                        return darkColor
                    }
                } else if DarkModeUtils.isSmartPeeling {
                    return isSmartPeelingTime() ? darkColor : lightColor
                } else {
                    return DarkModeUtils.isLight ? lightColor : darkColor
                }
            }
        } else {
            // iOS 13 以下主题色的使用
            if DarkModeUtils.isLight {
                return lightColor
            }
            return darkColor
        }
    }

    /// 是否为智能换肤的时间:黑色
    /// - Returns:结果
    static func isSmartPeelingTime(startTime: String? = nil, endTime: String? = nil) -> Bool {
        // 获取暗黑模式时间的区间,转为两个时间戳,取出当前的时间戳,看是否在区间内,在的话:黑色,否则白色
        var timeIntervalValue: [String] = []
        if startTime != nil, endTime != nil {
            timeIntervalValue = [startTime!, endTime!]
        } else {
            timeIntervalValue = DarkModeUtils.SmartPeelingTimeIntervalValue.dd_split(with: "~")
        }
        // 1、时间区间分隔为:开始时间 和 结束时间
        // 2、当前的时间转时间戳
        let currentDate = Date.dd_now()
        let currentTimeStamp = Int(currentDate.dd_dateAs2Timestamp())!
        let dateString = currentDate.dd_String(with: "yyyy-MM-dd", isGMT: false)
        let startTimeStamp = (dateString + " " + timeIntervalValue[0])
            .dd_date(with: "yyyy-MM-dd HH:mm")?
            .dd_secondStamp()
            .dd_Int() ?? 0
        var endTimeStamp = (dateString + " " + timeIntervalValue[1])
            .dd_date(with: "yyyy-MM-dd HH:mm")?
            .dd_secondStamp()
            .dd_Int() ?? 0

        if startTimeStamp > endTimeStamp {
            endTimeStamp = endTimeStamp + 884_600
        }
        return currentTimeStamp >= startTimeStamp && currentTimeStamp <= endTimeStamp
    }
}

// MARK: - 动态图片的使用
public extension DarkModeUtils {
    /// 深色图片和浅色图片切换 (深色模式适配)
    /// - Parameters:
    ///   - light:浅色模式的图片
    ///   - dark:深色模式的图片
    /// - Returns:最终图片
    static func darkModeImage(light: UIImage?, dark: UIImage?) -> UIImage? {
        if #available(iOS 13.0, *) {
            guard let weakLight = light,
                  let weakDark = dark,
                  let config = weakLight.configuration
            else {
                return light
            }
            let lightImage = weakLight.withConfiguration(config.withTraitCollection(UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.light)))
            lightImage.imageAsset?.register(weakDark, with: config.withTraitCollection(UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.dark)))
            return lightImage.imageAsset?.image(with: UITraitCollection.current) ?? light
        } else {
            // iOS 13 以下主题色的使用
            if DarkModeUtils.isLight {
                return light
            }
            return dark
        }
    }
}
