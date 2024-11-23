//
//  UIImage+duck.swift
//  DuckDuck
//
//  Created by 王哥 on 2024/9/20.
//

import AVFoundation
import CoreImage
import Dispatch
import Photos
import UIKit

// MARK: - 关联键
private class DDAssociateKeys {
    static let SaveBlockKey = UnsafeRawPointer(bitPattern: "saveBlock".hashValue)
}

// MARK: - 方法
public extension UIImage {
    /// `UIImage`的大小(单位:bytes/字节)
    func dd_size_bytes() -> Int {
        return jpegData(compressionQuality: 1)?.count ?? 0
    }

    /// `UIImage`的大小(单位:`KB`)
    func dd_size_kb() -> Int {
        return (jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }

    /// 获取原始渲染模式下的图片
    func dd_original() -> UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }

    /// 获取模板渲染模式下的图片
    func dd_template() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - 构造方法
public extension UIImage {
    /// 根据颜色和大小创建UIImage
    /// - Parameters:
    ///   - color:图像填充颜色
    ///   - size:图像尺寸
    convenience init(with color: UIColor, size: CGSize = 1.dd_CGSize()) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer { UIGraphicsEndImageContext() }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }

    /// 从URL创建新图像
    /// - Parameters:
    ///   - imageUrl: 图片Url地址
    ///   - scale: 缩放比例
    convenience init?(imageUrl: URL, scale: CGFloat = 1.0) throws {
        let data = try Data(contentsOf: imageUrl)
        self.init(data: data, scale: scale)
    }

    /// 用不同的图片名称创建动态图片
    /// - Parameters:
    ///   - lightImageName:高亮图片名称
    ///   - darkImageName:暗调图片名称
    convenience init(lightImageName: String, darkImageName: String? = nil) {
        self.init(lightImage: lightImageName.dd_UIImage(),
                  darkImage: (darkImageName ?? lightImageName).dd_UIImage())
    }

    /// 用不同的图片创建动态图片
    /// - Parameters:
    ///   - lightImage:高亮图片
    ///   - darkImage:暗调图片
    convenience init(lightImage: UIImage?, darkImage: UIImage?) {
        if #available(iOS 13.0, *) {
            guard var lightImage else { self.init(); return }
            guard let darkImage else { self.init(); return }
            guard let config = lightImage.configuration else { self.init(); return }

            lightImage = lightImage.withConfiguration(
                config.withTraitCollection(UITraitCollection(userInterfaceStyle: .light)))
            lightImage.imageAsset?.register(
                darkImage,
                with: config.withTraitCollection(UITraitCollection(userInterfaceStyle: .dark))
            )
            let currentImage = lightImage.imageAsset?.image(with: .current) ?? lightImage
            self.init(cgImage: currentImage.cgImage!)
        } else {
            self.init(cgImage: lightImage!.cgImage!)
        }
    }
}

// MARK: - 动态图片的使用
public extension UIImage {
    /// 深色图片和浅色图片切换 (深色模式适配)
    /// - Parameters:
    ///   - lightImage:浅色模式的图片名称
    ///   - darkImage:深色模式的图片名称
    /// - Returns:最终图片
    static func dd_darkModeImage(_ lightImageName: String, darkImageName: String? = nil) -> UIImage? {
        return self.dd_darkModeImage(UIImage(named: lightImageName), darkImage: UIImage(named: darkImageName ?? lightImageName))
    }

    /// 深色图片和浅色图片切换 (深色模式适配)
    /// - Parameters:
    ///   - lightImage:浅色模式的图片
    ///   - darkImage:深色模式的图片
    /// - Returns:最终图片
    static func dd_darkModeImage(_ lightImage: UIImage?, darkImage: UIImage?) -> UIImage? {
        if #available(iOS 13.0, *) {
            guard var lightImage else { return lightImage }
            guard let darkImage else { return lightImage }
            guard let config = lightImage.configuration else { return lightImage }

            lightImage = lightImage.withConfiguration(
                config.withTraitCollection(UITraitCollection(userInterfaceStyle: .light)))
            lightImage.imageAsset?.register(
                darkImage, with:
                config.withTraitCollection(UITraitCollection(userInterfaceStyle: .dark))
            )
            return lightImage.imageAsset?.image(with: .current) ?? lightImage
        } else {
            return lightImage
        }
    }
}

// MARK: - Base64
public extension UIImage {
    /// 图像的`Base64`编码`PNG`数据字符串
    ///
    /// - Returns:以字符串形式返回图像的`Base` 64编码`PNG`数据
    func dd_pngBase64String() -> String? {
        pngData()?.base64EncodedString()
    }

    /// 图像的`Base64`编码`JPEG`数据字符串
    /// - Parameter compressionQuality:生成的JPEG图像的质量,表示为0.0到1.0之间的值.值0.0表示最大压缩(或最低质量),而值1.0表示最小压缩(或最佳质量)
    /// - Returns:以字符串形式返回图像的基本64编码JPEG数据
    func dd_jpegBase64String(compressionQuality: CGFloat) -> String? {
        jpegData(compressionQuality: compressionQuality)?.base64EncodedString()
    }
}

// MARK: - 压缩
public extension UIImage {
    // MARK: - 压缩模式
    enum DDCompressionMode {
        /// 分辨率规则
        static let resolutionRule: (min: CGFloat, max: CGFloat, low: CGFloat, default: CGFloat, high: CGFloat) =
            (10, 4096, 512, 1024, 2048)
        /// 数据大小规则
        static let dataSizeRule: (min: Int, max: Int, low: Int, default: Int, high: Int) =
            (1024 * 10, 1024 * 1024 * 20, 1024 * 512, 1024 * 1024 * 2, 1024 * 1024 * 10)

        // 低质量
        case low
        // 中等质量 默认
        case medium
        // 高质量
        case high
        // 自定义(最大分辨率, 最大输出数据大小)
        case other(CGFloat, Int)

        var maxDataSize: Int {
            switch self {
            case .low:
                return DDCompressionMode.dataSizeRule.low
            case .medium:
                return DDCompressionMode.dataSizeRule.default
            case .high:
                return DDCompressionMode.dataSizeRule.high
            case let .other(_, dataSize):
                if dataSize < DDCompressionMode.dataSizeRule.min {
                    return DDCompressionMode.dataSizeRule.default
                }
                if dataSize > DDCompressionMode.dataSizeRule.max {
                    return DDCompressionMode.dataSizeRule.max
                }
                return dataSize
            }
        }

        func resize(_ size: CGSize) -> CGSize {
            if size.width < DDCompressionMode.resolutionRule.min || size.height < DDCompressionMode.resolutionRule.min {
                return size
            }
            let maxResolution = maxSize
            let aspectRatio = max(size.width, size.height) / maxResolution
            if aspectRatio <= 1.0 {
                return size
            } else {
                let resizeWidth = size.width / aspectRatio
                let resizeHeighth = size.height / aspectRatio
                if resizeHeighth < DDCompressionMode.resolutionRule.min || resizeWidth < DDCompressionMode.resolutionRule.min {
                    return size
                } else {
                    return CGSize(width: resizeWidth, height: resizeHeighth)
                }
            }
        }

