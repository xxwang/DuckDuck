import UIKit

// MARK: - 方法
public extension UIStoryboard {
    /// 获取应用程序的主`UIStoryboard`
    /// - Returns: `UIStoryboard` 对象，表示应用的主故事板
    ///
    /// 示例：
    /// ```swift
    /// if let mainStoryboard = UIStoryboard.dd_main() {
    ///     // 使用 mainStoryboard 进行视图控制器的操作
    /// }
    /// ```
    static func dd_main() -> UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else { return nil }
        return UIStoryboard(name: name, bundle: bundle)
    }

    /// 使用`UIStoryboard`实例化指定类型控制器(`UIViewController`类或其子类)
    /// - Parameter name: `UIViewController` 类型，指定要实例化的视图控制器的类型
    /// - Returns: 与指定类名对应的视图控制器，如果没有找到对应的控制器则返回`nil`
    ///
    /// 示例：
    /// ```swift
    /// if let viewController = storyboard.dd_instantiateViewController(withClass: MyViewController.self) {
    ///     // 使用 viewController 执行相关操作
    /// }
    /// ```
    func dd_instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return self.instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
}
