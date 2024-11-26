//
//  CLVisit++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import CoreLocation

// MARK: - CLVisit 类型转换
public extension CLVisit {
    /// 将 `CLVisit` 转换为 `CLLocation`
    ///
    /// `CLVisit` 包含一个坐标点，可以使用这个方法将其转换为 `CLLocation`，方便进行距离计算或其他基于 `CLLocation` 的操作。
    ///
    /// - Returns: 转换后的 `CLLocation` 实例
    /// - Example:
    ///   ```swift
    ///   let visit = CLVisit()  // 假设 visit 已经是一个有效的 CLVisit 实例
    ///   let location = visit.dd_toCLLocation()
    ///   print(location.coordinate)  // 输出 CLLocation(latitude: ..., longitude: ...)
    ///   ```
    func dd_toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}