        var maxSize: CGFloat {
            switch self {
            case .low:
                return DDCompressionMode.resolutionRule.low
            case .medium:
                return DDCompressionMode.resolutionRule.default
            case .high:
                return DDCompressionMode.resolutionRule.high
            case let .other(size, _):
                if size < DDCompressionMode.resolutionRule.min {
                    return DDCompressionMode.resolutionRule.default
                }
                if size > DDCompressionMode.resolutionRule.max {
                    return DDCompressionMode.resolutionRule.max
                }
                return size
            }
        }
    }

    /// 压缩图片大小(返回`UIImage`)
    /// - Parameter quality:生成的`JPEG`图像的质量,表示为0.0到1.0之间的值.值0.0表示最大压缩(或最低质量),而值1.0表示最小压缩(或最佳质量)(默认值为0.5)
    /// - Returns:压缩后的可选`UIImage`
    func dd_compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }

    /// 压缩`UIImage`并生成`Data`(返回`UIImage`的`Data`)
    ///
    /// - Parameter quality:生成的`JPEG`图像的质量,表示为0.0到1.0之间的值.值0.0表示最大压缩(或最低质量),而值1.0表示最小压缩(或最佳质量)(默认值为0.5)
    /// - Returns:压缩后的可选Data
    func dd_compressedData(quality: CGFloat = 0.5) -> Data? {
        jpegData(compressionQuality: quality)
    }

    /// 压缩图片
    /// - Parameter mode:压缩模式
    /// - Returns:压缩后Data
    func dd_compress(mode: DDCompressionMode = .medium) -> Data? {
        dd_resizeIO(resizeSize: mode.resize(size))?.dd_compressDataSize(maxSize: mode.maxDataSize)
    }

    /// 异步图片压缩
    /// - Parameters:
    ///   - mode:压缩模式
    ///   - queue:压缩队列
    ///   - complete:完成回调(压缩后Data, 调整后分辨率)
    func dd_asyncCompress(mode: DDCompressionMode = .medium, queue: DispatchQueue = DispatchQueue.global(), complete: @escaping (Data?, CGSize) -> Void) {
        queue.async {
            let data = self.dd_resizeIO(resizeSize: mode.resize(self.size))?.dd_compressDataSize(maxSize: mode.maxDataSize)
            DispatchQueue.main.async { complete(data, mode.resize(self.size)) }
        }
    }

    /// 压缩图片质量
    /// - Parameter maxSize:最大数据大小
    /// - Returns:压缩后数据
    func dd_compressDataSize(maxSize: Int = 1024 * 1024 * 2) -> Data? {
        let maxSize = maxSize
        var quality: CGFloat = 0.8
        var data = jpegData(compressionQuality: quality)
        var dataCount = data?.count ?? 0

        while (data?.count ?? 0) > maxSize {
            if quality <= 0.6 { break }
            quality = quality - 0.05
            data = jpegData(compressionQuality: quality)
            if (data?.count ?? 0) <= dataCount { break }
            dataCount = data?.count ?? 0
        }
        return data
    }

    /// ImageIO 方式调整图片大小 性能很好
    /// - Parameter resizeSize:图片调整Size
    /// - Returns:调整后图片
    func dd_resizeIO(resizeSize: CGSize) -> UIImage? {
        if size == resizeSize { return self }
        guard let imageData = pngData() else { return nil }
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }

        let maxPixelSize = max(size.width, size.height)
        let options = [kCGImageSourceCreateThumbnailWithTransform: true,
                       kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                       kCGImageSourceThumbnailMaxPixelSize: maxPixelSize] as [CFString: Any] as CFDictionary

        let resizedImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options).flatMap {
            UIImage(cgImage: $0)
        }

        return resizedImage
    }

    /// CoreGraphics 方式调整图片大小 性能很好
    /// - Parameter resizeSize:图片调整Size
    /// - Returns:调整后图片
    func dd_resizeCG(resizeSize: CGSize) -> UIImage? {
        if size == resizeSize { return self }
        guard let cgImage else { return nil }
        guard let colorSpace = cgImage.colorSpace else { return nil }
        guard let context = CGContext(data: nil,
                                      width: Int(resizeSize.width),
                                      height: Int(resizeSize.height),
                                      bitsPerComponent: cgImage.bitsPerComponent,
                                      bytesPerRow: cgImage.bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }
        context.interpolationQuality = .high
        context.draw(cgImage, in: CGRect(origin: .zero, size: resizeSize))
        let resizedImage = context.makeImage().flatMap { UIImage(cgImage: $0) }
        return resizedImage
    }

    /// 压缩图片大小
    /// - Parameters:
    ///   - maxLength:最大长度 0-1
    /// - Returns:处理好的图片
    func dd_compressImageSize(toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1

        // 压缩尺寸
        guard var data = jpegData(compressionQuality: compression) else { return self }

        // 原图大小在要求范围内,不压缩图片
        if data.count < maxLength { return self }

        // 原图大小超过范围,先进行"压处理",这里 压缩比 采用二分法进行处理,6次二分后的最小压缩比是0.015625,已经够小了
        var max: CGFloat = 1
        var min: CGFloat = 0

        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            guard let data = jpegData(compressionQuality: compression) else { return self }

            if data.count < Int(Double(maxLength) * 0.9) {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }

        // 压缩结果符合 直接返回
        guard var resultImage = UIImage(data: data) else { return self }
        if data.count < maxLength { return resultImage }

        var lastDataLength = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count

            // 获取处理后的尺寸
            let ratio = CGFloat(maxLength) / CGFloat(data.count)
            let size = CGSize(width: resultImage.size.width * CGFloat(sqrtf(Float(ratio))),
                              height: resultImage.size.height * CGFloat(sqrtf(Float(ratio))))

            // 通过图片上下文进行处理图片
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()

            // 获取处理后图片的大小
            data = resultImage.jpegData(compressionQuality: compression)!
        }

        return resultImage
    }
}

// MARK: - 缩放
public extension UIImage {
    /// 裁剪给定区域
    /// - Parameter crop:裁剪区域
    /// - Returns:剪裁后的图片
    func dd_cropWithCropRect(_ crop: CGRect) -> UIImage? {
        let cropRect = CGRect(x: crop.origin.x * scale,
                              y: crop.origin.y * scale,
                              width: crop.size.width * scale,
                              height: crop.size.height * scale)
        if cropRect.size.width <= 0 || cropRect.size.height <= 0 { return nil }
        var image: UIImage?
        autoreleasepool {
            let imageRef: CGImage? = self.cgImage!.cropping(to: cropRect)
            if let imageRef { image = UIImage(cgImage: imageRef) }
        }
        return image
    }

