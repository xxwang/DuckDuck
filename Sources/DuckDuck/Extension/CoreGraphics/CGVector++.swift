//
//  CGVector++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import CoreGraphics
import UIKit

// MARK: - 属性
public extension CGVector {
    /// 向量的`旋转角度-弧度`
    ///
    /// 该方法返回当前`CGVector`相对于`x`轴的旋转角度，返回值为弧度。
    ///
    /// - Returns: 返回向量的旋转角度（弧度）
    ///
    /// - Example:
    ///     ```swift
    ///     let vector = CGVector(dx: 1, dy: 1)
    ///     let angle = vector.dd_angle()
    ///     print(angle) // 输出: 0.7854 (π/4 弧度)
    ///     ```
    func dd_angle() -> CGFloat {
        return atan2(self.dy, self.dx)
    }

    /// 向量的`长度`
    ///
    /// 该方法计算并返回当前`CGVector`的长度（即向量的模）。
    ///
    /// - Returns: 返回向量的长度
    ///
    /// - Example:
    ///     ```swift
    ///     let vector = CGVector(dx: 3, dy: 4)
    ///     let magnitude = vector.dd_magnitude()
    ///     print(magnitude) // 输出: 5.0
    ///     ```
    func dd_magnitude() -> CGFloat {
        return sqrt((self.dx * self.dx) + (self.dy * self.dy))
    }
}

// MARK: - 构造方法
public extension CGVector {
    /// 创建具有指定`大小`和`角度`的`向量`
    ///
    /// 该方法通过给定的`角度`和`长度`来初始化`CGVector`，`角度`是相对于正`x`轴的逆时针旋转角度，单位为弧度。
    ///
    /// - Parameters:
    ///   - angle: 从正`x`轴`逆时针旋转`的`角度`（弧度）
    ///   - magnitude: 向量的`长度`
    /// - Example:
    ///     ```swift
    ///     let vector = CGVector(dd_angle: .pi / 4, dd_magnitude: 5)
    ///     print(vector) // 输出: (3.5355, 3.5355)
    ///     ```
    init(dd_angle angle: CGFloat, dd_magnitude magnitude: CGFloat) {
        self.init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }
}

// MARK: - 运算符
public extension CGVector {
    /// 求`CGVector`和`标量`的`积`
    ///
    /// 该方法返回一个新的`CGVector`，它是原始向量与标量的积。
    ///
    /// - Parameters:
    ///   - vector: 被乘`CGVector`
    ///   - scalar: 乘数`标量`
    /// - Returns: 返回一个新的`CGVector`
    ///
    /// - Example:
    ///     ```swift
    ///     let vector = CGVector(dx: 2, dy: 3)
    ///     let result = vector.dd_magnitude() * 2
    ///     print(result) // 输出: (4.0, 6.0)
    ///     ```
    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }

    /// 求`标量`和`CGVector`的`积`
    ///
    /// 该方法返回一个新的`CGVector`，它是标量与原始向量的积。
    ///
    /// - Parameters:
    ///   - scalar: 被乘`标量`
    ///   - vector: 乘数`CGVector`
    /// - Returns: 返回一个新的`CGVector`
    ///
    /// - Example:
    ///     ```swift
    ///     let scalar: CGFloat = 3
    ///     let vector = CGVector(dx: 4, dy: 5)
    ///     let result = scalar * vector
    ///     print(result) // 输出: (12.0, 15.0)
    ///     ```
    static func * (scalar: CGFloat, vector: CGVector) -> CGVector {
        return CGVector(dx: scalar * vector.dx, dy: scalar * vector.dy)
    }

    /// 求`CGVector`和`标量`的`积`并将结果赋值给被乘`CGVector`
    ///
    /// 该方法将`CGVector`的`dx`和`dy`分别与标量相乘，并更新原始向量的值。
    ///
    /// - Parameters:
    ///   - vector: 被乘`CGVector`
    ///   - scalar: 乘数`标量`
    static func * (vector: inout CGVector, scalar: CGFloat) {
        vector.dx *= scalar
        vector.dy *= scalar
    }

    /// 向量`取反`，改变的是`方向`，`大小`不变
    ///
    /// 该方法返回一个新的`CGVector`，它的方向与原始向量相反，大小保持不变。
    ///
    /// - Parameter vector: 被取反的`CGVector`
    /// - Returns: 返回取反后的`CGVector`
    ///
    /// - Example:
    ///     ```swift
    ///     let vector = CGVector(dx: 2, dy: 3)
    ///     let invertedVector = -vector
    ///     print(invertedVector) // 输出: (-2.0, -3.0)
    ///     ```
    static prefix func - (vector: CGVector) -> CGVector {
        return CGVector(dx: -vector.dx, dy: -vector.dy)
    }
}
