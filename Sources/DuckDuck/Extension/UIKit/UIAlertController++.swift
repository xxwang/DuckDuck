import AudioToolbox
import UIKit

// MARK: - Creatable
public extension UIAlertController {
    /// 纯净的创建方法
    static func create<T: UIAlertController>(_ aClass: T.Type = UIAlertController.self) -> T {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        return alertController as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIAlertController>(_ aClass: T.Type = UIAlertController.self) -> T {
        let alertController: UIAlertController = self.create()
        return alertController as! T
    }
}

// MARK: - 构造方法
public extension UIAlertController {
    /// 创建 `UIAlertController`
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 详细的信息
    ///   - titles: 按钮标题数组
    ///   - style: 弹出样式
    ///   - tintColor: `UIAlertController`的`tintColor`
    ///   - highlightedIndex: 高亮按钮索引
    ///   - completion: 按钮点击回调
    ///
    /// - Example:
    /// ```swift
    /// let alert = UIAlertController(title: "提示", message: "请选择操作", titles: ["确定", "取消"], highlightedIndex: 0) { index in
    ///     print("点击了第 \(index + 1) 个按钮")
    /// }
    /// ```
    convenience init(_ title: String? = nil,
                     message: String? = nil,
                     titles: [String] = [],
                     style: UIAlertController.Style = .alert,
                     tintColor: UIColor? = nil,
                     highlightedIndex: Int? = nil,
                     completion: ((Int) -> Void)? = nil)
    {
        self.init(title: title, message: message, preferredStyle: style)

        // 设置tintColor
        if let color = tintColor { view.tintColor = color }

        // 添加选项按钮
        for (index, title) in titles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: { _ in
                completion?(index)
            })
            addAction(action)

            // 高亮按钮
            if let highlightedIndex, index == highlightedIndex { preferredAction = action }
        }
    }
}

// MARK: - 显示弹窗
public extension UIAlertController {
    /// 用于在任意控制器上显示`UIAlertController`(alert样式)
    /// - Parameters:
    ///   - title: 提示标题
    ///   - message: 提示内容
    ///   - titles: 按钮标题数组
    ///   - tintColor: `UIAlertController`的`tintColor`
    ///   - highlightedIndex: 高亮按钮索引
    ///   - completion: 完成回调
    /// - Returns: `UIAlertController`实例
    ///
    /// - Example:
    /// ```swift
    /// let alert = UIAlertController.dd_showAlertController(title: "警告", message: "请确认", titles: ["确定", "取消"])
    /// ```
    @discardableResult
    static func dd_showAlertController(_ title: String? = nil,
                                       message: String? = nil,
                                       titles: [String] = [],
                                       tintColor: UIColor? = nil,
                                       highlightedIndex: Int? = nil,
                                       completion: ((Int) -> Void)? = nil) -> UIAlertController
    {
        // 初始化UIAlertController
        let alertController = UIAlertController(title, message: message, style: .alert, highlightedIndex: highlightedIndex, completion: completion)

        // 弹出UIAlertController
        UIWindow.dd_rootViewController()?.present(alertController, animated: true, completion: nil)

        return alertController
    }

    /// 用于在任意控制器上显示`UIAlertController`(sheet样式)
    /// - Parameters:
    ///   - title: 提示标题
    ///   - message: 提示内容
    ///   - titles: 按钮标题数组
    ///   - tintColor: `UIAlertController`的`tintColor`
    ///   - highlightedIndex: 高亮按钮索引
    ///   - completion: 完成回调
    /// - Returns: `UIAlertController`实例
    ///
    /// - Example:
    /// ```swift
    /// let sheet = UIAlertController.dd_showSheetController(title: "操作", message: "选择一个操作", titles: ["复制", "粘贴"])
    /// ```
    @discardableResult
    static func dd_showSheetController(_ title: String? = nil,
                                       message: String? = nil,
                                       titles: [String] = [],
                                       tintColor: UIColor? = nil,
                                       highlightedIndex: Int? = nil,
                                       completion: ((Int) -> Void)? = nil) -> UIAlertController
    {
        // 初始化UIAlertController
        let alertController = UIAlertController(title, message: message, style: .actionSheet, highlightedIndex: highlightedIndex, completion: completion)

        // 弹出UIAlertController
        UIWindow.dd_rootViewController()?.present(alertController, animated: true, completion: nil)

        return alertController
    }

    /// 用于弹起`UIAlertController`实例
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - shake: 是否震动
    ///   - deadline: 消失时间
    ///   - completion: 完成回调
    func dd_show(animated: Bool = true, shake: Bool = false, deadline: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        // 弹起UIAlertController实例
        UIWindow.dd_rootViewController()?.present(self, animated: animated, completion: completion)

        // 是否震动
        if shake { AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) }

        // 是否需要自动消失
        guard let deadline else { return }

        // 根据deadline来让UIAlertController实例消失
        DispatchQueue.dd_delayExecute(delay: deadline) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.dismiss(animated: animated, completion: nil)
            }
        }
    }
}

// MARK: - 链式语法
public extension UIAlertController {
    /// 设置标题
    /// - Parameter title: 标题
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let alert = UIAlertController().dd_title("警告")
    /// ```
    @discardableResult
    func dd_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置消息(副标题)
    /// - Parameter message: 消息内容
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let alert = UIAlertController().dd_message("请确认您的操作")
    /// ```
    @discardableResult
    func dd_message(_ message: String?) -> Self {
        self.message = message
        return self
    }

    /// 添加 `UIAlertAction`
    /// - Parameter action: `UIAlertAction` 事件
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let action = UIAlertAction(title: "确定", style: .default, handler: nil)
    /// let alert = UIAlertController().dd_addAction(action)
    /// ```
    @discardableResult
    func dd_addAction(_ action: UIAlertAction) -> Self {
        self.addAction(action)
        return self
    }

    /// 添加一个 `UIAlertAction`
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - action: 点击处理回调
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let alert = UIAlertController().dd_addAction_(title: "确定", style: .default) { _ in
    ///     print("点击确定")
    /// }
    /// ```
    @discardableResult
    func dd_addAction_(title: String, style: UIAlertAction.Style = .default, action: ((UIAlertAction) -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: action)
        self.addAction(action)
        return self
    }

    /// 添加一个 `UITextField`
    /// - Parameters:
    ///   - text: 输入框默认文字
    ///   - placeholder: 占位文本
    ///   - target: 事件响应者
    ///   - action: 事件响应方法
    /// - Returns: `Self`
    ///
    /// - Example:
    /// ```swift
    /// let alert = UIAlertController().dd_addTextField(text: "默认文字", placeholder: "请输入", target: self, action: #selector(textFieldChanged))
    /// ```
    @discardableResult
    func dd_addTextField(_ text: String? = nil, placeholder: String? = nil, target: Any?, action: Selector?) -> Self {
        self.addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
            if let target,
               let action
            {
                textField.addTarget(target, action: action, for: .editingChanged)
            }
        }
        return self
    }
}