    /// 把`UIImage`裁剪为指定`CGRect`大小
    ///
    /// - Parameter rect:目标`CGRect`
    /// - Returns:裁剪后的`UIImage`
    func dd_cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= size.width, rect.size.height <= size.height else { return self }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        guard let image = cgImage?.cropping(to: scaledRect) else { return self }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    /// 返回指定尺寸的图片
    /// - Parameter size:目标图片大小
    /// - Returns:缩放完成的图片
    func dd_resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }

    /// 指定大小的image
    /// - Parameter maxSize:图片最大尺寸(不会超过)
    /// - Returns:固定大小的 image
    func dd_solidTo(maxSize: CGSize) -> UIImage? {
        if size.height <= size.width {
            if size.width >= maxSize.width {
                let scaleSize = CGSize(width: maxSize.width, height: maxSize.width * size.height / size.width)
                return dd_fixOrientation().dd_scaleTo(size: scaleSize)
            } else {
                return dd_fixOrientation()
            }
        } else {
            if size.height >= maxSize.height {
                let scaleSize = CGSize(width: maxSize.height * size.width / size.height, height: maxSize.height)
                return dd_fixOrientation().dd_scaleTo(size: scaleSize)
            } else {
                return dd_fixOrientation()
            }
        }
    }

    /// 按指定尺寸等比缩放
    /// - Parameter size:要缩放的尺寸
    /// - Returns:缩放后的图片
    func dd_scaleTo(size: CGSize) -> UIImage? {
        if cgImage == nil { return nil }
        var w = CGFloat(cgImage!.width)
        var h = CGFloat(cgImage!.height)
        let verticalRadio = size.height / h
        let horizontalRadio = size.width / w
        var radio: CGFloat = 1
        if verticalRadio > 1, horizontalRadio > 1 {
            radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio
        } else {
            radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio
        }
        w = w * radio
        h = h * radio
        let xPos = (size.width - w) / 2
        let yPos = (size.height - h) / 2
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: xPos, y: yPos, width: w, height: h))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }

    /// 按宽高比系数:等比缩放
    /// - Parameter scale:要缩放的 宽高比 系数
    /// - Returns:等比缩放 后的图片
    func dd_scaleTo(scale: CGFloat) -> UIImage? {
        let w = size.width
        let h = size.height
        let scaledW = w * scale
        let scaledH = h * scale
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: scaledW, height: scaledH))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 等比例把`UIImage`缩放至指定宽度
    ///
    /// - Parameters:
    ///   - newWidth:新宽度
    ///   - opaque:是否不透明
    /// - Returns:缩放后的`UIImage`(可选)
    func dd_scaleTo(newWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 等比例把`UIImage`缩放至指定高度
    ///
    /// - Parameters:
    ///   - newHeight:新高度
    ///   - opaque:是否不透明
    /// - Returns:缩放后的`UIImage`(可选)
    func dd_scaleTo(newHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = newHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 从图片的中心点拉伸
    /// - Returns:拉伸后的图片
    func dd_strechAsBubble() -> UIImage {
        let edgeInsets = UIEdgeInsets(
            top: size.height * 0.5,
            left: size.width * 0.5,
            bottom: size.height * 0.5,
            right: size.width * 0.5
        )
        return resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
    }

    /// 按`edgeInsets`与`resizingMode`拉伸图片
    /// - Parameters:
    ///   - edgeInsets:拉伸区域
    ///   - resizingMode:拉伸模式
    /// - Returns:返回拉伸后的图片
    func dd_strechBubble(edgeInsets: UIEdgeInsets,
                         resizingMode: UIImage.ResizingMode = .stretch) -> UIImage
    {
        // 拉伸
        resizableImage(withCapInsets: edgeInsets, resizingMode: resizingMode)
    }
}

// MARK: - 旋转
public extension UIImage {
    /// 调整图像方向 避免图像有旋转
    /// - Returns:返正常的图片
    func dd_fixOrientation() -> UIImage {
        if imageOrientation == .up { return self }

        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi / 2)
        default:
            break
        }

        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }

        let ctx = CGContext(data: nil,
                            width: Int(size.width),
                            height: Int(size.height),
                            bitsPerComponent: (cgImage?.bitsPerComponent)!,
                            bytesPerRow: 0,
                            space: (cgImage?.colorSpace)!,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }

        let cgImage: CGImage = ctx.makeImage()!
        return UIImage(cgImage: cgImage)
    }

    /// 图片旋转 (角度)
    /// - Parameter degree:角度 0 -- 360
    /// - Returns:旋转后的图片
    func dd_rotatedTo(degree: CGFloat) -> UIImage? {
        let radians = Double(degree) / 180 * Double.pi
        return dd_rotatedTo(radians: CGFloat(radians))
    }

    /// 图片旋转 (弧度)
    /// - Parameter radians:弧度 0 -- 2π
    /// - Returns:旋转后的图片
    func dd_rotatedTo(radians: CGFloat) -> UIImage? {
        guard let weakCGImage = cgImage else { return nil }
        let rotateViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let transform = CGAffineTransform(rotationAngle: radians)
        rotateViewBox.transform = transform
        UIGraphicsBeginImageContext(rotateViewBox.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.translateBy(x: rotateViewBox.frame.width / 2, y: rotateViewBox.frame.height / 2)
        context.rotate(by: radians)
        context.scaleBy(x: 1, y: -1)
        let rect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
        context.draw(weakCGImage, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 创建按给定角度旋转的图片
    ///
    ///     // 将图像旋转180°
    ///     image.rotated(by:Measurement(value:180, unit:.degrees))
    ///
    /// - Parameter angle:旋转(按:测量值(值:180,单位:度))
    /// - Returns:按给定角度旋转的新图像
    @available(tvOS 10.0, watchOS 3.0, *)
    func dd_rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)

        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        draw(in: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2),
                        size: size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 创建按给定角度(弧度)旋转的图片
    ///
    ///     // 将图像旋转180°
    ///     image.rotated(by:.pi)
    ///
    /// - Parameter radians:旋转图像的角度(以弧度为单位)
    /// - Returns:按给定角度旋转的新图像
    func dd_rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        draw(in: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2),
                        size: size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 水平翻转
    /// - Returns:返回水平翻转的图片
    func dd_flipHorizontal() -> UIImage? {
        dd_rotate(orientation: .upMirrored)
    }

    /// 垂直翻转
    /// - Returns:返回垂直翻转的图片
    func dd_flipVertical() -> UIImage? {
        dd_rotate(orientation: .downMirrored)
    }

    /// 向下翻转
    /// - Returns:向下翻转后的图片
    func dd_flipDown() -> UIImage? {
        dd_rotate(orientation: .down)
    }

    /// 向左翻转
    /// - Returns:向左翻转后的图片
    func dd_flipLeft() -> UIImage? {
        dd_rotate(orientation: .left)
    }

    /// 镜像向左翻转
    /// - Returns:镜像向左翻转后的图片
    func dd_flipLeftMirrored() -> UIImage? {
        dd_rotate(orientation: .leftMirrored)
    }

    /// 向右翻转
    /// - Returns:向右翻转后的图片
    func dd_flipRight() -> UIImage? {
        dd_rotate(orientation: .right)
    }

    /// 镜像向右翻转
    /// - Returns:镜像向右翻转后的图片
    func dd_flipRightMirrored() -> UIImage? {
        dd_rotate(orientation: .rightMirrored)
    }

    /// 图片翻转(base)
    /// - Parameter orientation:翻转类型
    /// - Returns:翻转后的图片
    private func dd_rotate(orientation: UIImage.Orientation) -> UIImage? {
        guard let imageRef = cgImage else { return nil }

        let rect = CGRect(x: 0, y: 0, width: imageRef.width, height: imageRef.height)
        var bounds = rect
        var transform = CGAffineTransform.identity

        switch orientation {
        case .up:
            return self
        case .upMirrored:
            // 图片左平移width个像素
            transform = CGAffineTransform(translationX: rect.size.width, y: 0)
            // 缩放
            transform = transform.scaledBy(x: -1, y: 1)
        case .down:
            transform = CGAffineTransform(translationX: rect.size.width, y: rect.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0, y: rect.size.height)
            transform = transform.scaledBy(x: 1, y: -1)
        case .left:
            dd_swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: 0, y: rect.size.width)
            transform = transform.rotated(by: CGFloat(Double.pi * 1.5))
        case .leftMirrored:
            dd_swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: rect.size.height, y: rect.size.width)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat(Double.pi * 1.5))
        case .right:
            dd_swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: rect.size.height, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .rightMirrored:
            dd_swapWidthAndHeight(rect: &bounds)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        default:
            return nil
        }

        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        // 图片绘制时进行图片修正
        switch orientation {
        case .left:
            fallthrough
        case .leftMirrored:
            fallthrough
        case .right:
            fallthrough
        case .rightMirrored:
            context.scaleBy(x: -1.0, y: 1.0)
            context.translateBy(x: -bounds.size.width, y: 0.0)
        default:
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0.0, y: -rect.size.height)
        }
        context.concatenate(transform)
        context.draw(imageRef, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 交换宽高
    /// - Parameter rect:image 的 frame
    private func dd_swapWidthAndHeight(rect: inout CGRect) {
        let swap = rect.size.width
        rect.size.width = rect.size.height
        rect.size.height = swap
    }
}

