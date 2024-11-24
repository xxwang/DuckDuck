//
//  CLGeocoder++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import CoreLocation

// MARK: - CLGeocoder 静态方法扩展
public extension CLGeocoder {
    /// 反地理编码（坐标转地址）
    /// 将给定的经纬度坐标转化为相应的地址信息。
    /// - Parameters:
    ///   - location: 要进行反地理编码的坐标位置
    ///   - completionHandler: 处理反地理编码结果的回调
    ///     - 参数 result: 地址的数组（可能为空），错误信息（如果有）
    ///     - 参数 error: 可能的错误信息
    /// - Example:
    ///   ```swift
    ///   let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
    ///   CLGeocoder.dd_reverseGeocode(with: location) { placemarks, error in
    ///       if let error = error {
    ///           print("Error: \(error)")
    ///       } else {
    ///           print("Placemark: \(placemarks?.first?.locality ?? "Unknown")")
    ///       }
    ///   }
    ///   ```
    static func dd_reverseGeocode(with location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: completionHandler)
    }

    /// 地理编码（地址转坐标）
    /// 将给定的地址字符串转化为对应的经纬度坐标。
    /// - Parameters:
    ///   - addr: 要进行地理编码的地址字符串
    ///   - completionHandler: 处理地理编码结果的回调
    ///     - 参数 result: 坐标的数组（可能为空），错误信息（如果有）
    ///     - 参数 error: 可能的错误信息
    /// - Example:
    ///   ```swift
    ///   let address = "1600 Amphitheatre Parkway, Mountain View, CA"
    ///   CLGeocoder.dd_locationEncode(with: address) { placemarks, error in
    ///       if let error = error {
    ///           print("Error: \(error)")
    ///       } else {
    ///           print("Coordinates: \(placemarks?.first?.location?.coordinate ?? CLLocationCoordinate2D())")
    ///       }
    ///   }
    ///   ```
    static func dd_locationEncode(with addr: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().geocodeAddressString(addr, completionHandler: completionHandler)
    }
}
