import UIKit

// MARK: - Creatable
public extension UICollectionReusableView {
    /// 纯净的创建方法
    static func create<T: UICollectionReusableView>(_ aClass: T.Type = UICollectionReusableView.self) -> T {
        let reusableView = UICollectionReusableView()
        return reusableView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UICollectionReusableView>(_ aClass: T.Type = UICollectionReusableView.self) -> T {
        let reusableView: UICollectionReusableView = self.create()
        return reusableView as! T
    }
}

// MARK: - 计算属性
public extension UICollectionReusableView {
    /// 获取当前类的唯一标识符（通常用于注册和复用时）
    /// - Returns: 返回类名作为标识符
    ///
    /// 示例：
    /// ```swift
    /// let identifier = UICollectionReusableView.dd_identifier()
    /// ```
    static func dd_identifier() -> String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Self.self)
        // 获取类名部分作为标识符
        return classNameString.components(separatedBy: ".").last!
    }
}
