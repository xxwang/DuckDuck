//
//  CGPath+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGPath {
    /// 转换为可变路径
    func dd_CGMutablePath() -> CGMutablePath {
        return CGMutablePath().dd_addPath(self)
    }
}
