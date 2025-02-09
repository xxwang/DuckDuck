import MapKit

// MARK: - MKMultiPoint 扩展
public extension MKMultiPoint {
    /// 获取 `MKMultiPoint` 的所有坐标
    ///
    /// 此方法返回当前多点对象包含的所有坐标点。
    ///
    /// ```swift
    /// if let polyline = overlay as? MKPolyline {
    ///     let coordinates = polyline.dd_coordinates()
    ///     print("Polyline coordinates: \(coordinates)")
    /// }
    /// ```
    /// - Returns: 一个包含所有坐标的 `CLLocationCoordinate2D` 数组
    func dd_coordinates() -> [CLLocationCoordinate2D] {
        let pointCount = self.pointCount
        guard pointCount > 0 else { return [] }

        // 创建一个数组来存储坐标，初始值为无效坐标
        var coordinates = [CLLocationCoordinate2D](
            repeating: kCLLocationCoordinate2DInvalid,
            count: pointCount
        )

        // 从对象中获取坐标
        self.getCoordinates(&coordinates, range: NSRange(location: 0, length: pointCount))
        return coordinates
    }
}
