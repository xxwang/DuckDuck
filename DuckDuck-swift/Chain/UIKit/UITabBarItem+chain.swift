import UIKit

extension UITabBarItem: DDExtensionable {}

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UITabBarItem {
    /// 设置标题
    /// - Parameter title: 标题
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd.title("Home")
    /// ```
    @discardableResult
    func title(_ title: String) -> Self {
        self.base.title = title
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
    /// barButtonItem.dd.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .normal)
    /// ```
    @discardableResult
    func setTitleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        self.base.setTitleTextAttributes(attributes, for: state)
        return self
    }

    /// 设置默认图片
    /// - Parameter image: 图片
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd.image(UIImage(named: "home_icon")!)
    /// ```
    @discardableResult
    func image(_ image: UIImage) -> Self {
        self.base.image = image.withRenderingMode(.alwaysOriginal)
        return self
    }

    /// 设置选中图片
    /// - Parameter image: 图片
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd.selectedImage(UIImage(named: "home_selected")!)
    /// ```
    @discardableResult
    func selectedImage(_ image: UIImage) -> Self {
        self.base.selectedImage = image.withRenderingMode(.alwaysOriginal)
        return self
    }

    /// 设置 `badgeColor` 颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd.badgeColor(.red)
    /// ```
    @discardableResult
    func badgeColor(_ color: UIColor) -> Self {
        self.base.badgeColor = color
        return self
    }

    /// 设置 `badgeValue` 值
    /// - Parameter value: 值
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd.badgeValue("5")
    /// ```
    @discardableResult
    func badgeValue(_ value: String) -> Self {
        self.base.badgeValue = value
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
    /// tabBarItem.dd.setBadgeTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 12)], for: .normal)
    /// ```
    @discardableResult
    func setBadgeTextAttributes(_ textAttributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        self.base.setBadgeTextAttributes(textAttributes, for: state)
        return self
    }

    /// 设置标题的位置调整
    /// - Parameter titleOffset: 标题相对于默认位置的偏移量
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd.titlePositionAdjustment(UIOffset(horizontal: 10, vertical: 0))
    /// ```
    @discardableResult
    func titlePositionAdjustment(_ titleOffset: UIOffset) -> Self {
        self.base.titlePositionAdjustment = titleOffset
        return self
    }

    /// 设置图片的内边距
    /// - Parameter imageInsets: 图片的内边距
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd.imageInsets(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    /// ```
    @discardableResult
    func imageInsets(_ imageInsets: UIEdgeInsets) -> Self {
        self.base.imageInsets = imageInsets
        return self
    }

    /// 设置图标的渲染模式
    /// - Parameter renderingMode: 渲染模式（默认使用 `.alwaysOriginal`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// tabBarItem.dd.imageRenderingMode(.alwaysTemplate)
    /// ```
    @discardableResult
    func imageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let image = self.base.image {
            self.base.image = image.withRenderingMode(renderingMode)
        }
        if let selectedImage = self.base.selectedImage {
            self.base.selectedImage = selectedImage.withRenderingMode(renderingMode)
        }
        return self
    }
}
