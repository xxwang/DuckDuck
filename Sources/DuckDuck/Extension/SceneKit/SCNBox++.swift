//
//  SCNBox++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import SceneKit
import UIKit

// MARK: - SCNBox 构造方法扩展

public extension SCNBox {
    /// 创建具有指定`宽度`、`高度`和`长度`的`长方体几何图形`
    /// - Parameters:
    ///   - width: 沿其局部坐标空间`x轴`的`宽度`
    ///   - height: 沿其局部坐标空间`y轴`的`高度`
    ///   - length: 沿其局部坐标空间`z轴`的`长度`
    /// - Example:
    ///   ```swift
    ///   let box = SCNBox(width: 1.0, height: 2.0, length: 3.0)
    ///   ```
    convenience init(width: CGFloat, height: CGFloat, length: CGFloat) {
        self.init(width: width, height: height, length: length, chamferRadius: 0)
    }

    /// 创建具有`指定边长`和`倒角半径`的`立方体几何体`
    /// - Parameters:
    ///   - sideLength: 在其`局部坐标空间`中的`宽度`、`高度`和`长度`
    ///   - chamferRadius: 盒子边缘和角落的`曲率半径`
    /// - Example:
    ///   ```swift
    ///   let cube = SCNBox(sideLength: 2.0)
    ///   ```
    convenience init(sideLength: CGFloat, chamferRadius: CGFloat = 0) {
        self.init(width: sideLength, height: sideLength, length: sideLength, chamferRadius: chamferRadius)
    }

    /// 创建具有指定`宽度`、`高度`、`长度`、`倒角半径`和`材质`的`长方体几何图形`
    /// - Parameters:
    ///   - width: 沿其局部坐标空间`x轴`的`宽度`
    ///   - height: 沿其局部坐标空间`y轴`的`高度`
    ///   - length: 沿其局部坐标空间`z轴`的`长度`
    ///   - chamferRadius: 盒子边缘和角落的`曲率半径`
    ///   - material: 材质
    /// - Example:
    ///   ```swift
    ///   let material = SCNMaterial()
    ///   material.diffuse.contents = UIColor.red
    ///   let box = SCNBox(width: 1.0, height: 2.0, length: 3.0, chamferRadius: 0, material: material)
    ///   ```
    convenience init(width: CGFloat, height: CGFloat, length: CGFloat, chamferRadius: CGFloat = 0, material: SCNMaterial) {
        self.init(width: width, height: height, length: length, chamferRadius: chamferRadius)
        self.materials = [material]
    }

    /// 创建具有指定`边长`、`倒角半径`和`材质`的`立方体几何体`
    /// - Parameters:
    ///   - sideLength: 在其局部坐标空间中的`宽度`、`高度`和`长度`
    ///   - chamferRadius: 盒子边缘和角落的`曲率半径`
    ///   - material: 材质
    /// - Example:
    ///   ```swift
    ///   let material = SCNMaterial()
    ///   material.diffuse.contents = UIColor.blue
    ///   let cube = SCNBox(sideLength: 2.0, chamferRadius: 0, material: material)
    ///   ```
    convenience init(sideLength: CGFloat, chamferRadius: CGFloat = 0, material: SCNMaterial) {
        self.init(width: sideLength, height: sideLength, length: sideLength, chamferRadius: chamferRadius)
        self.materials = [material]
    }

    /// 创建具有指定`宽度`、`高度`、`长度`、`倒角半径`和`材质颜色`的`长方体几何图形`
    /// - Parameters:
    ///   - width: 沿其局部坐标空间`x轴`的`宽度`
    ///   - height: 沿其局部坐标空间`y轴`的`高度`
    ///   - length: 沿其局部坐标空间`z轴`的`长度`
    ///   - chamferRadius: 盒子边缘和角落的`曲率半径`
    ///   - color: 材质的颜色
    /// - Example:
    ///   ```swift
    ///   let box = SCNBox(width: 1.0, height: 2.0, length: 3.0, chamferRadius: 0, color: UIColor.green)
    ///   ```
    convenience init(width: CGFloat, height: CGFloat, length: CGFloat, chamferRadius: CGFloat = 0, color: UIColor) {
        self.init(width: width, height: height, length: length, chamferRadius: chamferRadius)

        // 创建材质并设置颜色
        let material = SCNMaterial()
        material.diffuse.contents = color
        self.materials = [material]
    }

    /// 创建具有指定`边长`、`倒角半径`和`材质颜色`的`立方体几何图形`
    /// - Parameters:
    ///   - sideLength: 在其局部坐标空间中的`宽度`、`高度`和`长度`
    ///   - chamferRadius: 盒子边缘和角落的`曲率半径`
    ///   - color: 几何体材质的颜色
    /// - Example:
    ///   ```swift
    ///   let cube = SCNBox(sideLength: 2.0, chamferRadius: 0, color: UIColor.yellow)
    ///   ```
    convenience init(sideLength: CGFloat, chamferRadius: CGFloat = 0, color: UIColor) {
        self.init(width: sideLength, height: sideLength, length: sideLength, chamferRadius: chamferRadius)

        // 创建材质并设置颜色
        let material = SCNMaterial()
        material.diffuse.contents = color
        self.materials = [material]
    }
}
