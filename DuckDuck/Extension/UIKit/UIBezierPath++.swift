import UIKit

// MARK: - 构造方法
public extension UIBezierPath {
    /// 使用从一个`CGPoint`到另一个`CGPoint`的直线初始化`UIBezierPath`
    ///
    /// - Parameters:
    ///   - from: 路径的起点
    ///   - to: 路径的终点
    ///
    /// - Example:
    /// ```swift
    /// let path = UIBezierPath(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 100, y: 100))
    /// ```
    convenience init(from: CGPoint, to otherPoint: CGPoint) {
        self.init()
        move(to: from)
        addLine(to: otherPoint)
    }

    /// 初始化一个路径，通过直线连接给定的多个`CGPoint`
    ///
    /// - Parameter points: 路径所包含的多个点
    ///
    /// - Example:
    /// ```swift
    /// let points = [CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 0), CGPoint(x: 100, y: 100)]
    /// let path = UIBezierPath(points: points)
    /// ```
    convenience init(points: [CGPoint]) {
        self.init()
        guard !points.isEmpty else { return }
        move(to: points[0])
        for point in points.dropFirst() {
            addLine(to: point)
        }
    }

    /// 使用给定的`CGPoint`初始化多边形路径，至少需要3个点
    ///
    /// - Parameter points: 路径所包含的点
    /// - Returns: 一个多边形路径，若点数小于3则返回`nil`
    ///
    /// - Example:
    /// ```swift
    /// let points = [CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 0), CGPoint(x: 50, y: 100)]
    /// if let path = UIBezierPath(polygonWithPoints: points) {
    ///     // 使用path绘制多边形
    /// }
    /// ```
    convenience init?(polygonWithPoints points: [CGPoint]) {
        guard points.count > 2 else { return nil }
        self.init()
        move(to: points[0])
        for point in points.dropFirst() {
            addLine(to: point)
        }
        close() // 闭合路径，连接最后一个点与第一个点
    }

    /// 使用给定大小的椭圆形路径初始化`UIBezierPath`
    ///
    /// - Parameters:
    ///   - size: 椭圆的宽度和高度
    ///   - centered: 是否将椭圆居中
    ///
    /// - Example:
    /// ```swift
    /// let path = UIBezierPath(ovalOf: CGSize(width: 100, height: 50), centered: true)
    /// ```
    convenience init(ovalOf size: CGSize, centered: Bool) {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        self.init(ovalIn: CGRect(origin: origin, size: size))
    }

    /// 使用给定大小的矩形路径初始化`UIBezierPath`
    ///
    /// - Parameters:
    ///   - size: 矩形的宽度和高度
    ///   - centered: 是否将矩形居中
    ///
    /// - Example:
    /// ```swift
    /// let path = UIBezierPath(rectOf: CGSize(width: 200, height: 100), centered: false)
    /// ```
    convenience init(rectOf size: CGSize, centered: Bool) {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        self.init(rect: CGRect(origin: origin, size: size))
    }
}

