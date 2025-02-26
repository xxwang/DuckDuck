//
//  AppDimensions.swift
//  DuckDuck
//
//  Created by 王斌 on 2025/2/25.
//

import UIKit

// MARK: - 屏幕尺寸
public struct AppDimensions {
    /// 设计图的尺寸
    private static var sketchSize: CGSize = .zero
}

public extension AppDimensions {
    /// 屏幕的整体边界 (CGRect)
    static var screenBounds: CGRect { UIScreen.main.bounds }

    /// 屏幕尺寸 (CGSize)
    static var screenSize: CGSize { self.screenBounds.size }

    /// 屏幕宽度
    static var screenWidth: CGFloat { self.screenBounds.width }

    /// 屏幕高度
    static var screenHeight: CGFloat { self.screenBounds.height }
}

// MARK: - 安全区相关属性
public extension AppDimensions {
    /// 安全区的Insets (UIEdgeInsets)
    static var safeAreaInsets: UIEdgeInsets { UIWindow.dd_mainWindow()?.safeAreaInsets ?? .zero }

    /// 安全区顶部的高度
    static var safeAreaTop: CGFloat { self.safeAreaInsets.top }

    /// 安全区底部的高度
    static var safeAreaBottom: CGFloat { self.safeAreaInsets.bottom }

    /// 安全区左侧的宽度
    static var safeAreaLeft: CGFloat { self.safeAreaInsets.left }

    /// 安全区右侧的宽度
    static var safeAreaRight: CGFloat { self.safeAreaInsets.right }
}

// MARK: - 导航栏相关属性
public extension AppDimensions {
    /// 状态栏的高度
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return UIWindow.dd_mainWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }

    /// 标题栏的高度
    static var titleBarHeight: CGFloat = {
        let navBarHeight = UINavigationController().navigationBar.frame.height
        return navBarHeight > 0 ? navBarHeight : 44
    }()

    /// 导航栏的总高度 ，包含状态栏和标题栏
    static var navBarFullHeight: CGFloat { self.statusBarHeight + self.titleBarHeight }
}

// MARK: - 标签栏相关属性
public extension AppDimensions {
    /// 标签栏的高度
    static var tabBarHeight: CGFloat = {
        let tabBarHeight = UITabBarController().tabBar.frame.height
        return tabBarHeight > 0 ? tabBarHeight : 49
    }()

    /// 标签栏的安全区底部高度
    static var tabBarIndentHeight: CGFloat { self.safeAreaBottom }

    /// 标签栏的总高度 ，包括标签栏本身和安全区的底部
    static var tabBarFullHeight: CGFloat { self.tabBarHeight + self.tabBarIndentHeight }
}

// MARK: - 屏幕适配
public extension AppDimensions {
    /// 设置设计图的尺寸，适配不同设备的设计图尺寸（默认使用 iPhone8 尺寸）。
    ///
    /// - Parameter size: 设计图的尺寸，通常为设计图的宽度和高度。
    /// - Default value: 默认设置为 CGSize(width: 375, height: 812)，适配 iPhone 8 尺寸。
    ///
    /// - Example:
    /// ```swift
    /// let size = CGSize(width: 375, height: 667)
    /// SizeCalculator.setupSketch(size: size)  // 设置为 iPhone 6, 7, 8 的设计图尺寸
    /// ```
    static func setupSketch(size: CGSize = CGSize(width: 375, height: 812)) {
        self.sketchSize = size
    }
}

// MARK: - 屏幕适配功能
private extension AppDimensions {
    /// 根据设计图宽度计算适配后的宽度。
    ///
    /// - Parameter value: 需要计算适配的宽度值，通常是视图的宽度。
    /// - Returns: 适配后的宽度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedWidth = SizeCalculator.calculateWidth(from: 200)
    /// ```
    static func calculateWidth(from value: Any) -> CGFloat {
        return self.calculateWidthRatio() * self.convertValueToCGFloat(from: value)
    }

    /// 根据设计图高度计算适配后的高度。
    ///
    /// - Parameter value: 需要计算适配的高度值，通常是视图的高度。
    /// - Returns: 适配后的高度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedHeight = SizeCalculator.calculateHeight(from: 100)
    /// ```
    static func calculateHeight(from value: Any) -> CGFloat {
        return self.calculateHeightRatio() * self.convertValueToCGFloat(from: value)
    }

