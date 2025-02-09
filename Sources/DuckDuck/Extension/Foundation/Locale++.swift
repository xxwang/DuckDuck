import Foundation

// MARK: - Locale扩展
public extension Locale {
    /// 判断当前 `Locale` 是否为12小时制
    ///
    /// - Returns: 如果是12小时制，返回 `true`；否则返回 `false`。
    ///
    /// - Example:
    /// ```swift
    /// let locale = Locale(identifier: "en_US")
    /// let is12Hour = locale.dd_is12HourFormat()
    /// print(is12Hour)  // 输出: true
    /// ```
    func dd_is12HourFormat() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = self

        let dateString = dateFormatter.string(from: Date())

        // 判断是否包含 "am/pm"
        return dateString.contains(dateFormatter.amSymbol) || dateString.contains(dateFormatter.pmSymbol)
    }

    /// 获取当前地区的货币符号
    ///
    /// - Returns: 当前地区的货币符号，如 "$"（美元）或 "€"（欧元），如果无法获取则返回空字符串。
    ///
    /// - Example:
    /// ```swift
    /// let locale = Locale(identifier: "en_US")
    /// let currencySymbol = locale.dd_currencySymbol()
    /// print(currencySymbol)  // 输出: "$"
    /// ```
    func dd_currencySymbol() -> String {
        return self.currencySymbol ?? ""
    }

    /// 获取当前地区的语言代码
    ///
    /// - Returns: 当前地区的语言代码，例如 "en"、"fr" 等。
    ///
    /// - Example:
    /// ```swift
    /// let locale = Locale(identifier: "en_US")
    /// let languageCode = locale.dd_languageCode()
    /// print(languageCode)  // 输出: "en"
    /// ```
    func dd_languageCode() -> String {
        return self.languageCode ?? ""
    }

    /// 获取当前地区的区域代码
    ///
    /// - Returns: 当前地区的区域代码，如 "US"（美国）或 "FR"（法国）。
    ///
    /// - Example:
    /// ```swift
    /// let locale = Locale(identifier: "en_US")
    /// let regionCode = locale.dd_regionCode()
    /// print(regionCode)  // 输出: "US"
    /// ```
    func dd_regionCode() -> String {
        return self.regionCode ?? ""
    }

    /// 获取当前地区的日期格式
    ///
    /// - Returns: 当前地区的日期格式，如 "MM/dd/yyyy" 或 "dd/MM/yyyy"。
    ///
    /// - Example:
    /// ```swift
    /// let locale = Locale(identifier: "en_US")
    /// let dateFormat = locale.dd_dateFormat()
    /// print(dateFormat)  // 输出: "MM/dd/yyyy"
    /// ```
    func dd_dateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = self
        return dateFormatter.dateFormat ?? "Unknown format"
    }

    /// 判断当前 `Locale` 是否是左到右语言
    ///
    /// - Returns: 如果是左到右语言，返回 `true`；否则返回 `false`。
    ///
    /// - Example:
    /// ```swift
    /// let locale = Locale(identifier: "en_US")
    /// let isLTR = locale.dd_isLeftToRightLanguage()
    /// print(isLTR)  // 输出: true
    ///
    /// let arabicLocale = Locale(identifier: "ar")
    /// let isLTRArabic = arabicLocale.dd_isLeftToRightLanguage()
    /// print(isLTRArabic)  // 输出: false
    /// ```
    func dd_isLeftToRightLanguage() -> Bool {
        let languageCode = self.languageCode ?? ""
        let direction = Locale.characterDirection(forLanguage: languageCode)
        return direction == .leftToRight
    }

    /// 获取当前地区的时区名称
    ///
    /// - Returns: 当前地区的时区名称，例如 "GMT" 或 "CET"。
    ///
    /// - Example:
    /// ```swift
    /// let locale = Locale(identifier: "en_US")
    /// let timezoneName = locale.dd_timezoneName()
    /// print(timezoneName)  // 输出: "GMT"
    /// ```
    func dd_timezoneName() -> String {
        let timeZone = TimeZone.current
        return timeZone.identifier
    }

    /// 获取当前地区的货币代码
    ///
    /// - Returns: 当前地区的货币代码，如 "USD"、"EUR"。
    ///
    /// - Example:
    /// ```swift
    /// let locale = Locale(identifier: "en_US")
    /// let currencyCode = locale.dd_currencyCode()
    /// print(currencyCode)  // 输出: "USD"
    /// ```
    func dd_currencyCode() -> String {
        return self.currencyCode ?? ""
    }
}
