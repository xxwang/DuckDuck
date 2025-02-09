import UIKit

// MARK: - Creatable
public extension UITapGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UITapGestureRecognizer>(_ aClass: T.Type = UITapGestureRecognizer.self) -> T {
        let gesture = UITapGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITapGestureRecognizer>(_ aClass: T.Type = UITapGestureRecognizer.self) -> T {
        let gesture: UITapGestureRecognizer = self.create()
        return gesture as! T
    }
}