// MARK: - 圆角
public extension UIImage {
    /// 带圆角的`UIImage`
    ///
    /// - Parameters:
    ///   - radius:角半径(可选),如果未指定,结果图像将为圆形
    /// - Returns:带圆角的`UIImage`
    func dd_corner(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius, radius > 0, radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 设置图片的圆角
    /// - Parameters:
    ///   - size:图片的大小
    ///   - radius:圆角大小 (默认:3.0,图片大小)
    ///   - corners:切圆角的方式
    /// - Returns:剪切后的图片
    func dd_corner(size: CGSize?,
                         radius: CGFloat,
                         corners: UIRectCorner = .allCorners) -> UIImage?
    {
        let weakSize = size ?? self.size
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: weakSize)
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(weakSize, false, UIScreen.main.scale)
        guard let contentRef: CGContext = UIGraphicsGetCurrentContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 绘制路线
        contentRef.addPath(UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        // 裁剪
        contentRef.clip()
        // 将原图片画到图形上下文
        draw(in: rect)
        contentRef.drawPath(using: .fillStroke)
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 关闭上下文
        UIGraphicsEndImageContext()
        return output
    }

    /// 设置图片圆角(带边框)
    /// - Parameters:
    ///   - size:最终生成的图片尺寸
    ///   - radius:圆角半径
    ///   - corners:圆角方向
    ///   - borderWidth:边框线宽
    ///   - borderColor:边框颜色
    ///   - backgroundColor:背景颜色
    /// - Returns:最终图片
    func dd_corner(size: CGSize,
                         radius: CGFloat,
                         corners: UIRectCorner = .allCorners,
                         borderWidth: CGFloat,
                         borderColor: UIColor?,
                         backgroundColor: UIColor? = nil,
                         completion: ((UIImage?) -> Void)? = nil) -> UIImage
    {
        // 图形上下文设置
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        // 获取当前图形上下文
        let context = UIGraphicsGetCurrentContext()!

        // 填充背景色
        if let backgroundColor {
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }

        // 绘制区域的大小
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        // 路径
        var path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        if rect.size.width == rect.size.height, radius == rect.size.width / 2 {
            path = UIBezierPath(ovalIn: rect)
        }
        // 添加裁剪
        path.addClip()

        // 绘制图片到上下文
        draw(in: rect)

        // 设置边框
        if let borderColor, borderWidth > 0 {
            path.lineWidth = borderWidth * 2
            borderColor.setStroke()
            path.stroke()
        }

        // 从上下文获取图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()

        // 回调
        DispatchQueue.dd_async_main {
            completion?(resultImage)
        }
        return resultImage!
    }

    /// 设置圆形图片
    /// - Returns:圆形图片
    func dd_roundImage() -> UIImage? {
        self.dd_corner(size: size,
                        radius: (size.width < size.height ? size.width : size.height) / 2.0,
                        corners: .allCorners)
    }

    /// 生成指定尺寸的纯色图像
    /// - Parameters:
    ///   - color:图片颜色
    ///   - size:图片尺寸
    /// - Returns:返回对应的图片
    static func dd_createImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        dd_createImage(with: color, size: size, corners: .allCorners, radius: 0)
    }

