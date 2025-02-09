import UIKit

extension NSTextAttachment: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base: NSTextAttachment {
    /// 设置附件图片
    /// - Parameter image: 附件图片
    /// - Returns: 当前附件对象 (`Self`)，以支持链式调用
    /// - Example:
    /// ```swift
    /// let attachment = NSTextAttachment()
    /// attachment.dd.image(UIImage(named: "exampleImage"))
    /// ```
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.base.image = image
        return self
    }

    /// 设置附件边界
    /// - Parameter bounds: 附件的边界 (CGRect)
    /// - Returns: 当前附件对象 (`Self`)，以支持链式调用
    /// - Example:
    /// ```swift
    /// let attachment = NSTextAttachment()
    /// attachment.dd.bounds(CGRect(x: 0, y: 0, width: 50, height: 50))
    /// ```
    @discardableResult
    func bounds(_ bounds: CGRect) -> Self {
        self.base.bounds = bounds
        return self
    }
}
