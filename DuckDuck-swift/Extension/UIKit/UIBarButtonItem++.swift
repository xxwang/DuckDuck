import UIKit

// MARK: - Creatable
public extension UIBarButtonItem {
    /// 纯净的创建方法
    static func create<T: UIBarButtonItem>(_ aClass: T.Type = UIBarButtonItem.self) -> T {
        let barButtonItem = UIBarButtonItem()
        return barButtonItem as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIBarButtonItem>(_ aClass: T.Type = UIBarButtonItem.self) -> T {
        let barButtonItem: UIBarButtonItem = self.create()
        return barButtonItem as! T
    }
}

// MARK: - 类型
extension UIBarButtonItem {
    // MARK: - 关联键
    @MainActor
    class AssociateKeys {
        /// 用于存储事件回调的关联键
        static var eventKey = UnsafeRawPointer(bitPattern: ("UIBarButtonItem" + "eventKey").hashValue)
    }
}

// MARK: - 事件关联
extension UIBarButtonItem {
    /// 事件回调
    public var barButtonItem_onEventHandler: ((UIBarButtonItem) -> Void)? {
        get { AssociatedObject.get(self, key: &AssociateKeys.eventKey) as? (UIBarButtonItem) -> Void }
        set { AssociatedObject.set(self, key: &AssociateKeys.eventKey, value: newValue) }
    }

    /// 事件触发时的处理方法
    /// - Parameter event: 事件发生的 `UIBarButtonItem`
    @objc func eventHandler(_ event: UIBarButtonItem) {
        self.barButtonItem_onEventHandler?(event)
    }
}

// MARK: - 构造方法
public extension UIBarButtonItem {
    /// 创建固定宽度的弹簧
    /// - Parameter width: 宽度
    ///
    /// **示例**：
    /// ```swift
    /// let spacer = UIBarButtonItem(flexible: 10)
    /// ```
    convenience init(flexible width: CGFloat) {
        self.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.width = width
    }

    /// 创建自定义`UIBarButtonItem`
    /// - Parameters:
    ///   - image: 默认图片
    ///   - highlightedImage: 高亮图片
    ///   - title: 标题
    ///   - font: 字体
    ///   - titleColor: 标题颜色
    ///   - highlightedTitleColor: 高亮标题颜色
    ///   - target: 事件响应方
    ///   - action: 事件处理方法
    ///
    /// **示例**：
    /// ```swift
    /// let barButton = UIBarButtonItem(
    ///     image: UIImage(named: "icon"),
    ///     highlightedImage: UIImage(named: "icon_highlighted"),
    ///     title: "Click Me",
    ///     font: .systemFont(ofSize: 16),
    ///     titleColor: .black,
    ///     highlightedTitleColor: .gray,
    ///     target: self,
    ///     action: #selector(buttonAction)
    /// )
    /// ```
    convenience init(image: UIImage? = nil,
                     highlightedImage: UIImage? = nil,
                     title: String? = nil,
                     font: UIFont? = nil,
                     titleColor: UIColor? = nil,
                     highlightedTitleColor: UIColor? = nil,
                     target: Any? = nil,
                     action: Selector?)
    {
        let button = UIButton(type: .custom)

        // 设置默认图片
        if let image { button.setImage(image, for: .normal) }
        // 设置高亮图片
        if let highlightedImage { button.setImage(highlightedImage, for: .highlighted) }
        // 设置标题文字
        if let title { button.setTitle(title, for: .normal) }
        // 设置标题字体
        if let font { button.titleLabel?.font = font }
        // 设置标题颜色
        if let titleColor { button.setTitleColor(titleColor, for: .normal) }
        // 设置高亮标题颜色
        if let highlightedTitleColor { button.setTitleColor(highlightedTitleColor, for: .highlighted) }
        // 设置响应方法
        if let target, let action { button.addTarget(target, action: action, for: .touchUpInside) }
        // 设置图标与标题之间的间距
        button.dd_spacing(3)

        self.init(customView: button)
    }
}

// MARK: - 链式方法
public extension UIBarButtonItem {
    /// 设置按钮样式
    /// - Parameter style: 样式（如 `.plain`, `.done`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem().dd_style(.done)
    /// ```
    @discardableResult
    func dd_style(_ style: UIBarButtonItem.Style) -> Self {
        self.style = style
        return self
    }

