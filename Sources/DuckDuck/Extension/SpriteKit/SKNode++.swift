//
//  SKNode++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import SpriteKit

// MARK: - SKNode 属性扩展
public extension SKNode {
    /// 获取 `SKNode` 在父节点中的中心点坐标
    var dd_center: CGPoint {
        get {
            let contents = self.calculateAccumulatedFrame()
            return CGPoint(x: contents.midX, y: contents.midY)
        }
        set {
            let contents = self.calculateAccumulatedFrame()
            self.position = CGPoint(x: newValue.x - contents.midX, y: newValue.y - contents.midY)
        }
    }

    /// 获取 `SKNode` 在父节点中的左上角坐标
    var dd_topLeft: CGPoint {
        get {
            let contents = self.calculateAccumulatedFrame()
            return CGPoint(x: contents.minX, y: contents.maxY)
        }
        set {
            let contents = self.calculateAccumulatedFrame()
            self.position = CGPoint(x: newValue.x - contents.minX, y: newValue.y - contents.maxY)
        }
    }

    /// 获取 `SKNode` 在父节点中的右上角坐标
    var dd_topRight: CGPoint {
        get {
            let contents = self.calculateAccumulatedFrame()
            return CGPoint(x: contents.maxX, y: contents.maxY)
        }
        set {
            let contents = self.calculateAccumulatedFrame()
            self.position = CGPoint(x: newValue.x - contents.maxX, y: newValue.y - contents.maxY)
        }
    }

    /// 获取 `SKNode` 在父节点中的左下角坐标
    var dd_bottomLeft: CGPoint {
        get {
            let contents = self.calculateAccumulatedFrame()
            return CGPoint(x: contents.minX, y: contents.minY)
        }
        set {
            let contents = self.calculateAccumulatedFrame()
            self.position = CGPoint(x: newValue.x - contents.minX, y: newValue.y - contents.minY)
        }
    }

    /// 获取 `SKNode` 在父节点中的右下角坐标
    var dd_bottomRight: CGPoint {
        get {
            let contents = self.calculateAccumulatedFrame()
            return CGPoint(x: contents.maxX, y: contents.minY)
        }
        set {
            let contents = self.calculateAccumulatedFrame()
            self.position = CGPoint(x: newValue.x - contents.maxX, y: newValue.y - contents.minY)
        }
    }
}

// MARK: - SKNode 方法扩展
public extension SKNode {
    /// 将节点添加到当前节点
    /// - Parameter node: 要添加的节点
    /// - Example:
    ///   ```swift
    ///   let newNode = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
    ///   parentNode.dd_addChildNode(newNode)
    ///   ```
    func dd_addChildNode(_ node: SKNode) {
        self.addChild(node)
    }

    /// dd_removeAllChildren: 移除当前节点下的所有子节点
    /// - Example:
    ///   ```swift
    ///   parentNode.dd_removeAllChildren()
    ///   ```
    func dd_removeAllChildren() {
        self.removeAllChildren()
    }

    /// 获取当前节点及其所有后代子节点的数组
    /// - Returns: 返回一个包含当前节点及所有后代节点的数组
    /// - Example:
    ///   ```swift
    ///   let allDescendants = node.dd_allDescendants()
    ///   ```
    func dd_allDescendants() -> [SKNode] {
        var descendants = self.children
        descendants.append(contentsOf: children.reduce(into: [SKNode]()) { $0.append(contentsOf: $1.dd_allDescendants()) })
        return descendants
    }

    /// 使节点平滑旋转到指定角度
    /// - Parameter angle: 目标角度（弧度）
    /// - Parameter duration: 旋转持续时间
    /// - Example:
    ///   ```swift
    ///   node.dd_rotateToAngle(.pi / 2, duration: 1.0)
    ///   ```
    func dd_rotateToAngle(_ angle: CGFloat, duration: TimeInterval) {
        let rotateAction = SKAction.rotate(toAngle: angle, duration: duration)
        self.run(rotateAction)
    }

    /// 使节点平滑移动到目标位置
    /// - Parameters:
    ///   - position: 目标位置
    ///   - duration: 移动持续时间
    /// - Example:
    ///   ```swift
    ///   node.dd_moveToPosition(CGPoint(x: 100, y: 200), duration: 1.5)
    ///   ```
    func dd_moveToPosition(_ position: CGPoint, duration: TimeInterval) {
        let moveAction = SKAction.move(to: position, duration: duration)
        self.run(moveAction)
    }
}
