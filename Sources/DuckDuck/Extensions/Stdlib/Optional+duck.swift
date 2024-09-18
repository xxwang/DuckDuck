//
//  Optional+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - Collection
public extension Optional<Collection> {
    /// 判断可选集protocol合类型是否为空或者`nil`
    /// - Returns: `Bool`
    func dd_isNilOrEmpty() -> Bool {
        guard let collection = self else {return true}
        return collection.isEmpty
    }
}

// MARK: - 执行方法
public extension Optional {
    /// 如果不为空,则执行`block`代码
    /// - Parameter block:要执行的代码
    func run(_ block: (Wrapped) -> Void) {
        _ = self.map(block)
    }

    /// 猜测数据有值(无值引起致命错误)
    /// - Parameter fatalErrorDescription: 致命错误描述
    /// - Returns: `Wrapped`
    func expect(_ fatalErrorDescription: String) -> Wrapped {
        guard let value = self else { fatalError(fatalErrorDescription) }
        return value
    }
}

// MARK: - OR方法
public extension Optional {
    /// 返回可选值或默认值
    /// - Parameter default:默认值
    /// - Returns:如果可选值为空,返回默认值
    func or(_ default: Wrapped) -> Wrapped { self ?? `default` }

    /// 返回可选值或 `else` 表达式返回的值
    /// - Parameter else:`self`为`nil`时返回执行
    /// - Returns:有值返回值,无值返回`else`闭包结果
    func or(else: @autoclosure () -> Wrapped) -> Wrapped { self ?? `else`() }

    /// 返回可选值或者 `else` 闭包返回的值
    /// - Parameter else:没有值的时候执行闭包
    /// - Returns:如果有值返回值,没有值返回闭包结果
    func or(else: () -> Wrapped) -> Wrapped { self ?? `else`() }

    /// 当可选值不为空时,返回可选值,如果为空,抛出异常
    /// - Parameter exception:可选值为空时要抛出的错误
    /// - Returns:可选值包装的值
    func or(throw exception: Error) throws -> Wrapped {
        guard let unBase = self else { throw exception }
        return unBase
    }
}

// MARK: - OR Error相关方法
public extension Optional<Error> {
    /// 当前类型为可选类型`Error`,如果有值就执行闭包,`error`作为闭包参数
    /// - Parameter else:闭包,`error`作为闭包参数
    func or(_ else: (Error) -> Void) {
        guard let error = self else { return }
        `else`(error)
    }
}

// MARK: - ON方法
public extension Optional {
    /// 可选值不为空,执行`some` 闭包
    /// - Parameter some:可选值不为空执行的闭包
    func on(some: () throws -> Void) rethrows { if self != nil { try some() }}

    /// 当可选值为空时,执行 `none` 闭包
    /// - Parameter none:可选值为空执行的闭包
    func on(none: () throws -> Void) rethrows { if self == nil { try none() }}
}

infix operator ??=: AssignmentPrecedence
infix operator ?=: AssignmentPrecedence

// MARK: - 赋值运算符重载
public extension Optional {
    /// 当右值不为`nil`的时候,把右值赋值给左值
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    @inlinable static func ??= (lhs: inout Optional, rhs: Optional) {
        guard let rhs else { return }
        lhs = rhs
    }

    /// 当左值为空的时候, 把右值赋值给左值
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    @inlinable static func ?= (lhs: inout Optional, rhs: @autoclosure () -> Optional) {
        if lhs == nil { lhs = rhs() }
    }
}

// MARK: - 比较运算符重载
public extension Optional where Wrapped: RawRepresentable, Wrapped.RawValue: Equatable {
    /// 判断两个值是否相等
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    /// - Returns: 是否相等
    @inlinable static func == (lhs: Optional, rhs: Wrapped.RawValue?) -> Bool {
        return lhs?.rawValue == rhs
    }

    /// 判断两个值是否相等
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    /// - Returns:是否相等
    @inlinable static func == (lhs: Wrapped.RawValue?, rhs: Optional) -> Bool {
        return lhs == rhs?.rawValue
    }

    /// 判断两个值是否不相等
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    /// - Returns:是否不相等
    @inlinable static func != (lhs: Optional, rhs: Wrapped.RawValue?) -> Bool {
        return lhs?.rawValue != rhs
    }

    /// 判断两个值是否不相等
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    /// - Returns:是否不相等
    @inlinable static func != (lhs: Wrapped.RawValue?, rhs: Optional) -> Bool {
        return lhs != rhs?.rawValue
    }
}
