import UIKit

// MARK: - Creatable
public extension UIScreenEdgePanGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIScreenEdgePanGestureRecognizer>(_ aClass: T.Type = UIScreenEdgePanGestureRecognizer.self) -> T {
        let gesture = UIScreenEdgePanGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIScreenEdgePanGestureRecognizer>(_ aClass: T.Type = UIScreenEdgePanGestureRecognizer.self) -> T {
        let gesture: UIScreenEdgePanGestureRecognizer = self.create()
        return gesture as! T
    }
}
