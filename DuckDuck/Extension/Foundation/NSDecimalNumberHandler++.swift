import Foundation

// MARK: - NSDecimalNumberHandler 操作符
/// 基本运算操作符
public enum DecimalNumberHandlerOperator {
    case add // 加法
    case subtract // 减法
    case multiply // 乘法
    case divide // 除法

    /// 对两个数值进行计算
    /// - Parameters:
    ///   - numberA: 第一个数值
    ///   - numberB: 第二个数值
    ///   - behavior: 运算行为（四舍五入模式、精度等）
    /// - Returns: 计算结果
    ///
    /// - Example:
    /// ```swift
    /// let result = DecimalNumberHandlerOperator.add.dd_calculate(numberA: 10.5, numberB: 2.3, behavior: NSDecimalNumberHandler.default)
    /// print(result) // 输出: 12.8
    /// ```
    func dd_calculate(numberA: NSDecimalNumber, numberB: NSDecimalNumber, behavior: NSDecimalNumberBehaviors) -> NSDecimalNumber {
        switch self {
        case .add:
            return numberA.adding(numberB, withBehavior: behavior)
        case .subtract:
            return numberA.subtracting(numberB, withBehavior: behavior)
        case .multiply:
            return numberA.multiplying(by: numberB, withBehavior: behavior)
        case .divide:
            return numberA.dividing(by: numberB, withBehavior: behavior)
        }
    }
}

// MARK: - NSDecimalNumberHandler 计算扩展
public extension NSDecimalNumberHandler {
    /// 执行基本的数值计算
    /// - Parameters:
    ///   - operator: 运算符
    ///   - valueA: 第一个数值
    ///   - valueB: 第二个数值
    ///   - roundingMode: 舍入模式（默认为 `.plain`）
    ///   - scale: 小数位数（默认为 `2`）
    ///   - exact: 是否抛出精度错误
    ///   - overflow: 是否抛出溢出错误
    ///   - underflow: 是否抛出下溢错误
    ///   - divideByZero: 是否抛出除以0错误
    /// - Returns: 计算结果
    ///
    /// - Example:
    /// ```swift
    /// let result = NSDecimalNumberHandler.dd_calculate(operator: .add, valueA: 10.5, valueB: 2.3)
    /// print(result) // 输出: 12.8
    /// ```
    static func dd_calculate(
        operator: DecimalNumberHandlerOperator,
        valueA: Any,
        valueB: Any,
        roundingMode: NSDecimalNumber.RoundingMode = .plain,
        scale: Int16 = 2,
        exact: Bool = false,
        overflow: Bool = false,
        underflow: Bool = false,
        divideByZero: Bool = false
    ) -> NSDecimalNumber {
        let numberA = NSDecimalNumber(string: "\(valueA)")
        let numberB = NSDecimalNumber(string: "\(valueB)")

        let handler = NSDecimalNumberHandler(
            roundingMode: roundingMode,
            scale: scale,
            raiseOnExactness: exact,
            raiseOnOverflow: overflow,
            raiseOnUnderflow: underflow,
            raiseOnDivideByZero: divideByZero
        )

        return `operator`.dd_calculate(numberA: numberA, numberB: numberB, behavior: handler)
    }

    /// 检查两个数是否可以整除
    /// - Parameters:
    ///   - valueA: 被除数
    ///   - valueB: 除数
    /// - Returns: 是否整除
    ///
    /// - Example:
    /// ```swift
    /// let divisible = NSDecimalNumberHandler.dd_isDivisible(valueA: 10, valueB: 2)
    /// print(divisible) // 输出: true
    /// ```
    static func dd_isDivisible(valueA: Any, valueB: Any) -> Bool {
        let result = dd_calculate(operator: .divide, valueA: valueA, valueB: valueB, roundingMode: .down, scale: 3)
        return result.dd_isInteger()
    }

