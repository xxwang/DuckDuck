//
//  CGColor+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGColor {
    /// `CGColor`转`UIColor`
    func dd_UIColor() -> UIColor {
        return UIColor(cgColor: self)
    }
}
