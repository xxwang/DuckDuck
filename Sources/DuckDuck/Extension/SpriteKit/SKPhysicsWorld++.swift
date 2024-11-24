//
//  SKPhysicsWorld++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import SpriteKit

extension SKPhysicsWorld {
    /// 设置物理世界的重力
    /// - Parameter gravity: 重力向量
    /// - Example:
    ///   ```swift
    ///   scene.physicsWorld.dd_setGravity(CGVector(dx: 0, dy: -9.8))
    ///   ```
    func dd_setGravity(_ gravity: CGVector) {
        self.gravity = gravity
    }
}
