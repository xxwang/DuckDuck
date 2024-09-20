//
//  UIBezierPath+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 构造方法
public extension UIBezierPath {
    /// 使用从一个`CGPoint`到另一个`CGPoint`的线初始化`UIBezierPath`
    ///
    /// - Parameters:
    ///   - from:指向路径的起点
    ///   - otherPoint:路径应该结束的点
    convenience init(from: CGPoint, to otherPoint: CGPoint) {
        self.init()
        move(to: from)
        addLine(to: otherPoint)
    }

    /// 初始化用直线连接给定`CGPoint`的`UIBezierPath`
    ///
    /// - Parameter points:路径所包含的点
    convenience init(points: [CGPoint]) {
        self.init()
        if !points.isEmpty {
            move(to: points[0])
            for point in points[1...] {
                addLine(to: point)
            }
        }
    }

    /// 使用给定的`CGPoint`初始化多边形`UIBezierPath`至少得3个点
    ///
    /// - Parameter points:路径所包含的点
    convenience init?(polygonWithPoints points: [CGPoint]) {
        guard points.count > 2 else { return nil }
        self.init()
        move(to: points[0])
        for point in points[1...] {
            addLine(to: point)
        }
        close()
    }

    /// 使用给定大小的椭圆形路径初始化`UIBezierPath`
    ///
    /// - Parameters:
    ///   - size:椭圆形的宽度和高度
    ///   - centered:椭圆是否应在其坐标空间中居中
    convenience init(ovalOf size: CGSize, centered: Bool) {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        self.init(ovalIn: CGRect(origin: origin, size: size))
    }

    /// 用给定大小的矩形路径初始化`UIBezierPath`
    ///
    /// - Parameters:
    ///   - size:矩形的宽度和高度
    ///   - centered:椭圆是否应在其坐标空间中居中
    convenience init(rectOf size: CGSize, centered: Bool) {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        self.init(rect: CGRect(origin: origin, size: size))
    }
}

