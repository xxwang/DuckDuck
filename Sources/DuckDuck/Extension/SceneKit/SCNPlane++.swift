//
//  SCNPlane++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNPlane {
    /// 创建具有指定宽度的方形平面几何图形
    /// 使用给定的宽度创建一个方形平面，宽度和高度相同。
    ///
    /// - Parameter width: 平面的宽度（`x轴`和`y轴`的尺寸相同）。
    ///
    /// - Example:
    ///     ```swift
    ///     let plane = SCNPlane(width: 10.0)  // 创建一个宽度为 10 的方形平面
    ///     ```
    convenience init(width: CGFloat) {
        self.init(width: width, height: width)
    }

    /// 创建具有指定宽度、高度和材质的平面几何图形
    /// 使用给定的宽度和高度创建一个平面，并应用指定的材质。
    ///
    /// - Parameters:
    ///   - width: 平面在`x轴`的宽度。
    ///   - height: 平面在`y轴`的高度。
    ///   - material: 平面的材质。
    ///
    /// - Example:
    ///     ```swift
    ///     let plane = SCNPlane(width: 10.0, height: 20.0, material: SCNMaterial())  // 创建一个宽为 10，高为 20 的平面
    ///     ```
    convenience init(width: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(width: width, height: height)
        self.materials = [material]
    }

    /// 创建具有指定宽度和材质的方形平面几何图形
    /// 使用给定的宽度创建一个方形平面，宽度和高度相同，并应用指定的材质。
    ///
    /// - Parameters:
    ///   - width: 平面在`x轴`和`y轴`的宽度和高度。
    ///   - material: 平面的材质。
    ///
    /// - Example:
    ///     ```swift
    ///     let plane = SCNPlane(width: 10.0, material: SCNMaterial())  // 创建一个宽度为 10 的方形平面
    ///     ```
    convenience init(width: CGFloat, material: SCNMaterial) {
        self.init(width: width, height: width)
        self.materials = [material]
    }

    /// 创建具有指定宽度、高度和材质颜色的平面几何体
    /// 使用给定的宽度和高度创建一个平面，并应用指定的颜色作为材质。
    ///
    /// - Parameters:
    ///   - width: 平面在`x轴`的宽度。
    ///   - height: 平面在`y轴`的高度。
    ///   - color: 平面材质的颜色。
    ///
    /// - Example:
    ///     ```swift
    ///     let plane = SCNPlane(width: 10.0, height: 20.0, color: UIColor.blue)  // 创建一个宽为 10，高为 20 的蓝色平面
    ///     ```
    convenience init(width: CGFloat, height: CGFloat, color: UIColor) {
        self.init(width: width, height: height)
        self.materials = [SCNMaterial(color: color)]
    }

    /// 创建具有指定宽度和材质颜色的方形平面几何体
    /// 使用给定的宽度创建一个方形平面，宽度和高度相同，并应用指定的颜色作为材质。
    ///
    /// - Parameters:
    ///   - width: 平面在`x轴`和`y轴`的宽度和高度。
    ///   - color: 平面材质的颜色。
    ///
    /// - Example:
    ///     ```swift
    ///     let plane = SCNPlane(width: 10.0, color: UIColor.green)  // 创建一个宽度为 10 的绿色方形平面
    ///     ```
    convenience init(width: CGFloat, color: UIColor) {
        self.init(width: width, height: width)
        self.materials = [SCNMaterial(color: color)]
    }
}
