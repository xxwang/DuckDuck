//
//  SKEmitterNode++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import SpriteKit

extension SKEmitterNode {
    /// 设置粒子的颜色
    /// - Parameter color: 颜色
    /// - Example:
    ///   ```swift
    ///   emitter.dd_setParticleColor(.red)
    ///   ```
    func dd_setParticleColor(_ color: UIColor) {
        self.particleColor = color
    }

    /// 创建闪烁效果的粒子发射器
    /// - Example:
    ///   ```swift
    ///   let sparkleEmitter = SKEmitterNode.dd_createSparkleEffect()
    ///   scene.addChild(sparkleEmitter)
    ///   ```
    class func dd_createSparkleEffect() -> SKEmitterNode {
        let sparkleEmitter = SKEmitterNode()
        sparkleEmitter.particleTexture = SKTexture(imageNamed: "sparkle")
        sparkleEmitter.particleColor = .white
        sparkleEmitter.particleSpeed = 100
        sparkleEmitter.particleLifetime = 0.5
        sparkleEmitter.numParticlesToEmit = 100
        return sparkleEmitter
    }
}
