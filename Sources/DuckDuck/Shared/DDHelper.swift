//
//  DDHelper.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import UIKit

public class DDHelper {}

// MARK: - 环境判断
public extension DDHelper {
    /// 是否是模拟器
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    /// 是否是调试模式
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}

// MARK: - 设备判断
public extension DDHelper {
    /// 是否是`iPad`
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    /// 是否是`iPhone`
    static var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    /// 是否是`iPhoneX`系列
    static var isIPhoneX: Bool {
        if #available(iOS 11, *) {
            return max(kSafeAreaLeft, kSafeAreaBottom) > 0
        }
        return false
    }

    /// 是否是横屏
    static var isLandscape: Bool {
        var isLandscape = false
        if #available(iOS 13, *) {
            isLandscape = [.landscapeLeft, .landscapeRight].contains(UIDevice.current.orientation)
        } else {
            isLandscape = UIApplication.shared.statusBarOrientation.isLandscape
        }

        if let window = UIWindow.dd_window(), isLandscape == false {
            isLandscape = window.dd_width > window.dd_height
        }
        return isLandscape
    }
}
