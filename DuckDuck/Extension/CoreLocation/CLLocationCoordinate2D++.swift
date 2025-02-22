import CoreLocation

// MARK: - CLLocationCoordinate2D 类型转换
public extension CLLocationCoordinate2D {
    /// 将 `CLLocationCoordinate2D` 转换为 `CLLocation`
    /// - Returns: 转换后的 `CLLocation` 实例
    /// - Example:
    ///   ```swift
    ///   let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ///   let location = coordinate.dd_toCLLocation()
    ///   print(location.coordinate)  // CLLocation(latitude: 37.7749, longitude: -122.4194)
    ///   ```
    func dd_toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}

// MARK: - CLLocationCoordinate2D 方法扩展
public extension CLLocationCoordinate2D {
    /// 计算两个 `CLLocationCoordinate2D` (两点)之间的距离
    /// 使用 `CLLocation` 的 `distance(from:)` 方法，计算两个坐标点之间的距离，单位为米。
    /// - Parameter other: 另一个 `CLLocationCoordinate2D` 坐标
    /// - Returns: 两个坐标点之间的距离（单位：米）
    /// - Example:
    ///   ```swift
    ///   let firstCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ///   let secondCoordinate = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
    ///   let distance = firstCoordinate.distance(to: secondCoordinate)
    ///   print("Distance: \(distance) meters")
    ///   ```
    func dd_distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        return self.dd_toCLLocation().distance(from: other.dd_toCLLocation())
    }
}
