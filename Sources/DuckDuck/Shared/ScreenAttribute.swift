//
//  ScreenAttribute.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import UIKit

// MARK: - 屏幕
public var kScreenBounds: CGRect { return UIScreen.main.bounds }
public var kScreenSize: CGSize { return kScreenBounds.size }
public var kScreenWidth: CGFloat { return kScreenBounds.width }
public var kScreenHeight: CGFloat { return kScreenBounds.height }

// MARK: - 安全区
public var kSafeAreaInsets: UIEdgeInsets {
    if #available(iOS 11.0, *) {
        return UIWindow.dd.window?.safeAreaInsets ?? .zero
    }
    return .zero
}

public var kSafeAreaTop: CGFloat { return kSafeAreaInsets.top }
public var kSafeAreaBottom: CGFloat { return kSafeAreaInsets.bottom }
public var kSafeAreaLeft: CGFloat { return kSafeAreaInsets.left }
public var kSafeAreaRight: CGFloat { return kSafeAreaInsets.right }

// MARK: - 导航栏
public var kStatusBarHeight: CGFloat {
    if #available(iOS 13.0, *) {
        if let statusbar = UIWindow.dd.window?.windowScene?.statusBarManager {
            return statusbar.statusBarFrame.size.height
        }
        return 0
    } else {
        return UIApplication.shared.statusBarFrame.size.height
    }
}

public var kTitleBarHeight: CGFloat = 44
public var kNavFullHeight: CGFloat { return kStatusBarHeight + kTitleBarHeight }

// MARK: - 标签栏
public var kTabBarHeight: CGFloat = 49
public var kTabBarIndentHeight: CGFloat { return kSafeAreaBottom }
public var kTabBarFullHeight: CGFloat { return kTabBarHeight + kTabBarIndentHeight }
