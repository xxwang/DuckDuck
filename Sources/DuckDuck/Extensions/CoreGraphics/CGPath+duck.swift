//
//  CGPath+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreGraphics
import UIKit

extension CGPath: DDExtensionable {}
public extension DDExtension where Base: CGPath {
    /// 转换为可变路径
    var as2CGMutablePath: CGMutablePath {
        return CGMutablePath().dd_addPath(self.base)
    }
}
