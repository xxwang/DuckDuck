//
//  CAShapeLayer+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import QuartzCore
import UIKit

// MARK: - 链式语法
public extension DDExtension where Base: CAShapeLayer {
    /// 设置路径
    /// - Parameter path: 路径
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.path(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100)).cgPath)
    /// ```
    @discardableResult
    func path(_ path: CGPath) -> Self {
        self.base.path = path
        return self
    }

    /// 设置线宽
    /// - Parameter width: 线宽
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.lineWidth(2.0)
    /// ```
    @discardableResult
    func lineWidth(_ width: CGFloat) -> Self {
        self.base.lineWidth = width
        return self
    }

    /// 设置填充颜色
    /// - Parameter color: 填充颜色
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.fillColor(.red)
    /// ```
    @discardableResult
    func fillColor(_ color: UIColor) -> Self {
        self.base.fillColor = color.cgColor
        return self
    }

    /// 设置笔触颜色
    /// - Parameter color: 笔触颜色
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.strokeColor(.blue)
    /// ```
    @discardableResult
    func strokeColor(_ color: UIColor) -> Self {
        self.base.strokeColor = color.cgColor
        return self
    }

    /// 设置笔触的开始位置
    /// - Parameter strokeStart: 画笔的起始位置
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.strokeStart(0.2)
    /// ```
    @discardableResult
    func strokeStart(_ strokeStart: CGFloat) -> Self {
        self.base.strokeStart = strokeStart
        return self
    }

    /// 设置笔触的结束位置
    /// - Parameter strokeEnd: 画笔的结束位置
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.strokeEnd(0.8)
    /// ```
    @discardableResult
    func strokeEnd(_ strokeEnd: CGFloat) -> Self {
        self.base.strokeEnd = strokeEnd
        return self
    }

    /// 设置最大斜接长度
    /// - Parameter miterLimit: 最大斜接长度
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.miterLimit(10.0)
    /// ```
    @discardableResult
    func miterLimit(_ miterLimit: CGFloat) -> Self {
        self.base.miterLimit = miterLimit
        return self
    }

    /// 设置线帽样式
    /// - Parameter lineCap: 线帽样式
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.lineCap(.round)
    /// ```
    @discardableResult
    func lineCap(_ lineCap: CAShapeLayerLineCap) -> Self {
        self.base.lineCap = lineCap
        return self
    }

    /// 设置线条的连接样式
    /// - Parameter lineJoin: 连接样式
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.lineJoin(.bevel)
    /// ```
    @discardableResult
    func lineJoin(_ lineJoin: CAShapeLayerLineJoin) -> Self {
        self.base.lineJoin = lineJoin
        return self
    }

    /// 设置填充路径的填充规则
    /// - Parameter fillRule: 填充规则
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.fillRule(.evenOdd)
    /// ```
    @discardableResult
    func fillRule(_ fillRule: CAShapeLayerFillRule) -> Self {
        self.base.fillRule = fillRule
        return self
    }

    /// 设置线型模版的起点
    /// - Parameter lineDashPhase: 线型模版的起点
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.lineDashPhase(5.0)
    /// ```
    @discardableResult
    func lineDashPhase(_ lineDashPhase: CGFloat) -> Self {
        self.base.lineDashPhase = lineDashPhase
        return self
    }

    /// 设置线型模版
    /// - Parameter lineDashPattern: 线型模版
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.lineDashPattern([6, 3])
    /// ```
    @discardableResult
    func lineDashPattern(_ lineDashPattern: [NSNumber]) -> Self {
        self.base.lineDashPattern = lineDashPattern
        return self
    }
}
