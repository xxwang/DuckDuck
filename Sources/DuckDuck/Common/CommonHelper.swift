//
//  CommonHelper.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 19/11/2024.
//

import UIKit

/// 工具类，包含环境和设备相关的判断方法
public class CommonHelper {}

/// 环境判断
public extension CommonHelper {
    /// 判断是否运行在模拟器上
    ///
    /// - Example:
    /// ```swift
    /// if DDHelper.isSimulator {
    ///     print("运行在模拟器上")
    /// }
    /// ```
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    /// 判断是否为调试模式
    ///
    /// - Example:
    /// ```swift
    /// if DDHelper.isDebug {
    ///     print("当前为调试模式")
    /// }
    /// ```
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    /// 当前 App 的运行环境
    ///
    /// 根据编译条件自动判断运行环境。
    ///
    /// - 返回值:
    ///   - `.dev`: 如果是调试模式。
    ///   - `.prod`: 如果是生产模式。
    ///
    /// - Example:
    /// ```swift
    /// let environment = CommonHelper.runEnv
    /// print("当前运行环境：\(environment.rawValue)")
    /// ```
    static var runEnv: AppRunEnv {
        #if DEBUG
            return .dev
        #else
            return .prod
        #endif
    }
}

/// 设备判断
@MainActor
public extension CommonHelper {
    /// 判断是否为 `iPad`
    ///
    /// - Example:
    /// ```swift
    /// if DDHelper.isIPad {
    ///     print("当前设备为 iPad")
    /// }
    /// ```
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    /// 判断是否为 `iPhone`
    ///
    /// - Example:
    /// ```swift
    /// if DDHelper.isIPhone {
    ///     print("当前设备为 iPhone")
    /// }
    /// ```
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    /// 判断是否为 `iPhone X` 系列
    ///
    /// - Example:
    /// ```swift
    /// if DDHelper.isIPhoneX {
    ///     print("当前设备为 iPhone X 系列")
    /// }
    /// ```
    static var isIPhoneX: Bool {
        return max(ScreenInfo.safeAreaLeft, ScreenInfo.safeAreaBottom) > 0
    }

    /// 判断是否为横屏
    ///
    /// - Example:
    /// ```swift
    /// if DDHelper.isLandscape {
    ///     print("当前为横屏")
    /// }
    /// ```
    static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            // 设备方向是否为横屏
            return UIDevice.current.orientation.isValidInterfaceOrientation &&
                UIDevice.current.orientation.isLandscape
        } else {
            // 状态栏方向是否为横屏
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}
