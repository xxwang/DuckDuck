//
//  UITabBar+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UITabBar {
    /// 设置是否半透明
    /// - Parameter isTranslucent: 是否半透明
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd.isTranslucent(true)
    /// ```
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        self.base.isTranslucent = isTranslucent
        return self
    }

    /// 设置标题字体
    /// - Parameters:
    ///   - font: 要设置的字体
    ///   - state: 要设置的状态（如 normal 或 selected）
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd.titleFont(UIFont.boldSystemFont(ofSize: 14), state: .normal)
    /// ```
    @discardableResult
    func titleFont(_ font: UIFont, state: UIControl.State) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            if state == .normal {
                var attributeds = appearance.stackedLayoutAppearance.normal.titleTextAttributes
                attributeds[.font] = font
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributeds
            } else if state == .selected {
                var attributeds = appearance.stackedLayoutAppearance.selected.titleTextAttributes
                attributeds[.font] = font
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributeds
            }
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.base.scrollEdgeAppearance = appearance }
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
    /// tabBar.dd.titleColor(.red, state: .normal)
    /// ```
    @discardableResult
    func titleColor(_ color: UIColor, state: UIControl.State) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            if state == .normal {
                var attributeds = appearance.stackedLayoutAppearance.normal.titleTextAttributes
                attributeds[.foregroundColor] = color
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributeds
            } else if state == .selected {
                var attributeds = appearance.stackedLayoutAppearance.selected.titleTextAttributes
                attributeds[.foregroundColor] = color
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributeds
            }
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.base.scrollEdgeAppearance = appearance }

            // 设置未选中状态的颜色
            if state == .normal { self.base.unselectedItemTintColor = color }
            // 设置选中状态的颜色
            if state == .selected { self.base.tintColor = color }
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
    /// tabBar.dd.backgroundColor(with: .blue)
    /// ```
    @discardableResult
    func backgroundColor(with color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            appearance.backgroundColor = color
            appearance.backgroundEffect = nil
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.base.scrollEdgeAppearance = appearance
            }
        } else {
            self.base.backgroundColor = color
            self.base.barTintColor = color
        }
        return self
    }

    /// 设置背景图片
    /// - Parameter image: 要设置的背景图片
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd.backgroundImage(UIImage(named: "backgroundImage")!)
    /// ```
    @discardableResult
    func backgroundImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            appearance.backgroundImage = image
            appearance.backgroundEffect = nil
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.base.scrollEdgeAppearance = appearance }
        } else {
            self.base.backgroundImage = image
        }
        return self
    }

    /// 设置标题文字的偏移
    /// - Parameter offset: 偏移量
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd.titlePositionAdjustment(UIOffset(horizontal: 0, vertical: 10))
    /// ```
    @discardableResult
    func titlePositionAdjustment(_ offset: UIOffset) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
            appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.base.scrollEdgeAppearance = appearance
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
    /// tabBar.dd.shadowImage(UIImage(named: "shadowImage")!)
    /// ```
    @discardableResult
    func shadowImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            appearance.shadowImage = image.withRenderingMode(.alwaysOriginal)
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.base.scrollEdgeAppearance = appearance }
        } else {
            self.base.shadowImage = image.withRenderingMode(.alwaysOriginal)
        }
        return self
    }

    /// 设置滚动时外观与标准外观一致
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd.scrollEdgeAppearance()
    /// ```
    @discardableResult
    func scrollEdgeAppearance() -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            if #available(iOS 15.0, *) { self.base.scrollEdgeAppearance = appearance }
        }
        return self
    }

    /// 设置选中指示器图片
    /// - Parameter image: 选中指示器图片
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd.selectionIndicatorImage(UIImage(named: "indicatorImage")!)
    /// ```
    @discardableResult
    func selectionIndicatorImage(_ image: UIImage) -> Self {
        self.base.selectionIndicatorImage = image
        return self
    }

    /// 设置圆角
    /// - Parameters:
    ///   - corners: 需要设置圆角的角
    ///   - radius: 圆角半径
    /// - Returns: `Self` 返回当前对象，实现链式调用
    /// - Example:
    /// ```swift
    /// tabBar.dd.corner(corners: [.topLeft, .topRight], radius: 10)
    /// ```
    @discardableResult
    func corner(corners: UIRectCorner, radius: CGFloat) -> Self {
        self.base.dd_applyCorner(radius: radius, corners: corners)
        return self
    }
}
