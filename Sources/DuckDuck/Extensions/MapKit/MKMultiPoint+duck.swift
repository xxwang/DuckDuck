//
//  MKMultiPoint+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import MapKit

// MARK: - 属性
public extension MKMultiPoint {
    /// 表示`MKMultiPoint`的坐标数组
    func dd_coordinates() -> [CLLocationCoordinate2D] {
        let pointCount = self.pointCount
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        self.getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
