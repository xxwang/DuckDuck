import UIKit

extension UIViewController: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base: UIViewController {
    /// 设置控制器的用户界面样式（亮色/黑暗模式）
    /// - Parameter userInterfaceStyle: 用户界面样式（如 `.light`, `.dark`, `.unspecified`）
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// controller.dd.overrideUserInterfaceStyle(.dark)
    /// ```
    @discardableResult
    func overrideUserInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) -> Self {
        if #available(iOS 13.0, *) {
            self.base.overrideUserInterfaceStyle = userInterfaceStyle
        }
        return self
    }

    /// 设置是否允许滚动视图自动调整内边距（iOS 11 以下版本）
    /// - Parameter automaticallyAdjustsScrollViewInsets: 是否允许自动调整
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// controller.dd.automaticallyAdjustsScrollViewInsets(true)
    /// ```
    @discardableResult
    func automaticallyAdjustsScrollViewInsets(_ automaticallyAdjustsScrollViewInsets: Bool) -> Self {
        if #available(iOS 11, *) {} else { // 仅适用于 iOS11 以下版本
            self.base.automaticallyAdjustsScrollViewInsets = automaticallyAdjustsScrollViewInsets
        }
        return self
    }

    /// 设置模态视图的呈现样式
    /// - Parameter style: 模态呈现样式（如 `.fullScreen`, `.pageSheet`）
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// controller.dd.modalPresentationStyle(.fullScreen)
    /// ```
    @discardableResult
    func modalPresentationStyle(_ style: UIModalPresentationStyle) -> Self {
        self.base.modalPresentationStyle = style
        return self
    }

    /// 设置控制器根视图的背景颜色
    /// - Parameter backgroundColor: 要设置的背景颜色
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// controller.dd.backgroundColor(.white)
    /// ```
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.base.view.backgroundColor = backgroundColor
        return self
    }
}
