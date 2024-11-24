//
//  MKMapRect++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 21/11/2024.
//

import MapKit

public extension MKMapRect {
    /// 从 MKCoordinateRegion 转换为 MKMapRect
    /// - Parameter region: 地理区域
    /// - Returns: 对应的地图矩形
    /// - Example:
    ///   ```swift
    ///   let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    ///   let mapRect = MKMapRect.regionToMapRect(region)
    ///   ```
    static func regionToMapRect(_ region: MKCoordinateRegion) -> MKMapRect {
        let topLeft = MKMapPoint(region.dd_topLeftCoordinate)
        let bottomRight = MKMapPoint(region.dd_bottomRightCoordinate)
        return MKMapRect(
            origin: MKMapPoint(x: topLeft.x, y: topLeft.y),
            size: MKMapSize(width: abs(bottomRight.x - topLeft.x), height: abs(bottomRight.y - topLeft.y))
        )
    }
}
