//
//  CGColor+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreGraphics
import UIKit

extension CGColor: DDExtensionable {}

// MARK: - 计算属性
public extension DDExtension where Base: CGColor {
    /// `CGColor`转`UIColor`
    var as2UIColor: UIColor {
        return UIColor(cgColor: self.base)
    }
}
