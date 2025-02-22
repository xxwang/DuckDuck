import UIKit

// MARK: - DDExtensionable
public protocol DDExtensionable {}

// MARK: - implementation DDExtensionable
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
public class DDExtension<Base> {
    /// 底层的基类型实例
    var base: Base

    /// 初始化方法
    /// - Parameter base: 需要扩展的基类型实例
    init(_ base: Base) {
        self.base = base
    }

    /// 获取真实数据
    var value: Base {
        return self.base
    }
}
