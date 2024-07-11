//
//  Measurement+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

extension Measurement: DDExtensionable where UnitType == UnitAngle {}

// MARK: - 静态方法
public extension DDExtension where Base == Measurement<UnitAngle> {
    /// 以`角度`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func degrees(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .degrees)
    }

    /// 以`弧度`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func radians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .radians)
    }

    /// 以`弧分`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func arcMinutes(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcMinutes)
    }

    /// 以`弧秒`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func arcSeconds(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcSeconds)
    }

    /// 以`梯度`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func gradians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .gradians)
    }

    /// 以`转数`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func revolutions(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .revolutions)
    }
}
