import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIImageView {
    /// 设置图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd.image(someImage)
    /// ```
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.base.image = image
        return self
    }

    /// 设置高亮状态的图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd.highlightedImage(highlightedImage)
    /// ```
    @discardableResult
    func highlightedImage(_ image: UIImage?) -> Self {
        self.base.highlightedImage = image
        return self
    }

    /// 设置模糊效果
    /// - Parameter style: 模糊效果样式
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd.blur(.dark)
    /// ```
    @discardableResult
    func blur(_ style: UIBlurEffect.Style = .light) -> Self {
        self.base.dd_blur(with: style)
        return self
    }
}
