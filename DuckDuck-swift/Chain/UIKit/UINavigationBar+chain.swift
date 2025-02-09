import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UINavigationBar {
    /// 设置导航栏是否半透明
    /// - Parameter isTranslucent: 是否半透明
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.isTranslucent(true)
    /// ```
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        self.base.isTranslucent = isTranslucent
        return self
    }

    /// 设置是否启用大标题
    /// - Parameter large: 是否启用大标题
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.prefersLargeTitles(true)
    /// ```
    @discardableResult
    func prefersLargeTitles(_ large: Bool) -> Self {
        self.base.prefersLargeTitles = large
        return self
    }

    /// 设置标题字体
    /// - Parameter font: 标题字体
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.titleFont(UIFont.systemFont(ofSize: 18))
    /// ```
    @discardableResult
    func titleFont(_ font: UIFont) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            var attributes = appearance.titleTextAttributes
            attributes[.font] = font
            appearance.titleTextAttributes = attributes
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.base.scrollEdgeAppearance = appearance
            }
        } else {
            var attributes = self.base.titleTextAttributes ?? [:]
            attributes[.font] = font
            self.base.titleTextAttributes = attributes
        }
        return self
    }

    /// 设置大标题字体
    /// - Parameter font: 大标题字体
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.largeTitleFont(UIFont.boldSystemFont(ofSize: 30))
    /// ```
    @discardableResult
    func largeTitleFont(_ font: UIFont) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            var attributes = appearance.largeTitleTextAttributes
            attributes[.font] = font
            appearance.largeTitleTextAttributes = attributes
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.base.scrollEdgeAppearance = appearance
            }
        } else {
            var attributes = self.base.largeTitleTextAttributes ?? [:]
            attributes[.font] = font
            self.base.largeTitleTextAttributes = attributes
        }
        return self
    }

    /// 设置标题颜色
    /// - Parameter color: 标题颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.titleColor(.black)
    /// ```
    @discardableResult
    func titleColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            var attributes = appearance.titleTextAttributes
            attributes[.foregroundColor] = color
            appearance.titleTextAttributes = attributes
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.base.scrollEdgeAppearance = appearance
            }
        } else {
            var attributes = self.base.titleTextAttributes ?? [:]
            attributes[.foregroundColor] = color
            self.base.titleTextAttributes = attributes
        }
        return self
    }

    /// 设置大标题颜色
    /// - Parameter color: 大标题颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.largeTitleColor(.red)
    /// ```
    @discardableResult
    func largeTitleColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            var attributes = appearance.largeTitleTextAttributes
            attributes[.foregroundColor] = color
            appearance.largeTitleTextAttributes = attributes
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.base.scrollEdgeAppearance = appearance
            }
        } else {
            var attributes = self.base.largeTitleTextAttributes ?? [:]
            attributes[.foregroundColor] = color
            self.base.largeTitleTextAttributes = attributes
        }
        return self
    }

    /// 设置导航栏的 `barTintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.barTintColor(.red)
    /// ```
    @discardableResult
    func barTintColor(_ color: UIColor) -> Self {
        self.base.barTintColor = color
        return self
    }

    /// 设置导航栏的 `tintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.tintColor(.blue)
    /// ```
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.base.tintColor = color
        return self
    }

    /// 设置导航栏的背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.backgroundColor(.white)
    /// ```
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
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

    /// 设置导航栏的背景图片
    /// - Parameter image: 背景图片
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.backgroundImage(UIImage(named: "background")!)
    /// ```
    @discardableResult
    func backgroundImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            appearance.backgroundImage = image
            appearance.backgroundEffect = nil
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.base.scrollEdgeAppearance = appearance
            }
        } else {
            self.base.setBackgroundImage(image, for: .default)
        }
        return self
    }

    /// 设置导航栏的阴影图片
    /// - Parameter image: 阴影图片
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.shadowImage(UIImage(named: "shadow")!)
    /// ```
    @discardableResult
    func shadowImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            appearance.shadowImage = image.withRenderingMode(.alwaysOriginal)
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.base.scrollEdgeAppearance = appearance
            }
        } else {
            self.base.shadowImage = image.withRenderingMode(.alwaysOriginal)
        }
        return self
    }

    /// 设置导航栏滚动时的外观与标准外观一致
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.scrollEdgeAppearance()
    /// ```
    @discardableResult
    func scrollEdgeAppearance() -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            if #available(iOS 15.0, *) {
                self.base.scrollEdgeAppearance = appearance
            }
        }
        return self
    }

    /// 设置导航栏标题的文本属性
    /// - Parameter attributes: 富文本属性
    /// - Returns: `Self`，支持链式调用
    /// - Example:
    /// ```swift
    /// navigationBar.dd.titleTextAttributes([.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.black])
    /// ```
    @discardableResult
    func titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.base.standardAppearance
            appearance.titleTextAttributes = attributes
            self.base.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.base.scrollEdgeAppearance = appearance
            }
        } else {
            self.base.titleTextAttributes = attributes
        }
        return self
    }
}
