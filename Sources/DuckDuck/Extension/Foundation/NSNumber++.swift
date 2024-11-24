//
//  NSNumber++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 22/11/2024.
//

import Foundation

// MARK: - 方法
public extension NSNumber {
    /// 按指定样式格式化数字
    /// - Parameters:
    ///   - style: 数字样式，例如 `.decimal`、`.currency` 等，默认是 `.none`。
    ///   - separator: 分隔符，默认是 `,`。
    ///   - roundingMode: 舍入模式，默认为 `.halfEven`。
    ///   - minDecimalPlaces: 小数点后最少保留位数，默认是 `0`。
    ///   - maxDecimalPlaces: 小数点后最大保留位数，默认是 `0`。
    ///   - prefix: 数字前缀，默认是空字符串。
    ///   - suffix: 数字后缀，默认是空字符串。
    ///   - usesGroupingSeparator: 是否使用千位分隔符，默认是 `true`。
    /// - Returns: 格式化后的字符串
    ///
    /// ### 示例：
    /// ```swift
    /// let number = NSNumber(value: 12345.6789)
    /// let formatted = number.dd_formatter(style: .decimal, separator: ",", minDecimalPlaces: 2, maxDecimalPlaces: 2)
    /// print(formatted) // 12,345.68
    /// ```
    func dd_formatter(style: NumberFormatter.Style = .none,
                      separator: String = ",",
                      roundingMode: NumberFormatter.RoundingMode = .halfEven,
                      minDecimalPlaces: Int = 0,
                      maxDecimalPlaces: Int = 0,
                      prefix: String = "",
                      suffix: String = "",
                      usesGroupingSeparator: Bool = true) -> String?
    {
        let formatter = NumberFormatter()
        // 样式
        formatter.numberStyle = style
        // 分隔符
        formatter.groupingSeparator = separator
        // 舍入模式
        formatter.roundingMode = roundingMode
        // 小数位数
        formatter.minimumFractionDigits = minDecimalPlaces
        formatter.maximumFractionDigits = maxDecimalPlaces
        // 是否使用千位分隔符
        formatter.usesGroupingSeparator = usesGroupingSeparator
        // 格式化后的字符串
        var formattedString = formatter.string(from: self)

        // 添加前缀和后缀
        if let result = formattedString {
            return "\(prefix)\(result)\(suffix)"
        }

        return nil
    }

    /// 格式化为货币字符串
    /// - Parameters:
    ///   - locale: 本地化地区，默认使用当前区域设置。
    ///   - currencySymbol: 是否显示货币符号，默认为 `true`。
    /// - Returns: 格式化后的货币字符串
    ///
    /// ### 示例：
    /// ```swift
    /// let number = NSNumber(value: 12345.6789)
    /// let formattedCurrency = number.dd_currencyFormatter()
    /// print(formattedCurrency) // $12,345.68 (假设在美国地区)
    /// ```
    func dd_currencyFormatter(locale: Locale = Locale.current, currencySymbol: Bool = true) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.usesGroupingSeparator = true
        // 可选地移除货币符号
        if !currencySymbol {
            formatter.currencySymbol = ""
        }

        return formatter.string(from: self)
    }

    /// 格式化为百分比字符串
    /// - Parameters:
    ///   - minDecimalPlaces: 小数点后最少保留位数，默认为 `0`。
    ///   - maxDecimalPlaces: 小数点后最大保留位数，默认为 `0`。
    /// - Returns: 格式化后的百分比字符串
    ///
    /// ### 示例：
    /// ```swift
    /// let number = NSNumber(value: 0.12345)
    /// let formattedPercentage = number.dd_percentageFormatter(minDecimalPlaces: 1, maxDecimalPlaces: 2)
    /// print(formattedPercentage) // 12.35%
    /// ```
    func dd_percentageFormatter(minDecimalPlaces: Int = 0, maxDecimalPlaces: Int = 0) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = minDecimalPlaces
        formatter.maximumFractionDigits = maxDecimalPlaces

        return formatter.string(from: self)
    }

    /// 格式化为科学计数法字符串
    /// - Returns: 格式化后的科学计数法字符串
    ///
    /// ### 示例：
    /// ```swift
    /// let number = NSNumber(value: 1234567890.0)
    /// let scientific = number.dd_scientificFormatter()
    /// print(scientific) // 1.234568E9
    /// ```
    func dd_scientificFormatter() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific

        return formatter.string(from: self)
    }

    /// 格式化为自定义小数位的字符串
    /// - Parameters:
    ///   - decimalPlaces: 设置小数点后保留位数
    /// - Returns: 格式化后的字符串
    ///
    /// ### 示例：
    /// ```swift
    /// let number = NSNumber(value: 12345.6789)
    /// let formattedDecimal = number.dd_customDecimalFormatter(decimalPlaces: 3)
    /// print(formattedDecimal) // 12345.679
    /// ```
    func dd_customDecimalFormatter(decimalPlaces: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces

        return formatter.string(from: self)
    }
}
