import UIKit

// MARK: - 类型
public extension UIButton {
    // MARK: - 关联键
    class AssociateKeys {
        static var callbackKey = UnsafeRawPointer(bitPattern: ("UIButton" + "callbackKey").hashValue)
        static var expandSizeKey = UnsafeRawPointer(bitPattern: ("UIButton" + "expandSizeKey").hashValue)
    }

    /// 按钮的所有状态
    var buttonAllStates: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }

    // 枚举定义按钮图片和标题的布局方式
    enum ImagePosition {
        case top // 图片位于标题上方
        case bottom // 图片位于标题下方
        case left // 图片位于标题左侧
        case right // 图片位于标题右侧
    }
}

// MARK: - 事件关联
extension UIButton {
    /// 事件回调
    public var button_onEventHandler: ((UIButton) -> Void)? {
        get { return AssociatedObject.get(self, key: &AssociateKeys.callbackKey) as? (UIButton) -> Void }
        set { AssociatedObject.set(self, key: &AssociateKeys.callbackKey, value: newValue) }
    }

    /// 按钮点击回调
    @objc func dd_tappedAction(_ button: UIButton) {
        self.button_onEventHandler?(button)
    }
}

// MARK: - 按钮布局管理
public extension UIButton {
    /// 调整按钮图片和标题的相对位置
    /// ⚠️ 注意：确保按钮的 `frame` 大小已确定
    /// - Parameters:
    ///   - position: 图片在标题周围的位置
    ///   - spacing: 图片和标题之间的间距
    /// - Example:
    /// ```swift
    /// button.layoutImage(position: .top, spacing: 10)
    /// ```
    func layoutImage(position: ImagePosition, spacing: CGFloat) {
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.plain() // 获取按钮配置
            var imagePadding: CGFloat = 0
            var titlePadding: CGFloat = 0

            // 根据位置设置配置
            switch position {
            case .left:
                configuration.imagePlacement = .leading
                imagePadding = spacing / 2
                titlePadding = spacing / 2
            case .right:
                configuration.imagePlacement = .trailing
                imagePadding = spacing / 2
                titlePadding = spacing / 2
            case .top:
                configuration.imagePlacement = .top
                imagePadding = spacing
                titlePadding = spacing
            case .bottom:
                configuration.imagePlacement = .bottom
                imagePadding = spacing
                titlePadding = spacing
            }

            // 设置按钮配置的图像和标题间距
            configuration.imagePadding = imagePadding
            configuration.titlePadding = titlePadding

            // 应用配置
            self.configuration = configuration
        } else {
            guard let imageRect = imageView?.frame, let titleRect = titleLabel?.frame else { return }
            let buttonWidth = frame.size.width
            let buttonHeight = frame.size.height
            let totalHeight = titleRect.height + spacing + imageRect.height

            switch position {
            case .left:
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
            case .right:
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.width + spacing / 2), bottom: 0, right: imageRect.width + spacing / 2)
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleRect.width + spacing / 2, bottom: 0, right: -(titleRect.width + spacing / 2))
            case .top:
                self.titleEdgeInsets = UIEdgeInsets(
                    top: (buttonHeight - totalHeight) / 2 + imageRect.height + spacing - titleRect.origin.y,
                    left: (buttonWidth / 2 - titleRect.origin.x - titleRect.width / 2) - (buttonWidth - titleRect.width) / 2,
                    bottom: -((buttonHeight - totalHeight) / 2 + imageRect.height + spacing - titleRect.origin.y),
                    right: -(buttonWidth / 2 - titleRect.origin.x - titleRect.width / 2) - (buttonWidth - titleRect.width) / 2
                )
                self.imageEdgeInsets = UIEdgeInsets(
                    top: (buttonHeight - totalHeight) / 2 - imageRect.origin.y,
                    left: buttonWidth / 2 - imageRect.origin.x - imageRect.width / 2,
                    bottom: -((buttonHeight - totalHeight) / 2 - imageRect.origin.y),
                    right: -(buttonWidth / 2 - imageRect.origin.x - imageRect.width / 2)
                )
            case .bottom:
                self.titleEdgeInsets = UIEdgeInsets(
                    top: (buttonHeight - totalHeight) / 2 - titleRect.origin.y,
                    left: (buttonWidth / 2 - titleRect.origin.x - titleRect.width / 2) - (buttonWidth - titleRect.width) / 2,
                    bottom: -((buttonHeight - totalHeight) / 2 - titleRect.origin.y),
                    right: -(buttonWidth / 2 - titleRect.origin.x - titleRect.width / 2) - (buttonWidth - titleRect.width) / 2
                )
                self.imageEdgeInsets = UIEdgeInsets(
                    top: (buttonHeight - totalHeight) / 2 + titleRect.height + spacing - imageRect.origin.y,
                    left: buttonWidth / 2 - imageRect.origin.x - imageRect.width / 2,
                    bottom: -((buttonHeight - totalHeight) / 2 + titleRect.height + spacing - imageRect.origin.y),
                    right: -(buttonWidth / 2 - imageRect.origin.x - imageRect.width / 2)
                )
            }
        }
    }

    /// 将按钮的图像和标题居中对齐
    /// - Parameters:
    ///   - imageAboveText: 如果为 `true`，则图像位于标题上方，默认为 `false`，图像位于标题的左侧
    ///   - spacing: 图像和标题之间的间距
    /// - Example:
    /// ```swift
    /// button.centerImageAndTitle(imageAboveText: true, spacing: 8)
    /// ```
    func layoutImageToCenter(imageAboveText: Bool = false, spacing: CGFloat) {
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.plain() // 获取按钮配置
            if imageAboveText {
                // 设置图像在标题上方
                configuration.imagePlacement = .top
                configuration.imagePadding = spacing
                configuration.titlePadding = spacing
            } else {
                // 图像在标题左侧
                configuration.imagePlacement = .leading
                configuration.imagePadding = spacing / 2
                configuration.titlePadding = spacing / 2
            }

            // 应用配置
            self.configuration = configuration
        } else {
            if imageAboveText {
                guard let imageSize = imageView?.image?.size else { return }
                guard let titleText = titleLabel?.text else { return }
                guard let font = titleLabel?.font else { return }

                let titleSize = titleText.size(withAttributes: [.font: font])

                // Adjust title insets
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)

                // Adjust image insets
                self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)

                // Adjust content insets to make sure the button is properly centered
                let edgeOffset = abs(titleSize.height - imageSize.height) / 2
                self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0, bottom: edgeOffset, right: 0)
            } else {
                let insetAmount = spacing / 2
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
                self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
            }
        }
    }

    /// 调整左图右字的图像和标题之间的间距
    /// - Parameter spacing: 标题文本和图像之间的间距
    /// - Example:
    /// ```swift
    /// button.dd_spacing(_ spacing: 10)
    /// ```
    func dd_spacing(_ spacing: CGFloat) {
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.plain() // 获取按钮配置
            configuration.imagePlacement = .leading
            configuration.imagePadding = spacing / 2
            configuration.titlePadding = spacing / 2

            // 应用配置
            self.configuration = configuration
        } else {
            let halfSpacing = spacing / 2
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -halfSpacing, bottom: 0, right: halfSpacing)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: halfSpacing, bottom: 0, right: -halfSpacing)
        }
    }
}

