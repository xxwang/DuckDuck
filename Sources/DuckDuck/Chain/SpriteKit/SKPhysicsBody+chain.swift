//
//  SKPhysicsBody+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import SpriteKit

extension SKPhysicsBody: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base: SKPhysicsBody {
    /// 设置物理体的密度
    /// - Parameter density: 密度值，默认为 1.0
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd.density(2.0)
    ///   ```
    @discardableResult
    func density(_ density: CGFloat) -> Self {
        self.base.density = density
        return self
    }

    /// 设置物理体的摩擦力
    /// - Parameter friction: 摩擦力值，默认为 0.0
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd.friction(0.5)
    ///   ```
    @discardableResult
    func friction(_ friction: CGFloat) -> Self {
        self.base.friction = friction
        return self
    }

    /// 设置物理体的弹性
    /// - Parameter restitution: 弹性值，默认为 0.0
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd.restitution(0.8)
    ///   ```
    @discardableResult
    func restitution(_ restitution: CGFloat) -> Self {
        self.base.restitution = restitution
        return self
    }

    /// 设置物理体的速度
    /// - Parameter velocity: 速度向量
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd.velocity(CGVector(dx: 100, dy: 0))
    ///   ```
    @discardableResult
    func velocity(_ velocity: CGVector) -> Self {
        self.base.velocity = velocity
        return self
    }

    /// 设置物理体的角速度
    /// - Parameter angularVelocity: 角速度值
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd.angularVelocity(2.0)
    ///   ```
    @discardableResult
    func angularVelocity(_ angularVelocity: CGFloat) -> Self {
        self.base.angularVelocity = angularVelocity
        return self
    }

    /// 添加一个力到物理体
    /// - Parameter force: 力的向量
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd.applyForce(CGVector(dx: 10, dy: 0))
    ///   ```
    @discardableResult
    func applyForce(_ force: CGVector) -> Self {
        self.base.applyForce(force)
        return self
    }

    /// 添加一个扭矩到物理体
    /// - Parameter torque: 扭矩的值
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd.applyTorque(5.0)
    ///   ```
    @discardableResult
    func applyTorque(_ torque: CGFloat) -> Self {
        self.base.applyTorque(torque)
        return self
    }

    /// 设置物理体的线性阻力
    /// - Parameter linearDamping: 线性阻力值，默认为 0.0
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd.linearDamping(0.2)
    ///   ```
    @discardableResult
    func linearDamping(_ linearDamping: CGFloat) -> Self {
        self.base.linearDamping = linearDamping
        return self
    }

    /// 设置物理体的角阻力
    /// - Parameter angularDamping: 角阻力值，默认为 0.0
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   body.dd.angularDamping(0.5)
    ///   ```
    @discardableResult
    func angularDamping(_ angularDamping: CGFloat) -> Self {
        self.base.angularDamping = angularDamping
        return self
    }
}
