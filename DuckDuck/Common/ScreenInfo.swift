import UIKit

// MARK: - 屏幕、导航栏、标签栏等属性管理
public class ScreenInfo {}

// MARK: - 屏幕相关属性
public extension ScreenInfo {
    /// 屏幕的整体边界 (CGRect)
    static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }

    /// 屏幕尺寸 (CGSize)
    static var screenSize: CGSize { screenBounds.size }

    /// 屏幕宽度 (CGFloat)
    static var screenWidth: CGFloat { screenBounds.width }

    /// 屏幕高度 (CGFloat)
    static var screenHeight: CGFloat { screenBounds.height }
}

// MARK: - 安全区相关属性
public extension ScreenInfo {
    /// 安全区的Insets (UIEdgeInsets)
    static var safeAreaInsets: UIEdgeInsets {
        let inserts = UIWindow.dd_mainWindow()?.safeAreaInsets ?? .zero
        return inserts
    }

    /// 安全区顶部的高度 (CGFloat)
    static var safeAreaTop: CGFloat { safeAreaInsets.top }

    /// 安全区底部的高度 (CGFloat)
    static var safeAreaBottom: CGFloat { safeAreaInsets.bottom }

    /// 安全区左侧的宽度 (CGFloat)
    static var safeAreaLeft: CGFloat { safeAreaInsets.left }

    /// 安全区右侧的宽度 (CGFloat)
    static var safeAreaRight: CGFloat { safeAreaInsets.right }
}

// MARK: - 导航栏相关属性
public extension ScreenInfo {
    /// 状态栏的高度 (CGFloat)
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return UIWindow.dd_mainWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return DispatchQueue.main.sync { UIApplication.shared.statusBarFrame.height }
        }
    }

    /// 标题栏的高度 (CGFloat)
    static let titleBarHeight1: CGFloat = 44
    static var titleBarHeight: CGFloat = {
        let navigationBar = UINavigationBar()
        return navigationBar.frame.height
    }()

    /// 导航栏的总高度 (CGFloat)，包含状态栏和标题栏
    static var navFullHeight: CGFloat { statusBarHeight + titleBarHeight }
}

// MARK: - 标签栏相关属性
public extension ScreenInfo {
    /// 标签栏的高度 (CGFloat)
    static let tabBarHeight: CGFloat = 49

    /// 标签栏的安全区底部高度 (CGFloat)
    static var tabBarIndentHeight: CGFloat { safeAreaBottom }

    /// 标签栏的总高度 (CGFloat)，包括标签栏本身和安全区的底部
    static var tabBarFullHeight: CGFloat { tabBarHeight + tabBarIndentHeight }
}
