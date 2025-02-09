import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGColor {
    /// 将 `CGColor` 转换为 `UIColor`
    ///
    /// 该方法将一个 `CGColor` 对象转换为 `UIColor`，可以方便地在 UIKit 中使用。
    ///
    /// - Returns: 返回一个 `UIColor` 对象，该对象等价于当前的 `CGColor`。
    ///
    /// - Example:
    ///     ```swift
    ///     let cgColor = UIColor.red.cgColor
    ///     let uiColor = cgColor.dd_toUIColor()
    ///     print(uiColor)  // 输出 UIColor.red
    ///     ```
    func dd_toUIColor() -> UIColor {
        return UIColor(cgColor: self)
    }
}
