import UIKit

// MARK: - Creatable
public extension UITabBarItem {
    /// 纯净的创建方法
    static func create<T: UITabBarItem>(_ aClass: T.Type = UITabBarItem.self) -> T {
        let tabBarItem = UITabBarItem()
        return tabBarItem as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITabBarItem>(_ aClass: T.Type = UITabBarItem.self) -> T {
        let tabBarItem: UITabBarItem = self.create()
        return tabBarItem as! T
    }
}

// MARK: - 链式语法
public extension UITabBarItem {
    /// 设置标题
    /// - Parameter title: 标题
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd_title("Home")
    /// ```
    @discardableResult
    func dd_title(_ title: String) -> Self {
        self.title = title
        return self
    }

    /// 设置按钮标题的文本属性
    /// - Parameters:
    ///   - attributes: 文本属性字典，如字体、颜色等
    ///   - state: 控件状态，如 `.normal`、`.highlighted` 等
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// barButtonItem.dd_titleTextAttributes([.foregroundColor: UIColor.red], for: .normal)
    /// ```
    @discardableResult
    func dd_titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        self.setTitleTextAttributes(attributes, for: state)
        return self
    }

    /// 设置默认图片
    /// - Parameter image: 图片
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd_image(UIImage(named: "home_icon")!)
    /// ```
    @discardableResult
    func dd_image(_ image: UIImage) -> Self {
        self.image = image.withRenderingMode(.alwaysOriginal)
        return self
    }

    /// 设置选中图片
    /// - Parameter image: 图片
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd_selectedImage(UIImage(named: "home_selected")!)
    /// ```
    @discardableResult
    func dd_selectedImage(_ image: UIImage) -> Self {
        self.selectedImage = image.withRenderingMode(.alwaysOriginal)
        return self
    }

    /// 设置 `badgeColor` 颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd_badgeColor(.red)
    /// ```
    @discardableResult
    func dd_badgeColor(_ color: UIColor) -> Self {
        self.badgeColor = color
        return self
    }

    /// 设置 `badgeValue` 值
    /// - Parameter value: 值
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd_badgeValue("5")
    /// ```
    @discardableResult
    func dd_badgeValue(_ value: String) -> Self {
        self.badgeValue = value
        return self
    }

    /// 设置 Badge 文本属性
    /// - Parameters:
    ///   - textAttributes: 文本属性字典（如字体、颜色等）
    ///   - state: 控制状态（如 `.normal` 或 `.selected`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd_badgeTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 12)], for: .normal)
    /// ```
    @discardableResult
    func dd_badgeTextAttributes(_ textAttributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        self.setBadgeTextAttributes(textAttributes, for: state)
        return self
    }

    /// 设置标题的位置调整
    /// - Parameter titleOffset: 标题相对于默认位置的偏移量
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd_titlePositionAdjustment(UIOffset(horizontal: 10, vertical: 0))
    /// ```
    @discardableResult
    func dd_titlePositionAdjustment(_ titleOffset: UIOffset) -> Self {
        self.titlePositionAdjustment = titleOffset
        return self
    }

    /// 设置图片的内边距
    /// - Parameter imageInsets: 图片的内边距
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd_imageInsets(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    /// ```
    @discardableResult
    func dd_imageInsets(_ imageInsets: UIEdgeInsets) -> Self {
        self.imageInsets = imageInsets
        return self
    }

    /// 设置图标的渲染模式
    /// - Parameter renderingMode: 渲染模式（默认使用 `.alwaysOriginal`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd_imageRenderingMode(.alwaysTemplate)
    /// ```
    @discardableResult
    func dd_imageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let image = self.image {
            self.image = image.withRenderingMode(renderingMode)
        }
        if let selectedImage = self.selectedImage {
            self.selectedImage = selectedImage.withRenderingMode(renderingMode)
        }
        return self
    }
}
