//
//  CGAffineTransform++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGAffineTransform {
    /// 将 `CGAffineTransform` 转换为 `CATransform3D`
    ///
    /// 该方法将一个 2D 的 `CGAffineTransform` 转换为 3D 的 `CATransform3D`，
    /// 使用 `CATransform3DMakeAffineTransform` 函数来执行转换。
    ///
    /// - Returns: 返回一个 `CATransform3D`，该值表示当前 `CGAffineTransform` 的 3D 转换结果。
    ///
    /// - Example:
    ///     ```swift
    ///     let affineTransform = CGAffineTransform(rotationAngle: .pi / 4)
    ///     let transform3D = affineTransform.dd_toCATransform3D()
    ///     print(transform3D)  // 输出3D转换后的结果
    ///     ```
    func dd_toCATransform3D() -> CATransform3D {
        return CATransform3DMakeAffineTransform(self)
    }
}
