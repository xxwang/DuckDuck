import AVFoundation
import CoreImage
import Dispatch
import Photos
import UIKit

// MARK: - 关联键
private class AssociateKeys {
    static var saveBlockKey = UnsafeRawPointer(bitPattern: "saveBlockKey".hashValue)
}

// MARK: - 构造方法
public extension UIImage {
    /// 根据颜色和大小创建UIImage
    /// - Parameters:
    ///   - color: 图像填充颜色
    ///   - size: 图像尺寸，默认为 (1, 1)
    /// - Example:
    ///   ```swift
    ///   let image = UIImage(with: .red, size: CGSize(width: 100, height: 100))
    ///   ```
    convenience init(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer { UIGraphicsEndImageContext() }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: cgImage)
    }

    /// 从URL创建新图像
    /// - Parameters:
    ///   - imageUrl: 图片的URL地址
    ///   - scale: 缩放比例，默认为1.0
    /// - Throws: 如果加载数据失败，则抛出错误
    /// - Example:
    ///   ```swift
    ///   let image = try? UIImage(imageUrl: url, scale: 2.0)
    ///   ```
    convenience init?(imageUrl: URL, scale: CGFloat = 1.0) throws {
        let data = try Data(contentsOf: imageUrl)
        self.init(data: data, scale: scale)
    }

    /// 使用不同的图片名称创建动态图片
    /// - Parameters:
    ///   - lightImageName: 高亮模式下的图片名称
    ///   - darkImageName: 暗调模式下的图片名称（可选）
    /// - Example:
    ///   ```swift
    ///   let dynamicImage = UIImage(lightImageName: "lightImage", darkImageName: "darkImage")
    ///   ```
    convenience init(lightImageName: String, darkImageName: String? = nil) {
        self.init(lightImage: UIImage(named: lightImageName),
                  darkImage: UIImage(named: darkImageName ?? lightImageName))
    }

    /// 使用不同的图片创建动态图片
    /// - Parameters:
    ///   - lightImage: 高亮模式下的图片
    ///   - darkImage: 暗调模式下的图片
    /// - Example:
    ///   ```swift
    ///   let dynamicImage = UIImage(lightImage: lightImage, darkImage: darkImage)
    ///   ```
    convenience init(lightImage: UIImage?, darkImage: UIImage?) {
        if #available(iOS 13.0, *) {
            guard let lightImage, let darkImage else {
                self.init()
                return
            }

            let lightConfig = lightImage.configuration?.withTraitCollection(UITraitCollection(userInterfaceStyle: .light))
            let darkConfig = darkImage.configuration?.withTraitCollection(UITraitCollection(userInterfaceStyle: .dark))

            guard let lightConfig, let darkConfig else {
                self.init(cgImage: lightImage.cgImage!)
                return
            }

            let updatedLightImage = lightImage.withConfiguration(lightConfig)
            updatedLightImage.imageAsset?.register(darkImage, with: darkConfig)

            let currentImage = updatedLightImage.imageAsset?.image(with: .current) ?? updatedLightImage
            self.init(cgImage: currentImage.cgImage!)
        } else {
            guard let lightImage else {
                self.init()
                return
            }
            self.init(cgImage: lightImage.cgImage!)
        }
    }
}

// MARK: - Base64 编码
public extension UIImage {
    /// 获取图像的 `Base64` 编码 `PNG` 数据字符串
    ///
    /// - Returns: 返回图像的 `Base64` 编码 `PNG` 数据字符串。如果生成失败，则返回 `nil`
    /// - 示例：
    ///   ```swift
    ///   if let base64String = image.dd_toPNGBase64String() {
    ///       print(base64String)
    ///   }
    ///   ```
    func dd_toPNGBase64String() -> String? {
        return pngData()?.base64EncodedString()
    }

    /// 获取图像的 `Base64` 编码 `JPEG` 数据字符串
    /// - Parameter compressionQuality: `JPEG` 图像的压缩质量，取值范围是 0.0 到 1.0。值为 0.0 表示最大压缩（最低质量），值为 1.0 表示最佳质量（最小压缩）。
    /// - Returns: 返回图像的 `Base64` 编码 `JPEG` 数据字符串。如果生成失败，则返回 `nil`
    /// - 示例：
    ///   ```swift
    ///   if let base64String = image.dd_toJPEGBase64String(compressionQuality: 0.8) {
    ///       print(base64String)
    ///   }
    ///   ```
    func dd_toJPEGBase64String(compressionQuality: CGFloat) -> String? {
        return jpegData(compressionQuality: compressionQuality)?.base64EncodedString()
    }
}

// MARK: - 常用方法
public extension UIImage {
    /// 获取图片的大小(单位:字节)
    /// - Returns: 图片的大小（字节数）
    ///
    /// - Example:
    ///   ```swift
    ///   let image = UIImage(named: "exampleImage")
    ///   let sizeInBytes = image?.dd_sizeInBytes()
    ///   ```
    func dd_sizeInBytes() -> Int {
        return jpegData(compressionQuality: 1)?.count ?? 0
    }

    /// 获取图片的大小(单位:KB)
    /// - Returns: 图片的大小（以KB为单位）
    ///
    /// - Example:
    ///   ```swift
    ///   let image = UIImage(named: "exampleImage")
    ///   let sizeInKB = image?.dd_sizeInKB()
    ///   ```
    func dd_sizeInKB() -> Int {
        return (jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }

    /// 获取图片的原始渲染模式
    /// - Returns: 使用原始渲染模式的图片
    ///
    /// - Example:
    ///   ```swift
    ///   let image = UIImage(named: "exampleImage")
    ///   let originalImage = image?.dd_asOriginal()
    ///   ```
    func dd_asOriginal() -> UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }

    /// 获取图片的模板渲染模式
    /// - Returns: 使用模板渲染模式的图片
    ///
    /// - Example:
    ///   ```swift
    ///   let image = UIImage(named: "exampleImage")
    ///   let templateImage = image?.dd_asTemplate()
    ///   ```
    func dd_asTemplate() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - 动态图片切换
public extension UIImage {
    /// 切换深色和浅色模式的图片（深色模式适配）
    /// - Parameters:
    ///   - lightImageName: 浅色模式的图片名称
    ///   - darkImageName: 深色模式的图片名称（可选，默认为浅色模式的图片）
    /// - Returns: 返回适配深色和浅色模式的图片
    /// - 示例：
    ///   ```swift
    ///   let image = UIImage.dd_darkModeImage("lightImage", darkImageName: "darkImage")
    ///   ```
    static func dd_darkModeImage(_ lightImageName: String, darkImageName: String? = nil) -> UIImage? {
        return self.dd_darkModeImage(UIImage(named: lightImageName), darkImage: UIImage(named: darkImageName ?? lightImageName))
    }

    /// 切换深色和浅色模式的图片（深色模式适配）
    /// - Parameters:
    ///   - lightImage: 浅色模式的图片
    ///   - darkImage: 深色模式的图片
    /// - Returns: 返回适配深色和浅色模式的图片
    /// - 示例：
    ///   ```swift
    ///   let image = UIImage.dd_darkModeImage(lightImage, darkImage: darkImage)
    ///   ```
    static func dd_darkModeImage(_ lightImage: UIImage?, darkImage: UIImage?) -> UIImage? {
        if #available(iOS 13.0, *) {
            guard let lightImage else { return darkImage }
            guard let darkImage else { return lightImage }
            guard let config = lightImage.configuration else { return lightImage }

            let lightImageConfigured = lightImage.withConfiguration(
                config.withTraitCollection(UITraitCollection(userInterfaceStyle: .light)))
            lightImageConfigured.imageAsset?.register(
                darkImage,
                with: config.withTraitCollection(UITraitCollection(userInterfaceStyle: .dark))
            )
            return lightImageConfigured.imageAsset?.image(with: .current) ?? lightImageConfigured
        } else {
            return lightImage
        }
    }
}

// MARK: - 压缩模式
public enum CompressionMode: Sendable {
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