    /// 执行向下取整的整数除法
    /// - Parameters:
    ///   - valueA: 被除数
    ///   - valueB: 除数
    /// - Returns: 整除结果
    ///
    /// - Example:
    /// ```swift
    /// let quotient = NSDecimalNumberHandler.dd_intFloor(valueA: 10, valueB: 3)
    /// print(quotient) // 输出: 3
    /// ```
    static func dd_intFloor(valueA: Any, valueB: Any) -> Int {
        let result = dd_calculate(operator: .divide, valueA: valueA, valueB: valueB, roundingMode: .down, scale: 0)
        return result.intValue
    }
}

// MARK: - 数值扩展方法
public extension NSDecimalNumberHandler {
    /// 计算百分比值
    /// - Parameters:
    ///   - value: 基础值
    ///   - percentage: 百分比值（例如 `10` 表示 10%）
    /// - Returns: 百分比计算结果
    ///
    /// - Example:
    /// ```swift
    /// let result = NSDecimalNumberHandler.dd_calculatePercentage(value: 100, percentage: 10)
    /// print(result) // 输出: 10
    /// ```
    static func dd_calculatePercentage(value: Any, percentage: Any) -> NSDecimalNumber {
        let percentageValue = dd_calculate(operator: .multiply, valueA: value, valueB: percentage)
        return percentageValue.dividing(by: NSDecimalNumber(100))
    }

    /// 将数值向下取整到最接近的倍数
    /// - Parameters:
    ///   - value: 需要取整的数值
    ///   - multiple: 取整的倍数
    /// - Returns: 向下取整后的数值
    ///
    /// - Example:
    /// ```swift
    /// let flooredValue = NSDecimalNumberHandler.dd_floorToNearest(value: 7.5, multiple: 2)
    /// print(flooredValue) // 输出: 6
    /// ```
    static func dd_floorToNearest(value: Any, multiple: Any) -> NSDecimalNumber {
        // 将输入值和倍数转换为 NSDecimalNumber
        let number = NSDecimalNumber(string: "\(value)")
        let factor = NSDecimalNumber(string: "\(multiple)")

        // 创建一个 NSDecimalNumberHandler 来指定向下舍入
        let handler = NSDecimalNumberHandler(
            roundingMode: .down, // 向下舍入
            scale: 0, // 保留零位小数
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )

        // 通过将数值除以倍数并向下舍入，再乘以倍数，实现取整
        return number.dividing(by: factor, withBehavior: handler).multiplying(by: factor)
    }

    /// 将数值限制在指定的范围内
    /// - Parameters:
    ///   - value: 需要被限制的数值
    ///   - lowerBound: 范围的最小值
    ///   - upperBound: 范围的最大值
    /// - Returns: 限制后的数值
    ///
    /// - Example:
    /// ```swift
    /// let clampedValue = NSDecimalNumberHandler.dd_clamp(value: 15, lowerBound: 10, upperBound: 20)
    /// print(clampedValue) // 输出: 15
    /// ```
    static func dd_clamp(value: Any, lowerBound: Any, upperBound: Any) -> NSDecimalNumber {
        let number = NSDecimalNumber(string: "\(value)")
        let minValue = NSDecimalNumber(string: "\(lowerBound)")
        let maxValue = NSDecimalNumber(string: "\(upperBound)")

        // 检查是否有效数值
        if number == .notANumber || minValue == .notANumber || maxValue == .notANumber {
            return NSDecimalNumber.zero
        }

        // 比较并返回范围内的数值
        return number.compare(minValue) == .orderedAscending ? minValue :
            (number.compare(maxValue) == .orderedDescending ? maxValue : number)
    }

