//
//  SCNCapsule+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNCapsule {
    /// 创建具有指定`直径`和`高度`的`胶囊几何体`
    /// - Parameters:
    ///   - capDiameter:胶囊圆柱形`主体`及其`半球形端部`的`直径`
    ///   - height:胶囊沿其局部坐标空间`y轴`的`高度`
    convenience init(capDiameter: CGFloat, height: CGFloat) {
        self.init(capRadius: capDiameter / 2, height: height)
    }

    /// 创建具有指定`半径`和`高度`的`胶囊几何体`
    /// - Parameters:
    ///   - capRadius:胶囊圆柱形`主体`及其`半球形端部`的`半径`
    ///   - height:胶囊沿其局部坐标空间`y轴`的`高度`
    ///   - material:材质
    convenience init(capRadius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(capRadius: capRadius, height: height)
        self.materials = [material]
    }

    /// 创建具有指定`直径`和`高度`的`胶囊几何体`
    /// - Parameters:
    ///   - capDiameter:胶囊圆柱形`主体`及其`半球形端部`的`直径`
    ///   - height:胶囊沿其局部坐标空间`y轴`的`高度`
    ///   - material:材质
    convenience init(capDiameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(capRadius: capDiameter / 2, height: height)
        self.materials = [material]
    }

    /// 创建具有指定`半径`和`高度`的`胶囊几何体`
    /// - Parameters:
    ///   - capRadius:胶囊圆柱形`主体`及其`半球形端部`的`半径`
    ///   - height:胶囊沿其局部坐标空间`y轴`的`高度`
    ///   - color:材质颜色
    convenience init(capRadius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(capRadius: capRadius, height: height)
        self.materials = [SCNMaterial(color: color)]
    }

    /// 创建具有指定`直径`和`高度`的`胶囊几何体`
    /// - Parameters:
    ///   - capDiameter:胶囊圆柱形`主体`及其`半球形端部`的`直径`
    ///   - height:胶囊沿其局部坐标空间`y轴`的`高度`
    ///   - color:材质颜色
    convenience init(capDiameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(capRadius: capDiameter / 2, height: height)
        self.materials = [SCNMaterial(color: color)]
    }
}
