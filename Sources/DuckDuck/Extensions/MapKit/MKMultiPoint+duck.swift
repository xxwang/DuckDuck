//
//  MKMultiPoint+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import MapKit

// MARK: - 属性
public extension DDExtension where Base: MKMultiPoint {
    /// 表示`MKMultiPoint`的坐标数组
    var coordinates: [CLLocationCoordinate2D] {
        let pointCount = self.base.pointCount
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        self.base.getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}

