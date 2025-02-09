import Foundation

// MARK: - NSDecimalNumber 扩展
public extension NSDecimalNumber {
    /// 检查当前数值是否为整数
    /// - Returns: 是否为整数
    ///
    /// - Example:
    /// ```swift
    /// let number = NSDecimalNumber(string: "10.0")
    /// let isInteger = number.dd_isInteger()
    /// print(isInteger) // 输出: true
    /// ```
    func dd_isInteger() -> Bool {
        return self.decimalValue.dd_isInteger
    }
}
