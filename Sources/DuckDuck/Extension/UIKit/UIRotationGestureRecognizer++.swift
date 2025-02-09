import UIKit

// MARK: - Creatable
public extension UIRotationGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIRotationGestureRecognizer>(_ aClass: T.Type = UIRotationGestureRecognizer.self) -> T {
        let gesture = UIRotationGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIRotationGestureRecognizer>(_ aClass: T.Type = UIRotationGestureRecognizer.self) -> T {
        let gesture: UIRotationGestureRecognizer = self.create()
        return gesture as! T
    }
}
