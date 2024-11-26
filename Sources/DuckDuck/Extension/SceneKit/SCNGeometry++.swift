//
//  SCNGeometry++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import SceneKit
import UIKit

// MARK: - 属性
public extension SCNGeometry {
    /// 返回几何体边界框的大小
    /// 该方法计算几何体的边界框的最大尺寸，忽略负值，返回正值的边界框大小。
    ///
    /// - Returns: 返回一个 `SCNVector3`，表示几何体的宽度、高度和深度。
    ///
    /// - Example:
    ///     ```swift
    ///     let geometry = SCNSphere(radius: 1)
    ///     let boundingSize = geometry.dd_boundingSize()
    ///     print(boundingSize)  // 输出几何体的边界框大小
    ///     ```
    func dd_boundingSize() -> SCNVector3 {
        // 计算边界框的最大尺寸，忽略负值，返回正值
        return (self.boundingBox.max - self.boundingBox.min).dd_abs()
    }
}
