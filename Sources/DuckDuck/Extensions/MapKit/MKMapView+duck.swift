//
//  MKMapView+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import MapKit

// MARK: - 方法
public extension DDExtension where Base: MKMapView {
    /// 注册大头针
    /// - Parameter name: 继承自`MKAnnotationView`的类型
    func register<T: MKAnnotationView>(annotationViewWithClass name: T.Type) {
        self.base.register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: name))
    }

    /// 获取`可重用`的大头针
    /// - Parameter name: 继承自`MKAnnotationView`的类型
    /// - Returns: 继承自`MKAnnotationView`的对象
    func dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type) -> T? {
        self.base.dequeueReusableAnnotationView(withIdentifier: String(describing: name)) as? T
    }

    /// 获取`可重用`的大头针
    /// - Parameters:
    ///   - name: 继承自`MKAnnotationView`的类型
    ///   - annotation: 大头针对象
    /// - Returns: 继承自`MKAnnotationView`的对象
    func dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type, for annotation: MKAnnotation) -> T? {
        guard let annotationView = self.base.dequeueReusableAnnotationView(withIdentifier: String(describing: name), for: annotation) as? T else {
            fatalError("Couldn't find MKAnnotationView for \(String(describing: name))")
        }
        return annotationView
    }

    /// 缩放地图区域
    /// - Parameters:
    ///   - coordinates: 由`CLLocationCoordinate2D`数组构成的区域
    ///   - meter: 缩放单位`米`
    ///   - edgePadding: 边界距离
    ///   - animated: 是否动画
    func zoom(to coordinates: [CLLocationCoordinate2D], meter: Double, edgePadding: UIEdgeInsets, animated: Bool) {
        guard !coordinates.isEmpty else { return }

        guard coordinates.count == 1 else {
            let mkPolygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            self.base.setVisibleMapRect(mkPolygon.boundingMapRect, edgePadding: edgePadding, animated: animated)
            return
        }

        let coordinateRegion = MKCoordinateRegion(
            center: coordinates.first!,
            latitudinalMeters: meter,
            longitudinalMeters: meter
        )
        self.base.setRegion(coordinateRegion, animated: true)
    }
}
