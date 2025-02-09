import UIKit

// MARK: - Creatable
public extension UIPanGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIPanGestureRecognizer>(_ aClass: T.Type = UIPanGestureRecognizer.self) -> T {
        let control = UIPanGestureRecognizer()
        return control as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIPanGestureRecognizer>(_ aClass: T.Type = UIPanGestureRecognizer.self) -> T {
        let control: UIPanGestureRecognizer = self.create()
        return control as! T
    }
}