// MARK: - 基本的扩展
public extension UIBezierPath {
    /// 根据圆上任意三个点添加圆弧
    /// - Parameters:
    ///   - startPoint: 起点坐标
    ///   - centerPoint: 中间任意点坐标
    ///   - endPoint: 结束点坐标
    ///   - clockwise: 是否顺时针方向绘制
    /// - Example:
    /// ```swift
    /// path.dd_addArc(startPoint: startPoint, centerPoint: centerPoint, endPoint: endPoint, clockwise: true)
    /// ```
    func dd_addArc(startPoint: CGPoint, centerPoint: CGPoint, endPoint: CGPoint, clockwise: Bool) {
        // 计算圆心
        let arcCenter = dd_calculateCircleCenter(pointA: startPoint, pointB: centerPoint, pointC: endPoint)
        // 计算半径
        let radius = dd_calculateRadius(center: arcCenter, point: startPoint)
        // 计算起始和结束角度
        let startAngle = dd_calculateAngle(center: arcCenter, point: startPoint)
        let endAngle = dd_calculateAngle(center: arcCenter, point: endPoint)
        // 添加圆弧
        addArc(withCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }

    /// 根据圆心和任意2个点添加圆弧
    /// - Parameters:
    ///   - arcCenter: 圆心坐标
    ///   - startPoint: 起点坐标
    ///   - endPoint: 结束点坐标
    ///   - clockwise: 是否顺时针方向绘制
    /// - Example:
    /// ```swift
    /// path.dd_addArc(arcCenter: arcCenter, startPoint: startPoint, endPoint: endPoint, clockwise: false)
    /// ```
    func dd_addArc(arcCenter: CGPoint, startPoint: CGPoint, endPoint: CGPoint, clockwise: Bool) {
        // 计算半径
        let radius = dd_calculateRadius(center: arcCenter, point: startPoint)
        // 计算起始和结束角度
        let startAngle = dd_calculateAngle(center: arcCenter, point: startPoint)
        let endAngle = dd_calculateAngle(center: arcCenter, point: endPoint)
        // 添加圆弧
        addArc(withCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }

    /// 绘制矩形路径
    /// - Parameter size: 矩形的宽度和高度
    /// - Parameter centered: 是否居中矩形，默认为 `false`
    ///
    /// 示例:
    /// ```swift
    /// let path = UIBezierPath()
    /// path.dd_addRectangle(size: CGSize(width: 100, height: 50), centered: true)
    /// ```
    func dd_addRectangle(size: CGSize, centered: Bool = false) {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        self.append(UIBezierPath(rect: CGRect(origin: origin, size: size)))
    }

    /// 绘制椭圆路径
    /// - Parameter size: 椭圆的宽度和高度
    /// - Parameter centered: 是否居中椭圆，默认为 `false`
    ///
    /// 示例:
    /// ```swift
    /// let path = UIBezierPath()
    /// path.dd_addEllipse(size: CGSize(width: 100, height: 50))
    /// ```
    func dd_addEllipse(size: CGSize, centered: Bool = false) {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        self.append(UIBezierPath(ovalIn: CGRect(origin: origin, size: size)))
    }

    /// 绘制圆形路径
    /// - Parameter radius: 圆的半径
    /// - Parameter centered: 是否居中圆形，默认为 `false`
    ///
    /// 示例:
    /// ```swift
    /// let path = UIBezierPath()
    /// path.dd_addCircle(radius: 50, centered: true)
    /// ```
    func dd_addCircle(radius: CGFloat, centered: Bool = false) {
        let origin = centered ? CGPoint(x: -radius, y: -radius) : .zero
        self.append(UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))))
    }

    /// 绘制二次贝塞尔曲线
    /// - Parameters:
    ///   - controlPoint: 控制点
    ///   - endPoint: 终点
    ///
    /// 示例:
    /// ```swift
    /// let path = UIBezierPath()
    /// path.dd_addQuadCurve(to: CGPoint(x: 100, y: 200), controlPoint: CGPoint(x: 50, y: 100))
    /// ```
    func dd_addQuadCurve(to endPoint: CGPoint, controlPoint: CGPoint) {
        self.addQuadCurve(to: endPoint, controlPoint: controlPoint)
    }

    /// 绘制三次贝塞尔曲线
    /// - Parameters:
    ///   - controlPoint1: 第一个控制点
    ///   - controlPoint2: 第二个控制点
    ///   - endPoint: 终点
    ///
    /// 示例:
    /// ```swift
    /// let path = UIBezierPath()
    /// path.dd_addCubicCurve(to: CGPoint(x: 200, y: 300), controlPoint1: CGPoint(x: 50, y: 150), controlPoint2: CGPoint(x: 150, y: 250))
    /// ```
    func dd_addCubicCurve(to endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }

    /// 绘制箭头路径
    /// - Parameters:
    ///   - startPoint: 箭头的起点
    ///   - endPoint: 箭头的终点
    ///   - arrowHeadSize: 箭头头部的大小
    ///
    /// 示例:
    /// ```swift
    /// let path = UIBezierPath()
    /// path.dd_addArrow(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 100, y: 100), arrowHeadSize: 10)
    /// ```
    func dd_addArrow(from startPoint: CGPoint, to endPoint: CGPoint, arrowHeadSize: CGFloat) {
        self.move(to: startPoint)
        self.addLine(to: endPoint)

        let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
        let arrowHeadAngle: CGFloat = .pi / 6

        let arrowHeadPoint1 = CGPoint(
            x: endPoint.x - arrowHeadSize * cos(angle - arrowHeadAngle),
            y: endPoint.y - arrowHeadSize * sin(angle - arrowHeadAngle)
        )
        let arrowHeadPoint2 = CGPoint(
            x: endPoint.x - arrowHeadSize * cos(angle + arrowHeadAngle),
            y: endPoint.y - arrowHeadSize * sin(angle + arrowHeadAngle)
        )

        self.move(to: endPoint)
        self.addLine(to: arrowHeadPoint1)
        self.move(to: endPoint)
        self.addLine(to: arrowHeadPoint2)
    }

    /// 绘制正多边形路径
    /// - Parameters:
    ///   - sides: 多边形的边数
    ///   - radius: 多边形的半径
    ///   - centered: 是否居中多边形，默认为 `false`
    ///
    /// 示例:
    /// ```swift
    /// let path = UIBezierPath()
    /// path.dd_addPolygon(sides: 5, radius: 50)
    /// ```
    func dd_addPolygon(sides: Int, radius: CGFloat, centered: Bool = false) {
        guard sides >= 3 else { return }

        let angle = 2 * CGFloat.pi / CGFloat(sides)
        let center = centered ? CGPoint(x: 0, y: 0) : .zero

        let firstPoint = CGPoint(
            x: center.x + radius * cos(0),
            y: center.y + radius * sin(0)
        )
        self.move(to: firstPoint)

        for i in 1 ..< sides {
            let x = center.x + radius * cos(angle * CGFloat(i))
            let y = center.y + radius * sin(angle * CGFloat(i))
            self.addLine(to: CGPoint(x: x, y: y))
        }

        self.close()
    }

    /// 创建由多个点组成的路径
    /// - Parameter points: 点的数组
    ///
    /// 示例:
    /// ```swift
    /// let path = UIBezierPath()
    /// path.dd_addShape(from: [CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 100), CGPoint(x: 200, y: 0)])
    /// ```
    func dd_addShape(from points: [CGPoint]) {
        guard !points.isEmpty else { return }

        self.move(to: points[0])
        for point in points[1...] {
            self.addLine(to: point)
        }

        self.close()
    }
}

