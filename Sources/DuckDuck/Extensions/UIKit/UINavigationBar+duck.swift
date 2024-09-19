//
//  UINavigationBar+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 方法
public extension UINavigationBar {
    /// 设置导航条为透明
    /// - Parameter tintColor:`tintColor`
    func dd_setTransparent(with tintColor: UIColor = .white) {
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
    ///   - background:背景颜色
    ///   - text:文字颜色
    func dd_setColors(background: UIColor, text: UIColor) {
        self.isTranslucent = false
        self.backgroundColor = background
        self.barTintColor = background
        self.setBackgroundImage(UIImage(), for: .default)
        self.tintColor = text
        self.titleTextAttributes = [.foregroundColor: text]
    }

    /// 修改`statusBar`的背景颜色
    /// - Parameter color:要设置的颜色
    func dd_setStatusBarBackgroundColor(with color: UIColor) {
        guard self.dd_statusBar == nil else {
            self.dd_statusBar?.backgroundColor = color
            return
        }

        let statusBar = UIView(frame: CGRect(
            x: 0,
            y: -kStatusBarHeight,
            width: kScreenWidth,
            height: kStatusBarHeight
        )).dd_add2(self)
        statusBar.backgroundColor = .clear
        self.dd_statusBar = statusBar
    }

    /// 移除`statusBar`
    func dd_removeStatusBar() {
        self.dd_statusBar?.removeFromSuperview()
        self.dd_statusBar = nil
    }
}

// MARK: - 关联键
private class DDAssociateKeys {
    static var StatusBarKey = UnsafeRawPointer(bitPattern: ("UINavigationBar" + "StatusBarKey").hashValue)
}

// MARK: - 关联属性
private extension UINavigationBar {
    /// 通过 Runtime 的属性关联添加自定义 View
    var dd_statusBar: UIView? {
        get { AssociatedObject.get(self, &DDAssociateKeys.StatusBarKey) as? UIView }
        set { AssociatedObject.set(self, &DDAssociateKeys.StatusBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

// MARK: - 链式语法
public extension UINavigationBar {
    /// 是否半透明
    /// - Parameter isTranslucent:是否半透明
    /// - Returns:`Self`
    @discardableResult
    func dd_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    /// 设置是否大导航
    /// - Parameter large:是否大导航
    /// - Returns:`Self`
    func dd_prefersLargeTitles(_ large: Bool) -> Self {
        self.prefersLargeTitles = large
        return self
    }

    /// 设置标题字体
    /// - Parameters:
    ///   - font:字体
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_titleFont(_ font: UIFont) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.titleTextAttributes
            attributeds[.font] = font
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = titleTextAttributes ?? [:]
            attributeds[.font] = font
            self.titleTextAttributes = attributeds
        }
        return self
    }

    /// 设置大标题字体
    /// - Parameters:
    ///   - font:字体
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_largeTitleFont(_ font: UIFont) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.largeTitleTextAttributes
            attributeds[.font] = font
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = largeTitleTextAttributes ?? [:]
            attributeds[.font] = font
            self.titleTextAttributes = attributeds
        }
        return self
    }

    /// 设置标题颜色
    /// - Parameters:
    ///   - color:颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_titleColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.titleTextAttributes
            attributeds[.foregroundColor] = color
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = titleTextAttributes ?? [:]
            attributeds[.foregroundColor] = color
            self.titleTextAttributes = attributeds
        }
        return self
    }

    /// 设置大标题颜色
    /// - Parameters:
    ///   - color:颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_largeTitleColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.largeTitleTextAttributes
            attributeds[.foregroundColor] = color
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = self.largeTitleTextAttributes ?? [:]
            attributeds[.foregroundColor] = color
            self.titleTextAttributes = attributeds
        }
        return self
    }

    /// 设置`barTintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_barTintColor(_ color: UIColor) -> Self {
        self.barTintColor = color
        return self
    }

    /// 设置`tintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    override func dd_tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }

    /// 设置背景颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
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
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            self.setBackgroundImage(image, for: .default)
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
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
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
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        }
        return self
    }

    /// 设置标题的的属性
    /// - Parameter attributes: 富文本属性
    /// - Returns: `Self`
    @discardableResult
    func dd_titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        self.titleTextAttributes = attributes
        return self
    }
}
