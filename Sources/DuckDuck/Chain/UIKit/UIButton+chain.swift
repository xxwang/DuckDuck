import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIButton {
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
    func title(_ text: String, for state: UIControl.State = .normal) -> Self {
        self.base.setTitle(text, for: state)
        return self
    }

    /// 设置按钮的属性文本标题
    /// - Parameters:
    ///   - title: 要设置的属性文本
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.setAttributedTitle(attributedText, for: .normal)
    /// ```
    @discardableResult
    func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        self.base.setAttributedTitle(title, for: state)
        return self
    }

    /// 设置按钮标题颜色
    /// - Parameters:
    ///   - color: 要设置的标题颜色
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.setTitleColor(.red, for: .normal)
    /// ```
    @discardableResult
    func setTitleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        self.base.setTitleColor(color, for: state)
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
    func font(_ font: UIFont) -> Self {
        self.base.titleLabel?.font = font
        return self
    }

    /// 设置按钮图片
    /// - Parameters:
    ///   - image: 要设置的图片
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.setImage(UIImage(named: "buttonImage"), for: .normal)
    /// ```
    @discardableResult
    func setImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.base.setImage(image, for: state)
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
    /// button.setImage("buttonImage", in: .main, for: .normal)
    /// ```
    @discardableResult
    func setImage(_ imageName: String, in bundle: Bundle? = nil, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        self.base.setImage(image, for: state)
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
    /// button.setImage("buttonImage", in: "MyBundle", from: MyClass.self, for: .normal)
    /// ```
    @discardableResult
    func setImage(_ imageName: String, in bundleName: String, from aClass: AnyClass, for state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        self.base.setImage(image, for: state)
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
    /// button.setImage(.red, size: CGSize(width: 50, height: 50), for: .normal)
    /// ```
    @discardableResult
    func setImage(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0), for state: UIControl.State = .normal) -> Self {
        let image = UIImage(with: color, size: size)
        self.base.setImage(image, for: state)
        return self
    }

    /// 设置按钮背景图片
    /// - Parameters:
    ///   - image: 背景图片
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.setBackgroundImage(UIImage(named: "backgroundImage"), for: .normal)
    /// ```
    @discardableResult
    func setBackgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.base.setBackgroundImage(image, for: state)
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
    /// button.setBackgroundImage("backgroundImage", in: "MyBundle", from: MyClass.self, for: .normal)
    /// ```
    @discardableResult
    func setBackgroundImage(_ imageName: String, in bundleName: String, from aClass: AnyClass, for state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        self.base.setBackgroundImage(image, for: state)
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
    /// button.dd.setBackgroundImage("backgroundImage", in: .main, for: .normal)
    /// ```
    @discardableResult
    func setBackgroundImage(_ imageName: String, in bundle: Bundle? = nil, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        self.base.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置纯颜色背景图片
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - state: 按钮状态，默认为 `.normal`
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.setBackgroundImage(.blue, for: .normal)
    /// ```
    @discardableResult
    func setBackgroundImage(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(with: color)
        self.base.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置按钮点击回调
    /// - Parameter callback: 按钮点击回调闭包
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd.onEvent { button in
    ///     // 处理按钮点击事件
    /// }
    /// ```
    @discardableResult
    func onEvent(_ handler: ((_ button: UIButton?) -> Void)?) -> Self {
        self.base.button_onEventHandler = handler
        self.base.addTarget(self, action: #selector(self.base.dd_tappedAction), for: .touchUpInside)
        return self
    }

    /// 扩大按钮的点击区域
    /// - Parameter size: 向四周扩展的像素大小
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd.expandClickArea(10)
    /// ```
    @discardableResult
    func expandClickArea(_ size: CGFloat = 10) -> Self {
        self.base.dd_expandClickArea(by: size)
        return self
    }

    /// 设置按钮所有状态的图片
    /// - Parameter image: 要设置的图片
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd.setImageForAllStates(UIImage(named: "buttonImage")!)
    /// ```
    @discardableResult
    func setImageForAllStates(_ image: UIImage) -> Self {
        self.base.buttonAllStates.forEach { self.base.setImage(image, for: $0) }
        return self
    }

    /// 设置按钮所有状态的标题颜色
    /// - Parameter color: 要设置的颜色
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd.setTitleColorForAllStates(.red)
    /// ```
    @discardableResult
    func setTitleColorForAllStates(_ color: UIColor) -> Self {
        self.base.buttonAllStates.forEach { self.base.setTitleColor(color, for: $0) }
        return self
    }

    /// 设置按钮所有状态的标题
    /// - Parameter title: 要设置的标题文本
    /// - Returns: 当前按钮实例，以便链式调用
    /// - Example:
    /// ```swift
    /// button.dd.setTitleForAllStates("Click Me")
    /// ```
    @discardableResult
    func setTitleForAllStates(_ title: String) -> Self {
        self.base.buttonAllStates.forEach { self.base.setTitle(title, for: $0) }
        return self
    }
}
