//
//  Creatable.swift
//  DuckDuck
//
//  Created by 王哥 on 26/11/2024.
//

import UIKit

// MARK: - 对象默认创建协议
public protocol Creatable {
    static func `default`<T: NSObject>() -> T
}

// MARK: - 泛型方法实现
public extension Creatable {
    static func create<T: NSObject>() -> T {
        return T.init()
    }

    static func `default`<T: NSObject>() -> T {
        return self.create()
    }
}
