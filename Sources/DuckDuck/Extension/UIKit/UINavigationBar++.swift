//
//  UINavigationBar++.swift
//  DuckDuck
//
//  Created by xxwang on 24/11/2024.
//

import UIKit

// MARK: - Creatable
public extension UINavigationBar {
    /// 纯净的创建方法
    static func create<T: UINavigationBar>(_ aClass: T.Type = UINavigationBar.self) -> T {
        let navigationBar = UINavigationBar()
        return navigationBar as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UINavigationBar>(_ aClass: T.Type = UINavigationBar.self) -> T {
        let navigationBar: UINavigationBar = self.create()
        return navigationBar as! T
    }
}

// MARK: - 关联键
@MainActor
private class AssociateKeys {
    static var statusBarKey = UnsafeRawPointer(bitPattern: "UINavigationBar_statusBarKey".hashValue)
}

// MARK: - 关联属性
private extension UINavigationBar {
    /// 自定义的 `statusBar` 背景视图
    var dd_statusBar: UIView? {
        get { AssociatedObject.get(self, key: &AssociateKeys.statusBarKey) as? UIView }
        set { AssociatedObject.set(self, key: &AssociateKeys.statusBarKey, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

// MARK: - 方法
public extension UINavigationBar {
    /// 设置导航条为透明
    /// - Parameter tintColor: `tintColor` 导航条上的按钮和文字颜色
    /// - Example:
    /// ```swift
    /// navigationBar.dd_transparent(with: .white)
    /// ```
    func dd_transparent(with tintColor: UIColor = .white) {
        self.dd_isTranslucent(true)
            .dd_backgroundColor(.clear)
            .dd_backgroundImage(UIImage())
            .dd_barTintColor(.clear)
            .dd_tintColor(tintColor)
            .dd_shadowImage(UIImage())
            .dd_titleTextAttributes([.foregroundColor: tintColor])
    }

    /// 设置导航条背景和文字颜色
    /// - Parameters:
    ///   - background: 背景颜色
    ///   - text: 文字颜色
    /// - Example:
    /// ```swift
    /// navigationBar.dd_colors(background: .blue, text: .white)
    /// ```
    func dd_colors(background: UIColor, text: UIColor) {
        self.isTranslucent = false
        self.backgroundColor = background
        self.barTintColor = background
        self.setBackgroundImage(UIImage(), for: .default)
        self.tintColor = text
        self.titleTextAttributes = [.foregroundColor: text]
    }

    /// 修改 `statusBar` 的背景颜色
    /// - Parameter color: 要设置的背景颜色
    /// - Example:
    /// ```swift
    /// navigationBar.dd_setStatusBarBackgroundColor(with: .red)
    /// ```
    func dd_statusBarBackgroundColor(with color: UIColor) {
        guard self.dd_statusBar == nil else {
            self.dd_statusBar?.backgroundColor = color
            return
        }

        let statusBar = UIView(frame: CGRect(
            x: 0,
            y: -ScreenInfo.statusBarHeight,
            width: ScreenInfo.screenWidth,
            height: ScreenInfo.statusBarHeight
        ))
        statusBar.backgroundColor = color
        statusBar.isUserInteractionEnabled = false
        self.addSubview(statusBar)
        self.dd_statusBar = statusBar
    }

    /// 移除自定义的 `statusBar` 背景
    /// - Example:
    /// ```swift
    /// navigationBar.dd_removeStatusBar()
    /// ```
    func dd_removeStatusBar() {
        self.dd_statusBar?.removeFromSuperview()
        self.dd_statusBar = nil
    }
}

// MARK: - 链式语法
public extension UINavigationBar {
    /// 设置导航栏是否半透明
    /// - Parameter isTranslucent: 是否半透明
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_isTranslucent(true)
    /// ```
    @discardableResult
    func dd_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    /// 设置是否启用大标题
    /// - Parameter large: 是否启用大标题
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_prefersLargeTitles(true)
    /// ```
    @discardableResult
    func dd_prefersLargeTitles(_ large: Bool) -> Self {
        self.prefersLargeTitles = large
        return self
    }

    /// 设置标题字体
    /// - Parameter font: 标题字体
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_titleFont(UIFont.systemFont(ofSize: 18))
    /// ```
    @discardableResult
    func dd_titleFont(_ font: UIFont) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributes = appearance.titleTextAttributes
            attributes[.font] = font
            appearance.titleTextAttributes = attributes
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributes = titleTextAttributes ?? [:]
            attributes[.font] = font
            self.titleTextAttributes = attributes
        }
        return self
    }

    /// 设置大标题字体
    /// - Parameter font: 大标题字体
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_largeTitleFont(UIFont.boldSystemFont(ofSize: 30))
    /// ```
    @discardableResult
    func dd_largeTitleFont(_ font: UIFont) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributes = appearance.largeTitleTextAttributes
            attributes[.font] = font
            appearance.largeTitleTextAttributes = attributes
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributes = largeTitleTextAttributes ?? [:]
            attributes[.font] = font
            self.largeTitleTextAttributes = attributes
        }
        return self
    }

