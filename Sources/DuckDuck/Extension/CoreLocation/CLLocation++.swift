//
//  CLLocation++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import CoreLocation

// MARK: - CLLocation 方法扩展
public extension CLLocation {
    /// 计算当前 `CLLocation` 到目标 `CLLocation` 的直线距离
    /// - Parameters:
    ///   - location: 目标位置，即要计算距离的 `CLLocation`
    ///   - unit: 距离的单位，默认为 `.meters`。可以选择 `.kilometers`、`.miles` 等单位进行转换
    /// - Returns: 计算结果，以指定的单位返回一个 `Measurement` 对象，包含距离和单位
    ///
    /// - Example:
    /// ```swift
    /// let currentLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
    /// let destinationLocation = CLLocation(latitude: 34.0522, longitude: -118.2437) // Los Angeles
    ///
    /// let distanceInKilometers = currentLocation.dd_distance(to: destinationLocation, unit: .kilometers)
    /// print("Distance: \(distanceInKilometers.value) kilometers") // 输出计算结果，例如：Distance: 559.231 kilometers
    /// ```
    func dd_distance(to location: CLLocation, unit: UnitLength = .meters) -> Measurement<UnitLength> {
        let distanceInMeters = self.distance(from: location) // 计算以米为单位的距离
        return Measurement(value: distanceInMeters, unit: UnitLength.meters).converted(to: unit) // 转换为指定的单位并返回
    }