    /// 生成指定尺寸和圆角的纯色图像
    /// - Parameters:
    ///   - color:图片颜色
    ///   - size:图片尺寸
    ///   - corners:剪切的方式
    ///   - round:圆角大小
    /// - Returns:返回对应的图片
    static func dd_createImage(with color: UIColor,
                               size: CGSize,
                               corners: UIRectCorner,
                               radius: CGFloat) -> UIImage?
    {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if radius > 0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            color.setFill()
            path.fill()
        } else {
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

// MARK: - 颜色
public extension UIImage {
    class CountedColor {
        let color: UIColor
        let count: Int

        init(color: UIColor, count: Int) {
            self.color = color
            self.count = count
        }
    }

    /// 获取图片背景/主要/次要/细节 颜色
    /// - Parameter scaleDownSize:指定图片大小
    /// - Returns:背景/主要/次要/细节 颜色
    func dd_colors(scaleDownSize: CGSize? = nil) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
        let cgImage: CGImage

        if let scaleDownSize {
            cgImage = dd_resize(to: scaleDownSize).cgImage!
        } else {
            let ratio = size.width / size.height
            let r_width: CGFloat = 250
            cgImage = dd_resize(to: CGSize(width: r_width, height: r_width / ratio)).cgImage!
        }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8
        let randomColorsThreshold = Int(CGFloat(height) * 0.01)
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let raw = malloc(bytesPerRow * height)
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        let context = CGContext(data: raw, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let data = UnsafePointer<UInt8>(context?.data?.assumingMemoryBound(to: UInt8.self))
        let imageBackgroundColors = NSCountedSet(capacity: height)
        let imageColors = NSCountedSet(capacity: width * height)

        let sortComparator: (CountedColor, CountedColor) -> Bool = { a, b -> Bool in
            a.count <= b.count
        }

        for x in 0 ..< width {
            for y in 0 ..< height {
                let pixel = ((width * y) + x) * bytesPerPixel
                let color = UIColor(
                    /*
                     red:CGFloat(data?[pixel + 1]!) / 255,
                     green:CGFloat(data?[pixel + 2]!) / 255,
                     blue:CGFloat(data?[pixel + 3]!) / 255,
                     */
                    red: CGFloat(data?[pixel + 1] ?? 0) / 255,
                    green: CGFloat(data?[pixel + 2] ?? 0) / 255,
                    blue: CGFloat(data?[pixel + 3] ?? 0) / 255,
                    alpha: 1
                )

                if x >= 5, x <= 10 {
                    imageBackgroundColors.add(color)
                }

                imageColors.add(color)
            }
        }

        var sortedColors = [CountedColor]()

        for color in imageBackgroundColors {
            guard let color = color as? UIColor else { continue }

            let colorCount = imageBackgroundColors.count(for: color)

            if randomColorsThreshold <= colorCount {
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }

        sortedColors.sort(by: sortComparator)

        var proposedEdgeColor = CountedColor(color: blackColor, count: 1)

        if let first = sortedColors.first { proposedEdgeColor = first }

        if proposedEdgeColor.color.isBlackOrWhite, !sortedColors.isEmpty {
            for countedColor in sortedColors where CGFloat(countedColor.count / proposedEdgeColor.count) > 0.3 {
                if !countedColor.color.isBlackOrWhite {
                    proposedEdgeColor = countedColor
                    break
                }
            }
        }

        let imageBackgroundColor = proposedEdgeColor.color
        let isDarkBackgound = imageBackgroundColor.isDark

        sortedColors.removeAll()

        for imageColor in imageColors {
            guard let imageColor = imageColor as? UIColor else { continue }

            let color = imageColor.dd_color(minSaturation: 0.15)

            if color.isDark == !isDarkBackgound {
                let colorCount = imageColors.count(for: color)
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }

        sortedColors.sort(by: sortComparator)

        var primaryColor, secondaryColor, detailColor: UIColor?

        for countedColor in sortedColors {
            let color = countedColor.color

            if primaryColor == nil,
               color.dd_isContrasting(with: imageBackgroundColor)
            {
                primaryColor = color
            } else if secondaryColor == nil,
                      primaryColor != nil,
                      primaryColor!.dd_isDistinct(from: color),
                      color.dd_isContrasting(with: imageBackgroundColor)
            {
                secondaryColor = color
            } else if secondaryColor != nil,
                      secondaryColor!.dd_isDistinct(from: color),
                      primaryColor!.dd_isDistinct(from: color),
                      color.dd_isContrasting(with: imageBackgroundColor)
            {
                detailColor = color
                break
            }
        }

        free(raw)

        return (
            imageBackgroundColor,
            primaryColor ?? (isDarkBackgound ? whiteColor : blackColor),
            secondaryColor ?? (isDarkBackgound ? whiteColor : blackColor),
            detailColor ?? (isDarkBackgound ? whiteColor : blackColor)
        )
    }

    /// 获取图片主题颜色
    func dd_themeColor(_ completion: @escaping (_ color: UIColor?) -> Void) {
        DispatchQueue.global().async {
            if self.cgImage == nil { DispatchQueue.main.async { completion(nil) }}
            let bitmapInfo = CGBitmapInfo(rawValue: 0).rawValue | CGImageAlphaInfo.premultipliedLast.rawValue

            // 第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
            let thumbSize = CGSize(width: 40, height: 40)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let context = CGContext(data: nil,
                                          width: Int(thumbSize.width),
                                          height: Int(thumbSize.height),
                                          bitsPerComponent: 8,
                                          bytesPerRow: Int(thumbSize.width) * 4,
                                          space: colorSpace,
                                          bitmapInfo: bitmapInfo) else { return completion(nil) }

            let drawRect = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
            context.draw(self.cgImage!, in: drawRect)

            // 第二步 取每个点的像素值
            if context.data == nil { return completion(nil) }
            let countedSet = NSCountedSet(capacity: Int(thumbSize.width * thumbSize.height))
            for x in 0 ..< Int(thumbSize.width) {
                for y in 0 ..< Int(thumbSize.height) {
                    let offset = 4 * x * y
                    let red = context.data!.load(fromByteOffset: offset, as: UInt8.self)
                    let green = context.data!.load(fromByteOffset: offset + 1, as: UInt8.self)
                    let blue = context.data!.load(fromByteOffset: offset + 2, as: UInt8.self)
                    let alpha = context.data!.load(fromByteOffset: offset + 3, as: UInt8.self)
                    // 过滤透明的、基本白色、基本黑色
                    if alpha > 0, red < 250, green < 250, blue < 250, red > 5, green > 5, blue > 5 {
                        let array = [red, green, blue, alpha]
                        countedSet.add(array)
                    }
                }
            }

            // 第三步 找到出现次数最多的那个颜色
            let enumerator = countedSet.objectEnumerator()
            var maxColor: [Int] = []
            var maxCount = 0
            while let curColor = enumerator.nextObject() as? [Int], !curColor.isEmpty {
                let tmpCount = countedSet.count(for: curColor)
                if tmpCount < maxCount { continue }
                maxCount = tmpCount
                maxColor = curColor
            }
            let color = UIColor(red: CGFloat(maxColor[0]) / 255.0, green: CGFloat(maxColor[1]) / 255.0, blue: CGFloat(maxColor[2]) / 255.0, alpha: CGFloat(maxColor[3]) / 255.0)
            DispatchQueue.main.async { completion(color) }
        }
    }

    /// 图像的平均颜色
    func dd_averageColor() -> UIColor? {
        guard let ciImage = ciImage ?? CIImage(image: self) else { return nil }

        // CIAreaAverage返回包含给定图像区域平均颜色的单像素图像
        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }

        // 从过滤器中获取单像素图像后,提取像素的RGBA8数据
        var bitmap = [UInt8](repeating: 0, count: 4)
        let workingColorSpace: Any = cgImage?.colorSpace ?? NSNull()
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // 将像素数据转换为UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255.0,
                       green: CGFloat(bitmap[1]) / 255.0,
                       blue: CGFloat(bitmap[2]) / 255.0,
                       alpha: CGFloat(bitmap[3]) / 255.0)
    }

    /// 获取图片某一个位置像素的颜色
    /// - Parameter point:图片上某个点
    /// - Returns:返回某个点的 UIColor
    func dd_pixelColor(_ point: CGPoint) -> UIColor? {
        if point.x < 0 || point.x > size.width || point.y < 0 || point.y > size.height {
            return nil
        }

        let provider = cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)

        let numberOfComponents: CGFloat = 4.0
        let pixelData = (size.width * point.y + point.x) * numberOfComponents

        let r = CGFloat(data![Int(pixelData)]) / 255.0
        let g = CGFloat(data![Int(pixelData) + 1]) / 255.0
        let b = CGFloat(data![Int(pixelData) + 2]) / 255.0
        let a = CGFloat(data![Int(pixelData) + 3]) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    /// 异步获取指定CGPoint位置颜色
    func dd_pixelColor(at point: CGPoint, completion: @escaping (UIColor?) -> Void) {
        let size = size
        let cgImage = cgImage

        DispatchQueue.global(qos: .userInteractive).async {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let imgRef = cgImage,
                  let dataProvider = imgRef.dataProvider,
                  let dataCopy = dataProvider.data,
                  let data = CFDataGetBytePtr(dataCopy), rect.contains(point)
            else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            let pixelInfo = (Int(size.width) * Int(point.y) + Int(point.x)) * 4
            let red = CGFloat(data[pixelInfo]) / 255.0
            let green = CGFloat(data[pixelInfo + 1]) / 255.0
            let blue = CGFloat(data[pixelInfo + 2]) / 255.0
            let alpha = CGFloat(data[pixelInfo + 3]) / 255.0

            DispatchQueue.main.async {
                completion(UIColor(red: red, green: green, blue: blue, alpha: alpha))
            }
        }
    }

    /// 设置图片透明度
    /// - Parameter alpha: 透明度
    /// - Returns: `UIImage`
    func dd_imageAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -area.height)
        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        context?.draw(cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }

    /// `UIImage`填充颜色
    ///
    /// - Parameter color:填充图像的颜色
    /// - Returns:用给定颜色填充的`UIImage`
    func dd_filled(with color: UIColor) -> UIImage {
        #if !os(watchOS)
            if #available(tvOS 10.0, *) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = scale
                let renderer = UIGraphicsImageRenderer(size: size, format: format)
                return renderer.image { context in
                    color.setFill()
                    context.fill(CGRect(origin: .zero, size: size))
                }
            }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 带背景色的`UImage`
    ///
    /// - Parameters:
    ///   - backgroundColor:用作背景色的颜色
    /// - Returns:带背景色的`UImage`
    func dd_setBackgroundColor(_ backgroundColor: UIColor) -> UIImage {
        #if !os(watchOS)
            if #available(tvOS 10.0, *) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = scale
                return UIGraphicsImageRenderer(size: size, format: format).image { context in
                    backgroundColor.setFill()
                    context.fill(context.format.bounds)
                    draw(at: .zero)
                }
            }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }

        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        draw(at: .zero)

        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// 指定颜色为`UIImage`着色
    ///
    /// - Parameters:
    ///   - color:为图像着色的颜色
    ///   - blendMode:混合模式
    ///   - alpha:用于绘制的`alpha`值
    /// - Returns:使用给定颜色着色的`UIImage`
    func dd_tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> UIImage {
        let drawRect = CGRect(origin: .zero, size: size)

        #if !os(watchOS)
            if #available(tvOS 10.0, *) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = scale
                return UIGraphicsImageRenderer(size: size, format: format).image { context in
                    color.setFill()
                    context.fill(drawRect)
                    draw(in: drawRect, blendMode: blendMode, alpha: alpha)
                }
            }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// 渲染图片颜色(默认: `.alwaysOriginal`)
    /// - Parameters:
    ///   - color: 颜色
    ///   - renderingMode: 渲染模式
    /// - Returns: `UIImage`
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func dd_tintColor(with color: UIColor, renderingMode: RenderingMode = .alwaysOriginal) -> UIImage {
        withTintColor(color, renderingMode: renderingMode)
    }
}

