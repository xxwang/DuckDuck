//
//  Defaultable.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import Foundation

// public protocol Defaultable: NSObjectProtocol where Self: NSObject
public protocol Defaultable {
    /// 关联类型
    associatedtype Associatedtype
    /// 生成默认对象
    static func `default`() -> Associatedtype
}