    /// 最大数据大小
    var maxDataSize: Int {
        switch self {
        case .low: return CompressionMode.dataSizeRule.low
        case .medium: return CompressionMode.dataSizeRule.default
        case .high: return CompressionMode.dataSizeRule.high
        case let .other(_, dataSize):
            return min(max(dataSize, CompressionMode.dataSizeRule.min), CompressionMode.dataSizeRule.max)
        }
    }

    /// 根据压缩模式调整图片尺寸
    func resize(_ size: CGSize) -> CGSize {
        guard size.width >= CompressionMode.resolutionRule.min, size.height >= CompressionMode.resolutionRule.min else {
            return size
        }
        let maxResolution = maxSize
        let aspectRatio = max(size.width, size.height) / maxResolution
        if aspectRatio <= 1.0 { return size }
        let resizeWidth = size.width / aspectRatio
        let resizeHeight = size.height / aspectRatio
        return CGSize(width: resizeWidth, height: resizeHeight)
    }

    /// 获取最大尺寸
    var maxSize: CGFloat {
        switch self {
        case .low: return CompressionMode.resolutionRule.low
        case .medium: return CompressionMode.resolutionRule.default
        case .high: return CompressionMode.resolutionRule.high
        case let .other(size, _):
            return min(max(size, CompressionMode.resolutionRule.min), CompressionMode.resolutionRule.max)
        }
    }
}

// MARK: - 图像压缩功能扩展
public extension UIImage {
    /// 压缩图片并返回新的 `UIImage`
    /// - Parameter quality: 生成的 `JPEG` 图像质量，范围从 0.0（最压缩）到 1.0（最佳质量）。默认值为 0.5
    /// - Returns: 返回压缩后的 `UIImage`
    /// - Example:
    /// ```swift
    /// let compressedImage = image.dd_compressed(quality: 0.7)
    /// ```
    func dd_compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }

    /// 压缩图片并返回压缩后的 `Data`
    /// - Parameter quality: 生成的 `JPEG` 图像质量，范围从 0.0（最压缩）到 1.0（最佳质量）。默认值为 0.5
    /// - Returns: 压缩后的 `Data`
    /// - Example:
    /// ```swift
    /// if let compressedData = image.dd_compressedData(quality: 0.8) {
    ///     // 处理压缩数据
    /// }
    /// ```
    func dd_compressedData(quality: CGFloat = 0.5) -> Data? {
        return jpegData(compressionQuality: quality)
    }

    /// 根据压缩模式压缩图片并返回压缩后的 `Data`
    /// - Parameter mode: 压缩模式，默认为 `.medium`
    /// - Returns: 压缩后的 `Data`
    /// - Example:
    /// ```swift
    /// if let compressedData = image.dd_compress(mode: .high) {
    ///     // 处理高质量压缩后的数据
    /// }
    /// ```
    func dd_compress(mode: CompressionMode = .medium) -> Data? {
        return dd_resizeIO(resizeSize: mode.resize(size))?.dd_compressDataSize(maxSize: mode.maxDataSize)
    }

    /// 异步压缩图片
    /// - Parameters:
    ///   - mode: 压缩模式，默认为 `.medium`
    ///   - queue: 压缩执行队列，默认使用全局队列
    ///   - complete: 完成回调，传递压缩后的 `Data` 和调整后的分辨率
    /// - Example:
    /// ```swift
    /// image.dd_asyncCompress(mode: .high) { data, size in
    ///     // 在主线程处理压缩数据和尺寸
    /// }
    /// ```
    func dd_asyncCompress(mode: CompressionMode = .medium, queue: DispatchQueue = DispatchQueue.global(), complete: @Sendable @escaping (Data?, CGSize) -> Void) {
        queue.async {
            let data = self.dd_resizeIO(resizeSize: mode.resize(self.size))?.dd_compressDataSize(maxSize: mode.maxDataSize)
            DispatchQueue.main.async {
                complete(data, mode.resize(self.size))
            }
        }
    }

    /// 压缩图片并根据指定大小调整 `Data`，直到达到目标大小
    /// - Parameter maxSize: 最大数据大小，单位为字节。默认值为 2MB
    /// - Returns: 压缩后的数据
    /// - Example:
    /// ```swift
    /// if let compressedData = image.dd_compressDataSize(maxSize: 1024 * 1024) {
    ///     // 处理压缩后数据
    /// }
    /// ```
    func dd_compressDataSize(maxSize: Int = 1024 * 1024 * 2) -> Data? {
        var quality: CGFloat = 0.8
        var data = jpegData(compressionQuality: quality)
        while data?.count ?? 0 > maxSize, quality > 0.6 {
            quality -= 0.05
            data = jpegData(compressionQuality: quality)
        }
        return data
    }

    /// 使用 `ImageIO` 方法调整图片大小，性能较好
    /// - Parameter resizeSize: 目标尺寸
    /// - Returns: 调整大小后的 `UIImage`
    /// - Example:
    /// ```swift
    /// if let resizedImage = image.dd_resizeIO(resizeSize: CGSize(width: 500, height: 500)) {
    ///     // 处理调整大小后的图像
    /// }
    /// ```
    func dd_resizeIO(resizeSize: CGSize) -> UIImage? {
        if size == resizeSize { return self }
        guard let imageData = pngData(), let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceThumbnailMaxPixelSize: max(resizeSize.width, resizeSize.height),
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    /// 使用 `CoreGraphics` 方法调整图片大小，性能较好
    /// - Parameter resizeSize: 目标尺寸
    /// - Returns: 调整大小后的 `UIImage`
    /// - Example:
    /// ```swift
    /// if let resizedImage = image.dd_resizeCG(resizeSize: CGSize(width: 500, height: 500)) {
    ///     // 处理调整大小后的图像
    /// }
    /// ```
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
        guard let resizedImage = context.makeImage() else { return nil }
        return UIImage(cgImage: resizedImage)
    }

    /// 压缩图片大小直到达到指定字节数
    /// - Parameter maxLength: 最大字节数
    /// - Returns: 处理后的 `UIImage`
    /// - Example:
    /// ```swift
    /// let resizedImage = image.dd_compressImageSize(toByte: 1024 * 1024)
    /// ```
    func dd_compressImageSize(toByte maxLength: Int) -> UIImage? {
        var imageData = jpegData(compressionQuality: 1.0)
        var quality: CGFloat = 1.0
        while (imageData?.count ?? 0) > maxLength, quality > 0.5 {
            quality -= 0.05
            imageData = jpegData(compressionQuality: quality)
        }
        return imageData.flatMap { UIImage(data: $0) }
    }
}

// MARK: - 缩放
public extension UIImage {
    /// 裁剪给定区域
    /// - Parameter crop: 裁剪区域的 CGRect，表示要裁剪的矩形区域
    /// - Returns: 裁剪后的图片，如果区域不合法则返回 nil
    /// - Example:
    /// ```swift
    /// let croppedImage = image.dd_cropWithCropRect(CGRect(x: 0, y: 0, width: 100, height: 100))
    /// ```
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

