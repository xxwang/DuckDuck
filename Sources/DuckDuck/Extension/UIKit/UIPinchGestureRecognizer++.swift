import UIKit

// MARK: - Creatable
public extension UIPinchGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIPinchGestureRecognizer>(_ aClass: T.Type = UIPinchGestureRecognizer.self) -> T {
        let control = UIPinchGestureRecognizer()
        return control as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIPinchGestureRecognizer>(_ aClass: T.Type = UIPinchGestureRecognizer.self) -> T {
        let control: UIPinchGestureRecognizer = self.create()
        return control as! T
    }
}