    /// 计算适配后的最大值（根据设计图的宽度和高度，选择较大的值）。
    ///
    /// - Parameter value: 需要计算适配的值。
    /// - Returns: 适配后的最大宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMax = SizeCalculator.calculateMax(from: 100)
    /// ```
    static func calculateMax(from value: Any) -> CGFloat {
        return max(self.calculateWidth(from: value), self.calculateHeight(from: value))
    }

    /// 计算适配后的最小值（根据设计图的宽度和高度，选择较小的值）。
    ///
    /// - Parameter value: 需要计算适配的值。
    /// - Returns: 适配后的最小宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMin = SizeCalculator.calculateMin(from: 100)
    /// ```
    static func calculateMin(from value: Any) -> CGFloat {
        return min(self.calculateWidth(from: value), self.calculateHeight(from: value))
    }

    /// 获取宽度适配比例（即当前屏幕宽度与设计图宽度的比例）。
    ///
    /// - Returns: 屏幕宽度与设计图宽度的适配比例。
    ///
    /// - Example:
    /// ```swift
    /// let widthRatio = SizeCalculator.calculateWidthRatio()
    /// ```
    static func calculateWidthRatio() -> CGFloat {
        return AppDimensions.screenWidth / self.sketchSize.width
    }

    /// 获取高度适配比例（即当前屏幕高度与设计图高度的比例）。
    ///
    /// - Returns: 屏幕高度与设计图高度的适配比例。
    ///
    /// - Example:
    /// ```swift
    /// let heightRatio = SizeCalculator.calculateHeightRatio()
    /// ```
    static func calculateHeightRatio() -> CGFloat {
        return AppDimensions.screenHeight / self.sketchSize.height
    }

    /// 将输入的值转换为 `CGFloat` 类型。
    ///
    /// - Parameter value: 需要转换的值，支持 `CGFloat`、`Double`、`Float` 和 `Int` 类型。
    /// - Returns: 转换后的 `CGFloat` 值。
    ///
    /// - Example:
    /// ```swift
    /// let cgValue = SizeCalculator.convertValueToCGFloat(from: 200)
    /// ```
    static func convertValueToCGFloat(from value: Any) -> CGFloat {
        if let value = value as? CGFloat { return value }
        if let value = value as? Double { return CGFloat(value) }
        if let value = value as? Float { return CGFloat(value) }
        if let value = value as? Int { return CGFloat(value) }
        return 0
    }
}

// MARK: - 整数适配扩展
public extension BinaryInteger {
    /// 自动适配宽度（将整数值按设计图宽度比例适配）。
    ///
    /// - Returns: 自动适配后的宽度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedWidth = 200.wAuto
    /// ```
    var wAuto: CGFloat { AppDimensions.calculateWidth(from: self) }

    /// 自动适配高度（将整数值按设计图高度比例适配）。
    ///
    /// - Returns: 自动适配后的高度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedHeight = 150.hAuto
    /// ```
    var hAuto: CGFloat { AppDimensions.calculateHeight(from: self) }

    /// 自动适配最大值（根据设计图宽度和高度适配后的最大值）。
    ///
    /// - Returns: 自动适配后的最大宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMax = 200.maxAuto
    /// ```
    var maxAuto: CGFloat { AppDimensions.calculateMax(from: self) }

    /// 自动适配最小值（根据设计图宽度和高度适配后的最小值）。
    ///
    /// - Returns: 自动适配后的最小宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMin = 100.minAuto
    /// ```
    var minAuto: CGFloat { AppDimensions.calculateMin(from: self) }
}

// MARK: - 浮动数字适配扩展
public extension BinaryFloatingPoint {
    /// 自动适配宽度（将浮动数字按设计图宽度比例适配）。
    ///
    /// - Returns: 自动适配后的宽度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedWidth = 200.5.wAuto
    /// ```
    var wAuto: CGFloat { AppDimensions.calculateWidth(from: self) }

    /// 自动适配高度（将浮动数字按设计图高度比例适配）。
    ///
    /// - Returns: 自动适配后的高度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedHeight = 150.75.hAuto
    /// ```
    var hAuto: CGFloat { AppDimensions.calculateHeight(from: self) }

    /// 自动适配最大值（根据设计图宽度和高度适配后的最大值）。
    ///
    /// - Returns: 自动适配后的最大宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMax = 200.5.maxAuto
    /// ```
    var maxAuto: CGFloat { AppDimensions.calculateMax(from: self) }

    /// 自动适配最小值（根据设计图宽度和高度适配后的最小值）。
    ///
    /// - Returns: 自动适配后的最小宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMin = 100.25.minAuto
    /// ```
    var minAuto: CGFloat { AppDimensions.calculateMin(from: self) }
}
