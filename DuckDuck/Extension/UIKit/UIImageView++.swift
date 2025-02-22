import UIKit

// MARK: - 方法
public extension UIImageView {
    /// 添加模糊效果
    /// - Parameter style: 模糊效果的样式，默认为 `.light`
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd_blur(with: .dark)
    /// ```
    func dd_blur(with style: UIBlurEffect.Style = .light) {
        // 创建模糊效果
        let blurEffect = UIBlurEffect(style: style)
        // 创建效果视图
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // 设置效果视图的尺寸与UIImageView相同
        blurEffectView.frame = bounds
        // 支持设备旋转
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 添加效果视图到图片视图
        self.addSubview(blurEffectView)
    }

    /// 修改图像的颜色
    /// - Parameter color: 要修改成的颜色
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd_image(with: .red)
    /// ```
    func dd_image(with color: UIColor) {
        // 使用模板渲染模式，将图片颜色改为TintColor
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

// MARK: - 加载图片
public extension UIImageView {
    /// 从`URL`下载网络图片并设置到`UIImageView`
    /// - Parameters:
    ///   - url: 图片URL地址
    ///   - contentMode: 图片视图内容模式，默认为 `.scaleAspectFill`
    ///   - placeholder: 占位图片，默认为 `nil`
    ///   - completionHandler: 完成回调
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd_loadImage(form: someURL, placeholder: placeholderImage) { image in
    ///     // 图片加载完成后的处理
    /// }
    /// ```
    func dd_loadImage(form url: URL,
                      contentMode: UIView.ContentMode = .scaleAspectFill,
                      placeholder: UIImage? = nil,
                      completionHandler: @escaping @Sendable (UIImage?) -> Void)
    {
        self.image = placeholder
        self.contentMode = contentMode

        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data,
                let image = UIImage(data: data)
            else {
                completionHandler(nil)
                return
            }

            DispatchQueue.main.async {
                self.image = image
                completionHandler(image)
            }
        }.resume()
    }

    /// 加载本地 `Gif` 图片的名称
    /// - Parameter name: 图片名称
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd_loadGifWith(imageNamed: "exampleGif")
    /// ```
    func dd_loadGifWith(imageNamed: String) {
        DispatchQueue.global().async {
            let image = UIImage.dd_loadImageWithGif(name: imageNamed)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

    /// 加载 `Asset` 中的 `Gif` 图片
    /// - Parameter asset: `Asset` 中的图片名称
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd_loadGifWith(asset: "exampleGif")
    /// ```
    func dd_loadGifWith(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.dd_loadImageWithGif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

    /// 加载网络 `URL` 的 `Gif` 图片
    /// - Parameter url: `Gif` 图片的 URL 地址
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd_loadGifWith(url: "https://example.com/image.gif")
    /// ```
    func dd_loadGifWith(url: String) {
        DispatchQueue.global().async {
            let image = UIImage.dd_loadImageWithGif(url: url)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

// MARK: - 链式语法
public extension UIImageView {
    /// 设置图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd_image(someImage)
    /// ```
    @discardableResult
    func dd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置高亮状态的图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd_highlightedImage(highlightedImage)
    /// ```
    @discardableResult
    func dd_highlightedImage(_ image: UIImage?) -> Self {
        self.highlightedImage = image
        return self
    }

    /// 设置模糊效果
    /// - Parameter style: 模糊效果样式
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// imageView.dd_blur(.dark)
    /// ```
    @discardableResult
    func dd_blur(_ style: UIBlurEffect.Style = .light) -> Self {
        self.dd_blur(with: style)
        return self
    }
}
