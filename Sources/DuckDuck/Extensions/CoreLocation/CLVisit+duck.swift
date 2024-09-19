//
//  CLVisit+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreLocation

// MARK: - 类型转换
public extension CLVisit {
    /// `CLVisit`转`CLLocation`
    func dd_CLLocation() -> CLLocation {
        return CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}
