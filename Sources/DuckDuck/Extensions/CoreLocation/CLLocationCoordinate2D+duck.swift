//
//  CLLocationCoordinate2D+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreLocation

// MARK: - 类型转换
public extension CLLocationCoordinate2D {
    /// `CLLocationCoordinate2D`转`CLLocation`
    func dd_CLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}

// MARK: - 方法
public extension CLLocationCoordinate2D {
    /// 两个`CLLocationCoordinate2D`之间的`距离`(单位:`米`)
    /// - Parameter second:`CLLocationCoordinate2D`
    /// - Returns: `Double`
    func distance(to second: CLLocationCoordinate2D) -> Double {
        return self.dd_CLLocation().distance(from: second.dd_CLLocation())
    }
}
