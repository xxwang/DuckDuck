//
//  SCNPlane+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNPlane {
    /// 创建具有指定`宽度`的`方形平面几何图形`
    /// - Parameter width: 沿其局部坐标空间的`x轴`和`y轴`的`宽度`和`高度`
    convenience init(width: CGFloat) {
        self.init(width: width, height: width)
    }

    /// 创建具有指定`宽度`、`高度`和`材质`的`平面几何图形`
    /// - Parameters:
    ///   - width:沿其局部坐标空间`x轴`的`宽度`
    ///   - height:沿其局部坐标空间`y轴`的`高度`
    ///   - material:材质
    convenience init(width: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(width: width, height: height)
        self.materials = [material]
    }

    /// 创建具有指定`宽度`和`材质`的`方形平面几何图形`
    /// - Parameters:
    ///   - width:沿其局部坐标空间的`x轴`和`y轴`的`宽度`和`高度`
    ///   - material:材质
    convenience init(width: CGFloat, material: SCNMaterial) {
        self.init(width: width, height: width)
        self.materials = [material]
    }

    /// 创建具有指定`宽度`、`高度`和`材质颜色`的`平面几何体`
    /// - Parameters:
    ///   - width:沿其局部坐标空间`x轴`的`宽度`
    ///   - height:沿其局部坐标空间`y轴`的`高度`
    ///   - color:材质的颜色
    convenience init(width: CGFloat, height: CGFloat, color: UIColor) {
        self.init(width: width, height: height)
        self.materials = [SCNMaterial(color: color)]
    }

    /// 创建具有指定`宽度`和`材质颜色`的`方形平面几何体`
    /// - Parameters:
    ///   - width:沿其局部坐标空间的`x轴`和`y轴`的`宽度`和`高度`
    ///   - color:材质的颜色
    convenience init(width: CGFloat, color: UIColor) {
        self.init(width: width, height: width)
        self.materials = [SCNMaterial(color: color)]
    }
}
