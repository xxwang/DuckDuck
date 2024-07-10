//
//  CGRect+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreGraphics
import Foundation

extension CGRect: DDExtensionable {}

// MARK: - 计算属性
public extension DDExtension where Base == CGRect {
    /// 获取中心点坐标(包括`origin`, 以`frame`为基准)
    var center: CGPoint {
        return CGPoint(x: self.base.midX, y: self.base.midY)
    }

    /// 获取中心点坐标(不包括`origin`, 以`bounds`为基准)
    var middle: CGPoint {
        return CGPoint(x: self.base.width / 2, y: self.base.height / 2)
    }
}

// MARK: - 构造方法
public extension CGRect {
    /// 使用`中心点`和`大小`构造`CGRect`
    /// - Parameters:
    ///   - center: `中心坐标`
    ///   - size: `大小`
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        self.init(origin: origin, size: size)
    }
}

// MARK: - 方法
public extension DDExtension where Base == CGRect {
    /// 通过`目标尺寸`及`锚点`来调整一个`CGRect`
    ///
    ///     (0, 0)左上角,(1, 1)右下角
    ///     默认为(0.5, 0.5)中心点:
    ///
    ///     anchor = CGPoint(x:0.0, y:1.0):
    ///                  A2------B2
    ///     A----B       |        |
    ///     |    |  -->  |        |
    ///     C----D       C-------D2
    ///
    /// - Parameters:
    ///   - size: 目标尺寸
    ///   - anchor: 锚点
    /// - Returns:  新的`CGRect`
    func resizing(to size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> CGRect {
        let sizeDelta = CGSize(width: size.width - self.base.width, height: size.height - self.base.height)
        let origin = CGPoint(x: self.base.minX - sizeDelta.width * anchor.x, y: self.base.minY - sizeDelta.height * anchor.y)
        return CGRect(origin: origin, size: size)
    }
}
