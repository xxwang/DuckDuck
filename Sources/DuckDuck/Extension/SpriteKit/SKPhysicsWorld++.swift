//
//  SKPhysicsWorld++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import SpriteKit

// MARK: - 链式语法
extension SKPhysicsWorld {
    /// 设置物理世界的重力
    /// - Parameter gravity: 重力向量
    /// - Example:
    ///   ```swift
    ///   scene.physicsWorld.dd_gravity(CGVector(dx: 0, dy: -9.8))
    ///   ```
    @discardableResult
    func dd_gravity(_ gravity: CGVector) -> Self {
        self.gravity = gravity
        return self
    }
}
