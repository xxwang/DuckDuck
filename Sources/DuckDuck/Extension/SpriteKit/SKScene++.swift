//
//  SKScene++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import SpriteKit

extension SKScene {
    /// 设置背景颜色
    /// - Parameter color: 背景颜色
    /// - Example:
    ///   ```swift
    ///   scene.dd_addBackgroundColor(.blue)
    ///   ```
    func dd_addBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }

    /// 使用纹理创建精灵节点
    /// - Parameter textureName: 纹理名称
    /// - Example:
    ///   ```swift
    ///   let textureNode = scene.dd_createNodeWithTexture("imageName")
    ///   ```
    func dd_createNodeWithTexture(_ textureName: String) -> SKSpriteNode {
        let texture = SKTexture(imageNamed: textureName)
        let node = SKSpriteNode(texture: texture)
        return node
    }

    /// 创建一个圆形节点
    /// - Parameters:
    ///   - radius: 圆的半径
    ///   - color: 圆的颜色
    /// - Example:
    ///   ```swift
    ///   let circleNode = scene.dd_createCircleNode(radius: 50, color: .green)
    ///   ```
    func dd_createCircleNode(radius: CGFloat, color: UIColor) -> SKShapeNode {
        let circlePath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        let circleNode = SKShapeNode(path: circlePath.cgPath)
        circleNode.fillColor = color
        circleNode.strokeColor = .clear
        return circleNode
    }

    /// 添加粒子发射器节点
    /// - Parameter particleFile: 粒子效果文件名
    /// - Example:
    ///   ```swift
    ///   scene.dd_addEmitterNode(particleFile: "Explosion.sks")
    ///   ```
    func dd_addEmitterNode(particleFile: String) {
        if let emitter = SKEmitterNode(fileNamed: particleFile) {
            emitter.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            self.addChild(emitter)
        }
    }

    /// 在场景中添加重力井
    /// - Parameters:
    ///   - position: 重力井的位置
    ///   - radius: 重力井的半径
    /// - Example:
    ///   ```swift
    ///   scene.dd_addGravityWell(position: CGPoint(x: 100, y: 100), radius: 50)
    ///   ```
    func dd_addGravityWell(position: CGPoint, radius: CGFloat) {
        // 创建一个重力场节点
        let gravityWell = SKFieldNode.radialGravityField()

        // 设置重力井的中心位置
        gravityWell.position = position

        // 设置重力井的范围（转换为 Float 类型）
        gravityWell.region = SKRegion(radius: Float(radius))

        // 将重力场节点添加到场景中
        self.addChild(gravityWell)
    }
}