// MARK: - 扩大按钮点击区域
public extension UIButton {
    /// 扩大UIButton的点击区域，默认向四周扩展10像素的点击范围
    /// - Parameter size: 向四周扩展的点击区域大小，默认值为10像素。传入更大的值可以使按钮的点击区域变大，方便用户点击。
    /// - Example:
    /// ```swift
    /// button.dd_expandClickArea(by: 15)  // 扩展15像素的点击区域
    /// ```
    func dd_expandClickArea(by size: CGFloat = 10) {
        AssociatedObject.set(self, key: &AssociateKeys.expandSizeKey, value: size, policy: .OBJC_ASSOCIATION_COPY)
    }

    /// 获取扩展的点击区域，如果没有设置扩展范围，则使用按钮的原始大小
    private func dd_expandedRect() -> CGRect {
        if let expandSize = AssociatedObject.get(self, key: &AssociateKeys.expandSizeKey) as? CGFloat {
            return CGRect(
                x: bounds.origin.x - expandSize,
                y: bounds.origin.y - expandSize,
                width: bounds.size.width + 2 * expandSize,
                height: bounds.size.height + 2 * expandSize
            )
        }
        return bounds
    }

    /// 重写点触及范围检测
    /// - Parameter point: 当前触摸点的坐标
    /// - Parameter event: 当前的触摸事件
    /// - Returns: 如果触摸点在扩展的区域内，则返回 `true`，否则返回 `false`
    /// - Example:
    /// ```swift
    /// button.point(inside: touchPoint, with: event)  // 判断触摸点是否在按钮的点击范围内
    /// ```
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let expandedRect = self.dd_expandedRect()
        // 如果没有扩展范围，则使用原始范围
        if expandedRect.equalTo(bounds) {
            return super.point(inside: point, with: event)
        } else {
            return expandedRect.contains(point)
        }
    }
}

