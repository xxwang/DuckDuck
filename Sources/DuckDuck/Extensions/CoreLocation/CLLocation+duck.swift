//
//  CLLocation+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreLocation
import Foundation

// MARK: - 方法
public extension CLLocation {
    /// 计算`两点之间`的`大圆路径`的`中间点`
    /// - Parameter point: 结束`CLLocation`
    /// - Returns: 中间点`CLLocation`
    func dd_middleLocation(to point: CLLocation) -> CLLocation {
        let lat1 = Double.pi * self.coordinate.latitude / 180.0
        let long1 = Double.pi * self.coordinate.longitude / 180.0

        let lat2 = Double.pi * point.coordinate.latitude / 180.0
        let long2 = Double.pi * point.coordinate.longitude / 180.0

        let bxLoc = cos(lat2) * cos(long2 - long1)
        let byLoc = cos(lat2) * sin(long2 - long1)
        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bxLoc) * (cos(lat1) + bxLoc) + (byLoc * byLoc)))
        let mlong = long1 + atan2(byLoc, cos(lat1) + bxLoc)

        return CLLocation(latitude: mlat * 180 / Double.pi, longitude: mlong * 180 / Double.pi)
    }

    /// 计算两个`CLLocation` 的方位角
    /// - Parameters:
    ///   - destination: 参与计算的`CLLocation`
    /// - Returns:`Double`类型方位角, 范围 `0°... 360° `
    func dd_bearing(to destination: CLLocation) -> Double {
        let lat1 = Double.pi * self.coordinate.latitude / 180.0
        let long1 = Double.pi * self.coordinate.longitude / 180.0
        let lat2 = Double.pi * destination.coordinate.latitude / 180.0
        let long2 = Double.pi * destination.coordinate.longitude / 180.0

        let rads = atan2(
            sin(long2 - long1) * cos(lat2),
            cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1)
        )
        let degrees = rads * 180 / Double.pi

        return (degrees + 360).truncatingRemainder(dividingBy: 360)
    }
}

// MARK: - `CLLocation`数组
public extension [CLLocation] {
    /// 根据地球的曲率,计算数组中每个`CLLocation`距离的总和
    /// - Parameter unit: 距离单位`UnitLength`
    /// - Returns: 指定单位的距离总和
    func dd_distance(unitLength unit: UnitLength) -> Measurement<UnitLength> {
        guard self.count > 1 else {
            return Measurement(value: 0.0, unit: unit)
        }
        var distance: CLLocationDistance = 0.0
        for idx in 0 ..< self.count - 1 {
            distance += self[idx].distance(from: self[idx + 1])
        }
        return Measurement(value: distance, unit: UnitLength.meters).converted(to: unit)
    }
}
