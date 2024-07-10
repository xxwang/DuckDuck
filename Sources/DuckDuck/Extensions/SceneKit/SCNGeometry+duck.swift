//
//  SCNGeometry+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import SceneKit
import UIKit

// MARK: - 属性
public extension DDExtension where Base: SCNGeometry {
    /// 返回几何体边界框的大小
    var boundingSize: SCNVector3 {
        return (self.base.boundingBox.max - self.base.boundingBox.min).dd.abs
    }
}
