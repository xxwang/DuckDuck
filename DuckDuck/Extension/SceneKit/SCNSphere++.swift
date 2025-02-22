import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNSphere {
    /// 创建具有指定直径的球体几何体
    /// 使用给定的直径来创建一个球体几何体，并自动计算半径。
    ///
    /// - Parameters:
    ///   - diameter: 球体在其局部坐标空间中的直径。
    ///
    /// - Example:
    ///     ```swift
    ///     let sphere = SCNSphere(diameter: 5.0)  // 创建直径为 5 的球体
    ///     ```
    convenience init(diameter: CGFloat) {
        self.init(radius: diameter / 2)
    }

    /// 创建具有指定半径和材质的球体几何体
    /// 使用给定的半径和材质来创建一个球体几何体。
    ///
    /// - Parameters:
    ///   - radius: 球体在其局部坐标空间中的半径。
    ///   - material: 球体的材质。
    ///
    /// - Example:
    ///     ```swift
    ///     let material = SCNMaterial()
    ///     material.diffuse.contents = UIColor.red
    ///     let sphere = SCNSphere(radius: 5.0, material: material)  // 创建半径为 5，材质为红色的球体
    ///     ```
    convenience init(radius: CGFloat, material: SCNMaterial) {
        self.init(radius: radius)
        self.materials = [material]
    }

    /// 创建具有指定半径和材质颜色的球体几何体
    /// 使用给定的半径和颜色创建一个球体，并将颜色应用于材质。
    ///
    /// - Parameters:
    ///   - radius: 球体在其局部坐标空间中的半径。
    ///   - color: 球体材质的颜色。
    ///
    /// - Example:
    ///     ```swift
    ///     let sphere = SCNSphere(radius: 5.0, color: UIColor.blue)  // 创建半径为 5，颜色为蓝色的球体
    ///     ```
    convenience init(radius: CGFloat, color: UIColor) {
        self.init(radius: radius, material: SCNMaterial(color: color))
    }

    /// 创建具有指定直径和材质的球体几何体
    /// 使用给定的直径和材质来创建一个球体几何体。
    ///
    /// - Parameters:
    ///   - diameter: 球体在其局部坐标空间中的直径。
    ///   - material: 球体的材质。
    ///
    /// - Example:
    ///     ```swift
    ///     let material = SCNMaterial()
    ///     material.diffuse.contents = UIColor.green
    ///     let sphere = SCNSphere(diameter: 10.0, material: material)  // 创建直径为 10，材质为绿色的球体
    ///     ```
    convenience init(diameter: CGFloat, material: SCNMaterial) {
        self.init(radius: diameter / 2)
        self.materials = [material]
    }

    /// 创建具有指定直径和材质颜色的球体几何体
    /// 使用给定的直径和颜色来创建一个球体，并将颜色应用于材质。
    ///
    /// - Parameters:
    ///   - diameter: 球体在其局部坐标空间中的直径。
    ///   - color: 球体材质的颜色。
    ///
    /// - Example:
    ///     ```swift
    ///     let sphere = SCNSphere(diameter: 10.0, color: UIColor.yellow)  // 创建直径为 10，颜色为黄色的球体
    ///     ```
    convenience init(diameter: CGFloat, color: UIColor) {
        self.init(diameter: diameter, material: SCNMaterial(color: color))
    }
}
