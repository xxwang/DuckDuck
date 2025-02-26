import UIKit

// MARK: - DDExtended
/// 任何遵循此协议的类型都可以通过 `dd` 属性访问扩展功能。
public protocol DDExtended {}

// MARK: - DDExtended 实现
public extension DDExtended {
    /// 提供实例级别的扩展功能
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }

    /// 提供类型级别的扩展功能
    static var dd: DDExtension<Self>.Type {
        return DDExtension<Self>.self
    }
}

// MARK: - DDExtension
/// 通过此类为遵循 `DDExtended` 的类型添加扩展方法。
public class DDExtension<Base> {
    /// 被扩展的实例
    var base: Base

    /// 初始化方法
    /// - Parameter base: 需要扩展的实例
    init(_ base: Base) {
        self.base = base
    }
}
