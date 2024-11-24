//
//  SCNCapsule++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import SceneKit
import UIKit

// MARK: - SCNCapsule 构造方法扩展
public extension SCNCapsule {
    /// 创建具有指定`直径`和`高度`的`胶囊几何体`
    /// - Parameters:
    ///   - capDiameter: 胶囊圆柱形`主体`及其`半球形端部`的`直径`
    ///   - height: 胶囊沿其局部坐标空间`y轴`的`高度`
    /// - Example:
    ///   ```swift
    ///   let capsule = SCNCapsule(capDiameter: 2.0, height: 5.0)
    ///   ```
    convenience init(capDiameter: CGFloat, height: CGFloat) {
        self.init(capRadius: capDiameter / 2, height: height)
    }

    /// 创建具有指定`半径`和`高度`的`胶囊几何体`，并设置材质
    /// - Parameters:
    ///   - capRadius: 胶囊圆柱形`主体`及其`半球形端部`的`半径`
    ///   - height: 胶囊沿其局部坐标空间`y轴`的`高度`
    ///   - material: `SCNMaterial`材质
    /// - Example:
    ///   ```swift
    ///   let material = SCNMaterial()
    ///   material.diffuse.contents = UIColor.red
    ///   let capsule = SCNCapsule(capRadius: 1.0, height: 5.0, material: material)
    ///   ```
    convenience init(capRadius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(capRadius: capRadius, height: height)
        self.materials = [material]
    }

    /// 创建具有指定`直径`和`高度`的`胶囊几何体`，并设置材质
    /// - Parameters:
    ///   - capDiameter: 胶囊圆柱形`主体`及其`半球形端部`的`直径`
    ///   - height: 胶囊沿其局部坐标空间`y轴`的`高度`
    ///   - material: `SCNMaterial`材质
    /// - Example:
    ///   ```swift
    ///   let material = SCNMaterial()
    ///   material.diffuse.contents = UIColor.blue
    ///   let capsule = SCNCapsule(capDiameter: 2.0, height: 5.0, material: material)
    ///   ```
    convenience init(capDiameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(capRadius: capDiameter / 2, height: height)
        self.materials = [material]
    }

    /// 创建具有指定`半径`和`高度`的`胶囊几何体`，并设置材质颜色
    /// - Parameters:
    ///   - capRadius: 胶囊圆柱形`主体`及其`半球形端部`的`半径`
    ///   - height: 胶囊沿其局部坐标空间`y轴`的`高度`
    ///   - color: 材质颜色
    /// - Example:
    ///   ```swift
    ///   let capsule = SCNCapsule(capRadius: 1.0, height: 5.0, color: UIColor.green)
    ///   ```
    convenience init(capRadius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(capRadius: capRadius, height: height)

        // 创建材质并设置颜色
        let material = SCNMaterial()
        material.diffuse.contents = color
        self.materials = [material]
    }

    /// 创建具有指定`直径`和`高度`的`胶囊几何体`，并设置材质颜色
    /// - Parameters:
    ///   - capDiameter: 胶囊圆柱形`主体`及其`半球形端部`的`直径`
    ///   - height: 胶囊沿其局部坐标空间`y轴`的`高度`
    ///   - color: 材质颜色
    /// - Example:
    ///   ```swift
    ///   let capsule = SCNCapsule(capDiameter: 2.0, height: 5.0, color: UIColor.orange)
    ///   ```
    convenience init(capDiameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(capRadius: capDiameter / 2, height: height)

        // 创建材质并设置颜色
        let material = SCNMaterial()
        material.diffuse.contents = color
        self.materials = [material]
    }
}
