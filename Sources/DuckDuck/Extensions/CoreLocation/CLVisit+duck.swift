//
//  CLVisit+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreLocation

// MARK: - 计算属性
public extension DDExtension where Base == CLVisit {
    /// `CLVisit`转`CLLocation`
    var as2CLLocation: CLLocation {
        return CLLocation(latitude: self.base.coordinate.latitude, longitude: self.base.coordinate.longitude)
    }
}