// MARK: - 计算按钮尺寸
public extension UIButton {
    /// 获取指定宽度下字符串的尺寸
    /// - Parameter lineWidth: 最大行宽度，默认是屏幕宽度。如果传入较小的宽度，文字将换行。
    /// - Returns: 文字的尺寸，包含计算后的宽度和高度
    /// - Example:
    /// ```swift
    /// let size = button.dd_calculateSize(for: 200)
    /// ```
    func dd_calculateSize(for lineWidth: CGFloat = AppDimensions.screenWidth) -> CGSize {
        if let currentAttributedTitle = self.currentAttributedTitle {
            return currentAttributedTitle.dd_calculateAttributedSize(forWidth: lineWidth)
        }
        return self.titleLabel?.dd_calculateSize(for: lineWidth) ?? .zero
    }
}

// MARK: - 链式语法
public extension UIButton {
    /// 设置按钮标题
    /// - Parameters:
    ///   - text: 要设置的标题文字
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.setTitle("Click Me", for: .normal)
    /// ```
    @discardableResult
    func dd_title(_ text: String, for state: UIControl.State = .normal) -> Self {
        self.setTitle(text, for: state)
        return self
    }

    /// 设置按钮的属性文本标题
    /// - Parameters:
    ///   - title: 要设置的属性文本
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_attributedTitle(attributedText, for: .normal)
    /// ```
    @discardableResult
    func dd_attributedTitle(_ title: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        self.setAttributedTitle(title, for: state)
        return self
    }

