// The Swift Programming Language
// https://docs.swift.org/swift-book

struct DuckDuck {
    static let text = "Hello World!"
}

extension DuckDuck {
    static func sayHello() {
        DDLog.info(self.text)
    }
}

// MARK: - DDExtensionable
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
