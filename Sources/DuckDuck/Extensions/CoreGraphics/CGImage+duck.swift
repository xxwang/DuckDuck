//
//  CGImage+duck.swift
//  
//
//  Created by 王哥 on 2024/7/10.
//

import CoreGraphics
import UIKit

extension CGImage: DDExtensionable {}

// MARK: - 计算属性
public extension DDExtension where Base: CGImage {
    /// `CGImage`转`UIImage`
    var as2UIImage: UIImage? {
        return UIImage(cgImage: self.base)
    }
}