// MARK: - 透明
public extension UIImage {
    /// 返回一个将白色背景变透明的UIImage
    /// - Returns: `UIImage?`
    func dd_imageByRemoveWhite() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return dd_transparentColor(colorMasking: colorMasking)
    }

    /// 返回一个将黑色背景变透明的UIImage
    /// - Returns: `UIImage?`
    func dd_imageByRemoveBlack() -> UIImage? {
        let colorMasking: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return dd_transparentColor(colorMasking: colorMasking)
    }

    /// 将图片中指定颜色设置为透明
    /// - Parameter colorMasking: 要透明的颜色
    /// - Returns: `UIImage?`
    func dd_transparentColor(colorMasking: [CGFloat]) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        guard let rawImageRef = cgImage else { return nil }
        guard let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) else { return nil }
        UIGraphicsBeginImageContext(size)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: 0.0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - 模糊
public extension UIImage {
    /// 图片的模糊效果(高斯模糊滤镜)
    /// - Parameter fuzzyValue:设置模糊半径值(越大越模糊)
    /// - Returns: `UIImage?`
    func dd_blurImage(fuzzyValue: CGFloat = 20) -> UIImage? {
        dd_blurredPicture(fuzzyValue: fuzzyValue, filterName: "CIGaussianBlur")
    }

    /// 像素化后的图片
    /// - Parameter fuzzyValue:设置模糊半径值(越大越模糊)
    /// - Returns: `UIImage?`
    func dd_pixelImage(fuzzyValue: CGFloat = 20) -> UIImage? {
        dd_blurredPicture(fuzzyValue: fuzzyValue, filterName: "CIPixellate")
    }

    /// 图片模糊
    /// - Parameters:
    ///   - fuzzyValue:设置模糊半径值(越大越模糊)
    ///   - filterName:模糊类型
    /// - Returns:返回模糊后的图片
    private func dd_blurredPicture(fuzzyValue: CGFloat, filterName: String) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        // 创建高斯模糊滤镜类
        guard let blurFilter = CIFilter(name: filterName) else { return nil }
        // 设置图片
        blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
        // 设置模糊半径值(越大越模糊)
        blurFilter.setValue(fuzzyValue, forKey: filterName == "CIPixellate" ? kCIInputScaleKey : kCIInputRadiusKey)
        // 从滤镜中 取出图片
        guard let outputImage = blurFilter.outputImage else { return nil }
        // 创建上下文
        let context = CIContext(options: nil)
        // 根据滤镜中的图片 创建CGImage
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return nil }
        // 生成的模糊图片
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - Core Image
public extension UIImage {
    enum FilterName: String {
        case CISepiaTone // 棕褐色复古滤镜(老照片效果),有点复古老照片发黄的效果)
        case CIPhotoEffectNoir // 黑白效果滤镜
    }

    /// 给图片添加加滤镜效果
    /// - Parameters:
    ///   - filterName: 滤镜类型
    ///   - alpha: 透明度
    /// - Returns: `UIImage?`
    func dd_useFilter(_ filterName: FilterName, alpha: CGFloat?) -> UIImage? {
        guard let imageData = pngData() else { return nil }
        let inputImage = CoreImage.CIImage(data: imageData)
        let context = CIContext(options: nil)

        guard let filter = CIFilter(name: filterName.rawValue) else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if alpha != nil { filter.setValue(alpha, forKey: "inputIntensity") }

        guard let outputImage = filter.outputImage else { return nil }
        guard let outImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }

