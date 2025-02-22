import CoreGraphics

// MARK: - 属性
public extension CGRect {
    /// 获取中心点坐标(包括`origin`, 以`frame`为基准)
    ///
    /// 该方法返回矩形框的中心点坐标，基于`frame`坐标系。中心点的坐标由矩形的`midX`和`midY`确定。
    ///
    /// - Returns: 返回矩形的中心点坐标
    ///
    /// - Example:
    ///     ```swift
    ///     let rect = CGRect(x: 0, y: 0, width: 100, height: 200)
    ///     let center = rect.dd_center()
    ///     print(center) // 输出: (50.0, 100.0)
    ///     ```
    func dd_center() -> CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }

    /// 获取中心点坐标(不包括`origin`, 以`bounds`为基准)
    ///
    /// 该方法返回矩形框的中心点坐标，基于矩形的`bounds`属性。坐标通过`width`和`height`来计算。
    ///
    /// - Returns: 返回矩形的中心点坐标
    ///
    /// - Example:
    ///     ```swift
    ///     let rect = CGRect(x: 0, y: 0, width: 100, height: 200)
    ///     let middle = rect.dd_middle()
    ///     print(middle) // 输出: (50.0, 100.0)
    ///     ```
    func dd_middle() -> CGPoint {
        return CGPoint(x: self.width / 2, y: self.height / 2)
    }
}

// MARK: - 构造方法
public extension CGRect {
    /// 使用`中心点`和`大小`构造`CGRect`
    ///
    /// 该初始化方法通过矩形的中心点和大小来创建`CGRect`，而不是通过`origin`。
    ///
    /// - Parameters:
    ///   - center: 矩形的`中心坐标`
    ///   - size: 矩形的`大小`
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        self.init(origin: origin, size: size)
    }
}

// MARK: - 方法
public extension CGRect {
    /// 通过`目标尺寸`及`锚点`来调整一个`CGRect`
    ///
    /// 该方法可以通过指定一个目标尺寸和一个锚点来调整矩形的大小。锚点在矩形中指定一个相对位置，矩形将以此点为基准进行大小调整。
    /// 锚点范围从`(0,0)`到`(1,1)`，分别表示矩形的左上角到右下角。默认为`(0.5, 0.5)`，即矩形的中心点。
    ///
    /// - Parameters:
    ///   - size: 目标尺寸
    ///   - anchor: 锚点位置，默认为`(0.5, 0.5)`
    /// - Returns: 调整后的`CGRect`
    ///
    /// - Example:
    ///     ```swift
    ///     let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
    ///     let resizedRect = rect.dd_resizing(to: CGSize(width: 150, height: 150), anchor: CGPoint(x: 0.0, y: 1.0))
    ///     print(resizedRect) // 输出: (0.0, -25.0, 150.0, 150.0)
    ///     ```
    func dd_resizing(to size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> CGRect {
        let sizeDelta = CGSize(width: size.width - self.width, height: size.height - self.height)
        let origin = CGPoint(x: self.minX - sizeDelta.width * anchor.x, y: self.minY - sizeDelta.height * anchor.y)
        return CGRect(origin: origin, size: size)
    }
}