// MARK: - 计算方法
public extension UIBezierPath {
    /// 计算圆心
    /// 通过三点的坐标计算圆心的位置
    /// - Parameters:
    ///   - pointA: 第一个点的坐标
    ///   - pointB: 第二个点的坐标
    ///   - pointC: 第三个点的坐标
    /// - Returns: 计算得到的圆心坐标
    /// - Example:
    /// ```swift
    /// let center = path.dd_calculateCircleCenter(pointA: pointA, pointB: pointB, pointC: pointC)
    /// ```
    func dd_calculateCircleCenter(pointA: CGPoint, pointB: CGPoint, pointC: CGPoint) -> CGPoint {
        let abCenter = dd_calculateCenterPoint(pointA: pointA, pointB: pointB)
        let slopeAB = dd_calculateSlope(pointA: pointA, pointB: pointB)
        let slopeABVertical = -1 / slopeAB

        let bcCenter = dd_calculateCenterPoint(pointA: pointB, pointB: pointC)
        let slopeBC = dd_calculateSlope(pointA: pointB, pointB: pointC)
        let slopeBCVertical = -1 / slopeBC

        return dd_findCircleCenter(slopeA: slopeABVertical, pointA: abCenter, slopeB: slopeBCVertical, pointB: bcCenter)
    }

