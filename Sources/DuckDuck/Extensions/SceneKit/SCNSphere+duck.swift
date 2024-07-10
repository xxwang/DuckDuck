//
//  SCNSphere+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNSphere {
    /// 创建具有指定`直径`的`球体几何体`
    ///
    /// - Parameter diameter:球体在其局部坐标空间中的直径
    convenience init(diameter: CGFloat) {
        self.init(radius: diameter / 2)
    }

    /// 创建具有指定`半径`和`材质`的`球体几何体`
    /// - Parameters:
    ///   - radius:球体在其局部坐标空间中的半径
    ///   - material:几何体的材质
    convenience init(radius: CGFloat, material: SCNMaterial) {
        self.init(radius: radius)
        self.materials = [material]
    }

    /// 创建具有指定`半径`和`材质颜色`的`球体几何体`
    /// - Parameters:
    ///   - radius:球体在其局部坐标空间中的半径
    ///   - color:几何体材质的颜色
    convenience init(radius: CGFloat, color: UIColor) {
        self.init(radius: radius, material: SCNMaterial(color: color))
    }

    /// 创建具有指定`直径`和`材质`的`球体几何体`
    /// - Parameters:
    ///   - diameter:球体在其局部坐标空间中的直径
    ///   - material:几何体的材质
    convenience init(diameter: CGFloat, material: SCNMaterial) {
        self.init(radius: diameter / 2)
        self.materials = [material]
    }

    /// 创建具有指定`直径`和`材质颜色`的`球体几何体`
    /// - Parameters:
    ///   - diameter:球体在其局部坐标空间中的直径
    ///   - color:几何体材质的颜色
    convenience init(diameter: CGFloat, color: UIColor) {
        self.init(diameter: diameter, material: SCNMaterial(color: color))
    }
}
