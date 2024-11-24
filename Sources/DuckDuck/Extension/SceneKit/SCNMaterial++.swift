//
//  SCNMaterial++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNMaterial {
    /// 使用特定漫反射颜色初始化SCN材质
    /// 该初始化方法允许创建一个材质并设置其漫反射颜色为指定的颜色。
    ///
    /// - Parameter color: 漫反射颜色，通常用于材质的表面颜色。
    ///
    /// - Example:
    ///     ```swift
    ///     let material = SCNMaterial(color: UIColor.red)  // 创建一个红色的材质
    ///     ```
    convenience init(color: UIColor) {
        self.init()
        self.diffuse.contents = color
    }
}
