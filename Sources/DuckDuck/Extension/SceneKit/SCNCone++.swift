//
//  SCNCone++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import SceneKit
import UIKit

// MARK: - SCNCone 构造方法扩展
public extension SCNCone {
    /// 创建具有给定`顶径`、`底径`和`高度`的`圆锥体几何体`
    /// - Parameters:
    ///   - topDiameter: 圆锥体`顶部`的`直径`, 在其局部坐标空间的`x轴`和`z轴`尺寸上形成一个圆
    ///   - bottomDiameter: 圆锥体`底部`的`直径`, 在其局部坐标空间的`x轴`和`z轴`尺寸上形成一个圆
    ///   - height: 圆锥体沿其局部坐标空间`y轴`的`高度`
    /// - Example:
    ///   ```swift
    ///   let cone = SCNCone(topDiameter: 1.0, bottomDiameter: 2.0, height: 3.0)
    ///   ```
    convenience init(topDiameter: CGFloat, bottomDiameter: CGFloat, height: CGFloat) {
        self.init(topRadius: topDiameter / 2, bottomRadius: bottomDiameter / 2, height: height)
    }

    /// 使用给定的`顶部半径`、`底部半径`、`高度`和`材质`创建`圆锥体几何体`
    /// - Parameters:
    ///   - topRadius: 圆锥体`顶部`的`半径`, 在其局部坐标空间的`x轴`和`z轴`尺寸上形成一个圆
    ///   - bottomRadius: 圆锥体`底部`的`半径`, 在其局部坐标空间的`x轴`和`z轴`尺寸上形成一个圆
    ///   - height: 圆锥体沿其局部坐标空间`y轴`的`高度`
    ///   - material: `SCNMaterial`材质
    /// - Example:
    ///   ```swift
    ///   let material = SCNMaterial()
    ///   material.diffuse.contents = UIColor.blue
    ///   let cone = SCNCone(topRadius: 1.0, bottomRadius: 2.0, height: 3.0, material: material)
    ///   ```
    convenience init(topRadius: CGFloat, bottomRadius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(topRadius: topRadius, bottomRadius: bottomRadius, height: height)
        self.materials = [material]
    }

    /// 创建具有给定`顶径`、`底径`、`高度`和`材质`的`圆锥体几何体`
    /// - Parameters:
    ///   - topDiameter: 圆锥体`顶部`的`直径`, 在其局部坐标空间的`x轴`和`z轴`尺寸上形成一个圆
    ///   - bottomDiameter: 圆锥体`底部`的`直径`, 在其局部坐标空间的`x轴`和`z轴`尺寸上形成一个圆
    ///   - height: 圆锥体沿其局部坐标空间`y轴`的`高度`
    ///   - material: `SCNMaterial`材质
    /// - Example:
    ///   ```swift
    ///   let material = SCNMaterial()
    ///   material.diffuse.contents = UIColor.green
    ///   let cone = SCNCone(topDiameter: 1.0, bottomDiameter: 2.0, height: 3.0, material: material)
    ///   ```
    convenience init(topDiameter: CGFloat, bottomDiameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(topRadius: topDiameter / 2, bottomRadius: bottomDiameter / 2, height: height)
        self.materials = [material]
    }

    /// 使用给定的`顶部半径`、`底部半径`、`高度`和`材质`创建`圆锥体几何体`
    /// - Parameters:
    ///   - topRadius: 圆锥体`顶部`的`半径`, 在其局部坐标空间的`x轴`和`z轴`尺寸上形成一个圆
    ///   - bottomRadius: 圆锥体`底部`的`半径`, 在其局部坐标空间的`x轴`和`z轴`尺寸上形成一个圆
    ///   - height: 圆锥体沿其局部坐标空间`y轴`的`高度`
    ///   - color: 材质颜色
    /// - Example:
    ///   ```swift
    ///   let cone = SCNCone(topRadius: 1.0, bottomRadius: 2.0, height: 3.0, color: UIColor.red)
    ///   ```
    convenience init(topRadius: CGFloat, bottomRadius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(topRadius: topRadius, bottomRadius: bottomRadius, height: height)

        // 创建材质并设置颜色
        let material = SCNMaterial()
        material.diffuse.contents = color
        self.materials = [material]
    }

    /// 创建具有给定`顶径`、`底径`、`高度`和`材质`的`圆锥体几何体`
    /// - Parameters:
    ///   - topDiameter: 圆锥体`顶部`的`直径`, 在其局部坐标空间的`x轴`和`z轴`尺寸上形成一个圆
    ///   - bottomDiameter: 圆锥体`底部`的`直径`, 在其局部坐标空间的`x轴`和`z轴`尺寸上形成一个圆
    ///   - height: 圆锥体沿其局部坐标空间`y轴`的`高度`
    ///   - color: 材质颜色
    /// - Example:
    ///   ```swift
    ///   let cone = SCNCone(topDiameter: 1.0, bottomDiameter: 2.0, height: 3.0, color: UIColor.orange)
    ///   ```
    convenience init(topDiameter: CGFloat, bottomDiameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(topRadius: topDiameter / 2, bottomRadius: bottomDiameter / 2, height: height)

        // 创建材质并设置颜色
        let material = SCNMaterial()
        material.diffuse.contents = color
        self.materials = [material]
    }
}
