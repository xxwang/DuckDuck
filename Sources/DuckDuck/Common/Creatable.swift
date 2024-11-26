//
//  Creatable.swift
//  DuckDuck
//
//  Created by 王哥 on 26/11/2024.
//

import UIKit

// MARK: - Creatable 协议
public protocol Creatable: NSObject {}

// MARK: - Creatable默认实现
public extension Creatable {
    /// 纯净的创建方法
    static func create<T: Creatable>(_ aClass: T.Type = NSObject.self) -> T {
        return aClass.init()
    }

    /// 带默认配置的创建方法
    static func `default`<T: Creatable>(_ aClass: T.Type = NSObject.self) -> T {
        return self.create(aClass)
    }
}

// MARK: - NSObject: Creatable
extension NSObject: Creatable {}
