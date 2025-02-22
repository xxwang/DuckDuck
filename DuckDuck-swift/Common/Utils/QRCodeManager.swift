import CoreImage
import UIKit

public class QRCodeManager: NSObject {
    /// 单例实例
    public static let shared = QRCodeManager()

    override private init() {}
}

// MARK: - 二维码生成
public extension QRCodeManager {
    /// 创建二维码图片
    /// - Parameters:
    ///   - content: 二维码内容。不能为空的字符串。
    ///   - size: 二维码图片的大小，指定二维码的宽度和高度。
    ///   - logoImage: 可选，二维码中间显示的Logo图片。
    ///   - logoSize: 可选，Logo图片的大小，默认为二维码尺寸的20%。
    ///   - logoCornerRadius: 可选，Logo图片的圆角半径。
    /// - Returns: 生成的二维码图片，如果生成失败返回`nil`。
    ///
    /// - Example:
    /// ```swift
    /// if let qrCodeImage = QRCodeManager.shared.createQRCode(with: "Hello, World!", size: CGSize(width: 300, height: 300)) {
    ///     imageView.image = qrCodeImage
    /// } else {
    ///     print("生成二维码失败")
    /// }
    /// ```
    func createQRCode(with content: String, size: CGSize, logoImage: UIImage? = nil, logoSize: CGSize? = nil, logoCornerRadius: CGFloat? = nil) -> UIImage? {
        guard !content.isEmpty else {
            return nil
        }

        // 创建二维码生成滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = content.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")

        guard let outputImage = filter?.outputImage else {
            return nil
        }

        let extent = outputImage.extent.integral
        let scale = min(size.width / extent.width, size.height / extent.height)
        let context = CIContext()
        guard let bitmapImage = context.createCGImage(outputImage, from: extent) else {
            return nil
        }

        let cs = CGColorSpaceCreateDeviceGray()
        guard let bitmapRef = CGContext(data: nil, width: Int(extent.width * scale), height: Int(extent.height * scale), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
            return nil
        }

        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)

        guard let scaledImage = bitmapRef.makeImage() else {
            return nil
        }

        let finalImage = UIImage(cgImage: scaledImage)

        guard let logoImage, let logoSize else {
            return finalImage
        }

        var logo = logoImage
        if let cornerRadius = logoCornerRadius {
            logo = logoImage.dd_corner(size: logoSize, radius: cornerRadius)!
        }

        // 将Logo绘制到二维码中央
        UIGraphicsBeginImageContextWithOptions(finalImage.size, false, UIScreen.main.scale)
        finalImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        let logoWidth = logoSize.width
        let logoHeight = logoSize.height
        let logoX = (size.width - logoWidth) * 0.5
        let logoY = (size.height - logoHeight) * 0.5
        logo.draw(in: CGRect(x: logoX, y: logoY, width: logoWidth, height: logoHeight))

        let finalQRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return finalQRCodeImage
    }
}

// MARK: - 二维码解析
public extension QRCodeManager {
    /// 识别二维码内容
    /// - Parameter image: 二维码图片。
    /// - Returns: 识别到的二维码内容，若没有识别到二维码则返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// if let qrContent = QRCodeManager.shared.recognizeQRCode(from: qrCodeImage) {
    ///     print("二维码内容：\(qrContent)")
    /// } else {
    ///     print("未识别到二维码")
    /// }
    /// ```
    func recognizeQRCode(from image: UIImage) -> String? {
        guard let cgImage = image.cgImage else {
            return nil
        }

        let context = CIContext()
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: CIImage(cgImage: cgImage))

        guard let feature = features?.first as? CIQRCodeFeature else {
            return nil
        }

        return feature.messageString
    }

    /// 识别图片中的所有二维码
    /// - Parameter image: 包含二维码的图片。
    /// - Returns: 返回识别到的所有二维码内容的字符串数组。如果没有识别到二维码则返回空数组。
    ///
    /// - Example:
    /// ```swift
    /// let qrContents = QRCodeManager.shared.recognizeAllQRCodes(from: multiQRCodeImage)
    /// if !qrContents.isEmpty {
    ///     print("所有二维码内容：\(qrContents)")
    /// } else {
    ///     print("未识别到二维码")
    /// }
    /// ```
    func recognizeAllQRCodes(from image: UIImage) -> [String] {
        let features = self.readQRCodes(from: image)

        guard features.count > 0 else {
            return []
        }

        return features.map { $0.messageString ?? "" }
    }

    /// 从图片中读取所有二维码
    /// - Parameter image: 包含二维码的图片。
    /// - Returns: 返回识别到的所有二维码的`CIQRCodeFeature`对象数组。
    func readQRCodes(from image: UIImage) -> [CIQRCodeFeature] {
        guard let ciImage = CIImage(image: image),
              let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: CIContext(), options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature]
        else {
            return []
        }
        return features
    }
}
