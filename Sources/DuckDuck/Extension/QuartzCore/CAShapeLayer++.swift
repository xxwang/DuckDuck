//
//  CAShapeLayer++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import QuartzCore
import UIKit

public extension CAShapeLayer {
    /// 创建一个默认的 `CAShapeLayer`
    /// - Returns: 默认的 `CAShapeLayer` 实例
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer.default()
    /// ```
    static func `default`() -> CAShapeLayer {
        return CAShapeLayer()
    }
}

// MARK: - 链式语法
public extension CAShapeLayer {
    /// 设置路径
    /// - Parameter path: 路径
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_path(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100)).cgPath)
    /// ```
    @discardableResult
    func dd_path(_ path: CGPath) -> Self {
        self.path = path
        return self
    }

    /// 设置线宽
    /// - Parameter width: 线宽
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_lineWidth(2.0)
    /// ```
    @discardableResult
    func dd_lineWidth(_ width: CGFloat) -> Self {
        lineWidth = width
        return self
    }

    /// 设置填充颜色
    /// - Parameter color: 填充颜色
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_fillColor(.red)
    /// ```
    @discardableResult
    func dd_fillColor(_ color: UIColor) -> Self {
        fillColor = color.cgColor
        return self
    }

    /// 设置笔触颜色
    /// - Parameter color: 笔触颜色
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_strokeColor(.blue)
    /// ```
    @discardableResult
    func dd_strokeColor(_ color: UIColor) -> Self {
        strokeColor = color.cgColor
        return self
    }

    /// 设置笔触的开始位置
    /// - Parameter strokeStart: 画笔的起始位置
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_strokeStart(0.2)
    /// ```
    @discardableResult
    func dd_strokeStart(_ strokeStart: CGFloat) -> Self {
        self.strokeStart = strokeStart
        return self
    }

    /// 设置笔触的结束位置
    /// - Parameter strokeEnd: 画笔的结束位置
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_strokeEnd(0.8)
    /// ```
    @discardableResult
    func dd_strokeEnd(_ strokeEnd: CGFloat) -> Self {
        self.strokeEnd = strokeEnd
        return self
    }

    /// 设置最大斜接长度
    /// - Parameter miterLimit: 最大斜接长度
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_miterLimit(10.0)
    /// ```
    @discardableResult
    func dd_miterLimit(_ miterLimit: CGFloat) -> Self {
        self.miterLimit = miterLimit
        return self
    }

    /// 设置线帽样式
    /// - Parameter lineCap: 线帽样式
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_lineCap(.round)
    /// ```
    @discardableResult
    func dd_lineCap(_ lineCap: CAShapeLayerLineCap) -> Self {
        self.lineCap = lineCap
        return self
    }

    /// 设置线条的连接样式
    /// - Parameter lineJoin: 连接样式
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_lineJoin(.bevel)
    /// ```
    @discardableResult
    func dd_lineJoin(_ lineJoin: CAShapeLayerLineJoin) -> Self {
        self.lineJoin = lineJoin
        return self
    }

    /// 设置填充路径的填充规则
    /// - Parameter fillRule: 填充规则
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_fillRule(.evenOdd)
    /// ```
    @discardableResult
    func dd_fillRule(_ fillRule: CAShapeLayerFillRule) -> Self {
        self.fillRule = fillRule
        return self
    }

    /// 设置线型模版的起点
    /// - Parameter lineDashPhase: 线型模版的起点
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_lineDashPhase(5.0)
    /// ```
    @discardableResult
    func dd_lineDashPhase(_ lineDashPhase: CGFloat) -> Self {
        self.lineDashPhase = lineDashPhase
        return self
    }

    /// 设置线型模版
    /// - Parameter lineDashPattern: 线型模版
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd_lineDashPattern([6, 3])
    /// ```
    @discardableResult
    func dd_lineDashPattern(_ lineDashPattern: [NSNumber]) -> Self {
        self.lineDashPattern = lineDashPattern
        return self
    }
}
