//
//  SKTexture++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import SpriteKit

extension SKTexture {
    /// 为纹理应用颜色滤镜
    /// - Parameter color: 颜色滤镜
    /// - Example:
    ///   ```swift
    ///   let tintedTexture = texture.dd_applyTint(.red)
    ///   sprite.texture = tintedTexture
    ///   ```
    func dd_applyTint(_ color: UIColor) -> SKTexture {
        let colorFilter = CIFilter(name: "CIColorMonochrome")
        colorFilter?.setValue(CIImage(image: UIImage(named: self.description)!), forKey: kCIInputImageKey)
        colorFilter?.setValue(CIColor(color: color), forKey: "inputColor")
        guard let outputImage = colorFilter?.outputImage?.cgImage else { return self }
        return SKTexture(cgImage: outputImage)
    }

    /// 调整纹理大小
    /// - Parameter size: 新的纹理大小
    /// - Example:
    ///   ```swift
    ///   let resizedTexture = texture.dd_resize(size: CGSize(width: 200, height: 200))
    ///   sprite.texture = resizedTexture
    ///   ```
    func dd_resize(size: CGSize) -> SKTexture {
        UIGraphicsBeginImageContext(size)
        UIImage(named: self.description)?.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return SKTexture(image: resizedImage!)
    }
}