    /// 把 `UIImage` 裁剪为指定 `CGRect` 大小
    /// - Parameter rect: 目标 `CGRect`，表示需要裁剪的区域
    /// - Returns: 裁剪后的 `UIImage`
    /// - Example:
    /// ```swift
    /// let croppedImage = image.dd_cropped(to: CGRect(x: 0, y: 0, width: 200, height: 200))
    /// ```
    func dd_cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= size.width, rect.size.height <= size.height else { return self }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        guard let image = cgImage?.cropping(to: scaledRect) else { return self }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    /// 返回指定尺寸的图片
    /// - Parameter size: 目标图片大小
    /// - Returns: 缩放完成的图片
    /// - Example:
    /// ```swift
    /// let resizedImage = image.dd_resize(to: CGSize(width: 200, height: 200))
    /// ```
    func dd_resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }

    /// 指定大小的图片
    /// - Parameter maxSize: 图片最大尺寸（不会超过）
    /// - Returns: 固定大小的 `UIImage`
    /// - Example:
    /// ```swift
    /// let fixedImage = image.dd_solidTo(maxSize: CGSize(width: 300, height: 300))
    /// ```
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
    /// - Parameter size: 要缩放的目标尺寸
    /// - Returns: 缩放后的图片
    /// - Example:
    /// ```swift
    /// let scaledImage = image.dd_scaleTo(size: CGSize(width: 150, height: 150))
    /// ```
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

    /// 按宽高比系数等比缩放
    /// - Parameter scale: 缩放的宽高比系数
    /// - Returns: 等比缩放后的图片
    /// - Example:
    /// ```swift
    /// let scaledImage = image.dd_scaleTo(scale: 0.5)
    /// ```
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

    /// 等比例把 `UIImage` 缩放至指定宽度
    /// - Parameters:
    ///   - newWidth: 新的宽度
    ///   - opaque: 是否不透明
    /// - Returns: 缩放后的 `UIImage`（可选）
    /// - Example:
    /// ```swift
    /// let scaledImage = image.dd_scaleTo(newWidth: 250)
    /// ```
    func dd_scaleTo(newWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 等比例把 `UIImage` 缩放至指定高度
    /// - Parameters:
    ///   - newHeight: 新的高度
    ///   - opaque: 是否不透明
    /// - Returns: 缩放后的 `UIImage`（可选）
    /// - Example:
    /// ```swift
    /// let scaledImage = image.dd_scaleTo(newHeight: 200)
    /// ```
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
    /// - Returns: 拉伸后的图片
    /// - Example:
    /// ```swift
    /// let stretchedImage = image.dd_strechAsBubble()
    /// ```
    func dd_strechAsBubble() -> UIImage {
        let edgeInsets = UIEdgeInsets(
            top: size.height * 0.5,
            left: size.width * 0.5,
            bottom: size.height * 0.5,
            right: size.width * 0.5
        )
        return resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
    }

    /// 按 `edgeInsets` 与 `resizingMode` 拉伸图片
    /// - Parameters:
    ///   - edgeInsets: 拉伸区域
    ///   - resizingMode: 拉伸模式，默认为 `.stretch`
    /// - Returns: 返回拉伸后的图片
    /// - Example:
    /// ```swift
    /// let stretchedImage = image.dd_strechBubble(edgeInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    /// ```
    func dd_strechBubble(edgeInsets: UIEdgeInsets,
                         resizingMode: UIImage.ResizingMode = .stretch) -> UIImage
    {
        // 拉伸
        return resizableImage(withCapInsets: edgeInsets, resizingMode: resizingMode)
    }
}

// MARK: - 旋转和翻转操作
public extension UIImage {
    /// 修复图片方向，确保图像方向正确
    /// 该方法修正图片的方向，使其始终处于正确的方向，避免图片显示旋转。
    /// - Returns: 修正后的图片
    ///
    /// ```swift
    /// let correctedImage = image.dd_fixOrientation()
    /// ```
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

    /// 按给定角度旋转图片 (角度为度数)
    /// 该方法将图像旋转指定的角度，角度范围从 0 到 360。
    /// - Parameter angle: 旋转角度，单位为度
    /// - Returns: 旋转后的图片
    ///
    /// ```swift
    /// let rotatedImage = image.dd_rotate2(degree: 90)
    /// ```
    func dd_rotate2(degree: CGFloat) -> UIImage? {
        let radians = degree * .pi / 180
        return dd_rotate2(radians: radians)
    }

    /// 按给定弧度旋转图片
    /// 该方法将图像旋转指定的弧度，弧度范围从 0 到 2π。
    /// - Parameter radians: 旋转的弧度
    /// - Returns: 旋转后的图片
    ///
    /// ```swift
    /// let rotatedImage = image.dd_rotate2(radians: .pi / 2)
    /// ```
    func dd_rotate2(radians: CGFloat) -> UIImage? {
        guard let cgImage else { return nil }
        let rotationTransform = CGAffineTransform(rotationAngle: radians)
        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: size))
        rotatedViewBox.transform = rotationTransform

        UIGraphicsBeginImageContext(rotatedViewBox.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        context.translateBy(x: rotatedViewBox.frame.width / 2, y: rotatedViewBox.frame.height / 2)
        context.rotate(by: radians)
        context.scaleBy(x: 1, y: -1)

        let rect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
        context.draw(cgImage, in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 图片按角度旋转，返回旋转后的新图片
    /// - Parameter angle: 旋转角度 (单位：度)，表示图片旋转的角度。
    /// - Returns: 旋转后的图片。如果旋转失败，则返回 nil。
    ///
    /// 示例：
    /// ```swift
    /// let rotatedImage = image.dd_rotated(by: Measurement(value: 90, unit: .degrees))
    /// ```
    /// 该方法将图片按给定角度旋转（度数），返回旋转后的新图片。
    @available(tvOS 10.0, watchOS 3.0, *)
    func dd_rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        // 将角度值转换为弧度值
        let radians = CGFloat(angle.converted(to: .radians).value)
        // 调用旋转弧度的实际旋转方法
        return dd_rotate(by: radians)
    }

    /// 按指定弧度旋转图片
    /// - Parameter radians: 旋转的弧度，表示图片旋转的角度（弧度值）。
    /// - Returns: 旋转后的图片。如果旋转失败，则返回 nil。
    ///
    /// 示例：
    /// ```swift
    /// let rotatedImage = image.dd_rotate(by: .pi / 2)  // 旋转90度
    /// ```
    /// 该方法将图片按指定的弧度值进行旋转，并返回旋转后的图片。
    func dd_rotate(by radians: CGFloat) -> UIImage? {
        // 计算旋转后的图片区域，得到旋转后的矩形边界
        let rotatedRect = CGRect(origin: .zero, size: size).applying(CGAffineTransform(rotationAngle: radians))
        // 对旋转后的矩形边界进行四舍五入
        let roundedRect = CGRect(x: rotatedRect.origin.x.rounded(), y: rotatedRect.origin.y.rounded(),
                                 width: rotatedRect.width.rounded(), height: rotatedRect.height.rounded())

        // 开始绘制新的图片
        UIGraphicsBeginImageContextWithOptions(roundedRect.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // 设置绘制坐标系的原点为旋转后的矩形中心
        context.translateBy(x: roundedRect.width / 2, y: roundedRect.height / 2)
        // 进行图片旋转
        context.rotate(by: radians)

        // 将图片绘制到新的上下文中
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size))

        // 从上下文中获取旋转后的图片
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        // 结束绘制上下文
        UIGraphicsEndImageContext()
        return rotatedImage
    }

    /// 水平翻转图片
    /// - Returns: 水平翻转后的图片
    ///
    /// ```swift
    /// let flippedImage = image.dd_flipHorizontally()
    /// ```
    func dd_flipHorizontally() -> UIImage? {
        return dd_rotate(orientation: .upMirrored)
    }

    /// 垂直翻转图片
    /// - Returns: 垂直翻转后的图片
    ///
    /// ```swift
    /// let flippedImage = image.dd_flipVertically()
    /// ```
    func dd_flipVertically() -> UIImage? {
        return dd_rotate(orientation: .downMirrored)
    }

    /// 向下翻转图片
    /// - Returns: 向下翻转后的图片，如果翻转失败则返回 nil。
    ///
    /// 示例：
    /// ```swift
    /// let flippedDownImage = image.dd_flipDown()
    /// ```
    /// 该方法将图片按垂直轴进行翻转，返回翻转后的新图片。
    func dd_flipDown() -> UIImage? {
        return dd_rotate(orientation: .down)
    }

    /// 向左翻转图片
    /// - Returns: 向左翻转后的图片，如果翻转失败则返回 nil。
    ///
    /// 示例：
    /// ```swift
    /// let flippedLeftImage = image.dd_flipLeft()
    /// ```
    /// 该方法将图片按水平方向进行翻转，返回翻转后的新图片。
    func dd_flipLeft() -> UIImage? {
        return dd_rotate(orientation: .left)
    }

    /// 镜像向左翻转图片
    /// - Returns: 镜像向左翻转后的图片，如果翻转失败则返回 nil。
    ///
    /// 示例：
    /// ```swift
    /// let flippedLeftMirroredImage = image.dd_flipLeftMirrored()
    /// ```
    /// 该方法将图片进行镜像翻转并水平翻转，返回镜像翻转后的新图片。
    func dd_flipLeftMirrored() -> UIImage? {
        return dd_rotate(orientation: .leftMirrored)
    }

    /// 向右翻转图片
    /// - Returns: 向右翻转后的图片，如果翻转失败则返回 nil。
    ///
    /// 示例：
    /// ```swift
    /// let flippedRightImage = image.dd_flipRight()
    /// ```
    /// 该方法将图片按水平方向进行翻转，返回翻转后的新图片。
    func dd_flipRight() -> UIImage? {
        return dd_rotate(orientation: .right)
    }

    /// 镜像向右翻转图片
    /// - Returns: 镜像向右翻转后的图片，如果翻转失败则返回 nil。
    ///
    /// 示例：
    /// ```swift
    /// let flippedRightMirroredImage = image.dd_flipRightMirrored()
    /// ```
    /// 该方法将图片进行镜像翻转并水平翻转，返回镜像翻转后的新图片。
    func dd_flipRightMirrored() -> UIImage? {
        return dd_rotate(orientation: .rightMirrored)
    }

    /// 根据指定的方向旋转图片
    /// - Parameter orientation: 翻转方向，指定如何翻转图片。
    /// - Returns: 按指定方向翻转后的图片，如果翻转失败则返回 nil。
    ///
    /// 示例：
    /// ```swift
    /// let flippedImage = image.dd_rotate(orientation: .down)
    /// ```
    /// 该方法根据传入的翻转方向，返回按方向翻转后的新图片。
    private func dd_rotate(orientation: UIImage.Orientation) -> UIImage? {
        guard let imageRef = cgImage else { return nil }

        let rect = CGRect(x: 0, y: 0, width: imageRef.width, height: imageRef.height)
        var bounds = rect
        var transform = CGAffineTransform.identity

        switch orientation {
        case .up:
            return self
        case .upMirrored:
            // 图片左平移 width 个像素后水平翻转
            transform = CGAffineTransform(translationX: rect.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .down:
            // 图片旋转180度
            transform = CGAffineTransform(translationX: rect.size.width, y: rect.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .downMirrored:
            // 图片翻转并沿 Y 轴镜像
            transform = CGAffineTransform(translationX: 0, y: rect.size.height)
            transform = transform.scaledBy(x: 1, y: -1)
        case .left:
            // 交换宽高并旋转90度
            dd_swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: 0, y: rect.size.width)
            transform = transform.rotated(by: CGFloat(Double.pi * 1.5))
        case .leftMirrored:
            // 交换宽高，镜像并旋转
            dd_swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: rect.size.height, y: rect.size.width)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat(Double.pi * 1.5))
        case .right:
            // 交换宽高并旋转90度
            dd_swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: rect.size.height, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .rightMirrored:
            // 交换宽高，镜像并旋转
            dd_swapWidthAndHeight(rect: &bounds)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        default:
            return nil
        }

        // 创建新的上下文以绘制旋转后的图片
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        // 对图片绘制进行修正以适应翻转方向
        switch orientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.scaleBy(x: -1.0, y: 1.0)
            context.translateBy(x: -bounds.size.width, y: 0.0)
        default:
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0.0, y: -rect.size.height)
        }

        context.concatenate(transform)
        context.draw(imageRef, in: rect)

        // 获取绘制后的新图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 交换宽高
    /// - Parameter rect: 输入图片的 frame
    /// - Returns: 更新后的 frame，其中宽高已交换。
    private func dd_swapWidthAndHeight(rect: inout CGRect) {
        let swap = rect.size.width
        rect.size.width = rect.size.height
        rect.size.height = swap
    }
}

