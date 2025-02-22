import UIKit

public protocol Loadable {}

public extension Loadable where Self: UIView {
    /// 从`xib`文件加载`UIView`实例
    /// - Parameters:
    ///   - nibName: `xib`文件名称，默认使用类名
    ///   - bundle: `xib`文件所在的`bundle`，默认是`main` bundle
    /// - Returns: 加载的`UIView`实例
    ///
    /// - Example:
    /// ```swift
    /// // 从 MyCustomView.xib 加载视图
    /// if let customView = MyCustomView.dd_loadNib() {
    ///     // 使用 customView
    /// }
    /// ```
    static func dd_loadNib(nibName: String? = nil, bundle: Bundle? = nil) -> Self? {
        let named = nibName ?? "\(self)"
        let bundle = bundle ?? .main

        // 尝试加载`xib`文件，若失败返回`nil`
        guard let view = UINib(nibName: named, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? Self else {
            Logger.fail("Warning: Failed to load nib file with name \(named) or it is not of type \(Self.self)")
            return nil
        }
        return view
    }
}

public extension Loadable where Self: UIViewController {
    /// 从`storyboard`文件加载控制器实例
    /// - Parameters:
    ///   - identifier: 控制器的标识符，默认使用控制器的类名
    ///   - fileName: `storyboard`文件的名称，默认使用`Main.storyboard`
    ///   - bundle: `storyboard`文件所在的`Bundle`，默认是`main` bundle
    /// - Returns: 加载的`UIViewController`实例
    ///
    /// - Example:
    /// ```swift
    /// // 从 Main.storyboard 加载控制器
    /// if let viewController = MyViewController.dd_loadStoryboard() {
    ///     // 使用 viewController
    /// }
    /// ```
    static func dd_loadStoryboard(identifier: String? = nil, fileName: String? = nil, bundle: Bundle = .main) -> Self? {
        // 获取`storyboard`文件名称，默认值为`Main.storyboard`
        guard let fileName = fileName ?? (bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String) else {
            Logger.fail("Warning: Storyboard file does not exist in the bundle.")
            return nil
        }

        // 使用类名作为标识符
        let identifier = identifier ?? String(describing: self)

        // 尝试加载`storyboard`控制器，若失败返回`nil`
        guard let controller = UIStoryboard(name: fileName, bundle: bundle).instantiateViewController(withIdentifier: identifier) as? Self else {
            Logger.fail("Warning: Failed to instantiate view controller with identifier \(identifier) in storyboard \(fileName).")
            return nil
        }
        return controller
    }
}
