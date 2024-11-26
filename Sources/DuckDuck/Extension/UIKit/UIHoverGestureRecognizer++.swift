//
//  UIHoverGestureRecognizer++.swift
//  DuckDuck
//
//  Created by 王哥 on 26/11/2024.
//

import UIKit

// MARK: - Creatable
public extension UIHoverGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIHoverGestureRecognizer>(_ aClass: T.Type = UIHoverGestureRecognizer.self) -> T {
        let gesture = UIHoverGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIHoverGestureRecognizer>(_ aClass: T.Type = UIHoverGestureRecognizer.self) -> T {
        let gesture: UIHoverGestureRecognizer = self.create()
        return gesture as! T
    }
}