    /// 设置标题颜色
    /// - Parameter color: 标题颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_titleColor(.black)
    /// ```
    @discardableResult
    func dd_titleColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributes = appearance.titleTextAttributes
            attributes[.foregroundColor] = color
            appearance.titleTextAttributes = attributes
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributes = titleTextAttributes ?? [:]
            attributes[.foregroundColor] = color
            self.titleTextAttributes = attributes
        }
        return self
    }

    /// 设置大标题颜色
    /// - Parameter color: 大标题颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_largeTitleColor(.red)
    /// ```
    @discardableResult
    func dd_largeTitleColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributes = appearance.largeTitleTextAttributes
            attributes[.foregroundColor] = color
            appearance.largeTitleTextAttributes = attributes
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributes = largeTitleTextAttributes ?? [:]
            attributes[.foregroundColor] = color
            self.largeTitleTextAttributes = attributes
        }
        return self
    }

    /// 设置导航栏的 `barTintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_barTintColor(.red)
    /// ```
    @discardableResult
    func dd_barTintColor(_ color: UIColor) -> Self {
        self.barTintColor = color
        return self
    }

    /// 设置导航栏的 `tintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_tintColor(.blue)
    /// ```
    @discardableResult
    override func dd_tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }

    /// 设置导航栏的背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_backgroundColor(.white)
    /// ```
    @discardableResult
    override func dd_backgroundColor(_ color: UIColor) -> Self {
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

    /// 设置导航栏的背景图片
    /// - Parameter image: 背景图片
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_backgroundImage(UIImage(named: "background")!)
    /// ```
    @discardableResult
    func dd_backgroundImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.backgroundImage = image
            appearance.backgroundEffect = nil
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            self.setBackgroundImage(image, for: .default)
        }
        return self
    }

    /// 设置导航栏的阴影图片
    /// - Parameter image: 阴影图片
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_shadowImage(UIImage(named: "shadow")!)
    /// ```
    @discardableResult
    func dd_shadowImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.shadowImage = image.withRenderingMode(.alwaysOriginal)
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            self.shadowImage = image.withRenderingMode(.alwaysOriginal)
        }
        return self
    }

    /// 设置导航栏滚动时的外观与标准外观一致
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_scrollEdgeAppearance()
    /// ```
    @discardableResult
    func dd_scrollEdgeAppearance() -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        }
        return self
    }

    /// 设置导航栏标题的文本属性
    /// - Parameter attributes: 富文本属性
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd_titleTextAttributes([.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.black])
    /// ```
    @discardableResult
    func dd_titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.titleTextAttributes = attributes
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            self.titleTextAttributes = attributes
        }
        return self
    }
}
