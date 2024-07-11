//
//  DecimalNumberHandlerOperator+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

extension DecimalNumberHandlerOperator: DDExtensionable {}

// MARK: - NSDecimalNumberHandler操作符
public enum DecimalNumberHandlerOperator: String {
    /// 加法
    case add
    /// 减法
    case sub
    /// 乘法
    case mul
    /// 除法/
    case div
}

// MARK: - 静态方法
public extension DDExtension where Base: NSDecimalNumberHandler {
    /// 简化数字计算操作
    /// - Parameters:
    ///   - operator: 操作符
    ///   - valueA: 数字1
    ///   - valueB: 数字2
    /// - Returns: 计算结果
    static func calculation(operator: DecimalNumberHandlerOperator,
                            valueA: Any,
                            valueB: Any) -> NSDecimalNumber
    {
        return self.decimalNumberCalculate(valueA: valueA,
                                           valueB: valueB,
                                           operator: `operator`,
                                           roundingMode: .down,
                                           scale: 30)
    }

    /// 向下取整
    /// - Parameters:
    ///   - valueA: 被除数
    ///   - valueB: 除数
    /// - Returns: 计算结果
    static func intFloor(valueA: Any, valueB: Any) -> Int {
        return self.decimalNumberCalculate(valueA: valueA,
                                           valueB: valueB,
                                           operator: .div,
                                           roundingMode: .down,
                                           scale: 0).intValue
    }

    /// 判断一个数字是否可以被另一个数字整除
    /// - Parameters:
    ///   - valueA: 被除数
    ///   - valueB: 除数
    /// - Returns: 判断结果
    static func isDivisible(valueA: Any, valueB: Any) -> Bool {
        let value = self.decimalNumberCalculate(valueA: valueA,
                                                valueB: valueB,
                                                operator: .div,
                                                roundingMode: .down,
                                                scale: 3).stringValue
        // TODO: -
//        let values = value.dd.split(with: ".")
//        guard values.count > 1 else { return true }
//        let decimalValue = values[1]
//        guard decimalValue.count == 1, decimalValue == "0" else { return false }
        return true
    }

    /// 数字计算
    /// - Parameters:
    ///   - valueA: 数字1
    ///   - valueB: 数字2
    ///   - operator: 操作符
    ///   - roundingMode: 传入模式
    ///   - scale: 小数点后舍入值的位数
    ///   - exact: 精度错误处理
    ///   - overflow: 溢出错误处理
    ///   - underflow: 下溢错误处理
    ///   - divideByZero: 除以0的错误处理
    /// - Returns: 计算结果
    static func decimalNumberCalculate(valueA: Any,
                                       valueB: Any,
                                       operator: DecimalNumberHandlerOperator,
                                       roundingMode: NSDecimalNumber.RoundingMode,
                                       scale: Int16,
                                       raiseOnExactness exact: Bool = false,
                                       raiseOnOverflow overflow: Bool = false,
                                       raiseOnUnderflow underflow: Bool = false,
                                       raiseOnDivideByZero divideByZero: Bool = false) -> NSDecimalNumber
    {
        let amountHandler = NSDecimalNumberHandler(
            roundingMode: roundingMode,
            scale: scale,
            raiseOnExactness: exact,
            raiseOnOverflow: overflow,
            raiseOnUnderflow: underflow,
            raiseOnDivideByZero: divideByZero
        )
        let numberA = NSDecimalNumber(string: "\(valueA)")
        let numberB = NSDecimalNumber(string: "\(valueB)")

        switch `operator` {
        case .add:
            return numberA.adding(numberB, withBehavior: amountHandler)
        case .sub:
            return numberA.subtracting(numberB, withBehavior: amountHandler)
        case .mul:
            return numberA.multiplying(by: numberB, withBehavior: amountHandler)
        case .div:
            return numberA.dividing(by: numberB, withBehavior: amountHandler)
        }
    }
}
