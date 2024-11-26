//
//  CGImage++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGImage {
    /// 将 `CGImage` 转换为 `UIImage`
    ///
    /// 该方法将一个 `CGImage` 对象转换为 `UIImage`，可以方便地在 UIKit 中进行图像处理和显示。
    ///
    /// - Returns: 返回一个 `UIImage` 对象。如果转换失败，则返回 `nil`。
    ///
    /// - Example:
    ///     ```swift
    ///     guard let cgImage = someCGImage else { return }
    ///     let uiImage = cgImage.dd_toUIImage()
    ///     // uiImage 现在是一个可用于 UIKit 的 UIImage 对象
    ///     ```
    func dd_toUIImage() -> UIImage? {
        return UIImage(cgImage: self)
    }
}
