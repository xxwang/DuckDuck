//
//  CLLocationManager++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import CoreLocation

// MARK: - 获取当前位置
public extension CLLocationManager {
    /// 获取当前设备的位置（同步方法）
    /// - Returns: 当前设备的 `CLLocation`，如果位置不可用则返回 `nil`
    func dd_currentLocation() -> CLLocation? {
        return self.location
    }
}
