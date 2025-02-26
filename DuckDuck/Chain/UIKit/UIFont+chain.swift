import UIKit

extension UIFont: DDExtended {}

// MARK: - 链式语法
public extension DDExtension where Base == UIFont {
    /// 设置字体大小
    /// - Parameter size: 字体大小
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let newFont = UIFont.preferredFont(forTextStyle: .body).dd.fontSize(18)
    /// ```
    @discardableResult
    func fontSize(_ fontSize: CGFloat) -> Self {
        self.base = self.base.withSize(fontSize)
        return self
    }
}
