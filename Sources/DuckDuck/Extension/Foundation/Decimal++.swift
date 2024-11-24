//
//  Decimal++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 22/11/2024.
//

import Foundation

public extension Decimal {
    /// 检查当前数值是否为整数
    var dd_isInteger: Bool {
        return self.dd_remainder(dividingBy: 1) == 0
    }

    /// 计算余数
    /// - Parameter divisor: 除数
    /// - Returns: 余数
    ///
    /// - Example:
    /// ```swift
    /// let remainder = Decimal(string: "10.5")!.dd_remainder(dividingBy: 3)
    /// print(remainder) // 输出: 1.5
    /// ```
    func dd_remainder(dividingBy divisor: Decimal) -> Decimal {
        guard divisor != 0 else {
            fatalError("除数不能为零")
        }

        let selfNumber = NSDecimalNumber(decimal: self)
        let divisorNumber = NSDecimalNumber(decimal: divisor)
        let quotient = selfNumber.dividing(by: divisorNumber).doubleValue.rounded(.down)
        return selfNumber.subtracting(NSDecimalNumber(value: quotient).multiplying(by: divisorNumber)).decimalValue
    }
}
