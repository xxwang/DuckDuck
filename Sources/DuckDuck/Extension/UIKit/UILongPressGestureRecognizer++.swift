//
//  UILongPressGestureRecognizer++.swift
//  DuckDuck
//
//  Created by 王哥 on 26/11/2024.
//

import UIKit

// MARK: - Creatable
public extension UILongPressGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UILongPressGestureRecognizer>(_ aClass: T.Type = UILongPressGestureRecognizer.self) -> T {
        let gesture = UILongPressGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UILongPressGestureRecognizer>(_ aClass: T.Type = UILongPressGestureRecognizer.self) -> T {
        let gesture: UILongPressGestureRecognizer = self.create()
        return gesture as! T
    }
}
