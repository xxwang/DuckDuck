//
//  CGAffineTransform+duck.swift
//  
//
//  Created by 王哥 on 2024/7/10.
//

import CoreGraphics
import UIKit

extension CGAffineTransform: DDExtensionable {}

// MARK: - 计算属性
public extension DDExtension where Base == CGAffineTransform {
    /// `CGAffineTransform`转换为`CATransform3D`
    var as2CATransform3D: CATransform3D {
        return CATransform3DMakeAffineTransform(self.base)
    }
}
