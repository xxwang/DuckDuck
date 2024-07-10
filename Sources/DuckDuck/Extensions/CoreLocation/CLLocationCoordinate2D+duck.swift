//
//  CLLocationCoordinate2D+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreLocation

extension CLLocationCoordinate2D: DDExtensionable {}

// MARK: - 计算属性
public extension DDExtension where Base == CLLocationCoordinate2D {
    /// `CLLocationCoordinate2D`转`CLLocation`
    var as2CLLocation: CLLocation {
        return CLLocation(latitude: self.base.latitude, longitude: self.base.longitude)
    }
}

// MARK: - 方法
public extension DDExtension where Base == CLLocationCoordinate2D {
    /// 两个`CLLocationCoordinate2D`之间的`距离`(单位:`米`)
    /// - Parameter second:`CLLocationCoordinate2D`
    /// - Returns: `Double`
    func distance(to second: CLLocationCoordinate2D) -> Double {
        return self.as2CLLocation.distance(from: second.dd.as2CLLocation)
    }
}
