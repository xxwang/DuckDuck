//
//  SCNCylinder+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNCylinder {
    /// 创建具有指定`直径`和`高度`的`圆柱体几何体`
    /// - Parameters:
    ///   - diameter:圆柱体的`圆形横截面`在其局部坐标空间的`x轴`和`z轴`尺寸中的`直径`
    ///   - height:圆柱体沿其局部坐标空间`y轴`的`高度`
    convenience init(diameter: CGFloat, height: CGFloat) {
        self.init(radius: diameter / 2, height: height)
    }

    /// 创建具有指定`半径`、`高度`和`材质`的`圆柱体几何体`
    /// - Parameters:
    ///   - radius:在其局部坐标空间的`x轴`和`z轴`尺寸中的`圆形横截面``半径`
    ///   - height:沿其局部坐标空间`y轴`的`高度`
    ///   - material:材质
    convenience init(radius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(radius: radius, height: height)
        self.materials = [material]
    }

    /// 创建具有指定`直径`、`高度`和`材质`的`圆柱体几何体`
    /// - Parameters:
    ///   - diameter:圆柱体的`圆形横截面`在其局部坐标空间的`x轴`和`z轴`尺寸中的`直径`
    ///   - height:沿其局部坐标空间`y轴`的`高度`
    ///   - material:材质
    convenience init(diameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(radius: diameter / 2, height: height)
        self.materials = [material]
    }

    /// 创建具有指定`半径`、`高度`和`材质颜色`的`圆柱体几何体`
    /// - Parameters:
    ///   - radius:在其局部坐标空间的`x轴`和`z轴`尺寸中的`圆形横截面半径`
    ///   - height:沿其局部坐标空间`y轴`的`高度`
    ///   - color:材质的颜色
    convenience init(radius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(radius: radius, height: height)
        self.materials = [SCNMaterial(color: color)]
    }

    /// 创建具有指定`直径`、`高度`和`材质颜色`的`圆柱体几何体`
    /// - Parameters:
    ///   - diameter:圆柱体的`圆形横截面`在其局部坐标空间的`x轴`和`z轴`尺寸中的`直径`
    ///   - height:圆柱体沿其局部坐标空间`y轴`的`高度`
    ///   - color:材质的颜色
    convenience init(diameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(radius: diameter / 2, height: height)
        self.materials = [SCNMaterial(color: color)]
    }
}
