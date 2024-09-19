//
//  DDExtension.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import Foundation
import UIKit

// MARK: - DDable
public protocol DDExtensionable1 {}
public extension DDExtensionable1 {
    /// 作用于实例
    var dd: DDExtension1<Self> {
        return DDExtension1(self)
    }

    /// 作用于类型
    static var dd: DDExtension1<Self>.Type {
        return DDExtension1<Self>.self
    }
}

// MARK: - DDExtension
public class DDExtension1<Base> {
    var base: Base

    init(_ base: Base) {
        self.base = base
    }
}

// MARK: - 继承DDExtensionable的类型
extension NSObject: DDExtensionable1 {}
