//
//  CGImage+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGImage {
    /// `CGImage`转`UIImage`
    func dd_UIImage() -> UIImage? {
        return UIImage(cgImage: self)
    }
}
