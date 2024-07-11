//
//  UIImageView+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 方法
public extension DDExtension where Base: UIImageView {
    /// 添加模糊效果
    /// - Parameter style:模糊效果的样式
    func blur(with style: UIBlurEffect.Style = .light) {
        // 模糊效果
        let blurEffect = UIBlurEffect(style: style)
        // 效果View
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // 设置效果view的尺寸
        blurEffectView.frame = bounds
        // 支持设备旋转
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 添加效果到图片
        self.base.addSubview(blurEffectView)
    }

    /// 修改图像的颜色
    /// - Parameter color:要修改成的颜色
    func image(with color: UIColor) {
        // .automatic 根据图片的使用环境和所处的绘图上下文自动调整渲染模式.
        // .alwaysOriginal 始终绘制图片原始状态,不使用Tint Color.
        // .alwaysTemplate 始终根据Tint Color绘制图片,忽略图片的颜色信息.
        self.base.image = self.base.image?.withRenderingMode(.alwaysTemplate)
        self.base.tintColor = color
    }
}

// MARK: - 加载图片
public extension DDExtension where Base: UIImageView {
    /// 从`URL`下载网络图片并设置到`UIImageView`
    /// - Parameters:
    ///   - url:图片URL地址
    ///   - contentMode:图片视图内容模式
    ///   - placeholder:占位图片
    ///   - completionHandler:完成回调
    func loadImage(form url: URL,
                   contentMode: UIView.ContentMode = .scaleAspectFill,
                   placeholder: UIImage? = nil,
                   completionHandler: ((UIImage?) -> Void)? = nil)
    {
        self.base.image = placeholder
        self.base.contentMode = contentMode

        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data,
                let image = UIImage(data: data)
            else {
                completionHandler?(nil)
                return
            }

            DispatchQueue.dd.async_on_main {
                self.base.image = image
                completionHandler?(image)
            }
        }.resume()
    }

    /// 加载本地`Gif`图片的名称
    /// - Parameter name:图片名称
    func loadGifWith(imageNamed: String) {
        DispatchQueue.dd.async_on_global {
            let image = UIImage.dd.loadImageWithGif(name: imageNamed)
            DispatchQueue.dd.async_on_main {
                self.base.image = image
            }
        }
    }

    /// 加载`Asset`中的`Gif`图片
    /// - Parameter asset:`asset`中的图片名称
    func loadGifWith(asset: String) {
        DispatchQueue.dd.async_on_global {
            let image = UIImage.dd.loadImageWithGif(asset: asset)
            DispatchQueue.dd.async_on_main {
                self.base.image = image
            }
        }
    }

    /// 加载网络`URL`的`Gif`图片
    /// - Parameter url:`Gif`图片URL地址
    func loadGifWith(url: String) {
        DispatchQueue.dd.async_on_global {
            let image = UIImage.dd.loadImageWithGif(url: url)
            DispatchQueue.dd.async_on_main {
                self.base.image = image
            }
        }
    }
}

// MARK: - Defaultable
public extension UIImageView {
    typealias Associatedtype = UIImageView
    override open class func `default`() -> Associatedtype {
        return UIImageView()
    }
}

// MARK: - 链式语法
public extension UIImageView {
    /// 设置图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func dd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置高亮状态的图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func dd_highlightedImage(_ image: UIImage?) -> Self {
        self.highlightedImage = image
        return self
    }

    /// 设置模糊效果
    /// - Parameter style:模糊效果样式
    /// - Returns:`Self`
    @discardableResult
    func dd_blur(_ style: UIBlurEffect.Style = .light) -> Self {
        self.dd.blur(with: style)
        return self
    }
}
