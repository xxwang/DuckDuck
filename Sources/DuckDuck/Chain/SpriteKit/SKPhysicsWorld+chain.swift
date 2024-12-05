//
//  SKPhysicsWorld+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 5/12/2024.
//

import SpriteKit

extension SKPhysicsWorld: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base: SKPhysicsWorld {
    /// 设置物理世界的重力
    /// - Parameter gravity: 重力向量
    /// - Example:
    ///   ```swift
    ///   scene.physicsWorld.dd.dd_gravity(CGVector(dx: 0, dy: -9.8))
    ///   ```
    @discardableResult
    func gravity(_ gravity: CGVector) -> Self {
        self.base.gravity = gravity
        return self
    }
}
