//
//  Optional++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 16/11/2024.
//

import Foundation

// MARK: - Optional 实用扩展
public extension Optional {
    /// 判断可选值是否为 `nil`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int? = nil
    /// print(value.dd_isNil) // true
    ///
    /// let nonNilValue: Int? = 42
    /// print(nonNilValue.dd_isNil) // false
    /// ```
    var dd_isNil: Bool {
        return self == nil
    }

    /// 判断可选值是否不为 `nil`
    ///
    /// - Example:
    /// ```swift
    /// let value: Int? = nil
    /// print(value.dd_isNotNil) // false
    ///
    /// let nonNilValue: Int? = 42
    /// print(nonNilValue.dd_isNotNil) // true
    /// ```
    var dd_isNotNil: Bool {
        return self != nil
    }
}

// MARK: - 执行方法
public extension Optional {
    /// 如果可选值不为 `nil`，执行 `block` 闭包
    /// - Parameter block: 执行的闭包，接收解包后的值
    ///
    /// - Example:
    /// ```swift
    /// let value: Int? = 5
    /// value.dd_run { print($0) } // 输出：5
    /// ```
    func dd_run(_ block: (Wrapped) -> Void) {
        if let value = self {
            block(value)
        }
    }

    /// 当可选值为 `nil` 时抛出致命错误
    /// - Parameter fatalErrorDescription: 错误描述
    /// - Returns: 解包后的值
    ///
    /// - Example:
    /// ```swift
    /// let value: Int? = nil
    /// let result = value.dd_expect("Value cannot be nil") // 触发致命错误
    /// ```
    func dd_expect(_ fatalErrorDescription: String) -> Wrapped {
        guard let value = self else { fatalError(fatalErrorDescription) }
        return value
    }
}

// MARK: - OR方法
public extension Optional {
    /// 返回可选值或默认值
    /// - Parameter default: 默认值
    /// - Returns: 如果可选值为空，返回默认值
    ///
    /// - Example:
    /// ```swift
    /// let value: Int? = nil
    /// print(value.dd_or(10)) // 输出：10
    /// ```
    func dd_or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }

    /// 返回可选值或 `else` 闭包的值
    /// - Parameter else: 当 `self` 为 `nil` 时执行的闭包
    /// - Returns: 如果可选值为空，返回 `else` 的结果
    ///
    /// - Example:
    /// ```swift
    /// let value: Int? = nil
    /// print(value.dd_or { 10 + 20 }) // 输出：30
    /// ```
    func dd_or(else: () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }

    /// 当可选值为空时抛出异常
    /// - Parameter exception: 抛出的异常
    /// - Returns: 解包后的值
    ///
    /// - Example:
    /// ```swift
    /// enum CustomError: Error { case valueMissing }
    /// let value: Int? = nil
    /// try value.dd_or(throw: CustomError.valueMissing) // 抛出异常
    /// ```
    func dd_or(throw exception: Error) throws -> Wrapped {
        guard let value = self else { throw exception }
        return value
    }
}

// MARK: - Optional 集合扩展
public extension Optional where Wrapped: Collection {
    /// 判断可选集合是否为空或 `nil`
    /// - Returns: 如果为空或 `nil`，返回 `true`
    ///
    /// - Example:
    /// ```swift
    /// let array: [Int]? = nil
    /// print(array.dd_isNilOrEmpty) // 输出：true
    /// let array2: [Int]? = []
    /// print(array2.dd_isNilOrEmpty) // 输出：true
    /// ```
    var dd_isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

infix operator ??=: AssignmentPrecedence
infix operator ?=: AssignmentPrecedence

// MARK: - 运算符重载
public extension Optional {
    /// 当右值不为 `nil` 时，把右值赋值给左值
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    ///
    /// - Example:
    /// ```swift
    /// var value: Int? = nil
    /// value ??= 10
    /// print(value) // 输出：10
    /// ```
    @inlinable static func ??= (lhs: inout Optional, rhs: Optional) {
        if let rhsValue = rhs { lhs = rhsValue }
    }

    /// 当左值为空时，把右值赋值给左值
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    ///
    /// - Example:
    /// ```swift
    /// var value: Int? = nil
    /// value ?= 20
    /// print(value) // 输出：20
    /// ```
    @inlinable static func ?= (lhs: inout Optional, rhs: @autoclosure () -> Optional) {
        if lhs == nil { lhs = rhs() }
    }
}

// MARK: - 比较运算符重载
public extension Optional where Wrapped: RawRepresentable, Wrapped.RawValue: Equatable {
    /// 判断可选值的 `rawValue` 是否等于另一个值
    /// - Parameters:
    ///   - lhs: 可选的枚举类型
    ///   - rhs: 可选的 `rawValue`
    /// - Returns: 是否相等
    ///
    /// - Example:
    /// ```swift
    /// enum Status: Int {
    ///     case success = 1
    ///     case failure = 2
    /// }
    /// let status: Status? = .success
    /// print(status == 1) // 输出：true
    /// print(status == 2) // 输出：false
    /// ```
    @inlinable static func == (lhs: Optional, rhs: Wrapped.RawValue?) -> Bool {
        return lhs?.rawValue == rhs
    }

    /// 判断可选的 `rawValue` 是否等于另一个枚举类型
    /// - Parameters:
    ///   - lhs: 可选的 `rawValue`
    ///   - rhs: 可选的枚举类型
    /// - Returns: 是否相等
    ///
    /// - Example:
    /// ```swift
    /// let status: Status? = .success
    /// print(1 == status) // 输出：true
    /// print(2 == status) // 输出：false
    /// ```
    @inlinable static func == (lhs: Wrapped.RawValue?, rhs: Optional) -> Bool {
        return lhs == rhs?.rawValue
    }

    /// 判断可选值的 `rawValue` 是否不等于另一个值
    /// - Parameters:
    ///   - lhs: 可选的枚举类型
    ///   - rhs: 可选的 `rawValue`
    /// - Returns: 是否不相等
    ///
    /// - Example:
    /// ```swift
    /// let status: Status? = .success
    /// print(status != 2) // 输出：true
    /// print(status != 1) // 输出：false
    /// ```
    @inlinable static func != (lhs: Optional, rhs: Wrapped.RawValue?) -> Bool {
        return lhs?.rawValue != rhs
    }

    /// 判断可选的 `rawValue` 是否不等于另一个枚举类型
    /// - Parameters:
    ///   - lhs: 可选的 `rawValue`
    ///   - rhs: 可选的枚举类型
    /// - Returns: 是否不相等
    ///
    /// - Example:
    /// ```swift
    /// let status: Status? = .failure
    /// print(1 != status) // 输出：true
    /// print(2 != status) // 输出：false
    /// ```
    @inlinable static func != (lhs: Wrapped.RawValue?, rhs: Optional) -> Bool {
        return lhs != rhs?.rawValue
    }
}