    /// 将数值转换为正数
    /// - Parameter value: 需要转换的数值
    /// - Returns: 转换后的正数
    ///
    /// - Example:
    /// ```swift
    /// let positiveValue = NSDecimalNumberHandler.dd_toPositive(value: -5)
    /// print(positiveValue) // 输出: 5
    /// ```
    static func dd_toPositive(value: Any) -> NSDecimalNumber {
        // 尝试将输入值转换为 NSDecimalNumber
        let number = NSDecimalNumber(string: "\(value)")

        // 如果数值小于零，调用转换为负数的方法
        return number.compare(NSDecimalNumber.zero) == .orderedAscending ? dd_toNegative(value: number) : number
    }

    /// 将数值转换为负数
    /// - Parameter value: 需要转换的数值
    /// - Returns: 转换后的负数
    ///
    /// - Example:
    /// ```swift
    /// let negativeValue = NSDecimalNumberHandler.dd_toNegative(value: 5)
    /// print(negativeValue) // 输出: -5
    /// ```
    static func dd_toNegative(value: NSDecimalNumber) -> NSDecimalNumber {
        // 如果是正数，返回负数；如果已经是负数，直接返回
        return value.compare(NSDecimalNumber.zero) == .orderedDescending
            ? value.multiplying(by: NSDecimalNumber(value: -1))
            : value
    }

    /// 累积求和
    /// - Parameter values: 数组中的数值
    /// - Returns: 数组中数值的总和
    ///
    /// - Example:
    /// ```swift
    /// let sum = NSDecimalNumberHandler.dd_sum(of: [1, 2, 3, 4])
    /// print(sum) // 输出: 10
    /// ```
    static func dd_sum(of values: [Any]) -> NSDecimalNumber {
        return values.reduce(NSDecimalNumber.zero) { partialResult, value in
            partialResult.adding(NSDecimalNumber(string: "\(value)"))
        }
    }

    /// 累积求积
    /// - Parameter values: 数组中的数值
    /// - Returns: 数组中数值的总积
    ///
    /// - Example:
    /// ```swift
    /// let product = NSDecimalNumberHandler.dd_product(of: [1, 2, 3, 4])
    /// print(product) // 输出: 24
    /// ```
    static func dd_product(of values: [Any]) -> NSDecimalNumber {
        return values.reduce(NSDecimalNumber.one) { partialResult, value in
            partialResult.multiplying(by: NSDecimalNumber(string: "\(value)"))
        }
    }

    /// 按比例分解总值
    /// - Parameters:
    ///   - total: 总值
    ///   - ratios: 比例数组
    /// - Returns: 根据比例分解后的数值数组
    ///
    /// - Example:
    /// ```swift
    /// let splitValues = NSDecimalNumberHandler.dd_splitByRatios(total: 100, ratios: [0.5, 0.3, 0.2])
    /// print(splitValues) // 输出: [50, 30, 20]
    /// ```
    static func dd_splitByRatios(total: Any, ratios: [Any]) -> [NSDecimalNumber] {
        let totalNumber = NSDecimalNumber(string: "\(total)")
        let ratioSum = dd_sum(of: ratios)
        return ratios.map { ratio in
            let ratioNumber = NSDecimalNumber(string: "\(ratio)")
            return totalNumber.multiplying(by: ratioNumber).dividing(by: ratioSum)
        }
    }

    /// 生成范围内的随机数（高精度）
    /// - Parameters:
    ///   - min: 最小值
    ///   - max: 最大值
    /// - Returns: 范围内的随机数
    ///
    /// - Example:
    /// ```swift
    /// let randomValue = NSDecimalNumberHandler.dd_random(min: 10, max: 20)
    /// print(randomValue) // 输出: 随机值，范围在10到20之间
    /// ```
    static func dd_random(min: Any, max: Any) -> NSDecimalNumber {
        let minValue = NSDecimalNumber(string: "\(min)")
        let maxValue = NSDecimalNumber(string: "\(max)")
        let random = Double.random(in: 0 ... 1)
        let range = maxValue.subtracting(minValue)
        return range.multiplying(by: NSDecimalNumber(value: random)).adding(minValue)
    }
}