// MARK: - 圆角
public extension UIImage {
    /// 带圆角的`UIImage`
    /// - Parameters:
    ///   - radius: 角半径 (可选), 如果未指定, 结果图像将为圆形。
    /// - Returns: 带圆角的`UIImage`，如果处理失败则返回 nil。
    ///
    /// 示例：
    /// ```swift
    /// let imageWithCorner = image.dd_corner(radius: 10)
    /// ```
    /// 该方法为图片添加圆角效果。如果未指定圆角半径，返回圆形图片。
    func dd_corner(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat = if let radius, radius > 0, radius <= maxRadius {
            radius
        } else {
            maxRadius
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
    ///   - size: 图片的大小
    ///   - radius: 圆角大小 (默认:3.0, 图片大小)
    ///   - corners: 切圆角的方式
    /// - Returns: 剪切后的图片，返回处理后的图片。
    ///
    /// 示例：
    /// ```swift
    /// let imageWithSpecificCorners = image.dd_corner(size: CGSize(width: 100, height: 100), radius: 10, corners: [.topLeft, .bottomRight])
    /// ```
    /// 该方法为图片设置指定圆角，可以选择裁剪的角。
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
    ///   - size: 最终生成的图片尺寸
    ///   - radius: 圆角半径
    ///   - corners: 圆角方向
    ///   - borderWidth: 边框线宽
    ///   - borderColor: 边框颜色
    ///   - backgroundColor: 背景颜色
    /// - Returns: 最终图片，返回带圆角和边框的图片。
    ///
    /// 示例：
    /// ```swift
    /// let imageWithBorder = image.dd_corner(size: CGSize(width: 150, height: 150), radius: 20, corners: .allCorners, borderWidth: 5, borderColor: .black)
    /// ```
    /// 该方法为图片设置圆角效果并添加边框。
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

        DispatchQueue.main.async {
            completion?(resultImage)
        }
        return resultImage!
    }

    /// 设置圆形图片
    /// - Returns: 圆形图片，返回圆形裁剪后的图片。
    ///
    /// 示例：
    /// ```swift
    /// let roundImage = image.dd_toCornerImage()
    /// ```
    /// 该方法将图片裁剪为圆形。
    func dd_toCornerImage() -> UIImage? {
        self.dd_corner(size: size,
                       radius: (size.width < size.height ? size.width : size.height) / 2.0,
                       corners: .allCorners)
    }

    /// 生成指定尺寸的纯色图像
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    /// - Returns: 返回对应的图片，生成纯色图片。
    ///
    /// 示例：
    /// ```swift
    /// let coloredImage = UIImage.dd_makeImage(with: .red, size: CGSize(width: 50, height: 50))
    /// ```
    /// 该方法生成指定颜色和尺寸的纯色图像。
    static func dd_makeImage(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        return self.dd_makeImage(with: color, size: size, corners: .allCorners, radius: 0)
    }

    /// 生成指定尺寸和圆角的纯色图像
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    ///   - corners: 剪切的方式
    ///   - round: 圆角大小
    /// - Returns: 返回对应的图片，生成指定圆角的纯色图像。
    ///
    /// 示例：
    /// ```swift
    /// let coloredImageWithCorner = UIImage.dd_makeImage(with: .blue, size: CGSize(width: 100, height: 100), corners: [.topLeft], radius: 10)
    /// ```
    /// 该方法生成指定颜色、圆角和尺寸的纯色图像。
    static func dd_makeImage(with color: UIColor,
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
    // 定义一个计数颜色类，用于存储颜色和其出现的次数
    class CountedColor {
        let color: UIColor
        let count: Int

        init(color: UIColor, count: Int) {
            self.color = color
            self.count = count
        }
    }

    /// 获取图片背景、主要、次要和细节颜色
    /// - Parameter scaleDownSize: 指定图片大小以便缩小图片进行颜色分析
    /// - Returns: 返回背景、主要、次要和细节颜色
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let colors = image?.dd_colors(scaleDownSize: CGSize(width: 100, height: 100))
    /// // colors: 返回图片的背景、主要、次要、细节颜色
    /// ```
    func dd_colors(scaleDownSize: CGSize? = nil) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
        let cgImage: CGImage

        // 如果传入了缩放尺寸，则使用该尺寸，否则使用默认尺寸
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

        // 排序函数，按颜色出现的次数排序
        let sortComparator: (CountedColor, CountedColor) -> Bool = { a, b -> Bool in
            a.count <= b.count
        }

        // 遍历图片像素，收集颜色信息
        for x in 0 ..< width {
            for y in 0 ..< height {
                let pixel = ((width * y) + x) * bytesPerPixel
                let color = UIColor(
                    red: CGFloat(data?[pixel + 1] ?? 0) / 255,
                    green: CGFloat(data?[pixel + 2] ?? 0) / 255,
                    blue: CGFloat(data?[pixel + 3] ?? 0) / 255,
                    alpha: 1
                )

                // 将背景区域的颜色添加到背景颜色集合
                if x >= 5, x <= 10 {
                    imageBackgroundColors.add(color)
                }

                // 将所有颜色添加到颜色集合
                imageColors.add(color)
            }
        }

        var sortedColors = [CountedColor]()

        // 过滤背景颜色
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

        if proposedEdgeColor.color.dd_isBlackOrWhite, !sortedColors.isEmpty {
            for countedColor in sortedColors where CGFloat(countedColor.count / proposedEdgeColor.count) > 0.3 {
                if !countedColor.color.dd_isBlackOrWhite {
                    proposedEdgeColor = countedColor
                    break
                }
            }
        }

        let imageBackgroundColor = proposedEdgeColor.color
        let isDarkBackground = imageBackgroundColor.dd_isDark

        sortedColors.removeAll()

        // 根据背景色过滤其他颜色
        for imageColor in imageColors {
            guard let imageColor = imageColor as? UIColor else { continue }

            let color = imageColor.dd_saturation(0.15)

            if color.dd_isDark == !isDarkBackground {
                let colorCount = imageColors.count(for: color)
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }

        sortedColors.sort(by: sortComparator)

        var primaryColor, secondaryColor, detailColor: UIColor?

        // 分配主要色、次要色、细节色
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
            primaryColor ?? (isDarkBackground ? whiteColor : blackColor),
            secondaryColor ?? (isDarkBackground ? whiteColor : blackColor),
            detailColor ?? (isDarkBackground ? whiteColor : blackColor)
        )
    }

    /// 获取图片主题颜色
    /// - Parameter completion: 完成回调，返回主题颜色
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// image?.dd_themeColor { color in
    ///     // 获取到的主题颜色
    /// }
    /// ```
    func dd_themeColor(_ completion: @Sendable @escaping (_ color: UIColor?) -> Void) {
        DispatchQueue.global().async {
            if self.cgImage == nil { DispatchQueue.main.async { completion(nil) }}
            let bitmapInfo = CGBitmapInfo(rawValue: 0).rawValue | CGImageAlphaInfo.premultipliedLast.rawValue

            // 步骤 1：将图片缩小，以加速计算过程
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

            // 步骤 2：提取每个像素点的颜色值
            if context.data == nil { return completion(nil) }
            let countedSet = NSCountedSet(capacity: Int(thumbSize.width * thumbSize.height))
            for x in 0 ..< Int(thumbSize.width) {
                for y in 0 ..< Int(thumbSize.height) {
                    let offset = 4 * x * y
                    let red = context.data!.load(fromByteOffset: offset, as: UInt8.self)
                    let green = context.data!.load(fromByteOffset: offset + 1, as: UInt8.self)
                    let blue = context.data!.load(fromByteOffset: offset + 2, as: UInt8.self)
                    let alpha = context.data!.load(fromByteOffset: offset + 3, as: UInt8.self)
                    // 过滤掉透明、近白色和近黑色的颜色
                    if alpha > 0, red < 250, green < 250, blue < 250, red > 5, green > 5, blue > 5 {
                        let array = [red, green, blue, alpha]
                        countedSet.add(array)
                    }
                }
            }

            // 步骤 3：找到出现频率最高的颜色
            let enumerator = countedSet.objectEnumerator()
            var maxColor: [Int] = []
            var maxCount = 0
            while let curColor = enumerator.nextObject() as? [Int], !curColor.isEmpty {
                let tmpCount = countedSet.count(for: curColor)
                if tmpCount > maxCount {
                    maxCount = tmpCount
                    maxColor = curColor
                }
            }

            // 通过频率最高的颜色作为主题颜色返回
            DispatchQueue.main.async {
                completion(UIColor(red: CGFloat(maxColor[0]) / 255.0,
                                   green: CGFloat(maxColor[1]) / 255.0,
                                   blue: CGFloat(maxColor[2]) / 255.0,
                                   alpha: CGFloat(maxColor[3]) / 255.0))
            }
        }
    }

    /// 获取图像的平均颜色
    /// - Returns: 返回图像的平均颜色 `UIColor`，如果无法计算则返回 nil
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let avgColor = image?.dd_averageColor()
    /// // avgColor: 返回图像的平均颜色
    /// ```
    func dd_averageColor() -> UIColor? {
        guard let ciImage = ciImage ?? CIImage(image: self) else { return nil }

        // 使用CIAreaAverage滤镜计算图像区域的平均颜色
        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }

        // 提取平均颜色的像素数据
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

    /// 获取图片某个位置像素的颜色
    /// - Parameter point: 图片上某个点的坐标
    /// - Returns: 返回该点的 `UIColor`，如果坐标无效则返回 nil
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let color = image?.dd_pixelColor(CGPoint(x: 50, y: 100))
    /// // color: 返回该点的颜色
    /// ```
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

    /// 异步获取指定 CGPoint 位置的颜色
    /// - Parameter point: 图片上某个点的坐标
    /// - Parameter completion: 完成回调，返回该点的颜色
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// image?.dd_pixelColor(at: CGPoint(x: 50, y: 100)) { color in
    ///     // 处理返回的颜色
    /// }
    /// ```
    func dd_pixelColor(at point: CGPoint, completion: @Sendable @escaping (UIColor?) -> Void) {
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

    /// 设置图片的透明度
    /// - Parameter alpha: 透明度值 (0.0 到 1.0)
    /// - Returns: 设置透明度后的 `UIImage`
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let newImage = image?.dd_imageAlpha(0.5)
    /// // newImage: 透明度设置为 0.5 的新图像
    /// ```
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

    /// 用指定颜色填充 `UIImage`
    /// - Parameter color: 用于填充的颜色
    /// - Returns: 用指定颜色填充的 `UIImage`
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let filledImage = image?.dd_filled(with: .red)
    /// // filledImage: 使用红色填充的图像
    /// ```
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

    /// 设置图片的背景颜色
    /// - Parameter backgroundColor: 背景颜色
    /// - Returns: 设置了背景颜色的 `UIImage`
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let newImage = image?.dd_backgroundColor(.blue)
    /// // newImage: 设置了蓝色背景的图像
    /// ```
    func dd_backgroundColor(_ backgroundColor: UIColor) -> UIImage {
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

    /// 使用指定颜色为 `UIImage` 着色
    /// - Parameters:
    ///   - color: 用于着色的颜色
    ///   - blendMode: 混合模式
    ///   - alpha: 用于绘制的透明度值
    /// - Returns: 使用给定颜色和混合模式着色的 `UIImage`
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let tintedImage = image?.dd_tint(.red, blendMode: .multiply)
    /// // tintedImage: 使用红色和乘法混合模式着色的图像
    /// ```
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

    /// 渲染图片颜色 (默认: `.alwaysOriginal`)
    /// - Parameters:
    ///   - color: 渲染颜色
    ///   - renderingMode: 渲染模式
    /// - Returns: 渲染后的 `UIImage`
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func dd_tintColor(with color: UIColor, renderingMode: RenderingMode = .alwaysOriginal) -> UIImage {
        withTintColor(color, renderingMode: renderingMode)
    }
}

// MARK: - 背景透明化处理
public extension UIImage {
    /// 返回一个将白色背景变透明的图片
    /// - Returns: 处理后的 `UIImage?`，白色背景已变透明
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let transparentImage = image?.dd_removeWhiteBackground()
    /// // transparentImage: 白色背景变透明后的图像
    /// ```
    func dd_removeWhiteBackground() -> UIImage? {
        // 白色背景的颜色范围
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return dd_makeBackgroundTransparent(forColorMasking: colorMasking)
    }

    /// 返回一个将黑色背景变透明的图片
    /// - Returns: 处理后的 `UIImage?`，黑色背景已变透明
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let transparentImage = image?.dd_removeBlackBackground()
    /// // transparentImage: 黑色背景变透明后的图像
    /// ```
    func dd_removeBlackBackground() -> UIImage? {
        // 黑色背景的颜色范围
        let colorMasking: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return dd_makeBackgroundTransparent(forColorMasking: colorMasking)
    }

    /// 将图片中的指定颜色背景变为透明
    /// - Parameter colorMasking: 要透明的颜色范围（以RGB分量表示）
    /// - Returns: 处理后的 `UIImage?`，指定颜色背景变透明后的图像
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let transparentImage = image?.dd_makeBackgroundTransparent(forColorMasking: [0, 32, 0, 32, 0, 32])
    /// // transparentImage: 处理后指定颜色透明的图像
    /// ```
    func dd_makeBackgroundTransparent(forColorMasking colorMasking: [CGFloat]) -> UIImage? {
        defer { UIGraphicsEndImageContext() }

        guard let rawImageRef = cgImage else { return nil }
        guard let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) else { return nil }

        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // 进行图像上下翻转，以匹配绘制坐标系
        context.translateBy(x: 0.0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - 模糊和像素化效果
public extension UIImage {
    /// 应用高斯模糊效果
    /// - Parameter blurRadius: 模糊半径，数值越大，模糊效果越强
    /// - Returns: 处理后的 `UIImage?`，高斯模糊效果
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let blurredImage = image?.dd_applyGaussianBlur(withRadius: 30)
    /// // blurredImage: 应用高斯模糊后的图像
    /// ```
    func dd_applyGaussianBlur(withRadius blurRadius: CGFloat = 20) -> UIImage? {
        return dd_applyBlurEffect(withRadius: blurRadius, filterName: "CIGaussianBlur")
    }

    /// 应用像素化效果
    /// - Parameter pixelationRadius: 像素化半径，数值越大，像素化效果越强
    /// - Returns: 处理后的 `UIImage?`，像素化效果
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let pixelatedImage = image?.dd_applyPixelationEffect(withRadius: 30)
    /// // pixelatedImage: 应用像素化效果后的图像
    /// ```
    func dd_applyPixelationEffect(withRadius pixelationRadius: CGFloat = 20) -> UIImage? {
        return dd_applyBlurEffect(withRadius: pixelationRadius, filterName: "CIPixellate")
    }

    /// 应用模糊或像素化效果
    /// - Parameters:
    ///   - blurRadius: 模糊半径或像素化半径
    ///   - filterName: 滤镜类型（例如 "CIGaussianBlur" 或 "CIPixellate"）
    /// - Returns: 处理后的 `UIImage?`，应用了模糊或像素化效果的图像
    private func dd_applyBlurEffect(withRadius blurRadius: CGFloat, filterName: String) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }

        // 创建指定类型的滤镜
        guard let blurFilter = CIFilter(name: filterName) else { return nil }
        blurFilter.setValue(ciImage, forKey: kCIInputImageKey)

        // 设置模糊半径
        blurFilter.setValue(blurRadius, forKey: filterName == "CIPixellate" ? kCIInputScaleKey : kCIInputRadiusKey)

        guard let outputImage = blurFilter.outputImage else { return nil }

        // 创建上下文
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }
}

// MARK: - Core Image
public extension UIImage {
    /// 滤镜类型枚举，包含常用的图片滤镜效果
    enum FilterName: String {
        case CISepiaTone // 棕褐色复古滤镜 (老照片效果)
        case CIPhotoEffectNoir // 黑白效果滤镜
    }

    /// 给图片添加滤镜效果
    /// - Parameters:
    ///   - filterName: 滤镜类型（参考 `FilterName` 枚举）
    ///   - alpha: 透明度，影响滤镜效果的强度（可选）
    /// - Returns: 应用滤镜后的 `UIImage?`
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let sepiaImage = image?.dd_applyFilter(.CISepiaTone, alpha: 0.8)
    /// // sepiaImage: 添加复古滤镜后的图像
    /// ```
    func dd_applyFilter(_ filterName: FilterName, alpha: CGFloat? = nil) -> UIImage? {
        guard let imageData = pngData() else { return nil }
        let inputImage = CIImage(data: imageData)
        let context = CIContext(options: nil)

        guard let filter = CIFilter(name: filterName.rawValue) else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if let alpha { filter.setValue(alpha, forKey: "inputIntensity") }

        guard let outputImage = filter.outputImage else { return nil }
        guard let outImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }

        return UIImage(cgImage: outImage)
    }

    /// 将整张图片进行马赛克处理
    /// - Parameter value: 马赛克像素值，数值越大，马赛克效果越明显
    /// - Returns: 处理后的 `UIImage?`，带有马赛克效果
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let pixelatedImage = image?.dd_applyPixelation(value: 10)
    /// // pixelatedImage: 添加马赛克效果后的图像
    /// ```
    func dd_applyPixelation(value: Int? = nil) -> UIImage? {
        guard let filter = CIFilter(name: "CIPixellate") else { return nil }
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if let value { filter.setValue(value, forKey: kCIInputScaleKey) }

        guard let fullPixelatedImage = filter.outputImage else { return nil }
        guard let cgImage = context.createCGImage(fullPixelatedImage, from: fullPixelatedImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }

    /// 检测图片中的人脸，并返回所有人脸的矩形区域
    /// - Returns: 所有检测到的人脸的矩形框 `CGRect` 数组
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let faces = image?.dd_detectFaces()
    /// // faces: 检测到的人脸矩形数组
    /// ```
    func dd_detectFaces() -> [CGRect]? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let context = CIContext(options: nil)

        // 使用高精度的人脸检测器
        let detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: context,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

        var faceFeatures: [CIFaceFeature]!

            // 使用图片元数据来处理图片方向
            = if let orientation = inputImage.properties[kCGImagePropertyOrientation as String]
        {
            detector?.features(in: inputImage, options: [CIDetectorImageOrientation: orientation]) as? [CIFaceFeature]
        } else {
            detector?.features(in: inputImage) as? [CIFaceFeature]
        }

        var rects: [CGRect] = []
        let inputImageSize = inputImage.extent.size
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -inputImageSize.height)

        // 遍历检测到的人脸，获取其框选的矩形区域
        for faceFeature in faceFeatures {
            let faceViewBounds = faceFeature.bounds.applying(transform)
            rects.append(faceViewBounds)
        }

        return rects
    }

    /// 检测人脸并对每张人脸应用马赛克效果
    /// - Returns: 马赛克处理后的人脸图像 `UIImage?`
    ///
    /// 示例:
    /// ```swift
    /// let image = UIImage(named: "example.png")
    /// let resultImage = image?.dd_detectAndPixelateFaces()
    /// // resultImage: 人脸已被马赛克处理后的图像
    /// ```
    func dd_detectAndPixelateFaces() -> UIImage? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let context = CIContext(options: nil)

        // 对原图进行全图马赛克
        let filter = CIFilter(name: "CIPixellate")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let inputScale = max(inputImage.extent.size.width, inputImage.extent.size.height) / 80
        filter.setValue(inputScale, forKey: kCIInputScaleKey)
        guard let fullPixelatedImage = filter.outputImage else { return nil }

        // 检测人脸
        guard let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: nil) else { return nil }
        let faceFeatures = detector.features(in: inputImage)

