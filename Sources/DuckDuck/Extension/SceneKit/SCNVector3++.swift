//
//  SCNVector3++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import SceneKit
import UIKit

// MARK: - 属性
public extension SCNVector3 {
    /// 返回向量各分量的绝对值
    /// 计算向量的每个分量的绝对值。
    ///
    /// - Example:
    ///     ```swift
    ///     SCNVector3(2, -3, -6).dd_abs()  // 返回 SCNVector3(2, 3, 6)
    ///     ```
    /// - Returns: 返回一个新的 `SCNVector3`，其每个分量的值为原始分量的绝对值。
    func dd_abs() -> SCNVector3 {
        return SCNVector3(Swift.abs(self.x), Swift.abs(self.y), Swift.abs(self.z))
    }

    /// 返回向量的长度（或模）
    /// 计算向量的长度，表示向量从原点到点 (x, y, z) 的直线距离。
    ///
    /// - Example:
    ///     ```swift
    ///     SCNVector3(2, 3, 6).dd_length()  // 返回 7.0
    ///     ```
    /// - Returns: 返回向量的长度（`Float` 类型）。
    func dd_length() -> Float {
        return sqrt(pow(self.x, 2) + pow(self.y, 2) + pow(self.z, 2))
    }

    /// 返回单位向量（规范化向量）
    /// 将向量归一化，返回的向量的长度为 1。
    ///
    /// - Example:
    ///     ```swift
    ///     SCNVector3(2, 3, 6).dd_normalized()  // 返回 SCNVector3(0.2857, 0.4285, 0.8571)
    ///     ```
    /// - Returns: 返回单位向量（`SCNVector3` 类型）。
    func dd_normalized() -> SCNVector3 {
        let length = self.dd_length()
        return SCNVector3(self.x / length, self.y / length, self.z / length)
    }
}

// MARK: - 运算符扩展
public extension SCNVector3 {
    /// 向量相加
    /// 将两个向量相加，返回一个新的向量。
    ///
    /// - Example:
    ///     ```swift
    ///     SCNVector3(10, 10, 10) + SCNVector3(10, 20, -30)  // 返回 SCNVector3(20, 30, -20)
    ///     ```
    /// - Parameters:
    ///   - lhs: 左边的向量。
    ///   - rhs: 右边的向量。
    /// - Returns: 返回相加后的 `SCNVector3`。
    static func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }

    /// 向量相加并赋值
    /// 将右边的向量加到左边的向量上，结果存储在左边的向量中。
    ///
    /// - Example:
    ///     ```swift
    ///     var vector1 = SCNVector3(10, 10, 10)
    ///     vector1 += SCNVector3(10, 20, -30)  // vector1 变为 SCNVector3(20, 30, -20)
    ///     ```
    /// - Parameters:
    ///   - lhs: 左边的向量。
    ///   - rhs: 右边的向量。
    static func += (lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }

    /// 向量相减
    /// 将两个向量相减，返回一个新的向量。
    ///
    /// - Example:
    ///     ```swift
    ///     SCNVector3(10, 10, 10) - SCNVector3(10, 20, -30)  // 返回 SCNVector3(0, -10, 40)
    ///     ```
    /// - Parameters:
    ///   - lhs: 左边的向量。
    ///   - rhs: 右边的向量。
    /// - Returns: 返回相减后的 `SCNVector3`。
    static func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }

    /// 向量相减并赋值
    /// 将右边的向量从左边的向量中减去，结果存储在左边的向量中。
    ///
    /// - Example:
    ///     ```swift
    ///     var vector1 = SCNVector3(10, 10, 10)
    ///     vector1 -= SCNVector3(10, 20, -30)  // vector1 变为 SCNVector3(0, -10, 40)
    ///     ```
    /// - Parameters:
    ///   - lhs: 左边的向量。
    ///   - rhs: 右边的向量。
    static func -= (lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }

    /// 向量与标量相乘
    /// 将向量的每个分量与标量相乘，返回一个新的向量。
    ///
    /// - Example:
    ///     ```swift
    ///     SCNVector3(10, 20, -30) * 3  // 返回 SCNVector3(30, 60, -90)
    ///     ```
    /// - Parameters:
    ///   - vector: 需要与标量相乘的向量。
    ///   - scalar: 标量。
    /// - Returns: 返回相乘后的 `SCNVector3`。
    static func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }

    /// 向量与标量相乘并赋值
    /// 将标量与向量的每个分量相乘，结果存储在向量中。
    ///
    /// - Example:
    ///     ```swift
    ///     var vector = SCNVector3(10, 20, -30)
    ///     vector *= 3  // vector 变为 SCNVector3(30, 60, -90)
    ///     ```
    /// - Parameters:
    ///   - vector: 需要与标量相乘的向量。
    ///   - scalar: 标量。
    static func *= (vector: inout SCNVector3, scalar: Float) {
        vector.x *= scalar
        vector.y *= scalar
        vector.z *= scalar
    }

    /// 标量与向量相乘
    /// 将标量与向量的每个分量相乘，返回一个新的向量。
    ///
    /// - Example:
    ///     ```swift
    ///     3 * SCNVector3(10, 20, -30)  // 返回 SCNVector3(30, 60, -90)
    ///     ```
    /// - Parameters:
    ///   - scalar: 标量。
    ///   - vector: 向量。
    /// - Returns: 返回相乘后的 `SCNVector3`。
    static func * (scalar: Float, vector: SCNVector3) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }

    /// 向量与标量相除
    /// 将向量的每个分量除以标量，返回一个新的向量。
    ///
    /// - Example:
    ///     ```swift
    ///     SCNVector3(10, 20, -30) / 3  // 返回 SCNVector3(3.33, 6.67, -10)
    ///     ```
    /// - Parameters:
    ///   - vector: 需要除以标量的向量。
    ///   - scalar: 标量。
    /// - Returns: 返回相除后的 `SCNVector3`。
    static func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }

    /// 向量与标量相除并赋值
    /// 将标量除以向量的每个分量，结果存储在向量中。
    ///
    /// - Example:
    ///     ```swift
    ///     var vector = SCNVector3(10, 20, -30)
    ///     vector /= 3  // vector 变为 SCNVector3(3.33, 6.67, -10)
    ///     ```
    /// - Parameters:
    ///   - vector: 需要与标量相除的向量。
    ///   - scalar: 标量。
    static func /= (vector: inout SCNVector3, scalar: Float) {
        vector = SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }
}
