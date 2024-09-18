//
//  SKNode+duck.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import SpriteKit

// MARK: - 属性
public extension SKNode {
    /// `SKNode`在父节点中的中心点坐标
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

    /// `SKNode`在父节点中的左上角坐标
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

    /// `SKNode`在父节点中的右上角坐标
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

    /// `SKNode`在父节点中的左下角坐标
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

    /// `SKNode`在父节点中的右下角坐标
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

// MARK: - 方法
public extension SKNode {
    /// 返回所有当前节点下的所有`SKNode`子节点数组
    /// - Returns: `[SKNode]`
    func dd_descendants() -> [SKNode] {
        var children = self.children
        children.append(contentsOf: children.reduce(into: [SKNode]()) { $0.append(contentsOf: $1.dd_descendants()) })
        return children
    }
}
