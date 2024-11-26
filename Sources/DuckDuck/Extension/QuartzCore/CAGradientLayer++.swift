//
//  CAGradientLayer++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import QuartzCore
import UIKit

// MARK: - 构造方法
public extension CAGradientLayer {
    /// 创建渐变图层(`CAGradientLayer`)
    /// - Parameters:
    ///   - frame: 图层尺寸及位置信息
    ///   - colors: 颜色位置数组
    ///   - locations: 颜色数组中颜色对应的位置
    ///   - startPoint: 渐变开始点
    ///   - endPoint: 渐变结束点
    ///   - type: 渐变类型
    convenience init(_ frame: CGRect = .zero,
                     colors: [UIColor],
                     locations: [CGFloat]? = nil,
                     startPoint: CGPoint,
                     endPoint: CGPoint,
                     type: CAGradientLayerType = .axial)
    {
        self.init()
        self.dd_frame(frame)
            .dd_colors(colors)
            .dd_locations(locations ?? [])
            .dd_startPoint(startPoint)
            .dd_endPoint(endPoint)
            .dd_type(type)
    }
}

// MARK: - 链式语法
public extension CAGradientLayer {
    /// 设置渐变类型
    /// - Parameter type: 渐变类型，`CAGradientLayerType` 用于指定渐变的方向类型。可以选择 `axial` 或 `radial`。
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `gradientLayer.dd_type(.axial)`
    @discardableResult
    func dd_type(_ type: CAGradientLayerType) -> Self {
        self.type = type
        return self
    }

    /// 设置渐变颜色数组
    /// - Parameter colors: 要设置的渐变颜色数组，颜色会从一个颜色渐变到另一个颜色。
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `gradientLayer.dd_colors([.red, .blue])`
    @discardableResult
    func dd_colors(_ colors: [UIColor]) -> Self {
        let cgColors = colors.map(\.cgColor)
        self.colors = cgColors
        return self
    }

    /// 设置渐变位置数组
    /// - Parameter locations: 要设置的渐变位置数组，数组中的每个元素是一个 `CGFloat`，表示渐变的进度位置，`0` 到 `1`。
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `gradientLayer.dd_locations([0, 0.5, 1])`
    @discardableResult
    func dd_locations(_ locations: [CGFloat] = [0, 1]) -> Self {
        let locationNumbers = locations.map { flt in
            return NSNumber(floatLiteral: flt)
        }
        self.locations = locationNumbers
        return self
    }

    /// 设置渐变开始位置
    /// - Parameter startPoint: 渐变开始位置，默认是 `.zero`，即左上角 (0, 0)
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `gradientLayer.dd_startPoint(CGPoint(x: 0, y: 0))`
    @discardableResult
    func dd_startPoint(_ startPoint: CGPoint = .zero) -> Self {
        self.startPoint = startPoint
        return self
    }

    /// 设置渐变结束位置
    /// - Parameter endPoint: 渐变结束位置，默认是 `.zero`，即左上角 (0, 0)
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `gradientLayer.dd_endPoint(CGPoint(x: 1, y: 1))`
    @discardableResult
    func dd_endPoint(_ endPoint: CGPoint = .zero) -> Self {
        self.endPoint = endPoint
        return self
    }

    /// 设置图层的加速器
    /// - Parameter speed: 加速器速度，值越大动画越快。可以调整 `CAGradientLayer` 的动画速度。
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `gradientLayer.dd_speed(2.0)`
    @discardableResult
    func dd_speed(_ speed: Float) -> Self {
        self.speed = speed
        return self
    }
}