        // 初始化蒙版图
        var maskImage: CIImage!
        for faceFeature in faceFeatures {
            // 为每个人脸位置创建一个渐变蒙版
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

            // 裁剪蒙版
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

        // 使用蒙版混合马赛克和原图
        let blendFilter = CIFilter(name: "CIBlendWithMask")!
        blendFilter.setValue(fullPixelatedImage, forKey: kCIInputImageKey)
        blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)

        guard let blendOutputImage = blendFilter.outputImage,
              let blendCGImage = context.createCGImage(blendOutputImage, from: blendOutputImage.extent)
        else {
            return nil
        }

        return UIImage(cgImage: blendCGImage)
    }
}

// MARK: - 渐变
public extension UIImage {
    // 渐变方向枚举，定义了不同的渐变方向
    enum GradientDirection {
        case horizontal // 水平从左到右
        case vertical // 垂直从上到下
        case leftOblique // 左上到右下
        case rightOblique // 右上到左下
        case other(CGPoint, CGPoint) // 自定义

        /// 获取渐变的起始和结束点
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
            case let .other(start, end):
                return (start, end)
            }
        }
    }

    /// 生成渐变色的图片 [如："#B0E0E6", "#00CED1", "#2E8B57"]
    /// 该方法通过传入十六进制颜色字符串数组来创建渐变色的图片。
    /// - Parameters:
    ///   - hexsString: 十六进制颜色字符串数组（例如：["#B0E0E6", "#00CED1", "#2E8B57"]）
    ///   - size: 图片大小，默认值为 CGSize(width: 1, height: 1)
    ///   - locations: 渐变色的位置数组，默认值为 [0, 1]
    ///   - direction: 渐变的方向，默认为 .horizontal（水平方向）
    /// - Returns: 渐变的图片，返回 `UIImage?` 类型，可能为 nil
    ///
    /// 示例：
    /// ```swift
    /// let gradientImage = UIImage.dd_createLinearGradient(
    ///     ["#B0E0E6", "#00CED1", "#2E8B57"],
    ///     size: CGSize(width: 200, height: 200),
    ///     direction: .vertical
    /// )
    /// ```
    static func dd_createLinearGradient(_ hexsString: [String],
                                        size: CGSize = CGSize(width: 1, height: 1),
                                        locations: [CGFloat]? = [0, 1],
                                        direction: GradientDirection = .horizontal) -> UIImage?
    {
        return self.dd_createLinearGradient(hexsString.map { UIColor(hex: $0) }, size: size, locations: locations, direction: direction)
    }

    /// 生成渐变色的图片 [如：UIColor, UIColor, UIColor]
    /// 该方法通过传入 UIColor 数组来创建渐变色的图片。
    /// - Parameters:
    ///   - colors: UIColor 数组（例如：[UIColor.red, UIColor.green, UIColor.blue]）
    ///   - size: 图片大小，默认值为 CGSize(width: 10, height: 10)
    ///   - locations: 渐变色的位置数组，默认值为 [0, 1]
    ///   - direction: 渐变的方向，默认为 .horizontal（水平方向）
    /// - Returns: 渐变的图片，返回 `UIImage?` 类型，可能为 nil
    ///
    /// 示例：
    /// ```swift
    /// let gradientImage = UIImage.dd_createLinearGradient(
    ///     [UIColor.red, UIColor.green, UIColor.blue],
    ///     size: CGSize(width: 200, height: 200),
    ///     direction: .leftOblique
    /// )
    /// ```
    static func dd_createLinearGradient(_ colors: [UIColor],
                                        size: CGSize = CGSize(width: 10, height: 10),
                                        locations: [CGFloat]? = [0, 1],
                                        direction: GradientDirection = .horizontal) -> UIImage?
    {
        return self.dd_createLinearGradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }

    /// 生成带圆角渐变色的图片 [如：UIColor, UIColor, UIColor]
    /// 该方法通过传入 UIColor 数组和圆角半径来创建带圆角的渐变色图片。
    /// - Parameters:
    ///   - colors: UIColor 数组（例如：[UIColor.red, UIColor.green, UIColor.blue]）
    ///   - size: 图片大小，默认值为 CGSize(width: 10, height: 10)
    ///   - radius: 圆角半径，必须提供
    ///   - locations: 渐变色的位置数组，默认值为 [0, 1]
    ///   - direction: 渐变的方向，默认为 .horizontal（水平方向）
    /// - Returns: 带圆角的渐变的图片，返回 `UIImage?` 类型，可能为 nil
    ///
    /// 示例：
    /// ```swift
    /// let gradientImageWithRadius = UIImage.dd_createLinearGradient(
    ///     [UIColor.red, UIColor.green, UIColor.blue],
    ///     size: CGSize(width: 200, height: 200),
    ///     radius: 20,
    ///     direction: .vertical
    /// )
    /// ```
    static func dd_createLinearGradient(_ colors: [UIColor],
                                        size: CGSize = CGSize(width: 10, height: 10),
                                        radius: CGFloat,
                                        locations: [CGFloat]? = [0, 1],
                                        direction: GradientDirection = .horizontal) -> UIImage?
    {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return self.dd_makeImage(with: colors[0])
        }

        // 开始绘制上下文
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()

        // 设置圆角路径
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)

        // 创建渐变
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map(\.cgColor) as CFArray, locations: locations?.map { CGFloat($0) }) else {
            return nil
        }

        // 获取渐变的起始和结束点
        let directionPoint = direction.point(size: size)

        // 绘制渐变
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)

        // 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - 图片加载
