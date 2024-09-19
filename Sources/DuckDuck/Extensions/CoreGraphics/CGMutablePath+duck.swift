//
//  CGMutablePath+duck.swift
//
//
//  Created by 王哥 on 2024/7/4.
//

import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGMutablePath {
    /// 转换成`CGPath`
    func dd_CGPath() -> CGPath {
        return self.copy()!
    }
}

// MARK: - 链式语法
public extension CGMutablePath {
    /// 添加路径
    /// - Parameters:
    ///   - path: 路径
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addPath(_ path: CGPath, transform: CGAffineTransform = .identity) -> Self {
        self.addPath(path, transform: transform)
        return self
    }

    /// 添加四边形
    /// - Parameters:
    ///   - rect: 四边形
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addRect(_ rect: CGRect, transform: CGAffineTransform = .identity) -> Self {
        self.addRect(rect, transform: transform)
        return self
    }

    /// 绘制带切角的四边形
    /// - Parameters:
    ///   - rect: 绘制四边形的大小
    ///   - cornerWidth: 切角的宽
    ///   - cornerHeight: 切角的高
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addRoundedRect(in rect: CGRect, cornerWidth: CGFloat, cornerHeight: CGFloat, transform: CGAffineTransform = .identity) -> Self {
        self.addRoundedRect(in: rect, cornerWidth: cornerWidth, cornerHeight: cornerHeight, transform: transform)
        return self
    }

    /// 添加多个四边形
    /// - Parameters:
    ///   - rects: 四边形数组
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addRects(_ rects: [CGRect], transform: CGAffineTransform = .identity) -> Self {
        self.addRects(rects, transform: transform)
        return self
    }

    /// 设置画笔起始点
    /// - Parameters:
    ///   - point: 起始点
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_move(to point: CGPoint, transform: CGAffineTransform = .identity) -> Self {
        self.move(to: point, transform: transform)
        return self
    }

    /// 通过点绘制线
    /// - Parameters:
    ///   - point: 要绘制到的点
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addLine(to point: CGPoint, transform: CGAffineTransform = .identity) -> Self {
        self.addLine(to: point, transform: transform)
        return self
    }

    /// 添加曲线(单控制点)
    /// - Parameters:
    ///   - end: 曲线的绘制结束点
    ///   - control: 曲线绘制的控制点
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addQuadCurve(to end: CGPoint, control: CGPoint, transform: CGAffineTransform = .identity) -> Self {
        self.addQuadCurve(to: end, control: control, transform: transform)
        return self
    }

    /// 添加曲线(双控制点)
    /// - Parameters:
    ///   - end: 曲线的绘制结束点
    ///   - control1: 曲线绘制的控制点一
    ///   - control2: 曲线绘制的控制点二
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addCurve(to end: CGPoint, control1: CGPoint, control2: CGPoint, transform: CGAffineTransform = .identity) -> Self {
        self.addCurve(to: end, control1: control1, control2: control2, transform: transform)
        return self
    }

    /// 根据`points`绘制线
    /// - Parameters:
    ///   - points: 是一个数组，里面存放的是多个点
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addLines(between points: [CGPoint], transform: CGAffineTransform = .identity) -> Self {
        self.addLines(between: points, transform: transform)
        return self
    }

    /// 添加一个椭圆
    /// - Parameters:
    ///   - rect: 绘制椭圆的大小
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addEllipse(in rect: CGRect, transform: CGAffineTransform = .identity) -> Self {
        self.addEllipse(in: rect, transform: transform)
        return self
    }

    /// 添加一个圆弧，没有结束的角度
    /// - Parameters:
    ///   - center: 中心点
    ///   - radius: 半径
    ///   - startAngle: 开始角度
    ///   - delta: 向前或者向后绘制弧度的大小
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, delta: CGFloat, transform: CGAffineTransform = .identity) -> Self {
        self.addRelativeArc(center: center, radius: radius, startAngle: startAngle, delta: delta, transform: transform)
        return self
    }

    /// 添加弧形
    /// - Parameters:
    ///   - center: 中心点
    ///   - radius: 半径
    ///   - startAngle: 开始角度
    ///   - endAngle: 结束角度
    ///   - clockwise: 绘制方向
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool, transform: CGAffineTransform = .identity) -> Self {
        self.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise, transform: transform)
        return self
    }

    /// 添加弧形
    /// - Parameters:
    ///   - tangent1End: 切点1
    ///   - tangent2End: 切点2
    ///   - radius: 半径
    ///   - transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dd_addArc(tangent1End: CGPoint, tangent2End: CGPoint, radius: CGFloat, transform: CGAffineTransform = .identity) -> Self {
        self.addArc(tangent1End: tangent1End, tangent2End: tangent2End, radius: radius, transform: transform)
        return self
    }
}
