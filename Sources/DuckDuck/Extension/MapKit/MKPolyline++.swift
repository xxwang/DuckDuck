//
//  MKPolyline++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 21/11/2024.
//

import MapKit

// MARK: - 构造方法
public extension MKPolyline {
    /// 根据提供的 `CLLocationCoordinate2D` 数组创建一条新的线段
    ///
    /// 此方法简化了 `MKPolyline` 的初始化过程，通过直接传入坐标数组即可创建线段。
    ///
    /// ```swift
    /// let coordinates = [
    ///     CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
    ///     CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
    /// ]
    /// let polyline = MKPolyline(coordinates: coordinates)
    /// mapView.addOverlay(polyline)
    /// ```
    /// - Parameter coordinates: 包含 `CLLocationCoordinate2D` 的数组
    convenience init(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        self.init(coordinates: &mutableCoordinates, count: mutableCoordinates.count)
    }
}

// MARK: - 静态方法
public extension MKPolyline {
    /// 创建包含边界的多段线
    /// - Parameter coordinates: 坐标数组
    /// - Returns: 边界内的多段线
    /// - Example:
    ///   ```swift
    ///   let coordinates = [
    ///       CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
    ///       CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
    ///   ]
    ///   let polyline = MKPolyline.dd_polyline(forBoundingCoordinates: coordinates)
    ///   ```
    static func dd_polyline(forBoundingCoordinates coordinates: [CLLocationCoordinate2D]) -> MKPolyline {
        return MKPolyline(coordinates: coordinates)
    }
}
