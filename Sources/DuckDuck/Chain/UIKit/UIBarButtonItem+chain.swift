//
//  UIBarButtonItem+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

extension UIBarButtonItem: DDExtensionable {}

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIBarButtonItem {
    /// 设置按钮样式
    /// - Parameter style: 样式（如 `.plain`, `.done`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem().dd.style(.done)
    /// ```
    @discardableResult
    func style(_ style: UIBarButtonItem.Style) -> Self {
        self.base.style = style
        return self
    }

    /// 设置是否可用
    /// - Parameter isEnabled: 是否可用（`true` 或 `false`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem().dd.isEnabled(false)
    /// ```
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        self.base.isEnabled = isEnabled
        return self
    }

    /// 设置自定义视图
    /// - Parameter customView: 自定义视图对象
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let customView = UIButton()
    /// let item = UIBarButtonItem().dd.customView(customView)
    /// ```
    @discardableResult
    func customView(_ customView: UIView?) -> Self {
        self.base.customView = customView
        return self
    }

    /// 设置图片
    /// - Parameter image: 图片
    /// - Returns: `Self`，支持链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let item = UIBarButtonItem().dd.image(UIImage(named: "icon"))
    /// ```
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.base.image = image
        return self
    }

    /// 设置标题
    /// - Parameter title: 标题
    /// - Returns: `Self`，支持链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let item = UIBarButtonItem().dd.title("Done")
    /// ```
    @discardableResult
    func title(_ title: String?) -> Self {
        self.base.title = title
        return self
    }

    /// 设置宽度
    /// - Parameter width: 宽度
    /// - Returns: `Self`，支持链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let item = UIBarButtonItem().dd.width(20)
    /// ```
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        self.base.width = width
        return self
    }

    /// 添加事件响应者和方法
    /// - Parameters:
    ///   - target: 事件响应者
    ///   - action: 事件响应方法
    /// - Returns: `Self`，支持链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let item = UIBarButtonItem().dd.addTarget(self, action: #selector(buttonTapped))
    /// ```
    @discardableResult
    func addTarget(_ target: AnyObject, action: Selector) -> Self {
        self.base.target = target
        self.base.action = action
        return self
    }

    /// 设置按钮的响应目标
    /// - Parameter target: 目标对象
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem().dd.target(self)
    /// ```
    @discardableResult
    func target(_ target: AnyObject?) -> Self {
        self.base.target = target
        return self
    }

    /// 设置按钮的响应动作
    /// - Parameter action: 响应方法
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem().dd.action(#selector(handleAction))
    /// ```
    @discardableResult
    func action(_ action: Selector?) -> Self {
        self.base.action = action
        return self
    }

    /// 添加事件回调处理
    /// - Parameter closure: 事件触发时的回调
    /// - Returns: `Self`，支持链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let item = UIBarButtonItem().dd.onEvent { item in
    ///     print("Item tapped: \(String(describing: item?.title))")
    /// }
    /// ```
    @discardableResult
    func onEvent(_ closure: ((UIBarButtonItem?) -> Void)?) -> Self {
        self.base.onEvent = closure
        self.base.dd.addTarget(self.base, action: #selector(self.base.eventHandler(_:)))
        return self
    }

    /// 设置按钮的背景图像
    /// - Parameters:
    ///   - backgroundImage: 背景图像
    ///   - state: 控件状态（如 `.normal`, `.highlighted`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem()
    ///     .dd.backgroundImage(UIImage(named: "background"), for: .normal)
    /// ```
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State) -> Self {
        self.base.setBackgroundImage(backgroundImage, for: state, barMetrics: .default)
        return self
    }

    /// 设置按钮的可能标题集合
    /// - Parameter possibleTitles: 标题集合
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem().dd.possibleTitles(["Save", "Edit", "Delete"])
    /// ```
    @discardableResult
    func possibleTitles(_ possibleTitles: Set<String>?) -> Self {
        self.base.possibleTitles = possibleTitles
        return self
    }

    /// 设置按钮图像的渲染模式
    /// - Parameter renderingMode: 渲染模式（如 `.alwaysOriginal`, `.alwaysTemplate`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem()
    ///     .dd.imageRenderingMode(.alwaysTemplate)
    /// ```
    @discardableResult
    func imageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let image = self.base.image {
            self.base.image = image.withRenderingMode(renderingMode)
        }
        return self
    }

    /// 设置按钮背景图像的渲染模式
    /// - Parameter renderingMode: 渲染模式（如 `.alwaysOriginal`, `.alwaysTemplate`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem()
    ///     .dd.backgroundImageRenderingMode(.alwaysOriginal)
    /// ```
    @discardableResult
    func backgroundImageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let backgroundImage = self.base.backgroundImage(for: .normal, barMetrics: .default) {
            let renderedImage = backgroundImage.withRenderingMode(renderingMode)
            self.base.setBackgroundImage(renderedImage, for: .normal, barMetrics: .default)
        }
        return self
    }
}
