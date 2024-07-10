//
//  DDExtension.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import Foundation
import UIKit

// MARK: - DDable
public protocol DDExtensionable {}
public extension DDExtensionable {
    /// 作用于实例
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }

    /// 作用于类型
    static var dd: DDExtension<Self>.Type {
        return DDExtension<Self>.self
    }
}

// MARK: - DDExtension
public class DDExtension<Base> {
    var base: Base

    init(_ base: Base) {
        self.base = base
    }
}

// MARK: - 继承DDExtensionable的类型
extension NSObject: DDExtensionable {}
