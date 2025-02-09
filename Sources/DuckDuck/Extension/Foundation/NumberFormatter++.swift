import Foundation

// MARK: - 静态方法
public extension NumberFormatter {
    /// 将 `Float` 类型格式化为本地字符串
    /// - Parameters:
    ///   - value: `Float` 数值
    ///   - style: 格式样式，默认 `.none`
    /// - Returns: 格式化后的字符串
    /// - Example:
    /// ```swift
    /// let formattedValue = NumberFormatter.dd_numberFormatting(value: 123.45)
    /// ```
    static func dd_numberFormatting(value: Float, style: NumberFormatter.Style = .none) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: value), number: style)
    }

    /// 将 `Double` 类型格式化为本地字符串
    /// - Parameters:
    ///   - value: `Double` 数值
    ///   - style: 格式样式，默认 `.none`
    /// - Returns: 格式化后的字符串
    /// - Example:
    /// ```swift
    /// let formattedValue = NumberFormatter.dd_numberFormatting(value: 12345.6789)
    /// ```
    static func dd_numberFormatting(value: Double, style: NumberFormatter.Style = .none) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: value), number: style)
    }

    /// 将 `String` 类型格式化为本地字符串
    /// - Parameters:
    ///   - value: `String` 数值
    ///   - style: 格式样式，默认 `.none`
    /// - Returns: 格式化后的字符串，若格式化失败则返回 `nil`
    /// - Example:
    /// ```swift
    /// let formattedValue = NumberFormatter.dd_stringFormattingNumber(value: "12345.67")
    /// ```
    static func dd_stringFormattingNumber(value: String, style: NumberFormatter.Style = .none) -> String? {
        guard let number = NumberFormatter().number(from: value) else { return nil }
        return NumberFormatter.localizedString(from: number, number: style)
    }

    /// 使用自定义 `NumberFormatter` 参数格式化 `String` 类型数值
    /// - Parameters:
    ///   - value: `String` 数值
    ///   - numberFormatter: 自定义格式化对象
    /// - Returns: 格式化后的字符串，若格式化失败则返回 `nil`
    /// - Example:
    /// ```swift
    /// let numberFormatter = NumberFormatter()
    /// numberFormatter.numberStyle = .currency
    /// let formattedValue = NumberFormatter.dd_customFormatter(value: "12345.67", numberFormatter: numberFormatter)
    /// ```
    static func dd_customFormatter(value: String, numberFormatter: NumberFormatter) -> String? {
        guard let number = NumberFormatter().number(from: value) else { return nil }
        return numberFormatter.string(from: number)
    }

    /// 为 `String` 数值设置分隔符和分割位数
    /// - Parameters:
    ///   - value: `String` 数值
    ///   - separator: 分隔符，例如 `","`
    ///   - size: 分割位数
    ///   - style: 格式样式，默认 `.none`
    /// - Returns: 格式化后的字符串
    /// - Example:
    /// ```swift
    /// let formattedValue = NumberFormatter.dd_groupingSeparatorAndSize(value: "1234567", separator: ",", size: 3)
    /// ```
    static func dd_groupingSeparatorAndSize(value: String,
                                            separator: String,
                                            size: Int,
                                            style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = separator
        numberFormatter.groupingSize = size
        return dd_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    /// 为 `String` 数值设置格式宽度及填充符和填充位置
    /// - Parameters:
    ///   - value: `String` 数值
    ///   - formatWidth: 格式宽度
    ///   - paddingCharacter: 填充符号，例如 `"0"`
    ///   - paddingPosition: 填充位置，默认 `.beforePrefix`
    ///   - style: 格式样式，默认 `.none`
    /// - Returns: 格式化后的字符串
    /// - Example:
    /// ```swift
    /// let formattedValue = NumberFormatter.dd_formatWidthPaddingCharacterAndPosition(value: "123", formatWidth: 6, paddingCharacter: "0")
    /// ```
    static func dd_formatWidthPaddingCharacterAndPosition(value: String,
                                                          formatWidth: Int,
                                                          paddingCharacter: String,
                                                          paddingPosition: NumberFormatter.PadPosition = .beforePrefix,
                                                          style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.formatWidth = formatWidth
        numberFormatter.paddingCharacter = paddingCharacter
        numberFormatter.paddingPosition = paddingPosition
        return dd_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    /// 为 `String` 数值设置最大整数位数和最小整数位数
    /// - Parameters:
    ///   - value: `String` 数值
    ///   - maximumIntegerDigits: 最大整数位数
    ///   - minimumIntegerDigits: 最小整数位数
    ///   - style: 格式样式，默认 `.none`
    /// - Returns: 格式化后的字符串
    /// - Example:
    /// ```swift
    /// let formattedValue = NumberFormatter.dd_maximumIntegerDigitsAndMinimumIntegerDigits(value: "12345", maximumIntegerDigits: 7, minimumIntegerDigits: 5)
    /// ```
    static func dd_maximumIntegerDigitsAndMinimumIntegerDigits(value: String,
                                                               maximumIntegerDigits: Int,
                                                               minimumIntegerDigits: Int,
                                                               style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.maximumIntegerDigits = maximumIntegerDigits
        numberFormatter.minimumIntegerDigits = minimumIntegerDigits
        return dd_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    /// 为 `String` 数值设置最大小数位数和最小小数位数
    /// - Parameters:
    ///   - value: `String` 数值
    ///   - maximumFractionDigits: 最大小数位数
    ///   - minimumFractionDigits: 最小小数位数
    /// - Returns: 格式化后的字符串
    /// - Example:
    /// ```swift
    /// let formattedValue = NumberFormatter.dd_maximumFractionDigitsAndMinimumFractionDigits(value: "12345.6789", maximumFractionDigits: 2, minimumFractionDigits: 1)
    /// ```
    static func dd_maximumFractionDigitsAndMinimumFractionDigits(value: String,
                                                                 maximumFractionDigits: Int,
                                                                 minimumFractionDigits: Int) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        return dd_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    /// 为 `String` 数值设置前缀和后缀
    /// - Parameters:
    ///   - value: `String` 数值
    ///   - positivePrefix: 自定义前缀
    ///   - positiveSuffix: 自定义后缀
    ///   - style: 格式样式，默认 `.none`
    /// - Returns: 格式化后的字符串
    /// - Example:
    /// ```swift
    /// let formattedValue = NumberFormatter.dd_maximumIntegerDigitsAndMinimumIntegerDigits(value: "12345", positivePrefix: "$", positiveSuffix: " USD")
    /// ```
    static func dd_maximumIntegerDigitsAndMinimumIntegerDigits(value: String,
                                                               positivePrefix: String,
                                                               positiveSuffix: String,
                                                               style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positivePrefix = positivePrefix
        numberFormatter.positiveSuffix = positiveSuffix
        return dd_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    /// 为 `String` 数值设置自定义格式化样式
    /// - Parameters:
    ///   - value: `String` 数值
    ///   - positiveFormat: 自定义格式化样式，如 `"###,###.##"`
    ///   - style: 格式样式，默认 `.none`
    /// - Returns: 格式化后的字符串
    /// - Example:
    /// ```swift
    /// let formattedValue = NumberFormatter.dd_positiveFormat(value: "1234567", positiveFormat: "###,###.##")
    /// ```
    static func dd_positiveFormat(value: String,
                                  positiveFormat: String,
                                  style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positiveFormat = positiveFormat
        return dd_customFormatter(value: value, numberFormatter: numberFormatter)
    }
}
