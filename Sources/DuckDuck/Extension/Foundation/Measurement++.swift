//
//  Measurement++.swift
//  DuckDuck
//
//  Created by xxwang on 22/11/2024.
//

import Foundation

// MARK: - 静态方法
public extension Measurement where UnitType == UnitAngle {
    /// 以`角度`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: 以角度为单位的`Measurement`
    ///
    /// - Example:
    /// ```swift
    /// let angle = Measurement<UnitAngle>.dd_degrees(45.0)
    /// print(angle) // 输出: 45.0 degrees
    /// ```
    static func dd_degrees(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .degrees)
    }

    /// 以`弧度`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: 以弧度为单位的`Measurement`
    ///
    /// - Example:
    /// ```swift
    /// let angle = Measurement<UnitAngle>.dd_radians(3.14159)
    /// print(angle) // 输出: 3.14159 radians
    /// ```
    static func dd_radians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .radians)
    }

    /// 以`弧分`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: 以弧分为单位的`Measurement`
    ///
    /// - Example:
    /// ```swift
    /// let angle = Measurement<UnitAngle>.dd_arcMinutes(1.5)
    /// print(angle) // 输出: 1.5 arcMinutes
    /// ```
    static func dd_arcMinutes(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcMinutes)
    }

    /// 以`弧秒`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: 以弧秒为单位的`Measurement`
    ///
    /// - Example:
    /// ```swift
    /// let angle = Measurement<UnitAngle>.dd_arcSeconds(60.0)
    /// print(angle) // 输出: 60.0 arcSeconds
    /// ```
    static func dd_arcSeconds(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcSeconds)
    }

    /// 以`梯度`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: 以梯度为单位的`Measurement`
    ///
    /// - Example:
    /// ```swift
    /// let angle = Measurement<UnitAngle>.dd_gradians(100.0)
    /// print(angle) // 输出: 100.0 gradians
    /// ```
    static func dd_gradians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .gradians)
    }

    /// 以`转数`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: 以转数为单位的`Measurement`
    ///
    /// - Example:
    /// ```swift
    /// let angle = Measurement<UnitAngle>.dd_revolutions(2.0)
    /// print(angle) // 输出: 2.0 revolutions
    /// ```
    static func dd_revolutions(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .revolutions)
    }
}