    /// 通过两条垂直线的斜率和两条线的中心点计算圆心
    /// - Parameters:
    ///   - slopeA: 第一条垂直线的斜率
    ///   - pointA: 第一条线的中点
    ///   - slopeB: 第二条垂直线的斜率
    ///   - pointB: 第二条线的中点
    /// - Returns: 计算得到的圆心坐标
    ///
    /// 示例:
    /// ```swift
    /// let slopeA: CGFloat = -1 // 第一条垂直线的斜率
    /// let pointA = CGPoint(x: 100, y: 200) // 第一条线的中点
    /// let slopeB: CGFloat = 1 // 第二条垂直线的斜率
    /// let pointB = CGPoint(x: 150, y: 250) // 第二条线的中点
    /// let circleCenter = findCircleCenter(slopeA: slopeA, pointA: pointA, slopeB: slopeB, pointB: pointB)
    /// print(circleCenter) // 输出圆心的坐标
    /// ```
    func dd_findCircleCenter(slopeA: CGFloat, pointA: CGPoint, slopeB: CGFloat, pointB: CGPoint) -> CGPoint {
        let centerX = -(pointA.y - slopeA * pointA.x - pointB.y + slopeB * pointB.x) / (slopeA - slopeB)
        let centerY = pointA.y - slopeA * (pointA.x - centerX)
        return CGPoint(x: centerX, y: centerY)
    }

    /// 计算两点之间的中点
    /// - Parameters:
    ///   - pointA: 第一个点的坐标
    ///   - pointB: 第二个点的坐标
    /// - Returns: 两点之间的中点坐标
    /// - Example:
    /// ```swift
    /// let midpoint = path.dd_calculateCenterPoint(pointA: pointA, pointB: pointB)
    /// ```
    func dd_calculateCenterPoint(pointA: CGPoint, pointB: CGPoint) -> CGPoint {
        return CGPoint(x: (pointA.x + pointB.x) / 2, y: (pointA.y + pointB.y) / 2)
    }

    /// 计算两点之间的斜率
    /// - Parameters:
    ///   - pointA: 第一个点的坐标
    ///   - pointB: 第二个点的坐标
    /// - Returns: 两点之间的斜率
    /// - Example:
    /// ```swift
    /// let slope = path.dd_calculateSlope(pointA: pointA, pointB: pointB)
    /// ```
    func dd_calculateSlope(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
        return (pointB.y - pointA.y) / (pointB.x - pointA.x)
    }

    /// 计算圆的半径
    /// - Parameters:
    ///   - center: 圆心的坐标
    ///   - point: 圆上的任意一点
    /// - Returns: 圆的半径
    /// - Example:
    /// ```swift
    /// let radius = path.dd_calculateRadius(center: centerPoint, point: pointOnCircle)
    /// ```
    func dd_calculateRadius(center: CGPoint, point: CGPoint) -> CGFloat {
        let a = Double(abs(point.x - center.x))
        let b = Double(abs(point.y - center.y))
        return CGFloat(sqrt(a * a + b * b))
    }

    /// 计算圆心角
    /// 计算圆心与指定点之间的角度
    /// - Parameters:
    ///   - center: 圆心的坐标
    ///   - point: 圆上的点
    /// - Returns: 圆心角
    /// - Example:
    /// ```swift
    /// let angle = path.dd_calculateAngle(center: centerPoint, point: pointOnCircle)
    /// ```
    func dd_calculateAngle(center: CGPoint, point: CGPoint) -> CGFloat {
        let pointX = point.x
        let pointY = point.y
        let centerX = center.x
        let centerY = center.y

        let a = abs(pointX - centerX)
        let b = abs(pointY - centerY)

        var angle: Double = 0
        if angle > Double.pi / 2 {
            return CGFloat(angle)
        }
        if pointX > centerX, pointY >= centerY { // 第一象限
            angle = Double(atan(b / a))
        } else if pointX <= centerX, pointY > centerY { // 第二象限
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