    /// 设置是否可用
    /// - Parameter isEnabled: 是否可用（`true` 或 `false`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem().dd_isEnabled(false)
    /// ```
    @discardableResult
    func dd_isEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }

    /// 设置自定义视图
    /// - Parameter customView: 自定义视图对象
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let customView = UIButton()
    /// let item = UIBarButtonItem().dd_customView(customView)
    /// ```
    @discardableResult
    func dd_customView(_ customView: UIView?) -> Self {
        self.customView = customView
        return self
    }

    /// 设置图片
    /// - Parameter image: 图片
    /// - Returns: `Self`，支持链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let item = UIBarButtonItem().dd_image(UIImage(named: "icon"))
    /// ```
    @discardableResult
    func dd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置标题
    /// - Parameter title: 标题
    /// - Returns: `Self`，支持链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let item = UIBarButtonItem().dd_title("Done")
    /// ```
    @discardableResult
    func dd_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置宽度
    /// - Parameter width: 宽度
    /// - Returns: `Self`，支持链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let item = UIBarButtonItem().dd_width(20)
    /// ```
    @discardableResult
    func dd_width(_ width: CGFloat) -> Self {
        self.width = width
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
    /// let item = UIBarButtonItem().dd_addTarget(self, action: #selector(buttonTapped))
    /// ```
    @discardableResult
    func dd_addTarget(_ target: AnyObject, action: Selector) -> Self {
        self.target = target
        self.action = action
        return self
    }

    /// 设置按钮的响应目标
    /// - Parameter target: 目标对象
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem().dd_target(self)
    /// ```
    @discardableResult
    func dd_target(_ target: AnyObject?) -> Self {
        self.target = target
        return self
    }

    /// 设置按钮的响应动作
    /// - Parameter action: 响应方法
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem().dd_action(#selector(handleAction))
    /// ```
    @discardableResult
    func dd_action(_ action: Selector?) -> Self {
        self.action = action
        return self
    }

    /// 添加事件回调处理
    /// - Parameter closure: 事件触发时的回调
    /// - Returns: `Self`，支持链式调用
    ///
    /// **示例**：
    /// ```swift
    /// let item = UIBarButtonItem().dd_onEvent { item in
    ///     print("Item tapped: \(String(describing: item?.title))")
    /// }
    /// ```
    @discardableResult
    func dd_onEvent(_ handler: ((UIBarButtonItem?) -> Void)?) -> Self {
        self.barButtonItem_onEventHandler = handler
        self.dd_addTarget(self, action: #selector(eventHandler(_:)))
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
    ///     .dd_backgroundImage(UIImage(named: "background"), for: .normal)
    /// ```
    @discardableResult
    func dd_backgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State) -> Self {
        self.setBackgroundImage(backgroundImage, for: state, barMetrics: .default)
        return self
    }

    /// 设置按钮的可能标题集合
    /// - Parameter possibleTitles: 标题集合
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem().dd_possibleTitles(["Save", "Edit", "Delete"])
    /// ```
    @discardableResult
    func dd_possibleTitles(_ possibleTitles: Set<String>?) -> Self {
        self.possibleTitles = possibleTitles
        return self
    }

    /// 设置按钮图像的渲染模式
    /// - Parameter renderingMode: 渲染模式（如 `.alwaysOriginal`, `.alwaysTemplate`）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let item = UIBarButtonItem()
    ///     .dd_imageRenderingMode(.alwaysTemplate)
    /// ```
    @discardableResult
    func dd_imageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let image = self.image {
            self.image = image.withRenderingMode(renderingMode)
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
    ///     .dd_backgroundImageRenderingMode(.alwaysOriginal)
    /// ```
    @discardableResult
    func dd_backgroundImageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let backgroundImage = self.backgroundImage(for: .normal, barMetrics: .default) {
            let renderedImage = backgroundImage.withRenderingMode(renderingMode)
            self.setBackgroundImage(renderedImage, for: .normal, barMetrics: .default)
        }
        return self
    }
}
