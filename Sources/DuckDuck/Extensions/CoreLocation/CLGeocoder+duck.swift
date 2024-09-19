//
//  CLGeocoder+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import CoreLocation

// MARK: - 静态方法
public extension CLGeocoder {
    /// 反地理编码(`坐标转地址`)
    /// - Parameters:
    ///   - completionHandler:回调函数
    static func dd_reverseGeocode(with location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        return CLGeocoder().reverseGeocodeLocation(location, completionHandler: completionHandler)
    }

    /// 地理编码(`地址转坐标`)
    /// - Parameters:
    ///   - completionHandler:回调函数
    static func dd_locationEncode(with addr: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        return CLGeocoder().geocodeAddressString(addr, completionHandler: completionHandler)
    }
}
