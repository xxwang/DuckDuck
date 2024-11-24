//
//  SKConstraint++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import SpriteKit

extension SKConstraint {
    /// 应用距离约束，限制节点的最大距离
    /// - Parameters:
    ///   - distance: 最大距离
    ///   - node: 限制的目标节点
    /// - Example:
    ///   ```swift
    ///   let constraint = SKConstraint.dd_applyDistanceConstraint(distance: 200, node: targetNode)
    ///   node.constraints = [constraint]
    ///   ```
    class func dd_applyDistanceConstraint(distance: CGFloat, node: SKNode) -> SKConstraint {
        let distanceConstraint = SKConstraint.distance(SKRange(constantValue: distance), to: node)
        return distanceConstraint
    }

    /// 应用角度约束，限制节点的旋转范围
    /// - Parameters:
    ///   - angle: 最大角度
    ///   - node: 限制的目标节点
    /// - Example:
    ///   ```swift
    ///   let constraint = SKConstraint.dd_applyAngleConstraint(angle: .pi / 2, node: targetNode)
    ///   node.constraints = [constraint]
    ///   ```
    class func dd_applyAngleConstraint(angle: CGFloat, node: SKNode) -> SKConstraint {
        let angleConstraint = SKConstraint.orient(to: node, offset: SKRange(constantValue: angle))
        return angleConstraint
    }
}
