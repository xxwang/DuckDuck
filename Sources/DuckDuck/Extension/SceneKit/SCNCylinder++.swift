//
//  SCNCylinder++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import SceneKit
import UIKit

// MARK: - SCNCylinder 构造方法扩展
public extension SCNCylinder {
    /// 创建具有指定`直径`和`高度`的`圆柱体几何体`
    /// - Parameters:
    ///   - diameter: 圆柱体的`圆形横截面`在其局部坐标空间的`x轴`和`z轴`尺寸中的`直径`
    ///   - height: 圆柱体沿其局部坐标空间`y轴`的`高度`
    /// - Example:
    ///   ```swift
    ///   let cylinder = SCNCylinder(diameter: 1.0, height: 2.0)
    ///   ```
    convenience init(diameter: CGFloat, height: CGFloat) {
        self.init(radius: diameter / 2, height: height)
    }

    /// 创建具有指定`半径`、`高度`和`材质`的`圆柱体几何体`
    /// - Parameters:
    ///   - radius: 在其局部坐标空间的`x轴`和`z轴`尺寸中的`圆形横截面`的`半径`
    ///   - height: 沿其局部坐标空间`y轴`的`高度`
    ///   - material: `SCNMaterial`材质
    /// - Example:
    ///   ```swift
    ///   let material = SCNMaterial()
    ///   material.diffuse.contents = UIColor.blue
    ///   let cylinder = SCNCylinder(radius: 1.0, height: 2.0, material: material)
    ///   ```
    convenience init(radius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(radius: radius, height: height)
        self.materials = [material]
    }

    /// 创建具有指定`直径`、`高度`和`材质`的`圆柱体几何体`
    /// - Parameters:
    ///   - diameter: 圆柱体的`圆形横截面`在其局部坐标空间的`x轴`和`z轴`尺寸中的`直径`
    ///   - height: 沿其局部坐标空间`y轴`的`高度`
    ///   - material: `SCNMaterial`材质
    /// - Example:
    ///   ```swift
    ///   let material = SCNMaterial()
    ///   material.diffuse.contents = UIColor.green
    ///   let cylinder = SCNCylinder(diameter: 1.0, height: 2.0, material: material)
    ///   ```
    convenience init(diameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(radius: diameter / 2, height: height)
        self.materials = [material]
    }

    /// 创建具有指定`半径`、`高度`和`材质颜色`的`圆柱体几何体`
    /// - Parameters:
    ///   - radius: 在其局部坐标空间的`x轴`和`z轴`尺寸中的`圆形横截面半径`
    ///   - height: 沿其局部坐标空间`y轴`的`高度`
    ///   - color: 材质颜色
    /// - Example:
    ///   ```swift
    ///   let cylinder = SCNCylinder(radius: 1.0, height: 2.0, color: UIColor.red)
    ///   ```
    convenience init(radius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(radius: radius, height: height)

        // 创建材质并设置颜色
        let material = SCNMaterial()
        material.diffuse.contents = color
        self.materials = [material]
    }

    /// 创建具有指定`直径`、`高度`和`材质颜色`的`圆柱体几何体`
    /// - Parameters:
    ///   - diameter: 圆柱体的`圆形横截面`在其局部坐标空间的`x轴`和`z轴`尺寸中的`直径`
    ///   - height: 沿其局部坐标空间`y轴`的`高度`
    ///   - color: 材质颜色
    /// - Example:
    ///   ```swift
    ///   let cylinder = SCNCylinder(diameter: 1.0, height: 2.0, color: UIColor.blue)
    ///   ```
    convenience init(diameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(radius: diameter / 2, height: height)

        // 创建材质并设置颜色
        let material = SCNMaterial()
        material.diffuse.contents = color
        self.materials = [material]
    }
}