        return UIImage(cgImage: outImage)
    }

    /// 将整张图片`马赛克化`
    /// - Parameter value: 值越大马赛克就越大(使用默认)
    /// - Returns: `UIImage?`
    func dd_pixAll(value: Int? = nil) -> UIImage? {
        guard let filter = CIFilter(name: "CIPixellate") else { return nil }
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if value != nil { filter.setValue(value, forKey: kCIInputScaleKey) }
        let fullPixellatedImage = filter.outputImage
        let cgImage = context.createCGImage(fullPixellatedImage!, from: fullPixellatedImage!.extent)
        return UIImage(cgImage: cgImage!)
    }

    /// 检测图片中的人脸(检测人脸的frame)
    /// - Returns: 所有人脸的`[CGRect]? `
    func dd_detectFace() -> [CGRect]? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let context = CIContext(options: nil)
        // 人脸检测器
        // CIDetectorAccuracyHigh:检测的精度高,但速度更慢些
        let detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: context,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        var faceFeatures: [CIFaceFeature]!
        // 人脸检测需要图片方向(有元数据的话使用元数据,没有就调用featuresInImage)
        if let orientation = inputImage.properties[kCGImagePropertyOrientation as String] {
            faceFeatures = (detector!.features(in: inputImage, options: [CIDetectorImageOrientation: orientation]) as! [CIFaceFeature])
        } else {
            faceFeatures = (detector!.features(in: inputImage) as! [CIFaceFeature])
        }
        // 打印所有的面部特征
        // print(faceFeatures)
        let inputImageSize = inputImage.extent.size
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -inputImageSize.height)

        // 人脸位置的frame
        var rects: [CGRect] = []
        // 遍历所有的面部,并框出
        for faceFeature in faceFeatures {
            let faceViewBounds = faceFeature.bounds.applying(transform)
            rects.append(faceViewBounds)
        }
        return rects
    }

    /// 检测人脸并打马赛克
    /// - Returns: 打马赛克后的人脸`UIImage?`
    func dd_detectAndPixFace() -> UIImage? {
        guard let inputImage = CIImage(image: self) else {
            return nil
        }
        let context = CIContext(options: nil)

        // 用CIPixellate滤镜对原图先做个完全马赛克
        let filter = CIFilter(name: "CIPixellate")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let inputScale = max(inputImage.extent.size.width, inputImage.extent.size.height) / 80
        filter.setValue(inputScale, forKey: kCIInputScaleKey)
        let fullPixellatedImage = filter.outputImage
        // 检测人脸,并保存在faceFeatures中
        guard let detector = CIDetector(ofType: CIDetectorTypeFace,
                                        context: context,
                                        options: nil)
        else {
            return nil
        }
        let faceFeatures = detector.features(in: inputImage)
        // 初始化蒙版图,并开始遍历检测到的所有人脸
        var maskImage: CIImage!
        for faceFeature in faceFeatures {
            // 基于人脸的位置,为每一张脸都单独创建一个蒙版,所以要先计算出脸的中心点,对应为x、y轴坐标,
            // 再基于脸的宽度或高度给一个半径,最后用这些计算结果初始化一个CIRadialGradient滤镜
            let centerX = faceFeature.bounds.origin.x + faceFeature.bounds.size.width / 2
            let centerY = faceFeature.bounds.origin.y + faceFeature.bounds.size.height / 2
            let radius = min(faceFeature.bounds.size.width, faceFeature.bounds.size.height)
            guard let radialGradient = CIFilter(name: "CIRadialGradient",
                                                parameters: [
                                                    "inputRadius0": radius,
                                                    "inputRadius1": radius + 1,
                                                    "inputColor0": CIColor(red: 0, green: 1, blue: 0, alpha: 1),
                                                    "inputColor1": CIColor(red: 0, green: 0, blue: 0, alpha: 0),
                                                    kCIInputCenterKey: CIVector(x: centerX, y: centerY),
                                                ])
            else {
                return nil
            }
            // 由于CIRadialGradient滤镜创建的是一张无限大小的图,所以在使用之前先对它进行裁剪
            let radialGradientOutputImage = radialGradient.outputImage!.cropped(to: inputImage.extent)
            if maskImage == nil {
                maskImage = radialGradientOutputImage
            } else {
                maskImage = CIFilter(name: "CISourceOverCompositing",
                                     parameters: [
                                         kCIInputImageKey: radialGradientOutputImage,
                                         kCIInputBackgroundImageKey: maskImage as Any,
                                     ])!.outputImage
            }
        }
        // 用CIBlendWithMask滤镜把马赛克图、原图、蒙版图混合起来
        let blendFilter = CIFilter(name: "CIBlendWithMask")!
        blendFilter.setValue(fullPixellatedImage, forKey: kCIInputImageKey)
        blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)
        // 输出,在界面上显示
        guard let blendOutputImage = blendFilter.outputImage, let blendCGImage = context.createCGImage(blendOutputImage, from: blendOutputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: blendCGImage)
    }
}

// MARK: - 渐变
public extension UIImage {
    enum GradientDirection {
        case horizontal // 水平从左到右
        case vertical // 垂直从上到下
        case leftOblique // 左上到右下
        case rightOblique // 右上到左下
        case other(CGPoint, CGPoint) // 自定义

        public func point(size: CGSize) -> (CGPoint, CGPoint) {
            switch self {
            case .horizontal:
                return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: 0))
            case .vertical:
                return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height))
            case .leftOblique:
                return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: size.height))
            case .rightOblique:
                return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
            case let .other(stat, end):
                return (stat, end)
            }
        }
    }

    /// 生成渐变色的图片 ["#B0E0E6", "#00CED1", "#2E8B57"]
    /// - Parameters:
    ///   - hexsString:十六进制字符数组
    ///   - size:图片大小
    ///   - locations:locations 数组
    ///   - direction:渐变的方向
    /// - Returns:渐变的图片
    static func dd_createGradient(_ hexsString: [String],
                                  size: CGSize = CGSize(width: 1, height: 1),
                                  locations: [CGFloat]? = [0, 1],
                                  direction: GradientDirection = .horizontal) -> UIImage?
    {
        dd_createGradient(hexsString.map { UIColor(hex: $0) }, size: size, locations: locations, direction: direction)
    }

    /// 生成渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors:UIColor 数组
    ///   - size:图片大小
    ///   - locations:locations 数组
    ///   - direction:渐变的方向
    /// - Returns:渐变的图片
    static func dd_createGradient(_ colors: [UIColor],
                                  size: CGSize = CGSize(width: 10, height: 10),
                                  locations: [CGFloat]? = [0, 1],
                                  direction: GradientDirection = .horizontal) -> UIImage?
    {
        dd_createGradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }

    /// 生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors:UIColor 数组
    ///   - size:图片大小
    ///   - radius:圆角
    ///   - locations:locations 数组
    ///   - direction:渐变的方向
    /// - Returns:带圆角的渐变的图片
    static func dd_createGradient(_ colors: [UIColor],
                                  size: CGSize = CGSize(width: 10, height: 10),
                                  radius: CGFloat,
                                  locations: [CGFloat]? = [0, 1],
                                  direction: GradientDirection = .horizontal) -> UIImage?
    {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return dd_createImage(color: colors[0])
        }
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map(\.cgColor) as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let directionPoint = direction.point(size: size)
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - 图片加载
public extension UIImage {
    /// 加载图片资源
    /// - Parameter image: 图片资源
    /// - Returns:图片
    static func dd_loadImage(with image: String) -> UIImage? {
        if image.hasPrefix("http://") || image.hasPrefix("https://") { // 网络图片
            let imageUrl = URL(string: image)
            var imageData: Data?
            do {
                imageData = try Data(contentsOf: imageUrl!)
                return UIImage(data: imageData!)!
            } catch {
                return nil
            }
        } else if image.contains("/") { // bundle路径
            return UIImage(contentsOfFile: image)
        }
        return UIImage(named: image)!
    }

