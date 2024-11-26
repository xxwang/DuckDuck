//
//  DDExtension.swift
//  DuckDuck
//
//  Created by xxwang on 24/11/2024.
//

import UIKit

// MARK: - DDExtensionable
public protocol DDExtensionable {}
/// 可扩展的协议，允许通过 `dd` 属性获得对应的扩展方法
public extension DDExtensionable {
    /// 获取实例扩展的方法
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }

    /// 获取类型扩展的方法
    static var dd: DDExtension<Self>.Type {
        return DDExtension<Self>.self
    }
}

// MARK: - DDExtension
/// DDExtension 类，用于提供扩展方法
public class DDExtension<Base> {
    /// 底层的基类型实例
    var base: Base

    /// 初始化方法
    /// - Parameter base: 需要扩展的基类型实例
    init(_ base: Base) {
        self.base = base
    }
}
