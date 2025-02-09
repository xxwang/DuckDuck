import UIKit

// MARK: - Creatable
public extension UISwipeGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UISwipeGestureRecognizer>(_ aClass: T.Type = UISwipeGestureRecognizer.self) -> T {
        let gesture = UISwipeGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UISwipeGestureRecognizer>(_ aClass: T.Type = UISwipeGestureRecognizer.self) -> T {
        let gesture: UISwipeGestureRecognizer = self.create()
        return gesture as! T
    }
}
