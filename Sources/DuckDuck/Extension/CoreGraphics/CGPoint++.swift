//
//  CGPoint++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import CoreGraphics

// MARK: - 方法
public extension CGPoint {
    /// 计算两个 `CGPoint` 之间的 `距离`
    ///
    /// 该方法通过使用欧几里得距离公式来计算当前点和目标点之间的直线距离。
    ///
    /// - Parameter point: 目标点，计算当前点到该点的距离
    /// - Returns: 返回两点之间的距离（`CGFloat` 类型）
    ///
    /// - Example:
    ///     ```swift
    ///     let point1 = CGPoint(x: 0, y: 0)
    ///     let point2 = CGPoint(x: 3, y: 4)
    ///     let distance = point1.dd_distance(to: point2)
    ///     print(distance) // 输出: 5.0
    ///     ```
    func dd_distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
}

// MARK: - 运算符
public extension CGPoint {
    /// 计算并返回两个 `CGPoint` 的 `和`
    ///
    /// - Parameters:
    ///   - lhs: 左值，当前点
    ///   - rhs: 右值，目标点
    /// - Returns: 返回两点相加后的 `CGPoint`
    ///
    /// - Example:
    ///     ```swift
    ///     let point1 = CGPoint(x: 1, y: 2)
    ///     let point2 = CGPoint(x: 3, y: 4)
    ///     let result = point1 + point2
    ///     print(result) // 输出: CGPoint(x: 4, y: 6)
    ///     ```
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    /// 计算并将两个 `CGPoint` 的 `和` 赋值给左值
    ///
    /// - Parameters:
    ///   - lhs: 左值，当前点
    ///   - rhs: 右值，目标点
    ///
    /// - Example:
    ///     ```swift
    ///     var point1 = CGPoint(x: 1, y: 2)
    ///     let point2 = CGPoint(x: 3, y: 4)
    ///     point1 += point2
    ///     print(point1) // 输出: CGPoint(x: 4, y: 6)
    ///     ```
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    /// 计算并返回两个 `CGPoint` 的 `差`
    ///
    /// - Parameters:
    ///   - lhs: 被减数 `CGPoint`（当前点）
    ///   - rhs: 减数 `CGPoint`（目标点）
    /// - Returns: 返回两点相减后的 `CGPoint`
    ///
    /// - Example:
    ///     ```swift
    ///     let point1 = CGPoint(x: 3, y: 4)
    ///     let point2 = CGPoint(x: 1, y: 2)
    ///     let result = point1 - point2
    ///     print(result) // 输出: CGPoint(x: 2, y: 2)
    ///     ```
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    /// 计算并将两个 `CGPoint` 的 `差` 赋值给左值
    ///
    /// - Parameters:
    ///   - lhs: 被减数 `CGPoint`（当前点）
    ///   - rhs: 减数 `CGPoint`（目标点）
    ///
    /// - Example:
    ///     ```swift
    ///     var point1 = CGPoint(x: 3, y: 4)
    ///     let point2 = CGPoint(x: 1, y: 2)
    ///     point1 -= point2
    ///     print(point1) // 输出: CGPoint(x: 2, y: 2)
    ///     ```
    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

    /// 求 `CGPoint` 和标量的 `积`
    ///
    /// - Parameters:
    ///   - point: `CGPoint`，当前点
    ///   - scalar: `CGFloat`，标量
    /// - Returns: 返回点与标量相乘后的 `CGPoint`
    ///
    /// - Example:
    ///     ```swift
    ///     let point = CGPoint(x: 1, y: 2)
    ///     let result = point * 2
    ///     print(result) // 输出: CGPoint(x: 2, y: 4)
    ///     ```
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    /// 求 `CGPoint` 和标量的 `积` 并将结果赋值给左值
    ///
    /// - Parameters:
    ///   - point: `CGPoint`，当前点
    ///   - scalar: `CGFloat`，标量
    ///
    /// - Example:
    ///     ```swift
    ///     var point = CGPoint(x: 1, y: 2)
    ///     point *= 2
    ///     print(point) // 输出: CGPoint(x: 2, y: 4)
    ///     ```
    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point.x *= scalar
        point.y *= scalar
    }

    /// 求标量和 `CGPoint` 的 `积`
    ///
    /// - Parameters:
    ///   - scalar: `CGFloat`，标量
    ///   - point: `CGPoint`，当前点
    /// - Returns: 返回点与标量相乘后的 `CGPoint`
    ///
    /// - Example:
    ///     ```swift
    ///     let point = CGPoint(x: 1, y: 2)
    ///     let result = 2 * point
    ///     print(result) // 输出: CGPoint(x: 2, y: 4)
    ///     ```
    static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
}
