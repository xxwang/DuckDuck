//
//  SKShapeNode++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import SpriteKit

extension SKShapeNode {
    /// 设置形状的边框样式
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    /// - Example:
    ///   ```swift
    ///   shapeNode.dd_setOutline(color: .black, width: 2.0)
    ///   ```
    func dd_setOutline(color: UIColor, width: CGFloat) {
        self.strokeColor = color
        self.lineWidth = width
    }

    /// 创建一个圆形的 SKShapeNode
    /// - Parameters:
    ///   - radius: 圆形的半径
    ///   - color: 填充颜色
    /// - Example:
    ///   ```swift
    ///   let circle = SKShapeNode.dd_createCircle(radius: 50, color: .blue)
    ///   ```
    class func dd_createCircle(radius: CGFloat, color: UIColor) -> SKShapeNode {
        let circlePath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        let circleNode = SKShapeNode(path: circlePath.cgPath)
        circleNode.fillColor = color
        return circleNode
    }
}
