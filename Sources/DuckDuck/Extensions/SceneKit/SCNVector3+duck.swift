//
//  SCNVector3+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import SceneKit
import UIKit

// MARK: - 属性
public extension SCNVector3 {
    /// 返回`向量分量`的`绝对值`
    ///
    ///     SCNVector3(2, -3, -6).dd_abs() -> SCNVector3(2, 3, 6)
    func dd_abs() -> SCNVector3 {
        return SCNVector3(Swift.abs(self.x), Swift.abs(self.y), Swift.abs(self.z))
    }

    /// 返回`向量`的`长度`
    ///
    ///     SCNVector3(2, 3, 6).dd_length() -> 7
    func dd_length() -> Float {
        return sqrt(pow(self.x, 2) + pow(self.y, 2) + pow(self.z, 2))
    }

    /// 返回`单位`或`规格化``向量`,其`length=1`
    ///
    ///     SCNVector3(2, 3, 6).dd_normalized()  -> SCNVector3(2/7, 3/7, 6/7)
    func dd_normalized() -> SCNVector3 {
        let length = sqrt(pow(self.x, 2) + pow(self.y, 2) + pow(self.z, 2))
        return SCNVector3(self.x / length, self.y / length, self.z / length)
    }
}

// MARK: - 运算符
public extension SCNVector3 {
    /// `求和`
    ///
    ///     SCNVector3(10, 10, 10) + SCNVector3(10, 20, -30) -> SCNVector3(20, 30, -20)
    ///
    /// - Parameters:
    ///   - lhs:`左值`
    ///   - rhs:`右值`
    /// - Returns:`SCNVector3`
    static func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }

    /// `求和`(`结果赋值给左值`)
    ///
    ///     SCNVector3(10, 10, 10) += SCNVector3(10, 20, -30) -> SCNVector3(20, 30, -20)
    ///
    /// - Parameters:
    ///   - lhs:`左值`
    ///   - rhs:`右值`
    static func += (lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }

    /// `求差`
    ///
    ///     SCNVector3(10, 10, 10) - SCNVector3(10, 20, -30) -> SCNVector3(0, -10, 40)
    ///
    /// - Parameters:
    ///   - lhs:`左值`
    ///   - rhs:`右值`
    /// - Returns:`SCNVector3`
    static func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }

    /// `求差`(`结果赋值给左值`)
    ///
    ///     SCNVector3(10, 10, 10) -= SCNVector3(10, 20, -30) -> SCNVector3(0, -10, 40)
    ///
    /// - Parameters:
    ///   - lhs:`左值`
    ///   - rhs:`右值`
    static func -= (lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }

    /// 求`SCNVector3`和`标量`的`积`
    ///
    ///     SCNVector3(10, 20, -30) * 3 -> SCNVector3(30, 60, -90)
    ///
    /// - Parameters:
    ///   - vector:`SCNVector3`
    ///   - scalar:`标量`
    /// - Returns:`SCNVector3`
    static func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }

    /// 求`SCNVector3`和`标量`的`积`(`结果赋值给左值`)
    ///
    ///     SCNVector3(10, 20, -30) *= 3 -> SCNVector3(30, 60, -90)
    ///
    /// - Parameters:
    ///   - vector:`SCNVector3`
    ///   - scalar:`标量`
    static func *= (vector: inout SCNVector3, scalar: Float) {
        vector.x *= scalar
        vector.y *= scalar
        vector.z *= scalar
    }

    /// 求`标量`和`SCNVector3`的`积`
    ///
    ///     3 * SCNVector3(10, 20, -30) -> SCNVector3(30, 60, -90)
    ///
    /// - Parameters:
    ///   - scalar:`标量`
    ///   - vector:`SCNVector3`
    /// - Returns:`SCNVector3`
    static func * (scalar: Float, vector: SCNVector3) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }

    /// 求`SCNVector3`和`标量`的`商`
    ///
    ///     SCNVector3(10, 20, -30) / 3 -> SCNVector3(3/10, 0.15, -30)
    ///
    /// - Parameters:
    ///   - vector:`SCNVector3`
    ///   - scalar:`标量`
    /// - Returns: `SCNVector3`
    static func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }

    /// 求`标量`和`SCNVector3`的`商`(结果赋值给左值)
    ///
    ///     SCNVector3(10, 20, -30) /= 3 -> SCNVector3(3/10, 0.15, -30)
    ///
    /// - Parameters:
    ///   - vector:`SCNVector3`
    ///   - scalar:`标量`
    static func /= (vector: inout SCNVector3, scalar: Float) {
        vector = SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }
}
