//
//  CGVector+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreGraphics
import UIKit

extension CGVector: DDExtensionable {}

// MARK: - 计算属性
public extension DDExtension where Base == CGVector {
    /// 向量的`旋转角度-弧度`
    var angle: CGFloat {
        return atan2(self.base.dy, self.base.dx)
    }

    /// 向量的`长度`
    var magnitude: CGFloat {
        return sqrt((self.base.dx * self.base.dx) + (self.base.dy * self.base.dy))
    }
}

// MARK: - 构造方法
public extension CGVector {
    /// 创建具有指定`大小`和`角度`的`向量`
    ///
    ///     let vector = CGVector(angle:.pi, magnitude:1)
    ///
    /// - Parameters:
    ///   - angle: 从正`x`轴`逆时针旋转`的`角度`(`弧度`)
    ///   - magnitude: `长度`
    init(angle: CGFloat, magnitude: CGFloat) {
        self.init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }
}

// MARK: - 运算符
public extension CGVector {
    /// 求`CGVector`和`标量`的`积`
    /// - Parameters:
    ///   - vector: 被乘`CGVector`
    ///   - scalar: 乘数`标量`
    /// - Returns: `CGVector`
    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }

    /// 求`标量`和`CGVector`的`积`
    /// - Parameters:
    ///   - scalar: 被乘`标量`
    ///   - vector: 乘数`CGVector`
    /// - Returns: `CGVector`
    static func * (scalar: CGFloat, vector: CGVector) -> CGVector {
        return CGVector(dx: scalar * vector.dx, dy: scalar * vector.dy)
    }

    /// 求`CGVector`和`标量`的`积`并将结果赋值给被乘`CGVector`
    /// - Parameters:
    ///   - vector: 被乘`CGVector`
    ///   - scalar: 乘数`标量`
    static func *= (vector: inout CGVector, scalar: CGFloat) {
        vector.dx *= scalar
        vector.dy *= scalar
    }

    /// 向量`取反`改变的只有`方向``大小`不变
    /// - Parameter vector: `CGVector`
    /// - Returns: `CGVector`
    static prefix func - (vector: CGVector) -> CGVector {
        return CGVector(dx: -vector.dx, dy: -vector.dy)
    }
}
