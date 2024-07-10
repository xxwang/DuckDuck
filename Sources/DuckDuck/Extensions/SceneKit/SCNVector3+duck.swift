//
//  SCNVector3+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import SceneKit
import UIKit

extension SCNVector3: DDExtensionable {}

// MARK: - 计算属性
public extension DDExtension where Base == SCNVector3 {
    /// 返回`向量分量`的`绝对值`
    ///
    ///     SCNVector3(2, -3, -6).dd.abs -> SCNVector3(2, 3, 6)
    var abs: SCNVector3 {
        return SCNVector3(Swift.abs(self.base.x), Swift.abs(self.base.y), Swift.abs(self.base.z))
    }

    /// 返回`向量`的`长度`
    ///
    ///     SCNVector3(2, 3, 6).dd.length -> 7
    var length: Float {
        return sqrt(pow(self.base.x, 2) + pow(self.base.y, 2) + pow(self.base.z, 2))
    }

    /// 返回`单位`或`规格化``向量`,其`length=1`
    ///
    ///     SCNVector3(2, 3, 6).dd.normalized  -> SCNVector3(2/7, 3/7, 6/7)
    var normalized: SCNVector3 {
        let length = sqrt(pow(self.base.x, 2) + pow(self.base.y, 2) + pow(self.base.z, 2))
        return SCNVector3(self.base.x / length, self.base.y / length, self.base.z / length)
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
