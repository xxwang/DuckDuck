//
//  SCNGeometry+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import SceneKit
import UIKit

// MARK: - 属性
public extension SCNGeometry {
    /// 返回几何体边界框的大小
    func dd_boundingSize() -> SCNVector3 {
        return (self.boundingBox.max - self.boundingBox.min).dd_abs()
    }
}
