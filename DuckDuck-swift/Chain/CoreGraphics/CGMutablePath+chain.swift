import CoreGraphics
import UIKit

extension CGMutablePath: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base: CGMutablePath {
    /// 添加路径
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// let subPath = CGPath(rect: CGRect(x: 10, y: 10, width: 50, height: 50), transform: nil)
    /// mutablePath.dd.add(path: subPath)
    /// ```
    /// - Parameters:
    ///   - path: 要添加的路径
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func add(path: CGPath, withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addPath(path, transform: transform)
        return self
    }

    /// 添加矩形
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// mutablePath.dd.add(rect: CGRect(x: 0, y: 0, width: 100, height: 50))
    /// ```
    /// - Parameters:
    ///   - rect: 要添加的矩形
    ///   - transform: 矩形变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func add(rect: CGRect, withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addRect(rect, transform: transform)
        return self
    }

    /// 添加圆角矩形
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// mutablePath.dd.addRoundedRect(rect: CGRect(x: 0, y: 0, width: 100, height: 50), cornerWidth: 10, cornerHeight: 10)
    /// ```
    /// - Parameters:
    ///   - rect: 圆角矩形的大小
    ///   - cornerWidth: 圆角宽度
    ///   - cornerHeight: 圆角高度
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addRoundedRect(rect: CGRect, cornerWidth: CGFloat, cornerHeight: CGFloat, withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addRoundedRect(in: rect, cornerWidth: cornerWidth, cornerHeight: cornerHeight, transform: transform)
        return self
    }

    /// 添加多个矩形
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// let rects = [CGRect(x: 0, y: 0, width: 50, height: 50), CGRect(x: 60, y: 0, width: 50, height: 50)]
    /// mutablePath.dd.add(rects: rects)
    /// ```
    /// - Parameters:
    ///   - rects: 矩形数组
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func add(rects: [CGRect], withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addRects(rects, transform: transform)
        return self
    }

    /// 设置绘制起点
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// mutablePath.dd.move(to: CGPoint(x: 0, y: 0))
    /// ```
    /// - Parameters:
    ///   - point: 起始点坐标
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func move(to point: CGPoint, withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.move(to: point, transform: transform)
        return self
    }

    /// 添加直线到目标点
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// mutablePath.dd.move(to: CGPoint(x: 0, y: 0))
    /// mutablePath.dd.addLine(to: CGPoint(x: 100, y: 100))
    /// ```
    /// - Parameters:
    ///   - point: 目标点坐标
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addLine(to point: CGPoint, withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addLine(to: point, transform: transform)
        return self
    }

    /// 添加二次贝塞尔曲线
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// mutablePath.dd.move(to: CGPoint(x: 0, y: 0))
    /// mutablePath.dd.addQuadCurve(to: CGPoint(x: 100, y: 100), control: CGPoint(x: 50, y: 150))
    /// ```
    /// - Parameters:
    ///   - endPoint: 曲线终点
    ///   - control: 控制点
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addQuadCurve(to endPoint: CGPoint, control: CGPoint, withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addQuadCurve(to: endPoint, control: control, transform: transform)
        return self
    }

    /// 添加三次贝塞尔曲线
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// mutablePath.dd.move(to: CGPoint(x: 0, y: 0))
    /// mutablePath.dd.addCurve(to: CGPoint(x: 100, y: 100), control1: CGPoint(x: 30, y: 150), control2: CGPoint(x: 70, y: 150))
    /// ```
    /// - Parameters:
    ///   - endPoint: 曲线终点
    ///   - control1: 第一个控制点
    ///   - control2: 第二个控制点
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addCurve(to endPoint: CGPoint, control1: CGPoint, control2: CGPoint, withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addCurve(to: endPoint, control1: control1, control2: control2, transform: transform)
        return self
    }

    /// 根据点数组绘制线段
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// let points = [CGPoint(x: 0, y: 0), CGPoint(x: 50, y: 50), CGPoint(x: 100, y: 100)]
    /// mutablePath.dd.addLines(between: points)
    /// ```
    /// - Parameters:
    ///   - points: 点数组
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addLines(between points: [CGPoint], withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addLines(between: points, transform: transform)
        return self
    }

    /// 添加椭圆路径
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// mutablePath.dd.addEllipse(in: CGRect(x: 0, y: 0, width: 100, height: 50))
    /// ```
    /// - Parameters:
    ///   - rect: 包围椭圆的矩形
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addEllipse(in rect: CGRect, withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addEllipse(in: rect, transform: transform)
        return self
    }

    /// 添加相对弧形路径
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// mutablePath.dd.addRelativeArc(center: CGPoint(x: 50, y: 50), radius: 40, startAngle: 0, delta: .pi / 2)
    /// ```
    /// - Parameters:
    ///   - center: 圆心
    ///   - radius: 半径
    ///   - startAngle: 起始角度
    ///   - delta: 角度变化量
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, delta: CGFloat) -> Self {
        self.base.addRelativeArc(center: center, radius: radius, startAngle: startAngle, delta: delta)
        return self
    }

    /// 添加弧形路径（基于中心点和角度）
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// mutablePath.dd.addArc(center: CGPoint(x: 50, y: 50), radius: 40, startAngle: 0, endAngle: .pi, clockwise: true)
    /// ```
    /// - Parameters:
    ///   - center: 圆弧的中心点
    ///   - radius: 圆弧的半径
    ///   - startAngle: 起始角度
    ///   - endAngle: 终止角度
    ///   - clockwise: 是否顺时针绘制
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool, withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise, transform: transform)
        return self
    }

    /// 添加弧形路径（基于切线）
    ///
    /// ```swift
    /// let mutablePath = CGMutablePath()
    /// mutablePath.dd.move(to: CGPoint(x: 0, y: 0))
    /// mutablePath.dd.addArc(tangent1End: CGPoint(x: 50, y: 0), tangent2End: CGPoint(x: 50, y: 50), radius: 10)
    /// ```
    /// - Parameters:
    ///   - tangent1End: 第一个切点
    ///   - tangent2End: 第二个切点
    ///   - radius: 弧形半径
    ///   - transform: 路径变换，默认为 `.identity`
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func addArc(tangent1End: CGPoint, tangent2End: CGPoint, radius: CGFloat, withTransform transform: CGAffineTransform = .identity) -> Self {
        self.base.addArc(tangent1End: tangent1End, tangent2End: tangent2End, radius: radius, transform: transform)
        return self
    }
}
