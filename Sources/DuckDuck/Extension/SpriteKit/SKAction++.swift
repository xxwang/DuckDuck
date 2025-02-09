import SpriteKit

extension SKAction {
    /// 创建一组顺序执行的动作
    /// - Parameter actions: 动作数组
    /// - Example:
    ///   ```swift
    ///   let action1 = SKAction.moveBy(x: 100, y: 0, duration: 1.0)
    ///   let action2 = SKAction.scale(to: 2.0, duration: 1.0)
    ///   let sequence = SKAction.dd_sequenceOfActions([action1, action2])
    ///   ```
    class func dd_sequenceOfActions(_ actions: [SKAction]) -> SKAction {
        return SKAction.sequence(actions)
    }

    /// 创建一个永久重复执行的动作
    /// - Parameter action: 要重复执行的动作
    /// - Example:
    ///   ```swift
    ///   let repeatAction = SKAction.dd_repeatActionForever(action)
    ///   node.run(repeatAction)
    ///   ```
    class func dd_repeatActionForever(_ action: SKAction) -> SKAction {
        return SKAction.repeatForever(action)
    }

    /// 创建一个缩放动作
    /// - Parameters:
    ///   - scale: 缩放比例
    ///   - duration: 动作持续时间
    /// - Example:
    ///   ```swift
    ///   let scaleAction = SKAction.dd_scaleTo(scale: 2.0, duration: 0.5)
    ///   node.run(scaleAction)
    ///   ```
    class func dd_scaleTo(scale: CGFloat, duration: TimeInterval) -> SKAction {
        return SKAction.scale(to: scale, duration: duration)
    }

    /// 创建一个旋转动作
    /// - Parameters:
    ///   - angle: 旋转角度（弧度）
    ///   - duration: 动作持续时间
    /// - Example:
    ///   ```swift
    ///   let rotateAction = SKAction.dd_rotateByAngle(angle: .pi, duration: 1.0)
    ///   node.run(rotateAction)
    ///   ```
    class func dd_rotateByAngle(angle: CGFloat, duration: TimeInterval) -> SKAction {
        return SKAction.rotate(byAngle: angle, duration: duration)
    }
}
