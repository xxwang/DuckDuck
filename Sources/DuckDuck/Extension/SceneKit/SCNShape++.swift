//
//  SCNShape++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNShape {
    /// 创建具有指定路径、拉伸深度和材质的形状几何体
    /// 使用给定的二维路径来创建形状，并通过指定的拉伸深度沿z轴拉伸，最后应用材质。
    ///
    /// - Parameters:
    ///   - path: 构成形状基础的二维路径（`UIBezierPath`）。
    ///   - extrusionDepth: 沿z轴拉伸形状的厚度。
    ///   - material: 形状的材质。
    ///
    /// - Example:
    ///     ```swift
    ///     let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 10, height: 10))
    ///     let material = SCNMaterial()
    ///     material.diffuse.contents = UIColor.red
    ///     let shape = SCNShape(path: path, extrusionDepth: 5.0, material: material)  // 创建一个矩形形状，厚度为 5，材质为红色
    ///     ```
    convenience init(path: UIBezierPath, extrusionDepth: CGFloat, material: SCNMaterial) {
        self.init(path: path, extrusionDepth: extrusionDepth)
        self.materials = [material]
    }

    /// 创建具有指定路径、拉伸深度和材质颜色的形状几何体
    /// 使用给定的二维路径来创建形状，并通过指定的拉伸深度沿z轴拉伸，最后应用颜色作为材质。
    ///
    /// - Parameters:
    ///   - path: 构成形状基础的二维路径（`UIBezierPath`）。
    ///   - extrusionDepth: 沿z轴拉伸形状的厚度。
    ///   - color: 形状材质的颜色。
    ///
    /// - Example:
    ///     ```swift
    ///     let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10))
    ///     let shape = SCNShape(path: path, extrusionDepth: 5.0, color: UIColor.blue)  // 创建一个椭圆形状，厚度为 5，材质为蓝色
    ///     ```
    convenience init(path: UIBezierPath, extrusionDepth: CGFloat, color: UIColor) {
        self.init(path: path, extrusionDepth: extrusionDepth)
        self.materials = [SCNMaterial(color: color)]
    }
}
