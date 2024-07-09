//
//  UITabBar+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - Defaultable
public extension UITabBar {
    public typealias Associatedtype = UITabBar
    open override class func `default`() -> Associatedtype {
        return UITabBar()
    }
}

// MARK: - 链式语法
public extension UITabBar {
    /// 是否半透明
    /// - Parameter isTranslucent:是否半透明
    /// - Returns:`Self`
    @discardableResult
    func dd_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    /// 设置标题字体
    /// - Parameters:
    ///   - font:字体
    ///   - state:状态
    /// - Returns:`Self`
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
    ///   - color:颜色
    ///   - state:状态
    /// - Returns:`Self`
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

            // item未选中颜色
            if state == .normal { self.unselectedItemTintColor = color }
            // item选中颜色
            if state == .selected { self.tintColor = color }
        } else {
            var attributeds = UITabBarItem.appearance().titleTextAttributes(for: state) ?? [:]
            attributeds[.foregroundColor] = color
            UITabBarItem.appearance().setTitleTextAttributes(attributeds, for: state)
        }
        return self
    }

    /// 设置背景颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
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
    /// - Parameter image:图片
    /// - Returns:`Self`
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

    /// 设置标题文字偏移
    /// - Parameter offset:偏移
    /// - Returns:`Self`
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
    /// - Parameter imageName:图片
    /// - Returns:`Self`
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

    /// 设置当页面中有滚动时`UITabBar`的外观与`standardAppearance`一致
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollEdgeAppearance() -> Self {
        if #available(iOS 13.0, *) {
            let appearance = standardAppearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        }
        return self
    }

    /// 设置选中指示器图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func dd_selectionIndicatorImage(_ image: UIImage) -> Self {
        self.selectionIndicatorImage = image
        return self
    }

    /// 设置圆角
    /// - Parameters:
    ///   - corners:需要设置圆角的角
    ///   - radius:圆角大小
    /// - Returns:`Self`
    @discardableResult
    func dd_corner(corners: UIRectCorner, radius: CGFloat) -> Self {
        // TODO: - 
        self.dd_roundCorners(radius: radius, corners: corners)
        return self
    }
}