// MARK: - 基本的扩展
public extension UIBezierPath {
    /// 根据圆上任意三个点添加圆弧
    /// - Parameters:
    ///   - startPoint:起点
    ///   - centerPoint:中间任意一点
    ///   - endPoint:结束点
    ///   - clockwise:顺时针方向
    func dd_addArc(startPoint: CGPoint, centerPoint: CGPoint, endPoint: CGPoint, clockwise: Bool) {
        // 求圆心
        let arcCenter = dd_getCircleCenter(pontA: startPoint, pontB: centerPoint, pontC: endPoint)
        // 求半径
        let radius = dd_getRadius(center: arcCenter, point: startPoint)
        // 求角度
        let startAngle = dd_getAngle(center: arcCenter, point: startPoint)
        let endAngle = dd_getAngle(center: arcCenter, point: endPoint)
        addArc(withCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }

    /// 根据圆心和任意2个点添加圆弧
    /// - Parameters:
    ///   - arcCenter:圆心
    ///   - startPoint:起点
    ///   - endPoint:结束点
    ///   - clockwise:顺时针,逆时针 这个决定这哪一个半圆
    func dd_addArc(arcCenter: CGPoint, startPoint: CGPoint, endPoint: CGPoint, clockwise: Bool) {
        // 求半径
        let radius = dd_getRadius(center: arcCenter, point: startPoint)
        // 求角度
        let startAngle = dd_getAngle(center: arcCenter, point: startPoint)
        let endAngle = dd_getAngle(center: arcCenter, point: endPoint)
        addArc(withCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }
}

// MARK: - 私有方法
private extension UIBezierPath {
    /// 计算圆心类
    /// 求圆心思路
    /// 0. 设置原先坐标为(centerX,centerY)
    /// 1.求出AB线的斜率,根据AB线的斜率 * AB垂线的斜率 = -1 得出 AB垂线的斜率:shapeABVertical
    /// 2.求出AB的中点,即AB垂线上的点.abCenter
    /// 3.根据斜率 = (y1-y2)/ (x1-x2)
    /// 得出方程:shapeABVertical = (abCenter.y - centerY) / (abCenter.x - centerX)
    /// 同理得出:shapeBCVertical = (bcCenter.y - centerY) / (bcCenter.x - centerX)
    func dd_getCircleCenter(pontA: CGPoint, pontB: CGPoint, pontC: CGPoint) -> CGPoint {
        let abCenter = dd_getCenterPoint(pontA: pontA, pontB: pontB)
        let slopeAB = dd_getSlope(pontA: pontA, pontB: pontB)
        let slopeABVertical = -1 / slopeAB

        let bcCenter = dd_getCenterPoint(pontA: pontB, pontB: pontC)
        let slopeBC = dd_getSlope(pontA: pontB, pontB: pontC)
        let slopeBCVertical = -1 / slopeBC

        return dd_getCircleCenter(slopeA: slopeABVertical, pointA: abCenter, slopeB: slopeBCVertical, pointB: bcCenter)
    }

    func dd_getCircleCenter(slopeA: CGFloat, pointA: CGPoint, slopeB: CGFloat, pointB: CGPoint) -> CGPoint {
        let centerX = -(pointA.y - slopeA * pointA.x - pointB.y + slopeB * pointB.x) / (slopeA - slopeB)
        let centerY = pointA.y - slopeA * (pointA.x - centerX)
        return CGPoint(x: centerX, y: centerY)
    }

    /// 获取两点之间中间点
    /// - Parameters:
    ///   - pontA:A 点
    ///   - pontB:B 点
    /// - Returns:两点之间中间点
    func dd_getCenterPoint(pontA: CGPoint, pontB: CGPoint) -> CGPoint {
        CGPoint(x: (pontA.x + pontB.x) / 2, y: (pontA.y + pontB.y) / 2)
    }

    /// 获取某条线的斜率
    /// - Parameters:
    ///   - pontA:A 点
    ///   - pontB:B 点
    /// - Returns:某条线的斜率
    func dd_getSlope(pontA: CGPoint, pontB: CGPoint) -> CGFloat {
        (pontB.y - pontA.y) / (pontB.x - pontA.x)
    }

    /// 计算出半径
    /// - Parameters:
    ///   - center:中心点
    ///   - point:圆上的某点
    /// - Returns:圆的半径
    func dd_getRadius(center: CGPoint, point: CGPoint) -> CGFloat {
        // 求半径
        let a = Double(Swift.abs(point.x - center.x))
        let b = Double(Swift.abs(point.y - center.y))
        let radius = sqrtf(Float(a * a + b * b))
        return CGFloat(radius)
    }

    /// 根据圆心和圆上的点,求出圆角
    /// ------------------------------------------>
    /// |                    |
    /// |                    |
    /// |     第 三 象 限    |    第四象限
    /// |                    |
    /// |                    |
    /// |                    |
    /// |                    |
    /// |------------------------------------------
    /// |                    |
    /// |                    |
    /// |      第 二 象 限   |   第一象限
    /// |                    |
    /// |                    |
    /// 获取圆心角的方法
    /// - Parameters:
    ///   - center:圆心
    ///   - point:点
    /// - Returns:圆角
    func dd_getAngle(center: CGPoint, point: CGPoint) -> CGFloat {
        let pointX = point.x
        let pointY = point.y

        let centerX = center.x
        let centerY = center.y

        let a = Swift.abs(pointX - centerX)
        let b = Swift.abs(pointY - centerY)

        var angle: Double = 0
        if angle > Double.pi / 2 {
            return CGFloat(angle)
        }
        if pointX > centerX, pointY >= centerY { // 第一象限
            angle = Double(atan(b / a))
        } else if pointX <= centerX, pointY > centerY { //// 第二象限
            angle = Double(atan(a / b))
            if a == 0 {
                angle = 0
            }
            angle = angle + Double.pi / 2
        } else if pointX < centerX, pointY <= centerY { // 第三象限
            angle = Double(atan(b / a))
            if a == 0 {
                angle = 0
            }
            angle = angle + Double.pi

        } else if pointX >= centerX, pointY < centerY { // 第四象限
            angle = Double(atan(a / b))
            if a == 0 {
                angle = 0
            }
            angle = angle + Double.pi / 2 * 3
        }
        return CGFloat(angle)
    }
}
