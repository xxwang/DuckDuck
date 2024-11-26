//
//  MKMapView++.swift
//  DuckDuck
//
//  Created by xxwang on 21/11/2024.
//

import MapKit

// MARK: - 注册/获取可重用大头针
public extension MKMapView {
    /// 注册大头针视图类
    ///
    /// ```swift
    /// mapView.dd_register(annotationViewWithClass: CustomAnnotationView.self)
    /// ```
    /// - Parameter annotationViewClass: 继承自 `MKAnnotationView` 的类类型
    func dd_register<T: MKAnnotationView>(annotationViewWithClass annotationViewClass: T.Type) {
        self.register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: annotationViewClass))
    }

    /// 获取可重用的大头针视图
    ///
    /// ```swift
    /// let annotationView = mapView.dd_dequeueReusableAnnotationView(withClass: CustomAnnotationView.self)
    /// ```
    /// - Parameter annotationViewClass: 继承自 `MKAnnotationView` 的类类型
    /// - Returns: 继承自 `MKAnnotationView` 的可重用视图，可能为 `nil`
    func dd_dequeueReusableAnnotationView<T: MKAnnotationView>(withClass annotationViewClass: T.Type) -> T? {
        return self.dequeueReusableAnnotationView(withIdentifier: String(describing: annotationViewClass)) as? T
    }

    /// 获取可重用的大头针视图（带注解）
    ///
    /// ```swift
    /// let annotationView = mapView.dd_dequeueReusableAnnotationView(withClass: CustomAnnotationView.self, for: annotation)
    /// ```
    /// - Parameters:
    ///   - annotationViewClass: 继承自 `MKAnnotationView` 的类类型
    ///   - annotation: 要关联的 `MKAnnotation` 对象
    /// - Returns: 继承自 `MKAnnotationView` 的可重用视图
    /// - Note: 如果未找到匹配的视图，将触发 `fatalError`
    func dd_dequeueReusableAnnotationView<T: MKAnnotationView>(withClass annotationViewClass: T.Type, for annotation: MKAnnotation) -> T? {
        guard let annotationView = self.dequeueReusableAnnotationView(
            withIdentifier: String(describing: annotationViewClass),
            for: annotation
        ) as? T else {
            fatalError("Couldn't dequeue reusable annotation view for \(String(describing: annotationViewClass))")
        }
        return annotationView
    }
}

// MARK: - 缩放
public extension MKMapView {
    /// 缩放地图至指定区域
    ///
    /// ```swift
    /// let coordinates = [CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)]
    /// mapView.dd_zoom(to: coordinates, meter: 500, edgePadding: .zero, animated: true)
    /// ```
    /// - Parameters:
    ///   - coordinates: 要显示的 `CLLocationCoordinate2D` 数组
    ///   - meter: 缩放范围（以米为单位）
    ///   - edgePadding: 地图边距（默认为零）
    ///   - animated: 是否启用动画
    func dd_zoom(to coordinates: [CLLocationCoordinate2D], meter: Double, edgePadding: UIEdgeInsets = .zero, animated: Bool) {
        guard !coordinates.isEmpty else { return }

        if coordinates.count == 1 {
            // 如果只有一个点，直接设置区域
            let coordinateRegion = MKCoordinateRegion(
                center: coordinates.first!,
                latitudinalMeters: meter,
                longitudinalMeters: meter
            )
            self.setRegion(coordinateRegion, animated: animated)
        } else {
            // 多个点则使用包围区域
            let mkPolygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            self.setVisibleMapRect(mkPolygon.boundingMapRect, edgePadding: edgePadding, animated: animated)
        }
    }

    /// 缩放到指定的坐标范围
    /// - Parameters:
    ///   - region: 包含的地理区域
    ///   - edgePadding: 地图边界的间距
    ///   - animated: 是否启用动画
    /// - Example:
    ///   ```swift
    ///   let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    ///   mapView.dd_zoom(to: region, animated: true)
    ///   ```
    func dd_zoom(to region: MKCoordinateRegion, edgePadding: UIEdgeInsets = .zero, animated: Bool = true) {
        let mapRect = MKMapRect.regionToMapRect(region)
        self.setVisibleMapRect(mapRect, edgePadding: edgePadding, animated: animated)
    }
}

// MARK: - 常用方法
public extension MKMapView {
    /// 在地图中添加多个大头针
    /// - Parameters:
    ///   - annotations: 大头针数组
    ///   - clearExisting: 是否清除现有的大头针
    /// - Example:
    ///   ```swift
    ///   let annotations: [MKAnnotation] = [annotation1, annotation2]
    ///   mapView.dd_addAnnotations(annotations, clearExisting: true)
    ///   ```
    func dd_addAnnotations(_ annotations: [MKAnnotation], clearExisting: Bool = false) {
        if clearExisting {
            self.removeAnnotations(self.annotations)
        }
        self.addAnnotations(annotations)
    }

    /// 将点转换为坐标
    /// - Parameter point: 地图中的点
    /// - Returns: 地图上的地理坐标
    /// - Example:
    ///   ```swift
    ///   let point = CGPoint(x: 100, y: 200)
    ///   let coordinate = mapView.dd_convertPointToCoordinate(point)
    ///   ```
    func dd_convertPointToCoordinate(_ point: CGPoint) -> CLLocationCoordinate2D {
        return self.convert(point, toCoordinateFrom: self)
    }

    /// 将坐标转换为点
    /// - Parameter coordinate: 地理坐标
    /// - Returns: 地图中的点
    /// - Example:
    ///   ```swift
    ///   let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ///   let point = mapView.dd_convertCoordinateToPoint(coordinate)
    ///   ```
    func dd_convertCoordinateToPoint(_ coordinate: CLLocationCoordinate2D) -> CGPoint {
        return self.convert(coordinate, toPointTo: self)
    }

    /// 检查坐标是否在地图的可见区域内
    /// - Parameter coordinate: 地理坐标
    /// - Returns: 布尔值，指示是否在可见区域内
    /// - Example:
    ///   ```swift
    ///   let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ///   let isVisible = mapView.dd_isCoordinateVisible(coordinate)
    ///   ```
    func dd_isCoordinateVisible(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let mapPoint = MKMapPoint(coordinate)
        return self.visibleMapRect.contains(mapPoint)
    }
}