public extension UIImage {
    /// 加载图片资源
    /// - Parameter image: 图片资源的路径，可以是网络地址（URL）或本地路径（Bundle中的图片）
    /// - Returns: 加载后的图片，返回 `UIImage?` 类型，可能为 nil
    ///
    /// 示例：
    /// ```swift
    /// // 加载网络图片
    /// let image = UIImage.dd_loadImage(with: "https://example.com/image.png")
    /// // 加载本地图片
    /// let image = UIImage.dd_loadImage(with: "myImageName")
    /// ```
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

    /// 使用 `data` 加载 `Gif` 图片
    /// - Parameter data: 图片数据，通常是 `Data` 类型
    /// - Returns: 加载的 `UIImage?` 类型的 `Gif` 图片
    ///
    /// 示例：
    /// ```swift
    /// if let data = try? Data(contentsOf: gifURL) {
    ///     let gifImage = UIImage.dd_loadImageWithGif(data: data)
    /// }
    /// ```
    static func dd_loadImageWithGif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        return dd_animatedImageWithSource(source)
    }

    /// 从 `URL` 中加载 `Gif` 图片
    /// - Parameter url: 图片 `URL` 地址
    /// - Returns: 加载的 `UIImage?` 类型的 `Gif` 图片
    ///
    /// 示例：
    /// ```swift
    /// let gifImage = UIImage.dd_loadImageWithGif(url: "https://example.com/animation.gif")
    /// ```
    static func dd_loadImageWithGif(url: String) -> UIImage? {
        guard let bundleURL = URL(string: url) else { return nil }
        guard let imageData = try? Data(contentsOf: bundleURL) else { return nil }
        return dd_loadImageWithGif(data: imageData)
    }

    /// 从 `Bundle` 中加载 `Gif` 图片
    /// - Parameter name: 图片的名字
    /// - Returns: 加载的 `UIImage?` 类型的 `Gif` 图片
    ///
    /// 示例：
    /// ```swift
    /// let gifImage = UIImage.dd_loadImageWithGif(name: "myGifImage")
    /// ```
    static func dd_loadImageWithGif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif")
        else {
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else { return nil }

        return dd_loadImageWithGif(data: imageData)
    }

    /// 使用 `NSDataAsset` 加载图片
    /// - Parameter asset: `NSDataAsset` 的名字
    /// - Returns: 加载的 `UIImage?` 类型的 `Gif` 图片
    @available(iOS 9.0, *)
    static func dd_loadImageWithGif(asset: String) -> UIImage? {
        guard let dataAsset = NSDataAsset(name: asset) else { return nil }
        return dd_loadImageWithGif(data: dataAsset.data)
    }

    /// 从 `Gif` 中获取每一帧及动画时长
    /// - Parameter asset: `NSDataAsset` 的名字
    /// - Returns: 每一帧的 `UIImage` 数组和动画时长
    ///
    /// 示例：
    /// ```swift
    /// let (frames, duration) = UIImage.dd_frameInfoWithGif(asset: "animatedGif")
    /// ```
    static func dd_frameInfoWithGif(asset: String) -> (images: [UIImage]?, duration: TimeInterval?) {
        guard let dataAsset = NSDataAsset(name: asset) else { return (nil, nil) }
        guard let source = CGImageSourceCreateWithData(dataAsset.data as CFData, nil) else {
            return (nil, nil)
        }
        return dd_animatedImageSources(source)
    }

    /// 从 `Bundle` 中获取 `Gif` 图片的每一帧及动画时长
    /// - Parameter name: `Gif` 图片的名字
    /// - Returns: 每一帧的 `UIImage` 数组和动画时长
    ///
    /// 示例：
    /// ```swift
    /// let (frames, duration) = UIImage.dd_frameInfoWithGif(name: "animatedGif")
    /// ```
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

    /// 从 `URL` 中获取 `Gif` 图片的每一帧及动画时长
    /// - Parameter url: `Gif` 图片的 URL 地址
    /// - Returns: 每一帧的 `UIImage` 数组和动画时长
    ///
    /// 示例：
    /// ```swift
    /// let (frames, duration) = UIImage.dd_frameInfoWithGif(url: "https://example.com/animation.gif")
    /// ```
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

    /// 获取 `Gif` 转化动画的 `UIImage?`
    /// - Parameter source: `CGImageSource` 源
    /// - Returns: 转化为 `UIImage` 的动画
    private static func dd_animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let info = dd_animatedImageSources(source)
        guard let frames = info.images, let duration = info.duration else { return nil }
        let animation = UIImage.animatedImage(with: frames, duration: duration)
        return animation
    }

    /// 获取 `Gif` 图片每一帧及动画时长
    /// - Parameter source: `CGImageSource` 资源
    /// - Returns: 包含每帧图片的数组和动画时长
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
    /// - Returns: 添加了水印的 `UIImage`
    ///
    /// 示例：
    /// ```swift
    /// let watermarkedImage = originalImage.dd_drawWatermark(with: "水印文字", attributes: [.font: UIFont.boldSystemFont(ofSize: 24)], frame: CGRect(x: 20, y: 20, width: 200, height: 50))
    /// ```
    func dd_drawWatermark(with text: String, attributes: [NSAttributedString.Key: Any]?, frame: CGRect) -> UIImage {
        // 开启图片上下文
        UIGraphicsBeginImageContext(size)
        // 图形重绘
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // 绘制文字
        text.dd_toNSString().draw(in: frame, withAttributes: attributes)
        // 从当前上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()

        return image!
    }

    /// 给图片添加图片水印
    /// - Parameters:
    ///   - rect: 水印图片的位置
    ///   - image: 水印图片
    /// - Returns: 带有水印的图片
    ///
    /// 示例：
    /// ```swift
    /// let watermarkedImage = originalImage.dd_addImageWatermark(rect: CGRect(x: 50, y: 50, width: 100, height: 100), image: watermarkImage)
    /// ```
    func dd_addImageWatermark(rect: CGRect, image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 创建文字占位符图片
    /// - Parameters:
    ///   - text: 图片上的文字
    ///   - size: 图片的大小
    ///   - backgroundColor: 图片背景色
    ///   - textColor: 文字颜色
    ///   - isCircle: 是否要圆角
    ///   - isFirstChar: 是否展示第一个字符
    /// - Returns: 生成的图片
    ///
    /// 示例：
    /// ```swift
    /// let placeholderImage = UIImage.dd_textImage("A", size: (100, 100), backgroundColor: .blue, textColor: .white)
    /// ```
    static func dd_textImage(_ text: String, fontSize: CGFloat = 16, size: (CGFloat, CGFloat), backgroundColor: UIColor = UIColor.orange, textColor: UIColor = UIColor.white, isCircle: Bool = true, isFirstChar: Bool = false) -> UIImage? {
        // 过滤空内容
        if text.isEmpty { return nil }
        // 取第一个字符
        let letter = isFirstChar ? (text as NSString).substring(to: 1) : text
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)

        let textsize = text.dd_calculateSize(for: AppDimensions.screenWidth, font: .systemFont(ofSize: fontSize))

        // 开启上下文
        UIGraphicsBeginImageContext(sise)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 取较小的边
        let minSide = min(size.0, size.1)
        // 是否圆角裁剪
        if isCircle {
            UIBezierPath(roundedRect: rect, cornerRadius: minSide * 0.5).addClip()
        }
        // 设置填充颜色
        ctx.setFillColor(backgroundColor.cgColor)
        ctx.fill(rect)
        let attr = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        // 写入文字
        let pointX: CGFloat = textsize.width > minSide ? 0 : (minSide - textsize.width) / 2.0
        let pointY: CGFloat = (minSide - fontSize - 4) / 2.0
        (letter as NSString).draw(at: CGPoint(x: pointX, y: pointY), withAttributes: attr)
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - 保存图片
public extension UIImage {
    /// 保存图片到相册
    /// - Parameter completion: 完成回调
    ///
    /// 示例：
    /// ```swift
    /// originalImage.dd_saveImageToPhotoAlbum { success in
    ///     if success {
    ///         print("图片已保存")
    ///     } else {
    ///         print("保存失败")
    ///     }
    /// }
    /// ```
    func dd_saveImageToPhotoAlbum(_ completion: ((Bool) -> Void)?) {
        self.onCompletion = completion
        UIImageWriteToSavedPhotosAlbum(self,
                                       self,
                                       #selector(saveImage(image:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }

    /// 保存图片到相册（使用 `PHPhotoLibrary`）
    /// - Parameter completion: 完成回调，返回保存成功与否和错误信息
    ///
    /// 示例：
    /// ```swift
    /// originalImage.dd_savePhotosImageToAlbum { success, error in
    ///     if success {
    ///         print("图片保存成功")
    ///     } else {
    ///         print("保存失败：\(error?.localizedDescription ?? "未知错误")")
    ///     }
    /// }
    /// ```
    func dd_savePhotosImageToAlbum(completion: @escaping ((Bool, Error?) -> Void)) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: self)
        } completionHandler: { (isSuccess: Bool, error: Error?) in
            completion(isSuccess, error)
        }
    }

    /// 保存图片完成回调
    private var onCompletion: ((Bool) -> Void)? {
        get { AttributeBinder.retrieve(self, forKey: AssociateKeys.saveBlockKey!) }
        set {
            AttributeBinder.bind(
                to: self,
                withKey: AssociateKeys.saveBlockKey!,
                value: newValue,
                usingPolicy: .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
        }
    }

    /// 保存图片结果
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            self.onCompletion?(false)
        } else {
            self.onCompletion?(true)
        }
    }
}

// MARK: - 方法
public extension UIImage {
    /// 平铺图片
    /// - Parameter size: 平铺区域的大小
    /// - Returns: 平铺后的图片
    ///
    /// 示例：
    /// ```swift
    /// let tiledImage = originalImage.dd_imageTile(size: CGSize(width: 300, height: 300))
    /// ```
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

    /// 获取图片的尺寸
    /// - Parameters:
    ///   - url: 图片的 URL 地址
    ///   - max: 最大边的长度
    /// - Returns: 返回根据最大边限制的图片尺寸
    ///
    /// 示例：
    /// ```swift
    /// let imageSize = UIImage.dd_imageSize(url: imageUrl, max: 500)
    /// ```
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