    /// 使用`data`加载`Gif`图片
    /// - Parameter data: 图片数据
    /// - Returns: `UIImage?`
    static func dd_loadImageWithGif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        return dd_animatedImageWithSource(source)
    }

    /// 从`URL`中加载`Gif`图片
    /// - Parameter url: 图片`URL`地址
    /// - Returns: `UIImage?`
    static func dd_loadImageWithGif(url: String) -> UIImage? {
        guard let bundleURL = URL(string: url) else { return nil }
        guard let imageData = try? Data(contentsOf: bundleURL) else { return nil }
        return dd_loadImageWithGif(data: imageData)
    }

    /// 从`Bundle`中加载`Gif`图片
    /// - Parameter name: 图片的名字
    /// - Returns: `UIImage?`
    static func dd_loadImageWithGif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif")
        else {
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else { return nil }

        return dd_loadImageWithGif(data: imageData)
    }

    /// 使用`NSDataAsset`加载图片
    /// - Parameter asset: `NSDataAsset`
    /// - Returns: `UIImage?`
    @available(iOS 9.0, *)
    static func dd_loadImageWithGif(asset: String) -> UIImage? {
        guard let dataAsset = NSDataAsset(name: asset) else { return nil }
        return dd_loadImageWithGif(data: dataAsset.data)
    }

    /// 从`Gif`中获取每一帧及动画时长
    /// - Parameter asset: `NSDataAsset`
    /// - Returns: `(images: [UIImage]?, duration: TimeInterval?)`
    static func dd_frameInfoWithGif(asset: String) -> (images: [UIImage]?, duration: TimeInterval?) {
        guard let dataAsset = NSDataAsset(name: asset) else { return (nil, nil) }
        guard let source = CGImageSourceCreateWithData(dataAsset.data as CFData, nil) else {
            return (nil, nil)
        }
        return dd_animatedImageSources(source)
    }

    /// 从`Bundle`中获取`Gif`图片的每一帧及动画时长
    /// - Parameter name: `Gif`名称
    /// - Returns: `(images: [UIImage]?, duration: TimeInterval?)`
    static func dd_frameInfoWithGif(name: String) -> (images: [UIImage]?, duration: TimeInterval?) {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif")
        else {
            return (nil, nil)
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return (nil, nil)
        }
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return (nil, nil)
        }
        return dd_animatedImageSources(source)
    }

    /// 从`URL`中获取`Gif`图片的每一帧及动画时长
    /// - Parameter url: `Gif`图片的网络地址
    /// - Returns: `(images: [UIImage]?, duration: TimeInterval?)`
    static func dd_frameInfoWithGif(url: String) -> (images: [UIImage]?, duration: TimeInterval?) {
        guard let bundleURL = URL(string: url) else { return (nil, nil) }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return (nil, nil)
        }
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return (nil, nil)
        }
        return dd_animatedImageSources(source)
    }

    /// 获取`Gif`转化动画的`UIImage?`
    /// - Parameter source: `CGImageSource`
    /// - Returns: `UIImage?`
    private static func dd_animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let info = dd_animatedImageSources(source)
        guard let frames = info.images, let duration = info.duration else { return nil }
        let animation = UIImage.animatedImage(with: frames, duration: duration)
        return animation
    }

    /// 获取`Gif`图片每一帧及动画时长
    /// - Parameter source:`CGImageSource` 资源
    /// - Returns:gif信息
    private static func dd_animatedImageSources(_ source: CGImageSource) -> (images: [UIImage]?, duration: TimeInterval?) {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        for index in 0 ..< count {
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            let delaySeconds = dd_delayForImageAtIndex(Int(index), source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }

        let duration: Int = {
            var sum = 0
            for val in delays {
                sum += val
            }
            return sum
        }()

        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for index in 0 ..< count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            for _ in 0 ..< frameCount {
                frames.append(frame)
            }
        }
        return (frames, Double(duration) / 1000.0)
    }

    private static func dd_delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self
        )
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1
        }
        return delay
    }

    private static func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        for val in array {
            gcd = gcdForPair(val, gcd)
        }
        return gcd
    }

    private static func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }

        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        var rest: Int
        while true {
            rest = lhs! % rhs!
            if rest == 0 {
                return rhs!
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
}

// MARK: - 图片水印
public extension UIImage {
    /// 给图片添加文字水印
    /// - Parameters:
    ///   - text: 水印文字
    ///   - attributes: 水印富文本属性
    ///   - frame: 水印的frame
    /// - Returns: `UIImage`
    func dd_drawWatermark(with text: String, attributes: [NSAttributedString.Key: Any]?, frame: CGRect) -> UIImage {
        // 开启图片上下文
        UIGraphicsBeginImageContext(size)
        // 图形重绘
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // 绘制文字
        text.dd_NSString().draw(in: frame, withAttributes: attributes)
        // 从当前上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()

        return image!
    }

    /// 添加图片水印
    /// - Parameters:
    ///   - rect:水印图片的位置
    ///   - image:水印图片
    /// - Returns:带有水印的图片
    func dd_addImageWatermark(rect: CGRect, image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 文字图片占位符
    /// - Parameters:
    ///   - text:图片上的文字
    ///   - size:图片的大小
    ///   - backgroundColor:图片背景色
    ///   - textColor:文字颜色
    ///   - isCircle:是否要圆角
    ///   - isFirstChar:是否展示第一个字符
    /// - Returns:返回图片
    static func dd_textImage(_ text: String, fontSize: CGFloat = 16, size: (CGFloat, CGFloat), backgroundColor: UIColor = UIColor.orange, textColor: UIColor = UIColor.white, isCircle: Bool = true, isFirstChar: Bool = false) -> UIImage? {
        // 过滤空内容
        if text.isEmpty { return nil }
        // 取第一个字符(测试了,太长了的话,效果并不好)
        let letter = isFirstChar ? (text as NSString).substring(to: 1) : text
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)

        let textsize = text.dd_stringSize(kScreenWidth, font: .systemFont(ofSize: fontSize))

        // 开启上下文
        UIGraphicsBeginImageContext(sise)
        // 拿到上下文
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 取较小的边
        let minSide = min(size.0, size.1)
        // 是否圆角裁剪
        if isCircle {
            UIBezierPath(roundedRect: rect, cornerRadius: minSide * 0.5).addClip()
        }
        // 设置填充颜色
        ctx.setFillColor(backgroundColor.cgColor)
        // 填充绘制
        ctx.fill(rect)
        let attr = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        // 写入文字
        // 文字写入的起点
        let pointX: CGFloat = textsize.width > minSide ? 0 : (minSide - textsize.width) / 2.0
        let pointY: CGFloat = (minSide - fontSize - 4) / 2.0
        (letter as NSString).draw(at: CGPoint(x: pointX, y: pointY), withAttributes: attr)
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - 保存图片
public extension UIImage {
    /// 保存图片到相册
    /// - Parameter completion:完成回调
    func dd_saveImageToPhotoAlbum(_ completion: ((Bool) -> Void)?) {
        saveBlock = completion
        UIImageWriteToSavedPhotosAlbum(self,
                                       self,
                                       #selector(saveImage(image:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }

    /// 保存图片到相册
    /// - Parameter completion:完成回调
    func dd_savePhotosImageToAlbum(completion: @escaping ((Bool, Error?) -> Void)) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: self)
        } completionHandler: { (isSuccess: Bool, error: Error?) in
            completion(isSuccess, error)
        }
    }

    private var saveBlock: ((Bool) -> Void)? {
        get { AssociatedObject.get(self, DDAssociateKeys.SaveBlockKey!) as? ((Bool) -> Void) }
        set {
            AssociatedObject.set(self, DDAssociateKeys.SaveBlockKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            saveBlock?(false)
        } else {
            saveBlock?(true)
        }
    }
}

// MARK: - 方法
public extension UIImage {
    /// 图片平铺区域
    /// - Parameter size:平铺区域的大小
    /// - Returns:平铺后的图片
    func dd_imageTile(size: CGSize) -> UIImage? {
        let tempView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        tempView.backgroundColor = UIColor(patternImage: self)
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        tempView.layer.render(in: context)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return bgImage
    }

    /// 获取图片大小
    /// - Parameters:
    ///   - url:图片地址
    ///   - max:最大边长度
    static func dd_imageSize(_ url: URL?, max: CGFloat? = nil) -> CGSize {
        guard let url else { return .zero }
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else { return .zero }
        guard let result = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else { return .zero }
        guard let width = result["PixelWidth"] as? CGFloat else { return .zero }
        guard let height = result["PixelHeight"] as? CGFloat else { return .zero }

        var size = CGSize(width: width, height: height)

        guard let relative = max else { return size }

        if size.height > size.width {
            size.width = size.width / size.height * relative
            size.height = relative
        } else {
            size.height = size.height / size.width * relative
            size.width = relative
        }
        return size
    }
}
