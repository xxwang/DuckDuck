//
//  Bool++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 15/11/2024.
//

import Foundation

// MARK: - Bool 类型转换
public extension Bool {
    /// 转换为 `Int` 类型。
    /// - Returns: 布尔值对应的 `Int` 值，`true` 返回 `1`，`false` 返回 `0`。
    ///
    /// - Example:
    /// ```swift
    /// let flag = true
    /// print(flag.dd_toInt()) // 输出: 1
    /// ```
    func dd_toInt() -> Int {
        return self ? 1 : 0
    }

    /// 转换为 `Double` 类型。
    /// - Returns: 布尔值对应的 `Double` 值，`true` 返回 `1.0`，`false` 返回 `0.0`。
    ///
    /// - Example:
    /// ```swift
    /// let flag = false
    /// print(flag.dd_toDouble()) // 输出: 0.0
    /// ```
    func dd_toDouble() -> Double {
        return self ? 1.0 : 0.0
    }

    /// 转换为 `Float` 类型。
    /// - Returns: 布尔值对应的 `Float` 值，`true` 返回 `1.0`，`false` 返回 `0.0`。
    ///
    /// - Example:
    /// ```swift
    /// let flag = true
    /// print(flag.dd_toFloat()) // 输出: 1.0
    /// ```
    func dd_toFloat() -> Float {
        return self ? 1.0 : 0.0
    }

    /// 转换为 `String` 类型。
    /// - Returns: 布尔值对应的 `String` 值，`true` 返回 `"true"`，`false` 返回 `"false"`。
    ///
    /// - Example:
    /// ```swift
    /// let flag = false
    /// print(flag.dd_toString()) // 输出: "false"
    /// ```
    func dd_toString() -> String {
        return self ? "true" : "false"
    }
}

// MARK: - Bool 便捷扩展
public extension Bool {
    /// 切换布尔值。
    /// - Returns: 切换后的布尔值，`true` 变为 `false`，`false` 变为 `true`。
    ///
    /// - Example:
    /// ```swift
    /// let flag = true
    /// print(flag.dd_toggle()) // 输出: false
    /// ```
    func dd_toggle() -> Bool {
        return !self
    }

    /// 当布尔值为 `true` 时，执行指定闭包。
    /// - Parameter action: 要执行的闭包。
    ///
    /// - Example:
    /// ```swift
    /// let flag = true
    /// flag.dd_ifTrue {
    ///     print("执行逻辑")
    /// }
    /// ```
    func dd_ifTrue(_ action: () -> Void) {
        if self { action() }
    }

    /// 当布尔值为 `false` 时，执行指定闭包。
    /// - Parameter action: 要执行的闭包。
    ///
    /// - Example:
    /// ```swift
    /// let flag = false
    /// flag.dd_ifFalse {
    ///     print("执行逻辑")
    /// }
    /// ```
    func dd_ifFalse(_ action: () -> Void) {
        if !self { action() }
    }

    /// 与另一个布尔值进行逻辑 `AND` 操作。
    /// - Parameter other: 另一个布尔值。
    /// - Returns: `self && other` 的结果。
    ///
    /// - Example:
    /// ```swift
    /// let flag1 = true
    /// let flag2 = false
    /// print(flag1.dd_and(flag2)) // 输出: false
    /// ```
    func dd_and(_ other: Bool) -> Bool {
        return self && other
    }

    /// 与另一个布尔值进行逻辑 `OR` 操作。
    /// - Parameter other: 另一个布尔值。
    /// - Returns: `self || other` 的结果。
    ///
    /// - Example:
    /// ```swift
    /// let flag1 = true
    /// let flag2 = false
    /// print(flag1.dd_or(flag2)) // 输出: true
    /// ```
    func dd_or(_ other: Bool) -> Bool {
        return self || other
    }
}
