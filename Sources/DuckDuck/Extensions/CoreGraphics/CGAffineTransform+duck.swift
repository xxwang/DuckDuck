//
//  CGAffineTransform+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGAffineTransform {
    /// `CGAffineTransform`转换为`CATransform3D`
    func dd_CATransform3D() -> CATransform3D {
        return CATransform3DMakeAffineTransform(self)
    }
}