    /// 设置按钮标题颜色
    /// - Parameters:
    ///   - color: 要设置的标题颜色
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_titleColor(.red, for: .normal)
    /// ```
    @discardableResult
    func dd_titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }

    /// 设置按钮标题字体
    /// - Parameter font: 要设置的字体
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.setFont(.systemFont(ofSize: 16))
    /// ```
    @discardableResult
    func dd_font(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }

    /// 设置按钮图片
    /// - Parameters:
    ///   - image: 要设置的图片
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_image(UIImage(named: "buttonImage"), for: .normal)
    /// ```
    @discardableResult
    func dd_image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setImage(image, for: state)
        return self
    }

    /// 设置按钮图片(通过Bundle加载)
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - bundle: 可选的 `Bundle`，默认为 nil
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_image("buttonImage", in: .main, for: .normal)
    /// ```
    @discardableResult
    func dd_image(_ imageName: String, in bundle: Bundle? = nil, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        self.setImage(image, for: state)
        return self
    }

    /// 设置按钮图片(通过Bundle加载)
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - bundleName: Bundle 的名称
    ///   - aClass: `Bundle` 所在类的类名
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_image("buttonImage", in: "MyBundle", from: MyClass.self, for: .normal)
    /// ```
    @discardableResult
    func dd_image(_ imageName: String, in bundleName: String, from aClass: AnyClass, for state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        self.setImage(image, for: state)
        return self
    }

    /// 设置纯颜色图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片尺寸，默认为 (1.0, 1.0)
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_image(.red, size: CGSize(width: 50, height: 50), for: .normal)
    /// ```
    @discardableResult
    func dd_image(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0), for state: UIControl.State = .normal) -> Self {
        let image = UIImage(with: color, size: size)
        self.setImage(image, for: state)
        return self
    }

    /// 设置按钮背景图片
    /// - Parameters:
    ///   - image: 背景图片
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_backgroundImage(UIImage(named: "backgroundImage"), for: .normal)
    /// ```
    @discardableResult
    func dd_backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - bundleName: Bundle 的名称
    ///   - aClass: `Bundle` 所在类的类名
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_backgroundImage("backgroundImage", in: "MyBundle", from: MyClass.self, for: .normal)
    /// ```
    @discardableResult
    func dd_backgroundImage(_ imageName: String, in bundleName: String, from aClass: AnyClass, for state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        self.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置按钮的背景图片（通过 `Bundle` 加载）
    /// - Parameters:
    ///   - imageName: 图片文件名
    ///   - bundle: 图片所在的 `Bundle`，默认为 `nil`，如果为 `nil`，则从主 bundle 加载
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_backgroundImage("backgroundImage", in: .main, for: .normal)
    /// ```
    @discardableResult
    func dd_backgroundImage(_ imageName: String, in bundle: Bundle? = nil, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        self.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置纯颜色背景图片
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_backgroundColor(.blue, for: .normal)
    /// ```
    @discardableResult
    func dd_backgroundColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(with: color)
        self.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置按钮点击回调
    /// - Parameter callback: 按钮点击回调闭包
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_onTapped { button in
    ///     // 处理按钮点击事件
    /// }
    /// ```
    @discardableResult
    func dd_onEvent(_ handler: ((_ button: UIButton?) -> Void)?) -> Self {
        self.button_onEventHandler = handler
        self.addTarget(self, action: #selector(dd_tappedAction), for: .touchUpInside)
        return self
    }

    /// 扩大按钮的点击区域
    /// - Parameter size: 向四周扩展的像素大小
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_expandClickArea(10)
    /// ```
    @discardableResult
    func dd_expandClickArea(_ size: CGFloat = 10) -> Self {
        self.dd_expandClickArea(by: size)
        return self
    }

    /// 设置按钮所有状态的图片
    /// - Parameter image: 要设置的图片
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_image2AllStates(UIImage(named: "buttonImage")!)
    /// ```
    @discardableResult
    func dd_image2AllStates(_ image: UIImage) -> Self {
        buttonAllStates.forEach { self.setImage(image, for: $0) }
        return self
    }

    /// 设置按钮所有状态的标题颜色
    /// - Parameter color: 要设置的颜色
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_titleColor2AllStates(.red)
    /// ```
    @discardableResult
    func dd_titleColor2AllStates(_ color: UIColor) -> Self {
        buttonAllStates.forEach { self.setTitleColor(color, for: $0) }
        return self
    }

    /// 设置按钮所有状态的标题
    /// - Parameter title: 要设置的标题文本
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd_title2AllStates("Click Me")
    /// ```
    @discardableResult
    func dd_title2AllStates(_ title: String) -> Self {
        buttonAllStates.forEach { self.setTitle(title, for: $0) }
        return self
    }
}