    /// 计算当前 `CLLocation` 到目标 `CLLocation` 的大圆路径的中间点
    /// - Parameter destination: 目标位置，即要计算中间点的目标 `CLLocation`
    /// - Returns: 大圆路径的中间点 `CLLocation`
    ///
    /// - Example:
    /// ```swift
    /// let currentLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
    /// let destinationLocation = CLLocation(latitude: 34.0522, longitude: -118.2437) // Los Angeles
    ///
    /// let midpoint = currentLocation.dd_midPoint(to: destinationLocation)
    /// print("Midpoint: \(midpoint)") // 输出计算结果，例如：Midpoint: CLLocation(latitude: 35.9128, longitude: -120.3315)
    /// ```
    func dd_midPoint(to destination: CLLocation) -> CLLocation {
        // 将经纬度转换为弧度
        let lat1 = self.coordinate.latitude.dd_toRadians()
        let lon1 = self.coordinate.longitude.dd_toRadians()
        let lat2 = destination.coordinate.latitude.dd_toRadians()
        let lon2 = destination.coordinate.longitude.dd_toRadians()

        // 计算经度差
        let deltaLon = lon2 - lon1

        // 使用大圆航线公式计算中点
        let bx = cos(lat2) * cos(deltaLon)
        let by = cos(lat2) * sin(deltaLon)

        let lat3 = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bx) * (cos(lat1) + bx) + by * by))
        let lon3 = lon1 + atan2(by, cos(lat1) + bx)

        // 返回中点的 `CLLocation`
        return CLLocation(latitude: lat3.dd_toDegrees(), longitude: lon3.dd_toDegrees())
    }

    /// 计算当前 `CLLocation` 到目标 `CLLocation` 的方位角
    /// - Parameter target: 目标位置，即要计算方位角的目标 `CLLocation`
    /// - Returns: 目标方位角，单位为度（0° 到 360°）
    ///
    /// - Example:
    /// ```swift
    /// let currentLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
    /// let destinationLocation = CLLocation(latitude: 34.0522, longitude: -118.2437) // Los Angeles
    ///
    /// let bearing = currentLocation.dd_bearing(to: destinationLocation)
    /// print("Bearing: \(bearing) degrees") // 输出计算结果，例如：Bearing: 135.0 degrees
    /// ```
    func dd_bearing(to target: CLLocation) -> Double {
        // 将经纬度转换为弧度
        let lat1 = self.coordinate.latitude.dd_toRadians()
        let lon1 = self.coordinate.longitude.dd_toRadians()
        let lat2 = target.coordinate.latitude.dd_toRadians()
        let lon2 = target.coordinate.longitude.dd_toRadians()

        // 计算经度差
        let deltaLon = lon2 - lon1

        // 使用大圆航线公式计算方位角
        let y = sin(deltaLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)

        // 计算方位角并转换为角度
        let bearing = atan2(y, x).dd_toDegrees()

        // 确保方位角在 0° 到 360° 之间
        return (bearing + 360).truncatingRemainder(dividingBy: 360)
    }

    /// 判断当前 `CLLocation` 是否在给定半径内
    /// - Parameters:
    ///   - radius: 半径，单位为米
    ///   - location: 目标 `CLLocation`
    /// - Returns: `Bool`，表示当前位置是否在给定半径内
    ///
    /// - Example:
    /// ```swift
    /// let currentLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
    /// let targetLocation = CLLocation(latitude: 37.7750, longitude: -122.4195) // Nearby point
    /// let radius: Double = 1000 // 1 km
    ///
    /// let isWithin = currentLocation.dd_isWithin(radius: radius, of: targetLocation)
    /// print(isWithin) // 输出: true (因为目标位置在1公里半径内)
    /// ```
    func dd_isWithin(radius: Double, of location: CLLocation) -> Bool {
        // 计算当前位置和目标位置之间的距离
        let distanceInMeters = self.distance(from: location)
        // 判断该距离是否小于或等于给定半径
        return distanceInMeters <= radius
    }

    /// 获取以当前位置为中心的边界坐标（正方形的四个角）
    /// - Parameter radius: 半径，单位为米
    /// - Returns: 一个包含四个边界点坐标的数组 `CLLocationCoordinate2D`
    ///
    /// - Example:
    /// ```swift
    /// let currentLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
    /// let radius: Double = 1000 // 1 km
    ///
    /// let boundaryCoordinates = currentLocation.dd_boundaryCoordinates(radius: radius)
    /// print(boundaryCoordinates) // 输出: 四个边界坐标，例如：[CLLocationCoordinate2D(latitude: 37.7852, longitude: -122.4298), ...]
    /// ```
    func dd_boundaryCoordinates(radius: Double) -> [CLLocationCoordinate2D] {
        let lat = self.coordinate.latitude
        let lon = self.coordinate.longitude

        // 1度纬度大约是111320米，使用此常数计算纬度变化量
        let deltaLat = radius / 111_320.0 // 计算纬度变化量
        // 计算经度变化量，考虑到地球的弯曲（纬度越大，经度的变化越小）
        let deltaLon = radius / (111_320.0 * cos(lat * .pi / 180)) // 经度根据纬度调整

        // 计算四个边界点的经纬度
        let topLeft = CLLocationCoordinate2D(latitude: lat + deltaLat, longitude: lon - deltaLon)
        let topRight = CLLocationCoordinate2D(latitude: lat + deltaLat, longitude: lon + deltaLon)
        let bottomLeft = CLLocationCoordinate2D(latitude: lat - deltaLat, longitude: lon - deltaLon)
        let bottomRight = CLLocationCoordinate2D(latitude: lat - deltaLat, longitude: lon + deltaLon)

        // 返回四个边界点的坐标
        return [topLeft, topRight, bottomLeft, bottomRight]
    }
}

// MARK: - CLLocation 数组扩展
public extension [CLLocation] {
    /// 根据地球的曲率，计算数组中每个`CLLocation`距离的总和
    /// 计算一个`CLLocation`数组中所有位置之间的距离总和，结果将考虑地球曲率并返回指定单位的总距离。
    /// - Parameter unit: 距离单位`UnitLength`，如米或千米
    /// - Returns: 按指定单位转换的距离总和
    /// - Example:
    ///   ```swift
    ///   let locations = [
    ///       CLLocation(latitude: 37.7749, longitude: -122.4194), // San Francisco
    ///       CLLocation(latitude: 34.0522, longitude: -118.2437)  // Los Angeles
    ///   ]
    ///   let totalDistance = locations.dd_distance(unitLength: .kilometers)
    ///   print("Total distance: \(totalDistance.value) \(totalDistance.unit.symbol)")
    ///   ```
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
