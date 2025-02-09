import UIKit

// MARK: - 类型转换
public extension NSTextAttachment {
    /// 使用附件创建一个属性字符串
    /// - Returns: 返回一个包含附件的 `NSAttributedString`
    /// - Example:
    /// ```swift
    /// let attachment = NSTextAttachment()
    /// let attributedString = attachment.dd_toNSAttributedString()
    /// ```
    func dd_toNSAttributedString() -> NSAttributedString {
        return NSAttributedString(attachment: self)
    }
}

// MARK: - 链式语法
public extension NSTextAttachment {
    /// 设置附件图片
    /// - Parameter image: 附件图片
    /// - Returns: 当前附件对象 (`Self`)，以支持链式调用
    /// - Example:
    /// ```swift
    /// let attachment = NSTextAttachment()
    /// attachment.dd_image(UIImage(named: "exampleImage"))
    /// ```
    @discardableResult
    func dd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置附件边界
    /// - Parameter bounds: 附件的边界 (CGRect)
    /// - Returns: 当前附件对象 (`Self`)，以支持链式调用
    /// - Example:
    /// ```swift
    /// let attachment = NSTextAttachment()
    /// attachment.dd_bounds(CGRect(x: 0, y: 0, width: 50, height: 50))
    /// ```
    @discardableResult
    func dd_bounds(_ bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
}
