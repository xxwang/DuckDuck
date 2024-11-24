//
//  SKPhysicsBody.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import SpriteKit

// MARK: - 链式语法
public extension SKPhysicsBody {
    /// 设置物理体的密度
    /// - Parameter density: 密度值，默认为 1.0
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd_density(2.0)
    ///   ```
    @discardableResult
    func dd_density(_ density: CGFloat) -> Self {
        self.density = density
        return self
    }

    /// 设置物理体的摩擦力
    /// - Parameter friction: 摩擦力值，默认为 0.0
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd_friction(0.5)
    ///   ```
    @discardableResult
    func dd_friction(_ friction: CGFloat) -> Self {
        self.friction = friction
        return self
    }

    /// 设置物理体的弹性
    /// - Parameter restitution: 弹性值，默认为 0.0
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd_restitution(0.8)
    ///   ```
    @discardableResult
    func dd_restitution(_ restitution: CGFloat) -> Self {
        self.restitution = restitution
        return self
    }

    /// 设置物理体的速度
    /// - Parameter velocity: 速度向量
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd_velocity(CGVector(dx: 100, dy: 0))
    ///   ```
    @discardableResult
    func dd_velocity(_ velocity: CGVector) -> Self {
        self.velocity = velocity
        return self
    }

    /// 设置物理体的角速度
    /// - Parameter angularVelocity: 角速度值
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd_angularVelocity(2.0)
    ///   ```
    @discardableResult
    func dd_angularVelocity(_ angularVelocity: CGFloat) -> Self {
        self.angularVelocity = angularVelocity
        return self
    }

    /// 添加一个力到物理体
    /// - Parameter force: 力的向量
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd_applyForce(CGVector(dx: 10, dy: 0))
    ///   ```
    @discardableResult
    func dd_applyForce(_ force: CGVector) -> Self {
        self.applyForce(force)
        return self
    }

    /// 添加一个扭矩到物理体
    /// - Parameter torque: 扭矩的值
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd_applyTorque(5.0)
    ///   ```
    @discardableResult
    func dd_applyTorque(_ torque: CGFloat) -> Self {
        self.applyTorque(torque)
        return self
    }

    /// 设置物理体的线性阻力
    /// - Parameter linearDamping: 线性阻力值，默认为 0.0
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd_linearDamping(0.2)
    ///   ```
    @discardableResult
    func dd_linearDamping(_ linearDamping: CGFloat) -> Self {
        self.linearDamping = linearDamping
        return self
    }

    /// 设置物理体的角阻力
    /// - Parameter angularDamping: 角阻力值，默认为 0.0
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd_angularDamping(0.5)
    ///   ```
    @discardableResult
    func dd_angularDamping(_ angularDamping: CGFloat) -> Self {
        self.angularDamping = angularDamping
        return self
    }
}
