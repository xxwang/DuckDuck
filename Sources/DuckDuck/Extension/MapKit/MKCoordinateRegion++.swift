//
//  MKCoordinateRegion++.swift
//  DuckDuck
//
//  Created by xxwang on 21/11/2024.
//

import MapKit

// MARK: - 实用工具
public extension MKCoordinateRegion {
    /// 获取当前区域的左上角坐标
    /// - Returns: 左上角的 `CLLocationCoordinate2D` 坐标
    /// - Example:
    ///   ```swift
    ///   let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    ///   let topLeft = region.dd_topLeftCoordinate
    ///   ```
    var dd_topLeftCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: center.latitude + (span.latitudeDelta / 2),
            longitude: center.longitude - (span.longitudeDelta / 2)
        )
    }

    /// 获取当前区域的右下角坐标
    /// - Returns: 右下角的 `CLLocationCoordinate2D` 坐标
    /// - Example:
    ///   ```swift
    ///   let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    ///   let bottomRight = region.dd_bottomRightCoordinate
    ///   ```
    var dd_bottomRightCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: center.latitude - (span.latitudeDelta / 2),
            longitude: center.longitude + (span.longitudeDelta / 2)
        )
    }
}

public extension MKCoordinateRegion {
    /// 计算两个坐标的包含区域
    /// - Parameters:
    ///   - coordinates: 坐标数组
    ///   - margin: 边界间距（单位：米）
    /// - Returns: 包含所有坐标的区域
    /// - Example:
    ///   ```swift
    ///   let coordinates = [
    ///       CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
    ///       CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
    ///   ]
    ///   let region = MKCoordinateRegion.dd_boundingRegion(for: coordinates, margin: 1000)
    ///   ```
    static func dd_boundingRegion(for coordinates: [CLLocationCoordinate2D], margin: CLLocationDistance = 100) -> MKCoordinateRegion {
        guard !coordinates.isEmpty else { return MKCoordinateRegion() }
        let latitudes = coordinates.map(\.latitude)
        let longitudes = coordinates.map(\.longitude)

        let minLat = latitudes.min()!
        let maxLat = latitudes.max()!
        let minLon = longitudes.min()!
        let maxLon = longitudes.max()!

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)

        return MKCoordinateRegion(center: center, span: span).expanded(by: margin)
    }

    /// 扩展区域
    /// - Parameter margin: 扩展边距（单位：米）
    /// - Returns: 扩展后的区域
    /// - Example:
    ///   ```swift
    ///   let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    ///   let expandedRegion = region.expanded(by: 500)
    ///   ```
    func expanded(by margin: CLLocationDistance) -> MKCoordinateRegion {
        let spanLat = span.latitudeDelta + margin / 111_000 // 1度纬度约等于111公里
        let spanLon = span.longitudeDelta + margin / (111_000 * cos(center.latitude * .pi / 180))
        return MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLon)
        )
    }
}
