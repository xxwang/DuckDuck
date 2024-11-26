//
//  UITabBar++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - 链式语法
public extension UITabBar {
    /// 设置是否半透明
    /// - Parameter isTranslucent: 是否半透明
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd_isTranslucent(true)
    /// ```
    @discardableResult
    func dd_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    /// 设置标题字体
    /// - Parameters:
    ///   - font: 要设置的字体
    ///   - state: 要设置的状态（如 normal 或 selected）
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd_titleFont(UIFont.boldSystemFont(ofSize: 14), state: .normal)
    /// ```
    @discardableResult
    func dd_titleFont(_ font: UIFont, state: UIControl.State) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            if state == .normal {
                var attributeds = appearance.stackedLayoutAppearance.normal.titleTextAttributes
                attributeds[.font] = font
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributeds
            } else if state == .selected {
                var attributeds = appearance.stackedLayoutAppearance.selected.titleTextAttributes
                attributeds[.font] = font
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributeds
            }
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        } else {
            var attributeds = UITabBarItem.appearance().titleTextAttributes(for: state) ?? [:]
            attributeds[.font] = font
            UITabBarItem.appearance().setTitleTextAttributes(attributeds, for: state)
        }
        return self
    }

    /// 设置标题颜色
    /// - Parameters:
    ///   - color: 要设置的颜色
    ///   - state: 要设置的状态（如 normal 或 selected）
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd_titleColor(.red, state: .normal)
    /// ```
    @discardableResult
    func dd_titleColor(_ color: UIColor, state: UIControl.State) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            if state == .normal {
                var attributeds = appearance.stackedLayoutAppearance.normal.titleTextAttributes
                attributeds[.foregroundColor] = color
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributeds
            } else if state == .selected {
                var attributeds = appearance.stackedLayoutAppearance.selected.titleTextAttributes
                attributeds[.foregroundColor] = color
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributeds
            }
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }

            // 设置未选中状态的颜色
            if state == .normal { self.unselectedItemTintColor = color }
            // 设置选中状态的颜色
            if state == .selected { self.tintColor = color }
        } else {
            var attributeds = UITabBarItem.appearance().titleTextAttributes(for: state) ?? [:]
            attributeds[.foregroundColor] = color
            UITabBarItem.appearance().setTitleTextAttributes(attributeds, for: state)
        }
        return self
    }

    /// 设置背景颜色
    /// - Parameter color: 要设置的背景颜色
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd_backgroundColor(with: .blue)
    /// ```
    @discardableResult
    func dd_backgroundColor(with color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.backgroundColor = color
            appearance.backgroundEffect = nil
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            self.backgroundColor = color
            self.barTintColor = color
        }
        return self
    }

    /// 设置背景图片
    /// - Parameter image: 要设置的背景图片
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd_backgroundImage(UIImage(named: "backgroundImage")!)
    /// ```
    @discardableResult
    func dd_backgroundImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.backgroundImage = image
            appearance.backgroundEffect = nil
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        } else {
            self.backgroundImage = image
        }
        return self
    }

    /// 设置标题文字的偏移
    /// - Parameter offset: 偏移量
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd_titlePositionAdjustment(UIOffset(horizontal: 0, vertical: 10))
    /// ```
    @discardableResult
    func dd_titlePositionAdjustment(_ offset: UIOffset) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
            appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            UITabBarItem.appearance().titlePositionAdjustment = offset
        }
        return self
    }

    /// 设置阴影图片
    /// - Parameter imageName: 阴影图片
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd_shadowImage(UIImage(named: "shadowImage")!)
    /// ```
    @discardableResult
    func dd_shadowImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.shadowImage = image.withRenderingMode(.alwaysOriginal)
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        } else {
            self.shadowImage = image.withRenderingMode(.alwaysOriginal)
        }
        return self
    }

    /// 设置滚动时外观与标准外观一致
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd_scrollEdgeAppearance()
    /// ```
    @discardableResult
    func dd_scrollEdgeAppearance() -> Self {
        if #available(iOS 13.0, *) {
            let appearance = standardAppearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        }
        return self
    }

    /// 设置选中指示器图片
    /// - Parameter image: 选中指示器图片
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd_selectionIndicatorImage(UIImage(named: "indicatorImage")!)
    /// ```
    @discardableResult
    func dd_selectionIndicatorImage(_ image: UIImage) -> Self {
        self.selectionIndicatorImage = image
        return self
    }

    /// 设置圆角
    /// - Parameters:
    ///   - corners: 需要设置圆角的角
    ///   - radius: 圆角半径
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd_corner(corners: [.topLeft, .topRight], radius: 10)
    /// ```
    @discardableResult
    func dd_corner(corners: UIRectCorner, radius: CGFloat) -> Self {
        self.dd_applyCorner(radius: radius, corners: corners)
        return self
    }
}
