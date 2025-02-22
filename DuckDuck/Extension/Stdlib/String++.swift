import CoreGraphics
import CoreLocation
import UIKit

// MARK: - 类型转换
public extension String {
    /// 转换为 `Bool`
    ///
    /// - Example:
    ///     ```swift
    /// "true".dd_toBool()   // true
    /// "0".dd_toBool()      // false
    /// "invalid".dd_toBool() // false
    ///     ```
    /// - Returns: `true` 或 `false`
    func dd_toBool() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch trimmed {
        case "1", "t", "true", "y", "yes":
            return true
        case "0", "f", "false", "n", "no":
            return false
        default:
            return false
        }
    }

    /// 转换为 `Int`
    ///
    /// - Example:
    ///     ```swift
    /// "42".dd_toInt()   // 42
    /// "invalid".dd_toInt() // 0
    ///     ```
    /// - Returns: 整数值，失败返回 `0`
    func dd_toInt() -> Int {
        return Int(self) ?? 0
    }

    /// 转换为 `Int64`
    ///
    /// - Example:
    ///     ```swift
    /// "9223372036854775807".dd_toInt64() // 9223372036854775807
    /// "invalid".dd_toInt64()           // 0
    ///     ```
    /// - Returns: `Int64` 值，失败返回 `0`
    func dd_toInt64() -> Int64 {
        return Int64(self) ?? 0
    }

    /// 转换为 `UInt`
    ///
    /// - Example:
    ///     ```swift
    /// "42".dd_toUInt()   // 42
    /// "-1".dd_toUInt()   // 0 (因 UInt 不能为负数)
    /// "invalid".dd_toUInt() // 0
    ///     ```
    /// - Returns: 无符号整数值，失败返回 `0`
    func dd_toUInt() -> UInt {
        return UInt(self) ?? 0
    }

    /// 转换为 `UInt64`
    ///
    /// - Example:
    ///     ```swift
    /// "18446744073709551615".dd_toUInt64() // 18446744073709551615
    /// "invalid".dd_toUInt64()            // 0
    ///     ```
    /// - Returns: `UInt64` 值，失败返回 `0`
    func dd_toUInt64() -> UInt64 {
        return UInt64(self) ?? 0
    }

    /// 转换为 `Float`
    ///
    /// - Example:
    ///     ```swift
    /// "3.14".dd_toFloat() // 3.14
    /// "invalid".dd_toFloat() // 0.0
    ///     ```
    /// - Returns: `Float` 值，失败返回 `0.0`
    func dd_toFloat() -> Float {
        return Float(self) ?? 0.0
    }

    /// 转换为 `Double`
    ///
    /// - Example:
    ///     ```swift
    /// "3.14159".dd_toDouble() // 3.14159
    /// "invalid".dd_toDouble() // 0.0
    ///     ```
    /// - Returns: `Double` 值，失败返回 `0.0`
    func dd_toDouble() -> Double {
        return Double(self) ?? 0.0
    }

    /// 转换为 `CGFloat`
    ///
    /// - Example:
    ///     ```swift
    /// "3.14".dd_toCGFloat() // 3.14
    /// "invalid".dd_toCGFloat() // 0.0
    ///     ```
    /// - Returns: `CGFloat` 值，失败返回 `0.0`
    func dd_toCGFloat() -> CGFloat {
        return CGFloat(dd_toDouble())
    }

    /// 转换为 `NSNumber`
    ///
    /// - Example:
    ///     ```swift
    /// "42".dd_toNSNumber() // 42
    /// "invalid".dd_toNSNumber() // 0
    ///     ```
    /// - Returns: `NSNumber` 对象
    func dd_toNSNumber() -> NSNumber {
        return NSNumber(value: dd_toDouble())
    }

    /// 转换为 `NSDecimalNumber`
    ///
    /// - Example:
    ///     ```swift
    /// "3.14159".dd_toNSDecimalNumber() // 3.14159
    /// "invalid".dd_toNSDecimalNumber() // 0.0
    ///     ```
    /// - Returns: `NSDecimalNumber` 对象
    func dd_toNSDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: dd_toDouble())
    }

    /// 转换为 `Decimal`
    ///
    /// - Example:
    ///     ```swift
    /// "3.14159".dd_toDecimal() // 3.14159
    /// "invalid".dd_toDecimal() // 0.0
    ///     ```
    /// - Returns: `Decimal` 值
    func dd_toDecimal() -> Decimal {
        return dd_toNSDecimalNumber().decimalValue
    }

    /// 十六进制字符串转换为十进制 `Int`
    ///
    /// - Example:
    ///     ```swift
    /// "FF".dd_toHexInt() // 255
    /// "invalid".dd_toHexInt() // 0
    ///     ```
    /// - Returns: 十进制整数值，失败返回 `0`
    func dd_toHexInt() -> Int {
        return Int(self, radix: 16) ?? 0
    }

    /// 转换为 `Character?`
    ///
    /// - Example:
    ///     ```swift
    /// "65".dd_toCharacter() // "A" (Unicode Scalar)
    ///     ```
    /// - Returns: `Character` 对象，失败返回 `nil`
    func dd_toCharacter() -> Character? {
        guard let intValue = Int(self), let scalar = UnicodeScalar(intValue) else { return nil }
        return Character(scalar)
    }

    /// 转换为 `[Character]`
    ///
    /// - Example:
    ///     ```swift
    /// "hello".dd_toCharacters() // ["h", "e", "l", "l", "o"]
    ///     ```
    /// - Returns: `Character` 数组
    func dd_toCharacters() -> [Character] {
        return Array(self)
    }

    /// 转换为 `NSString`
    ///
    /// - Example:
    ///     ```swift
    /// "Swift".dd_toNSString() // NSString("Swift")
    ///     ```
    /// - Returns: `NSString` 对象
    func dd_toNSString() -> NSString {
        return NSString(string: self)
    }

    /// 转换为 `NSAttributedString`
    ///
    /// - Example:
    ///     ```swift
    /// "Hello".dd_toNSAttributedString() // NSAttributedString("Hello")
    ///     ```
    /// - Returns: `NSAttributedString` 对象
    func dd_toNSAttributedString() -> NSAttributedString {
        return NSAttributedString(string: self)
    }

    /// 转换为 `NSMutableAttributedString`
    ///
    /// - Example:
    ///     ```swift
    /// "Hello".dd_toNSMutableAttributedString() // NSMutableAttributedString("Hello")
    ///     ```
    /// - Returns: `NSMutableAttributedString` 对象
    func dd_toNSMutableAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }

    /// 转换为 `Data`
    ///
    /// - Example:
    ///     ```swift
    /// "Hello".dd_toData() // utf8 编码的 Data
    ///     ```
    /// - Returns: `Data` 对象，失败返回 `nil`
    func dd_toData() -> Data? {
        return self.data(using: .utf8)
    }

    /// 转换为 `URL`
    ///
    /// - Example:
    ///     ```swift
    /// "https://example.com".dd_toURL() // URL 对象
    ///     ```
    /// - Returns: `URL` 对象，失败返回 `nil`
    func dd_toURL() -> URL? {
        return URL(string: self)
    }

    /// 转换为 `URLRequest`
    ///
    /// - Example:
    ///     ```swift
    /// "https://example.com".dd_toURLRequest() // URLRequest 对象
    ///     ```
    /// - Returns: `URLRequest` 对象，失败返回 `nil`
    func dd_toURLRequest() -> URLRequest? {
        guard let url = dd_toURL() else { return nil }
        return URLRequest(url: url)
    }

    /// 转换为通知名称
    ///
    /// - Example:
    ///     ```swift
    /// "MyNotification".dd_toNotificationName() // Notification.Name("MyNotification")
    ///     ```
    /// - Returns: `Notification.Name` 对象
    func dd_toNotificationName() -> Notification.Name {
        return Notification.Name(self)
    }

    /// 返回本地化字符串
    ///
    /// - Example:
    ///     ```swift
    /// "hello".dd_toLocalized() // 根据本地化配置返回结果
    ///     ```
    /// - Returns: 本地化字符串
    func dd_toLocalized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    /// 转换为 `UIColor`
    ///
    /// - Example:
    ///     ```swift
    /// "#FF5733".dd_toUIColor() // UIColor 对象
    ///     ```
    /// - Returns: `UIColor` 对象，失败返回默认颜色
    func dd_toUIColor() -> UIColor {
        return UIColor(hex: self)
    }

    /// 转换为 `UIImage`
    ///
    /// - Example:
    ///     ```swift
    /// "imageName".dd_toUIImage() // UIImage 对象
    ///     ```
    /// - Returns: `UIImage` 对象，失败返回 `nil`
    func dd_toUIImage() -> UIImage? {
        return UIImage(named: self)
    }

    /// 创建一个 SF Symbol 图标，支持单色和多色配置
    /// - Parameters:
    ///   - color: 单色图标的颜色。如果提供了此参数，图标将以单色渲染。
    ///   - paletteColors: 多色图标的颜色数组。如果提供了此参数，图标将以多色渲染。
    ///   - size: 图标的大小（默认值为 20）。
    ///   - weight: 图标的粗细（默认值为 .regular）。
    ///   - scale: 图标的缩放比例（默认值为 .default）。
    /// - Returns: 返回一个可选的 `UIImage`，如果 SF Symbol 名称无效则返回 `nil`
    func dd_sfSymbol(
        color: UIColor? = nil,
        paletteColors: [UIColor]? = nil,
        size: CGFloat = 20,
        weight: UIImage.SymbolWeight = .regular,
        scale: UIImage.SymbolScale = .default
    ) -> UIImage? {
        // 创建基础配置，包含大小、粗细和缩放比例
        var config = UIImage.SymbolConfiguration(
            pointSize: size,
            weight: weight,
            scale: scale
        )

        // 处理多色
        if let paletteColors {
            let paletteConfig = UIImage.SymbolConfiguration(paletteColors: paletteColors)
            config = config.applying(paletteConfig)
        }
        // 处理单色
        else if let color {
            let monochromeConfig = UIImage.SymbolConfiguration(paletteColors: [color])
            config = config.applying(monochromeConfig)
        }

        // 加载 SF Symbol 图标
        let image = UIImage(systemName: self, withConfiguration: config)

        return image
    }
}

// MARK: - Range
public extension String {
    /// 字符串的完整范围（`Range<String.Index>`）
    ///
    /// - Example:
    ///     ```swift
    /// let text = "Hello, World!"
    /// let range = text.dd_fullRange() // Range<String.Index>(0..<13)
    ///     ```
    /// - Returns: 字符串的完整范围，类型为 `Range<String.Index>`
    func dd_fullRange() -> Range<String.Index> {
        return self.startIndex ..< self.endIndex
    }

    /// 字符串的完整范围（`NSRange`）
    ///
    /// - Example:
    ///     ```swift
    /// let text = "Hello, World!"
    /// let nsRange = text.dd_fullNSRange() // NSRange(location: 0, length: 13)
    ///     ```
    /// - Returns: 字符串的完整范围，类型为 `NSRange`
    func dd_fullNSRange() -> NSRange {
        return NSRange(self.startIndex ..< self.endIndex, in: self)
    }

    /// 将 `NSRange` 转换为 `Range<String.Index>`
    ///
    /// - Example:
    ///     ```swift
    /// let nsRange = NSRange(location: 6, length: 5)
    /// let range = "Hello World!".dd_toRange(nsRange) // 6..<11
    ///     ```
    /// - Parameter nsRange: 要转换的 `NSRange`。
    /// - Returns: 等价的 `Range<String.Index>`。
    func dd_toRange(_ nsRange: NSRange) -> Range<String.Index> {
        guard let range = Range(nsRange, in: self) else {
            fatalError("Failed to find range \(nsRange) in \(self)")
        }
        return range
    }

    /// 将 `Range<String.Index>` 转换为 `NSRange`
    ///
    /// - Example:
    ///     ```swift
    /// let range = "Hello World!"[6..<11]
    /// let nsRange = range.dd_toNSRange() // NSRange(location: 6, length: 5)
    ///     ```
    /// - Parameter range: 要转换的 `Range<String.Index>`。
    /// - Returns: 等价的 `NSRange`。
    func dd_toNSRange(_ range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    /// 获取指定子字符串在当前字符串中的 `Range`
    ///
    /// - Example:
    ///     ```swift
    /// let range = "Hello World!".dd_subRange("World") // 6..<11
    ///     ```
    /// - Parameter subString: 要查找的子字符串。
    /// - Returns: 找到的 `Range<String.Index>?`，如果未找到则返回 `nil`。
    func dd_subRange(_ subString: String) -> Range<String.Index>? {
        return self.range(of: subString)
    }

    /// 获取子字符串在字符串中的 `NSRange`
    ///
    /// - Example:
    ///     ```swift
    /// let nsRange = "Hello World!".dd_subNSRange("World") // NSRange(location: 6, length: 5)
    ///     ```
    /// - Parameter subString: 要查找的子字符串。
    /// - Returns: 找到的 `NSRange`，如果未找到则返回 `NSRange(location: 0, length: 0)`。
    func dd_subNSRange(_ subString: String) -> NSRange {
        guard let range = self.range(of: subString) else {
            return NSRange(location: 0, length: 0)
        }
        return NSRange(range, in: self)
    }
}

// MARK: - 构造方法
public extension String {
    /// 从 `base64` 编码的字符串创建一个新的字符串（解码操作）
    ///
    /// - Example:
    ///     ```swift
    /// if let decodedString = String(dd_base64: "SGVsbG8gV29ybGQh") {
    ///     print(decodedString) // 输出 "Hello World!"
    /// }
    ///
    /// let invalidString = String(dd_base64: "invalid") // 返回 nil
    ///     ```
    /// - Parameter dd_base64: `base64` 编码的字符串
    init?(dd_base64: String) {
        guard let decodedData = Data(base64Encoded: dd_base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
}

// MARK: - 下标
public extension String {
    /// 获取或替换字符串中指定位置的字符
    ///
    /// - Example:
    ///     ```swift
    /// let character = "Hello World!"[dd_safe: 3] // "l"
    /// let outOfBounds = "Hello World!"[dd_safe: 20] // nil
    ///     ```
    /// - Note: 如果索引超出范围，将返回 `nil`。
    /// - Parameter index: 字符在字符串中的位置。
    /// - Returns: 字符 `String?`，如果索引无效则返回 `nil`。
    subscript(dd_safe index: Int) -> String? {
        get {
            guard index >= 0, index < count else { return nil }
            return String(self[self.index(startIndex, offsetBy: index)])
        }
        set {
            guard let newValue else { return }
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(after: startIndex)
            replaceSubrange(startIndex ..< endIndex, with: newValue)
        }
    }

    /// 在给定范围内安全地获取或替换字符串内容
    ///
    /// - Example:
    ///     ```swift
    /// let substring = "Hello World!"[dd_safe: 6..<11] // "World"
    /// let outOfBounds = "Hello World!"[dd_safe: 21..<110] // nil
    ///     ```
    /// - Parameter range: 字符串的范围，支持闭区间和开区间。
    /// - Returns: 范围内的子字符串 `String?`，如果范围超出字符串长度则返回 `nil`。
    subscript<R>(dd_safe range: R) -> String? where R: RangeExpression, R.Bound == Int {
        get {
            let range = range.relative(to: Int.min ..< Int.max)
            guard range.lowerBound >= 0, range.upperBound <= count else { return nil }
            let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: range.upperBound)
            return String(self[startIndex ..< endIndex])
        }
        set {
            guard let newValue else { return }
            let range = range.relative(to: Int.min ..< Int.max)
            let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: range.upperBound)
            replaceSubrange(startIndex ..< endIndex, with: newValue)
        }
    }

    /// 获取字符串在指定 `NSRange` 范围内的子字符串
    ///
    /// - Example:
    ///     ```swift
    /// let substring = "Hello World!"[dd_nsRange: NSRange(location: 6, length: 5)] // "World"
    ///     ```
    /// - Note: `NSRange` 的边界必须是有效的字符串索引范围。
    /// - Parameter nsRange: 要获取的子字符串的 `NSRange`。
    /// - Returns: 字符串的子字符串 `Substring`。
    subscript(dd_nsRange nsRange: NSRange) -> Substring {
        guard let range = Range(nsRange, in: self) else {
            fatalError("Invalid NSRange \(nsRange) in string: \(self)")
        }
        return self[range]
    }
}

// MARK: - 类/实例
public extension String {
    /// 将类名字符串转换为指定类型的类类型（默认为 `AnyClass`）
    ///
    /// - Example:
    ///     ```swift
    /// let classType: MyClass.Type? = "MyClass".dd_toClass()
    ///     ```
    /// - Parameter name: 目标类类型，默认为 `AnyClass`。
    /// - Returns: 对应的 `T.Type`，如果转换失败则返回 `nil`。
    func dd_toClass<T>(for name: T.Type = AnyClass.self) -> T.Type? {
        // 获取当前应用程序的命名空间
        guard let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else { return nil }
        let classNameString = "\(namespace.dd_replace(" ", with: "_")).\(self)"

        // 转换类名字符串为类类型
        guard let classType = NSClassFromString(classNameString) as? T.Type else { return nil }
        return classType
    }

    /// 将类名字符串转换为类对象实例
    ///
    /// - Example:
    ///     ```swift
    /// let myObject: MyClass? = "MyClass".dd_toInstance()
    ///     ```
    /// - Note: 类必须继承自 `NSObject`。
    /// - Parameter name: 目标类类型，默认为 `NSObject`。
    /// - Returns: 类的实例对象，如果转换失败则返回 `nil`。
    func dd_toInstance<T>(for name: T.Type = NSObject.self) -> T? where T: NSObject {
        guard let classType = dd_toClass(for: name) else {
            return nil
        }
        // 使用 `init()` 创建对象
        let object = classType.init()
        return object
    }
}

// MARK: - 静态方法
public extension String {
    /// 生成指定长度的随机字符串
    ///
    /// - Example:
    ///     ```swift
    /// let randomString = String.dd_random(count: 10)
    ///     ```
    /// - Parameter count: 随机字符串的长度，必须大于 0。
    /// - Returns: 随机字符串，如果长度小于等于 0，返回空字符串。
    static func dd_random(count: Int) -> String {
        guard count > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< count).compactMap { _ in base.randomElement() })
    }

    /// 生成指定长度的乱数假文字符串（Lorem Ipsum）
    ///
    /// - Example:
    ///     ```swift
    /// let loremIpsum = String.dd_loremIpsum(count: 100)
    ///     ```
    /// - Parameter count: 乱数假文字符串的长度，默认为 445 字符。
    /// - Returns: 生成的乱数假文字符串。如果请求的长度大于生成的假文长度，返回完整的假文内容。
    static func dd_loremIpsum(count: Int = 445) -> String {
        guard count > 0 else { return "" }

        let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        // 截取假文字符串
        return String(loremIpsum.prefix(count))
    }
}

// MARK: - base64
public extension String {
    /// `base64` 加密
    ///
    /// 将字符串转换为 base64 编码。
    /// - Returns: base64 编码的字符串，或 `nil` 如果编码失败。
    /// - Example:
    ///     ```swift
    ///     "Hello World!".dd_base64Encoded() -> "SGVsbG8gV29ybGQh"
    ///     ```
    func dd_base64Encoded() -> String? {
        // 转换为 Data 后进行 base64 编码
        guard let plainData = self.dd_toData() else { return nil }
        return plainData.base64EncodedString()
    }

    /// `base64` 解密
    ///
    /// 将 base64 编码的字符串解码为原始字符串。
    /// - Returns: 解码后的字符串，或 `nil` 如果解码失败。
    /// - Example:
    ///     ```swift
    ///     "SGVsbG8gV29ybGQh".dd_base64Decoded() -> "Hello World!"
    ///     ```
    func dd_base64Decoded() -> String? {
        // 尝试直接从 base64 解码
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }

        // 计算需要填充的 "=" 字符数
        let remainder = count % 4
        var padding = ""
        if remainder > 0 { padding = String(repeating: "=", count: 4 - remainder) }

        // 添加填充后再次尝试解码
        guard let data = Data(base64Encoded: self + padding, options: .ignoreUnknownCharacters) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}

// MARK: - Unicode 编码和解码
public extension String {
    /// 将字符串编码为 Unicode 格式
    ///
    /// - Example:
    ///     `"Hello 😊".dd_unicodeEncode()` -> `"Hello \\ud83d\\ude0a"`
    ///
    /// - Returns: 编码后的 Unicode 字符串
    func dd_unicodeEncode() -> String {
        var encodedString = ""
        for scalar in utf16 {
            if scalar < 128 {
                // 处理 ASCII 范围内的字符，直接追加
                encodedString.append(Unicode.Scalar(scalar)!.escaped(asASCII: true))
            } else {
                // 非 ASCII 字符，转为 Unicode 格式
                let unicodeCode = String(scalar, radix: 16, uppercase: false)
                encodedString.append("\\u" + unicodeCode.padLeft(toLength: 4, withPad: "0"))
            }
        }
        return encodedString
    }

    /// 将 Unicode 格式的字符串解码为普通字符串
    ///
    /// - Example:
    ///     `"Hello \\ud83d\\ude0a".dd_unicodeDecode()` -> `"Hello 😊"`
    ///
    /// - Returns: 解码后的普通字符串
    func dd_unicodeDecode() -> String {
        let processedString = replacingOccurrences(of: "\\u", with: "\\U")
            .replacingOccurrences(of: "\"", with: "\\\"")
        let wrappedString = "\"\(processedString)\""
        let data = wrappedString.data(using: .utf8)

        do {
            let decodedString = try PropertyListSerialization.propertyList(
                from: data!,
                options: [],
                format: nil
            ) as? String
            return decodedString?.replacingOccurrences(of: "\\r\\n", with: "\n") ?? self
        } catch {
            print("Unicode 解码失败: \(error.localizedDescription)")
            return self
        }
    }

    /// 用指定的字符填充字符串到指定长度
    /// - Parameters:
    ///   - toLength: 目标长度
    ///   - withPad: 填充字符
    /// - Returns: 填充后的字符串
    private func padLeft(toLength: Int, withPad: String) -> String {
        guard count < toLength else { return self }
        let padding = String(repeating: withPad, count: toLength - count)
        return padding + self
    }
}

// MARK: - URL 编解码
public extension String {
    /// 对字符串进行 URL 编码
    /// - Returns: 编码后的字符串。如果编码失败，返回原始字符串。
    ///
    /// - Example:
    /// ```swift
    /// let str = "it's easy to encode strings"
    /// let encoded = str.dd_urlEncode()
    /// print(encoded) // 输出: "it's%20easy%20to%20encode%20strings"
    /// ```
    func dd_urlEncode() -> String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }

    /// 对 URL 编码的字符串进行解码
    /// - Returns: 解码后的字符串。如果解码失败，返回原始字符串。
    ///
    /// - Example:
    /// ```swift
    /// let str = "it's%20easy%20to%20decode%20strings"
    /// let decoded = str.dd_urlDecode()
    /// print(decoded) // 输出: "it's easy to decode strings"
    /// ```
    func dd_urlDecode() -> String {
        removingPercentEncoding ?? self
    }
}

// MARK: - 位置相关
public extension String {
    /// `subStr` 在字符串中第一次出现的位置
    ///
    /// - Example:
    ///     ```swift
    /// let position = "Hello, world!".dd_positionFirst(of: "world")
    /// print(position)  // 输出: 7
    ///     ```
    /// - Parameter subStr: 要查询的子字符串
    /// - Returns: 子字符串第一次出现的位置，如果不存在返回 `-1`
    func dd_positionFirst(of subStr: String) -> Int {
        return dd_position(of: subStr)
    }

    /// `subStr` 在字符串中最后一次出现的位置
    ///
    /// - Example:
    ///     ```swift
    /// let position = "Hello, world! world".dd_positionLast(of: "world")
    /// print(position)  // 输出: 14
    ///     ```
    /// - Parameter subStr: 要查询的子字符串
    /// - Returns: 子字符串最后一次出现的位置，如果不存在返回 `-1`
    func dd_positionLast(of subStr: String) -> Int {
        return dd_position(of: subStr, backwards: true)
    }

    /// 返回 `subStr` 在字符串中的位置
    ///
    /// - Example:
    ///     ```swift
    /// let position = "Hello, world!".dd_position(of: "world")
    /// print(position)  // 输出: 7
    ///     ```
    /// - Parameters:
    ///   - subStr: 要查询的子字符串
    ///   - backwards: 如果设置为 `true`，返回最后一次出现的位置，否则返回第一次出现的位置
    /// - Returns: 子字符串的位置，如果不存在返回 `-1`
    func dd_position(of subStr: String, backwards: Bool = false) -> Int {
        var pos = -1
        // 查找子字符串的范围，选择是否向后查找
        if let range = range(of: subStr, options: backwards ? .backwards : .literal) {
            if !range.isEmpty {
                pos = distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }
}

// MARK: - 字符串截取
public extension String {
    /// 获取某个位置的字符串
    ///
    /// - Example:
    ///     ```swift
    /// let character = "Hello"[dd_indexString(index: 1)]
    /// print(character)  // 输出: "e"
    ///     ```
    /// - Parameter index: 位置
    /// - Returns: `String` 类型的子字符串
    func dd_indexString(index: Int) -> String {
        return self.dd_slice(index ..< index + 1)
    }

    /// 切割字符串(区间范围, 前闭后开)
    ///
    /// - Example:
    ///     ```swift
    /// let sliced = "Hello, World!"[dd_slice(0..<5)]
    /// print(sliced)  // 输出: "Hello"
    ///     ```
    /// - Parameter range: 范围
    /// - Returns: 结果字符串
    func dd_slice(_ range: CountableRange<Int>) -> String {
        let startIndex = dd_validateIndex(original: range.lowerBound)
        let endIndex = dd_validateIndex(original: range.upperBound)

        guard startIndex < endIndex else {
            return ""
        }
        return String(self[startIndex ..< endIndex])
    }

    /// 截取子字符串(从`from`开始到字符串结尾)
    ///
    /// - Example:
    ///     ```swift
    /// let substring = "Hello, World!"[dd_subString(from: 7)]
    /// print(substring)  // 输出: "World!"
    ///     ```
    /// - Parameter from: 开始位置
    /// - Returns: 结果字符串
    func dd_subString(from: Int) -> String {
        let end = count
        return self[dd_safe: from ..< end] ?? ""
    }

    /// 截取子字符串(从`开头`到`to`)
    ///
    /// - Example:
    ///     ```swift
    /// let substring = "Hello, World!"[dd_subString(to: 5)]
    /// print(substring)  // 输出: "Hello"
    ///     ```
    /// - Parameter to: 停止位置
    /// - Returns: 结果字符串
    func dd_subString(to: Int) -> String {
        return self[dd_safe: 0 ..< to] ?? ""
    }

    /// 截取子字符串(从`from`开始截取`length`个字符)
    ///
    /// - Example:
    ///     ```swift
    /// let substring = "Hello, World!"[dd_subString(from: 0, length: 5)]
    /// print(substring)  // 输出: "Hello"
    ///     ```
    /// - Parameters:
    ///   - from: 开始截取位置
    ///   - length: 长度
    /// - Returns: 结果字符串
    func dd_subString(from: Int, length: Int) -> String {
        let end = from + length
        return self[dd_safe: from ..< end] ?? ""
    }

    /// 截取子字符串(从`from`开始截取到`to`)
    ///
    /// - Example:
    ///     ```swift
    /// let substring = "Hello, World!"[dd_subString(from: 0, to: 5)]
    /// print(substring)  // 输出: "Hello"
    ///     ```
    /// - Parameters:
    ///   - from: 开始位置
    ///   - to: 结束位置
    /// - Returns: 结果字符串
    func dd_subString(from: Int, to: Int) -> String {
        return self[dd_safe: from ..< to] ?? ""
    }

    /// 根据`NSRange`截取子字符串
    ///
    /// - Example:
    ///     ```swift
    /// let substring = "Hello, World!"[dd_subString(range: NSRange(location: 0, length: 5))]
    /// print(substring)  // 输出: "Hello"
    ///     ```
    /// - Parameter range: `NSRange`
    /// - Returns: 结果字符串
    func dd_subString(range: NSRange) -> String {
        return self.dd_toNSString().substring(with: range)
    }

    /// 根据`Range<Int>`截取子字符串
    ///
    /// - Example:
    ///     ```swift
    /// let substring = "Hello, World!"[dd_subString(range: 0..<5)]
    /// print(substring)  // 输出: "Hello"
    ///     ```
    /// - Parameter range: `Range<Int>`
    /// - Returns: 结果字符串
    func dd_subString(range: Range<Int>) -> String {
        return self[dd_safe: range] ?? ""
    }

    /// 根据`Range<String.Index>`截取子字符串
    ///
    /// - Example:
    ///     ```swift
    /// let range = "Hello, World!".dd_range("World")
    /// let substring = "Hello, World!"[dd_subString(range: range)]
    /// print(substring)  // 输出: "World"
    ///     ```
    /// - Parameter range: `Range<String.Index>`
    /// - Returns: 结果字符串
    func dd_subString(range: Range<String.Index>) -> String {
        let subString = self[range]
        return String(subString)
    }

    /// 截断字符串
    ///
    /// - Example:
    ///     ```swift
    /// let truncated = "This is a very long sentence".dd_truncate(len: 14)
    /// print(truncated)  // 输出: "This is a very"
    ///     ```
    /// - Note: 保留指定长度
    /// - Parameter len: 保留长度
    /// - Returns: 结果字符串
    func dd_truncate(len: Int) -> String {
        if self.count > len {
            return self.dd_subString(to: len)
        }
        return self
    }

    /// 截断字符串，并添加尾巴
    ///
    /// - Example:
    ///     ```swift
    /// let truncated = "This is a very long sentence".dd_truncate(length: 14)
    /// print(truncated)  // 输出: "This is a very..."
    ///     ```
    /// - Note: 只有字符串长度大于保留长度时，才会发生截断
    /// - Parameters:
    ///   - length: 保留长度
    ///   - trailing: 尾巴
    /// - Returns: 结果字符串
    func dd_truncate(length: Int, trailing: String? = "...") -> String {
        guard 0 ..< count ~= length else { return self }
        return self[startIndex ..< index(startIndex, offsetBy: length)] + (trailing ?? "")
    }

    /// 截断字符串, 并添加分隔符
    ///
    /// - Example:
    ///     ```swift
    /// let truncated = "HelloWorld".dd_truncate(5, separator: "_")
    /// print(truncated)  // 输出: "Hello_World"
    ///     ```
    /// - Parameters:
    ///   - length: 截断长度
    ///   - separator: 分隔符
    /// - Returns: 结果字符串
    func dd_truncate(_ length: Int, separator: String = "-") -> String {
        // 确保length大于0
        guard length > 0 else { return self }

        var result = [String]()
        var startIndex = self.startIndex

        // 按指定长度分割字符串
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            let substring = self[startIndex ..< endIndex]
            result.append(String(substring))
            startIndex = endIndex
        }

        // 使用分隔符连接每段
        return result.joined(separator: separator)
    }

    /// 根据长度分割字符串
    ///
    /// - Example:
    ///     ```swift
    /// let parts = "HelloWorld".dd_split(by: 5)
    /// print(parts)  // 输出: ["Hello", "World"]
    ///     ```
    /// - Parameter length: 每段的长度
    /// - Returns: 被分割的字符串数组
    func dd_split(by length: Int) -> [String] {
        var result = [String]()
        var startIndex = self.startIndex

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            result.append(String(self[startIndex ..< endIndex]))
            startIndex = endIndex
        }
        return result
    }
}

// MARK: - 常用方法
public extension String {
    /// 从字符串中提取所有数字字符
    ///
    /// - Example:
    /// ```
    /// "abc123def456".dd_extractNumbers() -> "123456"
    /// ```
    func dd_extractNumbers() -> String {
        return self.filter(\.isNumber)
    }

    /// 获取字符串中的第一个字符
    ///
    /// - Example:
    /// ```
    /// "Swift".dd_firstCharacter() -> "S"
    /// ```
    func dd_firstCharacter() -> String? {
        guard let first else { return nil }
        return String(first)
    }

    /// 获取字符串中的最后一个字符
    ///
    /// - Example:
    /// ```
    /// "Swift".dd_lastCharacter() -> "t"
    /// ```
    func dd_lastCharacter() -> String? {
        guard let last else { return nil }
        return String(last)
    }

    /// 获取字符串中的单词数量
    ///
    /// - Example:
    /// ```
    /// "Swift is amazing".dd_wordCount() -> 3
    /// ```
    func dd_wordCount() -> Int {
        let characterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = components(separatedBy: characterSet)
        return components.filter { !$0.isEmpty }.count
    }

    /// 计算字符串中数字的个数
    ///
    /// - Example:
    /// ```
    /// "abc1234".dd_numericCount() -> 4
    /// ```
    func dd_numericCount() -> Int {
        return self.filter(\.isNumber).count
    }

    /// 计算字符串的字符数 (`英文 == 1`, `数字 == 1`, `汉字 == 2`)
    ///
    /// - Example:
    /// ```
    /// "Hello 你好".dd_charCount() -> 7
    /// ```
    func dd_calculateCharacterCount() -> Int {
        return self.reduce(0) { count, char in
            let isChinese = char.unicodeScalars.first?.value ?? 0 >= 0x4E00
            return count + (isChinese ? 2 : 1)
        }
    }

    /// 计算指定字符串出现的次数
    ///
    /// - Example:
    /// ```
    /// "Hello World!".dd_count(of: "o") -> 2
    /// "Hello World!".dd_count(of: "L", caseSensitive: false) -> 3
    /// ```
    func dd_countOccurrences(of string: String, caseSensitive: Bool = true) -> Int {
        let searchString = caseSensitive ? self : self.lowercased()
        let searchTarget = caseSensitive ? string : string.lowercased()
        return searchString.components(separatedBy: searchTarget).count - 1
    }

    /// 查找字符串中出现最频繁的字符
    ///
    /// - Example:
    /// ```
    /// "This is a test".dd_mostCommonCharacter() -> " " (空格是最常见的字符)
    /// ```
    func dd_findMostCommonCharacter() -> Character? {
        let cleanedString = self.filter { !$0.isWhitespace }
        let frequency = cleanedString.reduce(into: [Character: Int]()) { count, char in
            count[char, default: 0] += 1
        }
        return frequency.max { $0.value < $1.value }?.key
    }

    /// 校验字符串中的位置是否有效，并返回有效的 `String.Index`
    ///
    /// - Example:
    /// ```
    /// let index = "Hello".dd_validateIndex(original: 3)
    /// ```
    func dd_validateIndex(original: Int) -> String.Index {
        guard original >= 0 else { return startIndex }
        let offset = min(original, count - 1)
        return index(startIndex, offsetBy: offset)
    }

    /// 获取字符串中所有字符的 Unicode 数组
    ///
    /// - Example:
    /// ```
    /// "SwifterSwift".dd_unicodeValues() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    /// ```
    func dd_unicodeValues() -> [Int] {
        return self.unicodeScalars.map { Int($0.value) }
    }

    /// 获取字符串中的所有单词组成的数组
    ///
    /// - Example:
    /// ```
    /// "Swift is amazing".dd_extractWords() -> ["Swift", "is", "amazing"]
    /// ```
    func dd_extractWords() -> [String] {
        let characterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        return components(separatedBy: characterSet).filter { !$0.isEmpty }
    }

    /// 从 HTML 字符串中提取链接和文本
    ///
    /// - Example:
    /// ```
    /// "<a href=\"https://example.com\">Click here</a>".dd_extractLinkAndText() -> (link: "https://example.com", text: "Click here")
    /// ```
    /// - Returns: `(link: String, text: String)?`
    func dd_extractLinkAndText() -> (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) else { return nil }

        let link = dd_toNSString().substring(with: result.range(at: 1))
        let text = dd_toNSString().substring(with: result.range(at: 2))
        return (link, text)
    }

    /// 获取字符串中所有链接的 `NSRange` 数组
    ///
    /// - Example:
    /// ```
    /// "Check out https://example.com and @username".dd_extractLinkRanges() -> [NSRange(location: 10, length: 22), NSRange(location: 30, length: 10)]
    /// ```
    /// - Returns: `NSRange` 数组
    func dd_extractLinkRanges() -> [NSRange]? {
        let patterns = [
            "[a-zA-Z]*://[a-zA-Z0-9/\\.]*", // URL
            "#.*?#", // Hashtags
            "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*", // Mentions
        ]

        var ranges = [NSRange]()

        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
                return nil
            }
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: count))
            ranges.append(contentsOf: matches.map { $0.range(at: 0) })
        }

        return ranges
    }

    /// 将字符串按行分割为字符串数组
    ///
    /// - Example:
    /// ```
    /// "Hello\nWorld".dd_splitIntoLines() -> ["Hello", "World"]
    /// ```
    /// - Returns: 按行分割的字符串数组
    func dd_splitIntoLines() -> [String] {
        var result = [String]()
        self.enumerateLines { line, _ in result.append(line) }
        return result
    }

    /// 将字符串分割成多行文本
    ///
    /// 根据给定的宽度和字体，将字符串分割为适合显示的多行文本内容。
    ///
    /// 示例：
    /// ```swift
    /// let text = "这是一个测试字符串，分割成多行。"
    /// let font = UIFont.systemFont(ofSize: 16)
    /// let lines = text.dd_splitIntoLines1(forWidth: 100, usingFont: font)
    /// print("分割后的行内容: \(lines)")
    /// ```
    ///
    /// - Parameters:
    ///   - width: 每行的最大宽度。
    ///   - font: 用于计算文本宽度的字体。
    /// - Returns: 分割后的行内容数组。
    func dd_splitIntoLines1(forWidth width: CGFloat, usingFont font: UIFont) -> [String] {
        guard !isEmpty else { return [] }

        var lines: [String] = []
        var currentLine = ""
        var currentWidth: CGFloat = 0

        for word in self.split(separator: " ") {
            let wordWithSpace = currentLine.isEmpty ? String(word) : " \(word)"
            let wordSize = (wordWithSpace as NSString).size(withAttributes: [.font: font])

            if currentWidth + wordSize.width > width {
                // 当前行宽度超过限制，将当前行保存并开始新的一行
                lines.append(currentLine)
                currentLine = String(word)
                currentWidth = (word as NSString).size(withAttributes: [.font: font]).width
            } else {
                // 当前行可继续添加
                currentLine += wordWithSpace
                currentWidth += wordSize.width
            }
        }

        // 添加最后一行
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }

        return lines
    }

    /// 将字符串分割成多行文本
    ///
    /// 根据给定的宽度和字体，将字符串分割为适合显示的多行文本内容。
    ///
    /// 示例：
    /// ```swift
    /// let text = "这是一个测试字符串，分割成多行。"
    /// let font = UIFont.systemFont(ofSize: 16)
    /// let lines = text.dd_splitIntoLines2(forWidth: 100, usingFont: font)
    /// print("分割后的行内容: \(lines)")
    /// ```
    ///
    /// - Parameters:
    ///   - width: 每行的最大宽度。
    ///   - font: 用于计算文本宽度的字体。
    /// - Returns: 分割后的行内容数组。
    func dd_splitIntoLines2(forWidth width: CGFloat, usingFont font: UIFont) -> [String] {
        let label = UILabel()
        label.font = font
        label.lineBreakMode = .byWordWrapping
        label.text = self
        label.numberOfLines = 0
        label.frame = CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)
        label.sizeToFit()

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        let textStorage = NSTextStorage(string: self, attributes: [.font: font])

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        var lines: [String] = []
        var currentRange = NSRange(location: 0, length: 0)
        while currentRange.location < layoutManager.numberOfGlyphs {
            layoutManager.lineFragmentUsedRect(forGlyphAt: currentRange.location, effectiveRange: &currentRange)
            if let range = Range(currentRange, in: self) {
                lines.append(String(self[range]))
            }
        }
        return lines
    }

    /// 获取字符串中每行的内容，并根据行宽和字体限制进行分页处理
    ///
    /// - Example:
    /// ```
    /// let lines = "Hello Swift".dd_wrapLines(toWidth: 200, font: UIFont.systemFont(ofSize: 12))
    /// ```
    /// - Parameters:
    ///   - lineWidth: 行宽
    ///   - font: 字体
    /// - Returns: 字符串数组
    func dd_wrapLines(toWidth lineWidth: CGFloat, font: UIFont) -> [String] {
        let style = NSMutableParagraphStyle.default()
            .dd_lineBreakMode(.byCharWrapping)
        let cfFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)

        let attributedString = dd_toNSMutableAttributedString()
            .dd_addAttributes([
                .paragraphStyle: style,
                NSAttributedString.Key(kCTFontAttributeName as String): cfFont,
            ], for: dd_fullNSRange())

        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let path = CGMutablePath()
            .dd_add(rect: CGRect(x: 0, y: 0, width: lineWidth, height: 100_000))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(CFIndex(0), CFIndex(0)), path, nil)

        let lines = CTFrameGetLines(frame) as? [AnyHashable] ?? []
        var result: [String] = []

        for line in lines {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            result.append((self as NSString).substring(with: range))
        }

        return result
    }

    /// 将字符串转换为驼峰命名法
    ///
    /// - Example:
    /// ```
    /// "sOme vAriable naMe".dd_convertToCamelCase() -> "someVariableName"
    /// ```
    /// - Note: 移除空格并将单词首字母大写，第一个单词首字母小写
    /// - Returns: 转换后的字符串
    func dd_convertToCamelCase() -> String {
        let source = lowercased()
        let first = source.prefix(1)
        let rest = source.dropFirst().capitalized.replacingOccurrences(of: " ", with: "")

        return first + rest
    }

    /// 将汉字字符串转换为拼音字符串
    ///
    /// - Example:
    /// ```
    /// "汉字".dd_convertToPinYin() -> "hanzi"
    /// ```
    /// - Parameter isTone: 是否保留声调
    /// - Returns: 拼音字符串
    func dd_convertToPinYin(isTone: Bool = false) -> String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)

        if !isTone { CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false) }

        return mutableString as String
    }

    /// 提取汉字拼音首字母(每个汉字)
    ///
    /// - Example:
    /// ```
    /// "爱国".dd_extractPinYinInitials() --> AG
    /// ```
    /// - Parameter isUpper: 是否返回大写拼音首字母。默认是大写。
    /// - Returns: 拼音首字母的字符串
    func dd_extractPinYinInitials(isUpper: Bool = true) -> String {
        // 获取拼音的每个单词，并去掉空格
        let pinYin = self.dd_convertToPinYin(isTone: false).components(separatedBy: " ")
        // 获取每个拼音的首字母，并将其转换为字符数组
        let initials = pinYin.compactMap { String(format: "%c", $0.cString(using: .utf8)![0]) }
        // 根据是否需要大写首字母，返回拼音首字母字符串
        return isUpper ? initials.joined().uppercased() : initials.joined()
    }

    /// 返回本地化字符串
    /// - Parameter comment: 用于翻译的注释，默认值为空字符串。
    /// - Returns: 本地化字符串
    ///
    /// - Example:
    /// ```
    /// "Hello".dd_localizedString(comment: "Greeting") -> "你好"
    /// ```
    func dd_localizedString(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    /// 将字符串转换为slug字符串
    ///
    /// - Example:
    /// ```
    /// "Swift is amazing".dd_toSlug() -> "swift-is-amazing"
    /// ```
    /// - Returns: 转换后的slug字符串
    func dd_toSlug() -> String {
        let lowercased = lowercased()
        // 去除重音符号并将字符转为小写
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        // 将空格替换为短横线
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        // 过滤非字母数字字符
        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        // 去除前后多余的短横线
        while filtered.dd_lastCharacter() == "-" {
            filtered = String(filtered.dropLast())
        }
        while filtered.dd_firstCharacter() == "-" {
            filtered = String(filtered.dropFirst())
        }

        // 替换连续的短横线为单个短横线
        return filtered.replacingOccurrences(of: "--", with: "-")
    }

    /// 删除字符串开头和结尾的空格及换行符
    /// - Returns: 去掉前后空格和换行符的字符串
    ///
    /// - Example:
    /// ```
    /// var str = "  \n Hello World \n\n\n"
    /// str.dd_trimmed() // 输出 "Hello World"
    /// ```
    @discardableResult
    func dd_trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 移除字符串前后的空格
    /// - Returns: 去掉前后空格的字符串
    ///
    /// - Example:
    /// ```
    /// "  Hello World  ".dd_trimSpaces() // 输出 "Hello World"
    /// ```
    func dd_trimSpaces() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }

    /// 移除字符串前后的换行符
    /// - Returns: 去掉前后换行符的字符串
    ///
    /// - Example:
    /// ```
    /// "\nHello World\n".dd_trimNewLines() // 输出 "Hello World"
    /// ```
    func dd_trimNewLines() -> String {
        return trimmingCharacters(in: CharacterSet.newlines)
    }

    /// 移除字符串中的所有空格
    /// - Returns: 去掉所有空格的字符串
    ///
    /// - Example:
    /// ```
    /// "Hello World".dd_removeSpaces() // 输出 "HelloWorld"
    /// ```
    func dd_removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }

    /// 移除字符串中的所有换行符
    /// - Returns: 去掉所有换行符的字符串
    ///
    /// - Example:
    /// ```
    /// "Hello\nWorld".dd_removeNewLines() // 输出 "HelloWorld"
    /// ```
    func dd_removeNewLines() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
    }

    /// 移除字符串中所有的空格和换行符
    ///
    /// - Example:
    /// ```
    /// "   \n Swifter   \n  Swift  ".dd_removeSpacesAndNewLines() // 输出 "SwifterSwift"
    /// ```
    /// - Returns: 去掉所有空格和换行符的字符串
    func dd_removeSpacesAndNewLines() -> String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }

    /// 字符串的首字符大写, 其他字符保持原样
    /// - Returns: 首字符大写后的字符串, 如果原字符串为空，则返回nil
    ///
    /// - Example:
    /// ```
    /// "hello world".dd_capitalizeFirstCharacter() // 输出 "Hello world"
    /// ```
    func dd_capitalizeFirstCharacter() -> String? {
        guard let first else { return nil }
        return String(first).uppercased() + dropFirst()
    }

    /// 将字符串反转并返回
    /// - Returns: 反转后的字符串
    ///
    /// - Example:
    /// ```
    /// "Hello".dd_reverseString() // 输出 "olleH"
    /// ```
    @discardableResult
    mutating func dd_reverseString() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }

    /// 根据指定的字符分割字符串
    /// - Parameter separator: 分割依据的字符
    /// - Returns: 分割后的字符串数组
    ///
    /// - Example:
    /// ```
    /// "Hello,World".dd_split(by: ",") // 输出 ["Hello", "World"]
    /// ```
    func dd_split(by separator: String) -> [String] {
        let components = self.components(separatedBy: separator)
        return components != [""] ? components : []
    }

    /// 在字符串开头填充指定长度的字符
    ///
    /// - Example:
    /// ```
    /// "hue".dd_padStart(to: 10) -> "       hue"
    /// "hue".dd_padStart(to: 10, using: "br") -> "brbrbrbhue"
    /// ```
    /// - Note: 只有当字符串长度小于指定长度时，才会填充
    /// - Parameters:
    ///   - length: 目标字符串的长度
    ///   - character: 用于填充的字符，默认为空格
    /// - Returns: 填充后的字符串
    @discardableResult
    func dd_padStart(to length: Int, using character: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        let padding = String(repeating: character, count: (padLength + character.count - 1) / character.count).prefix(padLength)

        return padding + self
    }

    /// 在字符串末尾填充指定长度的字符
    ///
    /// - Example:
    /// ```
    /// "hue".dd_padEnd(to: 10) -> "hue       "
    /// "hue".dd_padEnd(to: 10, using: "br") -> "huebrbrbrb"
    /// ```
    /// - Note: 只有当字符串长度小于指定长度时，才会填充
    /// - Parameters:
    ///   - length: 目标字符串的长度
    ///   - character: 用于填充的字符，默认为空格
    /// - Returns: 填充后的字符串
    @discardableResult
    func dd_padEnd(to length: Int, using character: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        let padding = String(repeating: character, count: (padLength + character.count - 1) / character.count).prefix(padLength)

        return self + padding
    }

    /// 使用正则表达式替换匹配的内容
    /// - Parameters:
    ///   - regex: 正则表达式对象，用于匹配目标字符串
    ///   - template: 替换的字符串，用于替换正则匹配的部分
    ///   - options: 正则匹配选项，默认值为 []，可以用于指定匹配的规则（如忽略大小写等）
    ///   - range: 搜索范围，默认为整个字符串范围，允许指定搜索的起始和结束范围
    /// - Returns: 返回替换后的字符串
    ///
    /// - Example:
    /// ```
    /// let regex = try! NSRegularExpression(pattern: "\\d+")  // 匹配数字
    /// let result = "abc123xyz".dd_replaceRegexMatches(using: regex, template: "###")
    /// print(result)  // 输出: "abc###xyz"
    /// ```
    func dd_replaceRegexMatches(using regex: NSRegularExpression,
                                template: String,
                                options: NSRegularExpression.MatchingOptions = [],
                                range searchRange: Range<String.Index>? = nil) -> String
    {
        let range = NSRange(searchRange ?? startIndex ..< endIndex, in: self)
        return regex.stringByReplacingMatches(in: self,
                                              options: options,
                                              range: range,
                                              withTemplate: template)
    }

    /// 使用正则表达式字符串替换匹配的内容
    /// - Parameters:
    ///   - pattern: 正则表达式模式的字符串形式，用于匹配目标字符串
    ///   - template: 替换的字符串，用于替换正则匹配的部分
    ///   - options: 正则匹配选项，默认值为 []，可以指定匹配的规则（如忽略大小写等）
    /// - Returns: 返回替换后的字符串
    ///
    /// - Example:
    /// ```
    /// let result = "The number 123 is here".dd_replaceRegexMatches(using: "\\d+", template: "***")
    /// print(result)  // 输出: "The number *** is here"
    /// ```
    func dd_replaceRegexMatches(using pattern: String,
                                template: String,
                                options: NSRegularExpression.Options = []) -> String
    {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return self // 如果正则表达式无效，返回原字符串
        }
        return regex.stringByReplacingMatches(in: self,
                                              options: [],
                                              range: NSRange(location: 0, length: count),
                                              withTemplate: template)
    }

    /// 从字符串中删除指定前缀
    ///
    /// - Example:
    /// ```
    /// "Hello, World!".dd_removePrefix("Hello, ") -> "World!"
    /// ```
    /// - Parameter prefix: 要删除的前缀
    /// - Returns: 删除前缀后的字符串
    func dd_removePrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    /// 从字符串中删除指定后缀
    ///
    /// - Example:
    /// ```
    /// "Hello, World!".dd_removeSuffix(", World!") -> "Hello"
    /// ```
    /// - Parameter suffix: 要删除的后缀
    /// - Returns: 删除后缀后的字符串
    func dd_removeSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// 在字符串前添加指定前缀
    ///
    /// - Example:
    /// ```
    /// "www.apple.com".dd_withPrefix("https://") -> "https://www.apple.com"
    /// ```
    /// - Parameter prefix: 要添加的前缀
    /// - Returns: 添加前缀后的字符串
    func dd_withPrefix(_ prefix: String) -> String {
        return hasPrefix(prefix) ? self : prefix + self
    }

    /// 在字符串后添加指定后缀
    ///
    /// - Example:
    /// ```
    /// "www.apple".dd_withSuffix(".com") -> "www.apple.com"
    /// ```
    /// - Parameter suffix: 要添加的后缀
    /// - Returns: 添加后缀后的字符串
    func dd_withSuffix(_ suffix: String) -> String {
        return hasSuffix(suffix) ? self : self + suffix
    }

    /// 在指定位置插入字符串
    /// - Parameters:
    ///   - content: 要插入的内容
    ///   - index: 插入的位置（从0开始）
    /// - Returns: 返回插入后的新字符串
    ///
    /// - Example:
    /// ```
    /// let result = "Hello, World!".dd_insert(" Swift", at: 7)
    /// print(result)  // 输出: "Hello, SwiftWorld!"
    /// ```
    func dd_insert(_ content: String, at index: Int) -> String {
        guard index <= count else { return self } // 修复了不等于时的逻辑问题
        return String(self.prefix(index)) + content + String(self.suffix(count - index))
    }

    /// 替换字符串中的指定内容
    ///
    /// - Example:
    /// ```
    /// "Hello World".dd_replace("World", with: "Swift") -> "Hello Swift"
    /// ```
    /// - Parameters:
    ///   - target: 被替换的字符串
    ///   - replacement: 替换成的字符串
    /// - Returns: 替换后的字符串
    func dd_replace(_ target: String, with replacement: String) -> String {
        return self.replacingOccurrences(of: target, with: replacement)
    }

    /// 隐藏字符串中的敏感内容
    ///
    /// - Example:
    /// ```
    /// "012345678912".dd_hideSensitiveContent(range: 3..<8, replace: "*****") -> "012*****912"
    /// ```
    /// - Parameters:
    ///   - range: 要隐藏的内容范围
    ///   - replace: 用于替换的字符串
    /// - Returns: 隐藏后的字符串
    func dd_hideSensitiveContent(range: Range<Int>, replace: String = "****") -> String {
        guard range.lowerBound < count, range.upperBound <= count else { return self }
        let sensitiveContent = self[range]
        return self.replacingOccurrences(of: sensitiveContent, with: replace)
    }

    /// 生成指定次数的重复字符串
    ///
    /// - Example:
    /// ```
    /// "abc".dd_repeat(3) -> "abcabcabc"
    /// ```
    /// - Parameter count: 重复次数
    /// - Returns: 生成的重复字符串
    func dd_repeat(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }

    /// 删除字符串中的指定字符
    ///
    /// - Example:
    /// ```
    /// "Hello World!".dd_removeCharacter("l") -> "Heo Word!"
    /// ```
    /// - Parameter characterString: 要删除的字符
    /// - Returns: 删除字符后的字符串
    func dd_removeCharacter(_ characterString: String) -> String {
        return self.filter { !characterString.contains($0) }
    }

    /// 获取两个字符串的最长相同后缀
    ///
    /// - Example:
    /// ```
    /// "apple".dd_commonSuffix(with: "maple") -> "ple"
    /// ```
    /// - Parameters:
    ///   - other: 另一个用于比较的字符串
    /// - Returns: 最长相同后缀的字符串
    func dd_commonSuffix(with other: String) -> String {
        return String(zip(reversed(), other.reversed())
            .prefix(while: { $0.0 == $0.1 })
            .map(\.0))
    }
}

// MARK: - 字符串判断
public extension String {
    /// 检查字符串是否包含字母
    ///
    /// - Example:
    /// ```swift
    /// "123abc".dd_hasLetters() -> true
    /// "123".dd_hasLetters() -> false
    /// ```
    /// - Returns: 如果字符串包含字母，返回 `true`，否则返回 `false`
    func dd_hasLetters() -> Bool {
        return rangeOfCharacter(from: .letters) != nil
    }

    /// 检查字符串是否只包含字母
    ///
    /// - Example:
    /// ```swift
    /// "abc".dd_isAlphabetic() -> true
    /// "123abc".dd_isAlphabetic() -> false
    /// ```
    /// - Returns: 如果字符串只包含字母，返回 `true`，否则返回 `false`
    func dd_isAlphabetic() -> Bool {
        let containsLetters = rangeOfCharacter(from: .letters) != nil
        let containsNumbers = rangeOfCharacter(from: .decimalDigits) != nil
        return containsLetters && !containsNumbers
    }

    /// 检查字符串是否包含数字
    ///
    /// - Example:
    /// ```swift
    /// "abcd".dd_hasNumbers() -> false
    /// "123abc".dd_hasNumbers() -> true
    /// ```
    /// - Returns: 如果字符串包含数字，返回 `true`，否则返回 `false`
    func dd_hasNumbers() -> Bool {
        return rangeOfCharacter(from: .decimalDigits) != nil
    }

    /// 检查字符串是否同时包含字母和数字
    ///
    /// - Example:
    /// ```swift
    /// "123abc".dd_isAlphaNumeric() -> true
    /// "abc".dd_isAlphaNumeric() -> false
    /// ```
    /// - Returns: 如果字符串同时包含字母和数字，返回 `true`，否则返回 `false`
    func dd_isAlphaNumeric() -> Bool {
        let containsLetters = rangeOfCharacter(from: .letters) != nil
        let containsNumbers = rangeOfCharacter(from: .decimalDigits) != nil
        return containsLetters && containsNumbers
    }

    /// 检查字符串是否为有效的 Swift 数字
    ///
    /// - Example:
    /// ```swift
    /// "123".dd_isSwiftNumeric() -> true
    /// "1.3".dd_isSwiftNumeric() -> true
    /// "1,3".dd_isSwiftNumeric() -> true (取决于地区设置)
    /// "abc".dd_isSwiftNumeric() -> false
    /// ```
    /// - Returns: 如果字符串是有效的数字，返回 `true`，否则返回 `false`
    func dd_isSwiftNumeric() -> Bool {
        let scanner = Scanner(string: self)
        scanner.locale = Locale.current
        return scanner.scanDecimal() != nil && scanner.isAtEnd
    }

    /// 判断字符串是否是整数
    ///
    /// - Example:
    /// ```swift
    /// "123".dd_isPureInt() -> true
    /// "1.3".dd_isPureInt() -> false
    /// ```
    /// - Returns: 如果字符串是整数，返回 `true`，否则返回 `false`
    func dd_isPureInt() -> Bool {
        let scanner = Scanner(string: self)
        return scanner.scanInt() != nil && scanner.isAtEnd
    }

    /// 检查字符串是否只包含数字
    ///
    /// - Example:
    /// ```swift
    /// "123".dd_isDigits() -> true
    /// "1.3".dd_isDigits() -> false
    /// "abc".dd_isDigits() -> false
    /// ```
    /// - Returns: 如果字符串只包含数字，返回 `true`，否则返回 `false`
    func dd_isDigits() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    /// 判断字符串是否存在连续的数字字符 (连续的数字大于等于2)
    ///
    /// 该方法遍历字符串中的字符，检查是否有两个或更多连续的数字字符。
    /// 如果存在，返回 `true`；否则返回 `false`。
    ///
    /// - Example:
    /// ```swift
    /// let testString = "abc123def"
    /// print(testString.isHasContinuousNumber()) // 输出: true
    /// ```
    ///
    /// - Returns: `true` 如果存在连续的数字字符，`false` 否则。
    func isHasContinuousNumber() -> Bool {
        let chars = self.dd_toCharacters()

        var consecutiveCount = 0 // 连续数字的计数

        for c in chars {
            if c.isASCII, let asciiValue = c.asciiValue, asciiValue >= 48, asciiValue <= 57 {
                // 当前字符是数字
                consecutiveCount += 1
                if consecutiveCount >= 2 {
                    // 如果连续数字大于等于2个，返回 true
                    return true
                }
            } else {
                // 当前字符不是数字，重置连续数字计数
                consecutiveCount = 0
            }
        }

        return false
    }

    /// 检查字符串是否只包含空格
    ///
    /// - Example:
    /// ```swift
    /// "   ".dd_isWhitespace() -> true
    /// "abc".dd_isWhitespace() -> false
    /// ```
    /// - Returns: 如果字符串只包含空格，返回 `true`，否则返回 `false`
    func dd_isWhitespace() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 检查字符串拼写是否正确
    ///
    /// 检查当前字符串是否包含拼写错误。如果字符串没有拼写错误，则返回 `true`，否则返回 `false`。
    ///
    /// - Example:
    /// ```swift
    /// let correctText = "hello"
    /// let isSpelledCorrectly = correctText.dd_isSpelledCorrectly()  // 返回 true
    ///
    /// let incorrectText = "helllo"
    /// let isSpelledCorrectly2 = incorrectText.dd_isSpelledCorrectly()  // 返回 false
    /// ```
    ///
    /// - Returns: 如果字符串拼写正确，返回 `true`；如果有拼写错误，返回 `false`。
    func dd_isSpelledCorrectly() -> Bool {
        // 创建一个文本检查器
        let checker = UITextChecker()

        // 获取当前字符串的NSRange
        let range = NSRange(startIndex ..< endIndex, in: self)

        // 使用文本检查器检查拼写错误
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: self, // 要检查的文本
            range: range, // 检查的范围
            startingAt: 0, // 从字符串的起始位置开始检查
            wrap: false, // 不处理换行
            language: Locale.preferredLanguages.first ?? "en" // 使用当前语言环境，默认使用英语
        )

        // 如果找不到拼写错误，则返回 true（即拼写正确），否则返回 false
        return misspelledRange.location == NSNotFound
    }

    /// 检查字符串是否是回文
    ///
    /// - Example:
    /// ```swift
    /// "abcdcba".dd_isPalindrome() -> true
    /// "Mama".dd_isPalindrome() -> false
    /// ```
    /// - Returns: 如果字符串是回文，返回 `true`，否则返回 `false`
    func dd_isPalindrome() -> Bool {
        let letters = filter(\.isLetter)
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex ..< midIndex]
        let secondHalf = letters[midIndex ..< letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains { $0.lowercased() != $1.lowercased() }
    }

    /// 检查字符串是否只包含唯一字符（没有重复字符）
    ///
    /// - Example:
    /// ```swift
    /// "abc".dd_hasUniqueCharacters() -> true
    /// "aabb".dd_hasUniqueCharacters() -> false
    /// ```
    /// - Returns: 如果字符串只包含唯一字符，返回 `true`，否则返回 `false`
    func dd_hasUniqueCharacters() -> Bool {
        guard !isEmpty else { return false }
        var uniqueChars = Set<Character>()
        for char in self {
            if uniqueChars.contains(char) {
                return false
            }
            uniqueChars.insert(char)
        }
        return true
    }

    /// 判断字符串是否属于九宫格键盘字符
    ///
    /// - Example:
    /// ```swift
    /// "➋".dd_isNineKeyBoard() -> true
    /// "abc".dd_isNineKeyBoard() -> false
    /// ```
    /// - Returns: 如果字符串属于九宫格键盘字符，返回 `true`，否则返回 `false`
    func dd_isNineKeyBoard() -> Bool {
        let nineKeyCharacters: Set<Character> = ["➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"]
        return self.allSatisfy { nineKeyCharacters.contains($0) }
    }

    /// 利用正则表达式判断是否是手机号码
    ///
    /// 检查当前字符串是否符合中国的手机号码格式（11位数字，以1开头，第二位为3-9）。
    ///
    /// - Example:
    /// ```swift
    /// let validPhoneNumber = "13812345678"
    /// let isValid = validPhoneNumber.dd_isValidPhoneNumber()  // 返回 true
    ///
    /// let invalidPhoneNumber = "12345678901"
    /// let isValid2 = invalidPhoneNumber.dd_isValidPhoneNumber()  // 返回 false
    /// ```
    ///
    /// - Returns: 如果符合手机号码格式，返回 `true`，否则返回 `false`。
    func dd_isValidPhoneNumber() -> Bool {
        let pattern = "^1[3456789]\\d{9}$"
        return dd_matchPattern(pattern)
    }

    /// 是否是字母数字（指定范围）
    ///
    /// 检查当前字符串是否符合字母数字的格式，且长度在 `minLen` 和 `maxLen` 之间。
    ///
    /// - Example:
    /// ```swift
    /// let validString = "abc123"
    /// let isValid = validString.dd_isValidAlphanumeric(minLen: 6, maxLen: 10)  // 返回 true
    ///
    /// let invalidString = "abc"
    /// let isValid2 = invalidString.dd_isValidAlphanumeric(minLen: 6, maxLen: 10)  // 返回 false
    /// ```
    ///
    /// - Parameters:
    ///   - minLen: 最小长度
    ///   - maxLen: 最大长度
    /// - Returns: 如果符合字母数字并且长度在范围内，返回 `true`，否则返回 `false`。
    func dd_isValidAlphanumeric(minLen: Int, maxLen: Int) -> Bool {
        let pattern = "^[0-9a-zA-Z_]{\(minLen),\(maxLen)}$"
        return dd_matchPattern(pattern)
    }

    /// 是否是字母与数字
    ///
    /// 检查当前字符串是否只包含字母和数字。
    ///
    /// - Example:
    /// ```swift
    /// let validString = "abc123"
    /// let isValid = validString.dd_isValidAlphanumeric()  // 返回 true
    ///
    /// let invalidString = "abc@123"
    /// let isValid2 = invalidString.dd_isValidAlphanumeric()  // 返回 false
    /// ```
    ///
    /// - Returns: 如果只包含字母和数字，返回 `true`，否则返回 `false`。
    func dd_isValidAlphanumeric() -> Bool {
        let pattern = "^[A-Za-z0-9]+$"
        return dd_matchPattern(pattern)
    }

    /// 是否是纯汉字
    ///
    /// 检查当前字符串是否只包含汉字字符。
    ///
    /// - Example:
    /// ```swift
    /// let validString = "汉字"
    /// let isValid = validString.dd_isValidChinese()  // 返回 true
    ///
    /// let invalidString = "汉字123"
    /// let isValid2 = invalidString.dd_isValidChinese()  // 返回 false
    /// ```
    ///
    /// - Returns: 如果字符串只包含汉字，返回 `true`，否则返回 `false`。
    func dd_isValidChinese() -> Bool {
        let pattern = "(^[\u{4e00}-\u{9fef}]+$)"
        return dd_matchPattern(pattern)
    }

    /// 检查字符串是否为有效的电子邮件格式
    ///
    /// 使用正则表达式判断字符串是否符合电子邮件的格式。
    ///
    /// - Example:
    /// ```swift
    /// let validEmail = "john.doe@example.com"
    /// let isValid = validEmail.dd_isValidEmail1()  // 返回 true
    ///
    /// let invalidEmail = "john.doe@com"
    /// let isValid2 = invalidEmail.dd_isValidEmail1()  // 返回 false
    /// ```
    ///
    /// - Returns: 如果字符串符合电子邮件格式，返回 `true`，否则返回 `false`。
    func dd_isValidEmail1() -> Bool {
        let pattern = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?"
        return dd_matchPattern(pattern)
    }

    /// 检查字符串是否为有效的电子邮件格式
    ///
    /// 使用正则表达式检查电子邮件格式是否符合标准。此方法不验证电子邮件服务器是否存在，仅检查格式。
    ///
    /// - Example:
    /// ```swift
    /// let validEmail = "john.doe@example.com"
    /// let isValid = validEmail.dd_isValidEmail2()  // 返回 true
    ///
    /// let invalidEmail = "john.doe@com"
    /// let isValid2 = invalidEmail.dd_isValidEmail2()  // 返回 false
    /// ```
    ///
    /// - Returns: 如果字符串符合电子邮件格式，返回 `true`，否则返回 `false`。
    func dd_isValidEmail2() -> Bool {
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 是否是有效昵称，即允许`中文`、`英文`、`数字`
    ///
    /// 检查当前字符串是否符合有效昵称规则，允许包含中文、英文、数字。
    ///
    /// - Example:
    /// ```swift
    /// let validNickName = "张三abc123"
    /// let isValid = validNickName.dd_isValidNickName()  // 返回 true
    ///
    /// let invalidNickName = "张三abc123!"
    /// let isValid2 = invalidNickName.dd_isValidNickName()  // 返回 false
    /// ```
    ///
    /// - Returns: 如果字符串符合有效昵称规则，返回 `true`，否则返回 `false`。
    func dd_isValidNickName() -> Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        return dd_matchPattern(rgex)
    }

    /// 字符串是否为合法用户名
    ///
    /// 检查当前字符串是否符合合法用户名规则。用户名可以是英文或中文，且长度最多为20个字符。
    ///
    /// - Example:
    /// ```swift
    /// let validUserName = "张三"
    /// let isValid = validUserName.dd_isValidUserName()  // 返回 true
    ///
    /// let invalidUserName = "张三12345678901234567890"
    /// let isValid2 = invalidUserName.dd_isValidUserName()  // 返回 false
    /// ```
    ///
    /// - Returns: 如果字符串符合用户名规则，返回 `true`，否则返回 `false`。
    func dd_isValidUserName() -> Bool {
        let rgex = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        return dd_matchPattern(rgex)
    }

    /// 设置密码必须符合由`数字`、`大写字母`、`小写字母`、`特殊符号`组成的规则
    ///
    /// 检查密码是否符合指定规则，包含数字、字母（大写和小写）和特殊字符。可以设置是否为复杂密码，要求至少包含两种或三种不同类型的字符。
    ///
    /// - Example:
    /// ```swift
    /// let validPassword = "Abc123!"
    /// let isValid = validPassword.dd_isValidPassword()  // 返回 true
    ///
    /// let invalidPassword = "123456"
    /// let isValid2 = invalidPassword.dd_isValidPassword()  // 返回 false
    /// ```
    ///
    /// - Parameter complex: 是否要求复杂密码，默认为 `false`，如果设置为 `true`，则要求密码包含多种类型的字符。
    /// - Returns: 如果密码符合规则，返回 `true`，否则返回 `false`。
    func dd_isValidPassword(complex: Bool = false) -> Bool {
        let pattern = if complex {
            "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{}|;:'\",.<>/?]).{8,}$"
        } else {
            "^(?=.*[a-zA-Z])(?=.*\\d).{6,}$"
        }
        return dd_matchPattern(pattern)
    }

    /// 判断字符串是否仅由数字组成（0-9）
    ///
    /// 该方法使用正则表达式检查字符串是否仅由数字组成。
    ///
    /// - Returns: 返回 `true` 如果字符串只包含数字，返回 `false` 如果包含其他字符。
    ///
    /// - Example:
    /// ```swift
    /// let value = "123456"
    /// let isValid = value.dd_isNumberValue()  // 返回 true
    /// ```
    func dd_isNumberValue() -> Bool {
        let pattern = "^[\\d]+$" // 仅允许数字
        return dd_regexp(pattern)
    }

    /// 判断字符串是否为有效的数字或小数（包括小数点）
    ///
    /// 该方法使用正则表达式检查字符串是否符合数字或小数的格式。可以包含数字和一个小数点。
    ///
    /// - Returns: 返回 `true` 如果字符串是有效的数字或小数，返回 `false` 如果格式不正确。
    ///
    /// - Example:
    /// ```swift
    /// let value = "123.456"
    /// let isValid = value.dd_isValidNumberAndDecimalPoint()  // 返回 true
    /// ```
    func dd_isValidNumberAndDecimalPoint() -> Bool {
        let pattern = "^[\\d.]+$" // 允许数字和小数点
        return dd_regexp(pattern)
    }

    /// 判断字符串是否符合基本的身份证号格式（15位或18位数字）
    ///
    /// 该方法通过正则表达式检查字符串是否为15位或18位有效的数字组成，适用于字符串的基本格式验证。
    ///
    /// - Returns: 返回 `true` 如果符合基本的身份证号格式，返回 `false` 如果不符合。
    ///
    /// - Example:
    /// ```swift
    /// let idNumber = "11010519491231002X"
    /// let isBasicValid = idNumber.dd_isBasicIDNumber()  // 返回 true
    /// ```
    func dd_isBasicIDNumber() -> Bool {
        let pattern = "^(\\d{15}|\\d{18}|\\d{17}[\\dXx])$"
        return dd_regexp(pattern)
    }

    /// 校验身份证号是否为严格有效的身份证号
    /// - Returns: 如果身份证号格式有效并且出生日期、校验位等符合规则，则返回 true；否则返回 false
    /// - Example:
    ///   ```swift
    ///   let id = "11010119900307381X"
    ///   if id.dd_isStrictValidIDNumber() {
    ///       print("\(id) 是有效的身份证号")
    ///   } else {
    ///       print("\(id) 不是有效的身份证号")
    ///   }
    ///   ```
    func dd_isStrictValidIDNumber() -> Bool {
        // 去除首尾空格
        let str = trimmingCharacters(in: .whitespacesAndNewlines)

        // 先检查基本的身份证号格式（15位或18位）
        guard str.dd_isBasicIDNumber() else {
            return false
        }

        // 省份代码数组，所有合法的省份代码
        let areaArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]

        // 检查省份代码是否合法
        guard areaArray.contains(str.dd_subString(to: 2)) else {
            return false
        }

        let len = str.count

        // 根据身份证号的长度（15位或18位）执行不同的校验
        switch len {
        case 15:
            // 校验15位身份证号
            return dd_validate15IDNumber(str)

        case 18:
            // 校验18位身份证号
            return dd_validate18IDNumber(str)

        default:
            // 其他长度的身份证号不合法
            return false
        }
    }

    /// 校验15位身份证号的合法性
    /// - Parameter str: 输入的15位身份证号
    /// - Returns: 如果15位身份证号合法，则返回 true；否则返回 false
    /// - Example:
    ///   ```swift
    ///   let id = "110101900303073"
    ///   if id.dd_validate15IDNumber(id) {
    ///       print("\(id) 是有效的15位身份证号")
    ///   } else {
    ///       print("\(id) 不是有效的15位身份证号")
    ///   }
    ///   ```
    func dd_validate15IDNumber(_ str: String) -> Bool {
        guard let year = Int(str.dd_subString(from: 6, length: 2)) else {
            return false
        }

        // 检查出生日期是否合法
        let regex = dd_isLeapYear(year: year) ?
            "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" :
            "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"

        return dd_regexp(regex)
    }

    /// 校验18位身份证号的合法性
    /// - Parameter str: 输入的18位身份证号
    /// - Returns: 如果18位身份证号合法，则返回 true；否则返回 false
    /// - Example:
    ///   ```swift
    ///   let id = "11010119900307381X"
    ///   if id.dd_validate18IDNumber(id) {
    ///       print("\(id) 是有效的18位身份证号")
    ///   } else {
    ///       print("\(id) 不是有效的18位身份证号")
    ///   }
    ///   ```
    func dd_validate18IDNumber(_ str: String) -> Bool {
        guard let year = Int(str.dd_subString(from: 6, length: 4)) else {
            return false
        }

        // 检查出生日期是否合法
        let regex = dd_isLeapYear(year: year) ?
            "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" :
            "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"

        if !dd_regexp(regex) {
            return false
        }

        // 校验最后一位校验码
        return dd_validateCheckCode(str)
    }

    /// 校验身份证号的校验码
    /// - Parameter str: 输入的18位身份证号
    /// - Returns: 如果校验码正确，则返回 true；否则返回 false
    /// - Example:
    ///   ```swift
    ///   let id = "11010119900307381X"
    ///   if id.dd_validateCheckCode(id) {
    ///       print("\(id) 校验码正确")
    ///   } else {
    ///       print("\(id) 校验码错误")
    ///   }
    ///   ```
    func dd_validateCheckCode(_ str: String) -> Bool {
        // 身份证号码校验码的加权系数
        let check = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3]
        var sum = 0

        // 计算前17位的加权和
        for i in 0 ..< 17 {
            guard let digit = Int(str.dd_subString(from: i, length: 1)) else {
                return false
            }
            sum += digit * check[i % 10]
        }

        // 根据加权和计算校验码
        let checkCode = "10X98765432"
        let calculateCheck = checkCode.dd_subString(from: sum % 11, length: 1)

        // 校验计算出的校验码是否与身份证号的最后一位一致
        return calculateCheck == str.dd_subString(from: 17, length: 1)
    }

    /// 判断是否是闰年
    /// - Parameter year: 需要判断的年份
    /// - Returns: 如果是闰年，返回 true；否则返回 false
    /// - Example:
    ///   ```swift
    ///   let year = 2024
    ///   if year.dd_isLeapYear(year: year) {
    ///       print("\(year) 是闰年")
    ///   } else {
    ///       print("\(year) 不是闰年")
    ///   }
    ///   ```
    private func dd_isLeapYear(year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        } else if year % 100 == 0 {
            return false
        } else if year % 4 == 0 {
            return true
        } else {
            return false
        }
    }

    /// 判断字符串是否是有效的 `URL`
    ///
    /// - Example:
    /// ```swift
    /// "https://google.com".dd_isValidURL() // 返回 true
    /// "invalid-url".dd_isValidURL() // 返回 false
    /// ```
    /// - Returns: 是否是有效的 `URL`
    func dd_isValidURL() -> Bool {
        return URL(string: self) != nil
    }

    /// 判断字符串是否是有效的带协议头的 `URL`
    ///
    /// - Example:
    /// ```swift
    /// "https://google.com".dd_isValidSchemedURL() // 返回 true
    /// "google.com".dd_isValidSchemedURL() // 返回 false
    /// ```
    /// - Returns: 是否有效的带协议头的 `URL`
    func dd_isValidSchemedURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// 判断字符串是否是有效的 `https` 协议的 `URL`
    ///
    /// - Example:
    /// ```swift
    /// "https://google.com".dd_isValidHttpsURL() // 返回 true
    /// "http://google.com".dd_isValidHttpsURL() // 返回 false
    /// ```
    /// - Returns: 是否有效的 `https` 协议的 `URL`
    func dd_isValidHttpsURL() -> Bool {
        return URL(string: self)?.scheme == "https"
    }

    /// 判断字符串是否是有效的 `http` 协议的 `URL`
    ///
    /// - Example:
    /// ```swift
    /// "http://google.com".dd_isValidHttpURL() // 返回 true
    /// "https://google.com".dd_isValidHttpURL() // 返回 false
    /// ```
    /// - Returns: 是否有效的 `http` 协议的 `URL`
    func dd_isValidHttpURL() -> Bool {
        return URL(string: self)?.scheme == "http"
    }

    /// 判断字符串是否是有效的文件 `URL`
    ///
    /// - Example:
    /// ```swift
    /// "file://Documents/file.txt".dd_isValidFileURL() // 返回 true
    /// "https://google.com".dd_isValidFileURL() // 返回 false
    /// ```
    /// - Returns: 是否有效的文件 `URL`
    func dd_isValidFileURL() -> Bool {
        return URL(string: self)?.isFileURL ?? false
    }

    /// 判断字符串是否包含指定子串（区分大小写）
    ///
    /// - Example:
    /// ```swift
    /// "Hello World!".dd_contains("World") // 返回 true
    /// "Hello World!".dd_contains("world") // 返回 false
    /// ```
    /// - Parameter substring: 要查询的子串
    /// - Returns: 是否包含指定子串
    func dd_contains(substring: String) -> Bool {
        return dd_contains(substring, caseSensitive: true)
    }

    /// 判断字符串是否包含指定子串（支持忽略大小写）
    ///
    /// - Example:
    /// ```swift
    /// "Hello World!".dd_contains("world", caseSensitive: false) // 返回 true
    /// ```
    /// - Parameters:
    ///   - substring: 要查询的子串
    ///   - caseSensitive: 是否区分大小写，默认为 `true`
    func dd_contains(_ substring: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return range(of: substring) != nil
        }
        return range(of: substring, options: .caseInsensitive) != nil
    }

    /// 判断字符串是否包含指定子串（忽略大小写）
    ///
    /// - Example:
    /// ```swift
    /// "Hello World!".dd_containsIgnoringCase("world") // 返回 true
    /// ```
    /// - Parameter substring: 要查询的子串
    /// - Returns: 是否包含指定子串，忽略大小写
    func dd_containsIgnoringCase(substring: String) -> Bool {
        return dd_contains(substring, caseSensitive: false)
    }

    /// 判断字符串是否以指定前缀开头（支持大小写控制）
    ///
    /// - Example:
    /// ```swift
    /// "Hello World".dd_starts(with: "hello") // 返回 true
    /// "Hello World".dd_starts(with: "H", caseSensitive: false) // 返回 true
    /// "Hello World".dd_starts(with: "world") // 返回 false
    /// ```
    /// - Parameters:
    ///   - prefix: 要检查的前缀
    ///   - caseSensitive: 是否区分大小写，默认为 `true`
    func dd_starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return hasPrefix(prefix)
        }
        return lowercased().hasPrefix(prefix.lowercased())
    }

    /// 判断字符串是否以指定后缀结尾（支持大小写控制）
    ///
    /// - Example:
    /// ```swift
    /// "Hello World!".dd_ends(with: "!") // 返回 true
    /// "Hello World!".dd_ends(with: "world!", caseSensitive: false) // 返回 true
    /// "Hello World!".dd_ends(with: "?") // 返回 false
    /// ```
    /// - Parameters:
    ///   - suffix: 要检查的后缀
    ///   - caseSensitive: 是否区分大小写，默认为 `true`
    func dd_ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return hasSuffix(suffix)
        }
        return lowercased().hasSuffix(suffix.lowercased())
    }
}

// MARK: - 字符串尺寸计算
public extension String {
    /// 计算普通字符串在指定宽度下的实际尺寸
    ///
    /// - Example:
    /// ```swift
    /// let font = UIFont.systemFont(ofSize: 16)
    /// let size = "Hello, world!".dd_calculateSize(forWidth: 200, font: font)
    /// print(size) // CGSize(width: ..., height: ...)
    /// ```
    ///
    /// - Parameters:
    ///   - lineWidth: 最大宽度，默认为无穷大
    ///   - font: 字体对象
    /// - Returns: 计算得到的字符串尺寸
    func dd_calculateSize(forWidth lineWidth: CGFloat = .greatestFiniteMagnitude, font: UIFont) -> CGSize {
        let constraint = CGSize(width: lineWidth, height: .greatestFiniteMagnitude)
        let size = (self as NSString).boundingRect(
            with: constraint,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        ).size
        // 向上取整
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    /// 计算富文本字符串在指定宽度下的实际尺寸
    ///
    /// - Example:
    /// ```swift
    /// let font = UIFont.systemFont(ofSize: 16)
    /// let size = "Hello, world!".dd_calculateAttributedSize(forWidth: 200, font: font, lineSpacing: 4, wordSpacing: 1)
    /// print(size) // CGSize(width: ..., height: ...)
    /// ```
    ///
    /// - Parameters:
    ///   - lineWidth: 最大宽度，默认为无穷大
    ///   - font: 字体对象
    ///   - lineSpacing: 行间距，默认为 0
    ///   - wordSpacing: 字间距，默认为 0
    /// - Returns: 计算得到的富文本字符串尺寸
    func dd_calculateAttributedSize(
        forWidth lineWidth: CGFloat = .greatestFiniteMagnitude,
        font: UIFont,
        lineSpacing: CGFloat = 0,
        wordSpacing: CGFloat = 0
    ) -> CGSize {
        // 段落样式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = lineSpacing

        // 属性字符串
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: wordSpacing,
            .paragraphStyle: paragraphStyle,
        ]
        let attributedString = NSAttributedString(string: self, attributes: attributes)

        // 尺寸约束
        let constraint = CGSize(width: lineWidth, height: .greatestFiniteMagnitude)
        let size = attributedString.boundingRect(
            with: constraint,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size
        // 向上取整
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
}

// MARK: - Path
public extension String {
    /// 获取路径字符串中的最后一个路径组件
    ///
    /// - Example:
    /// ```swift
    /// let path = "/user/documents/file.txt"
    /// let lastComponent = path.dd_lastPathComponent() // "file.txt"
    /// ```
    /// - Returns: 路径字符串中的最后一个路径组件
    func dd_lastPathComponent() -> String {
        return (self as NSString).lastPathComponent
    }

    /// 获取路径字符串的扩展名
    ///
    /// - Example:
    /// ```swift
    /// let path = "/user/documents/file.txt"
    /// let extension = path.dd_pathExtension() // "txt"
    /// ```
    /// - Returns: 路径的扩展名
    func dd_pathExtension() -> String {
        return (self as NSString).pathExtension
    }

    /// 返回删除最后一个路径组件后的字符串
    ///
    /// - Example:
    /// ```swift
    /// let path = "/user/documents/file.txt"
    /// let newPath = path.dd_deletingLastPathComponent() // "/user/documents"
    /// ```
    /// - Returns: 删除最后一个路径组件后的路径字符串
    func dd_deletingLastPathComponent() -> String {
        return (self as NSString).deletingLastPathComponent
    }

    /// 返回删除路径扩展后的路径字符串
    ///
    /// - Example:
    /// ```swift
    /// let path = "/user/documents/file.txt"
    /// let newPath = path.dd_deletingPathExtension() // "/user/documents/file"
    /// ```
    /// - Returns: 删除路径扩展后的路径字符串
    func dd_deletingPathExtension() -> String {
        return (self as NSString).deletingPathExtension
    }

    /// 获取路径组件数组
    ///
    /// - Example:
    /// ```swift
    /// let path = "/user/documents/file.txt"
    /// let components = path.dd_pathComponents() // ["/", "user", "documents", "file.txt"]
    /// ```
    /// - Returns: 路径组件数组
    func dd_pathComponents() -> [String] {
        return (self as NSString).pathComponents
    }

    /// 在路径字符串的尾部添加路径组件
    ///
    /// - Example:
    /// ```swift
    /// let path = "/user/documents"
    /// let newPath = path.dd_appendingPathComponent("file.txt") // "/user/documents/file.txt"
    /// ```
    /// - Parameter str: 要添加的路径组件，通常以 `/` 开头
    /// - Returns: 添加路径组件后的新路径字符串
    func dd_appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }

    /// 添加路径扩展名
    ///
    /// - Example:
    /// ```swift
    /// let path = "/user/documents/file"
    /// let newPath = path.dd_appendingPathExtension("txt") // "/user/documents/file.txt"
    /// ```
    /// - Parameter str: 要添加的扩展名
    /// - Returns: 添加扩展后的路径字符串，如果无法添加扩展名，返回 nil
    func dd_appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
}

// MARK: - 沙盒路径
public extension String {
    /// 在`Application Support`目录后追加当前路径
    ///
    /// - Note: `Application Support`目录通常用于存储应用程序的支持文件，可能会被 iCloud 备份。
    /// - Example:
    ///   ```swift
    ///   let path = "MyApp/Configs/config.json"
    ///   let fullPath = path.dd_appendToSupportDirectory()
    ///   print(fullPath) // 输出类似：/Users/user/Library/Application Support/MyApp/Configs/config.json
    ///   ```
    /// - Returns: 拼接后的路径字符串
    func dd_appendToSupportDirectory() -> String {
        return PathManager.makeSupportPath(byAppending: self)
    }

    /// 在`Documents`目录后追加当前路径
    ///
    /// - Example:
    ///   ```swift
    ///   let path = "Documents/data.txt"
    ///   let fullPath = path.dd_appendToDocumentsDirectory()
    ///   print(fullPath) // 输出类似：/Users/user/Documents/data.txt
    ///   ```
    /// - Returns: 拼接后的路径字符串
    func dd_appendToDocumentsDirectory() -> String {
        return PathManager.makeDocumentsPath(byAppending: self)
    }

    /// 在`Caches`目录后追加当前路径
    ///
    /// - Example:
    ///   ```swift
    ///   let path = "Cache/temporaryData.dat"
    ///   let fullPath = path.dd_appendToCachesDirectory()
    ///   print(fullPath) // 输出类似：/Users/user/Library/Caches/Cache/temporaryData.dat
    ///   ```
    /// - Returns: 拼接后的路径字符串
    func dd_appendToCachesDirectory() -> String {
        return PathManager.makeCachesPath(byAppending: self)
    }

    /// 在`tmp`目录后追加当前路径
    ///
    /// - Example:
    ///   ```swift
    ///   let path = "temp/tempFile.tmp"
    ///   let fullPath = path.dd_appendToTempDirectory()
    ///   print(fullPath) // 输出类似：/tmp/tempFile.tmp
    ///   ```
    /// - Returns: 拼接后的路径字符串
    func dd_appendToTempDirectory() -> String {
        return PathManager.makeTempPath(byAppending: self)
    }
}

// MARK: - 沙盒URL
public extension String {
    /// 在`Application Support`目录后返回拼接的文件路径`URL`
    ///
    /// - Note: `Application Support`目录用于存储应用程序的支持文件，可能会被 iCloud 备份。
    /// - Example:
    ///   ```swift
    ///   let path = "MyApp/Configs/config.json"
    ///   let fileURL = path.dd_urlInSupportDirectory()
    ///   print(fileURL) // 输出类似：file:///Users/user/Library/Application%20Support/MyApp/Configs/config.json
    ///   ```
    /// - Returns: 拼接后的路径`URL`
    func dd_urlInSupportDirectory() -> URL {
        _ = dd_appendToSupportDirectory() // 确保路径目录存在
        let fileUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }

    /// 在`Documents`目录后返回拼接的文件路径`URL`
    ///
    /// - Example:
    ///   ```swift
    ///   let path = "Documents/data.txt"
    ///   let fileURL = path.dd_urlInDocumentsDirectory()
    ///   print(fileURL) // 输出类似：file:///Users/user/Documents/data.txt
    ///   ```
    /// - Returns: 拼接后的路径`URL`
    func dd_urlInDocumentsDirectory() -> URL {
        _ = dd_appendToDocumentsDirectory() // 确保路径目录存在
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }

    /// 在`Caches`目录后返回拼接的文件路径`URL`
    ///
    /// - Example:
    ///   ```swift
    ///   let path = "Cache/temporaryData.dat"
    ///   let fileURL = path.dd_urlInCachesDirectory()
    ///   print(fileURL) // 输出类似：file:///Users/user/Library/Caches/Cache/temporaryData.dat
    ///   ```
    /// - Returns: 拼接后的路径`URL`
    func dd_urlInCachesDirectory() -> URL {
        _ = dd_appendToCachesDirectory() // 确保路径目录存在
        let fileUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }
}

// MARK: - 文件操作
public extension String {
    /// 删除文件
    ///
    /// - Example:
    ///   ```swift
    ///   let filePath = "/Users/user/Documents/tempFile.txt"
    ///   filePath.dd_removeFile() // 删除文件
    ///   ```
    func dd_removeFile() {
        if FileManager.default.fileExists(atPath: self) {
            do {
                try FileManager.default.removeItem(atPath: self)
            } catch {
                Logger.fail("文件删除失败: \(error.localizedDescription)")
            }
        }
    }

    /// 创建目录/文件
    ///
    /// - Note: 如果路径是目录，请确保路径以 `/` 结尾。默认为当前用户目录。
    /// - Example:
    ///   ```swift
    ///   let directoryPath = "MyApp/Configs"
    ///   directoryPath.dd_createDirs() // 创建目录
    ///   ```
    /// - Parameter directory: 要创建的目录的父路径，默认为应用根目录。
    func dd_createDirs(in directory: String = NSHomeDirectory()) {
        let path = contains(NSHomeDirectory()) ? self : "\(directory)/\(self)"
        let dirs = path.components(separatedBy: "/")
        let dir = dirs[0 ..< dirs.count - 1].joined(separator: "/")

        if !FileManager.default.fileExists(atPath: dir) {
            do {
                try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                Logger.fail("创建目录失败: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - 日期相关扩展
public extension String {
    /// 将日期字符串格式化为 `Date` 对象
    ///
    /// - Example:
    /// ```swift
    /// let dateString = "2024-11-18 12:00:00"
    /// let date = dateString.dd_toDate(with: "yyyy-MM-dd HH:mm:ss")
    /// print(date) // 输出: Optional(2024-11-18 12:00:00 +0000)
    /// ```
    ///
    /// - Parameter format: 日期格式，默认为 `"yyyy-MM-dd HH:mm:ss"`
    /// - Returns: 转换后的 `Date` 对象，如果格式化失败则返回 `nil`
    func dd_toDate(with format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

// MARK: - 地理位置扩展
public extension String {
    /// 地理编码（地址转坐标）
    ///
    /// - Example:
    /// ```swift
    /// let address = "1600 Amphitheatre Parkway, Mountain View, CA"
    /// address.dd_locationEncode { placemarks, error in
    ///     if let error = error {
    ///         print("地理编码失败: \(error.localizedDescription)")
    ///     } else if let placemark = placemarks?.first {
    ///         print("坐标: \(placemark.location?.coordinate ?? CLLocationCoordinate2D())")
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter completionHandler: 地理编码的回调函数，返回 `CLPlacemark` 数组或错误
    func dd_locationEncode(completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().geocodeAddressString(self, completionHandler: completionHandler)
    }
}

// MARK: - 剪切板操作扩展
public extension String {
    /// 将字符串复制到全局粘贴板
    ///
    /// - Example:
    /// ```swift
    /// "SomeText".dd_copyToPasteboard() // Copies "SomeText" to the system clipboard
    /// ```
    func dd_copyToPasteboard() {
        #if os(iOS)
            // 在 iOS 上使用 UIPasteboard 复制到系统剪贴板
            UIPasteboard.general.string = self
        #elseif os(macOS)
            // 在 macOS 上使用 NSPasteboard 复制到系统剪贴板
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(self, forType: .string)
        #endif
    }
}

// MARK: - 正则相关运算符

/// 自定义正则匹配操作符 `=~`
/// 优先级定义：`RegPrecedence`
/// - 高于加法运算符，低于乘法运算符
infix operator =~: RegPrecedence
precedencegroup RegPrecedence {
    associativity: none
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

public extension String {
    /// 正则匹配操作符
    ///
    /// - Example:
    ///     `"123abc" =~ "\\d+"` -> `true`
    ///     `"abc" =~ "\\d+"` -> `false`
    ///
    /// - Parameters:
    ///   - lhs: 要匹配的字符串
    ///   - rhs: 正则表达式模式
    /// - Returns: 是否匹配正则表达式
    static func =~ (lhs: String, rhs: String) -> Bool {
        lhs.dd_regexp(rhs)
    }
}

// MARK: - 正则
public extension String {
    /// 将元字符转化为字面值以保护正则表达式
    ///
    /// - Example:
    ///     `"hello ^$ there".dd_regexEscaped()` -> `"hello \\^\\$ there"`
    ///
    /// - Returns: 转义后的字符串
    func dd_regexEscaped() -> String {
        return NSRegularExpression.escapedPattern(for: self)
    }

    /// 验证字符串是否与正则表达式模式匹配
    ///
    /// - Example:
    ///     `"123abc".dd_matches(pattern: "\\d+")` -> `true`
    ///
    /// - Parameter pattern: 正则表达式模式
    /// - Returns: 是否匹配
    func dd_matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression) != nil
    }

    /// 验证字符串是否与正则表达式实例匹配
    ///
    /// - Example:
    ///     `let regex = try? NSRegularExpression(pattern: "\\d+")`
    ///     `"123abc".dd_matches(regex: regex!)` -> `true`
    ///
    /// - Parameters:
    ///   - regex: 正则表达式对象
    ///   - options: 匹配选项
    /// - Returns: 是否匹配
    func dd_matches(regex: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        let range = NSRange(startIndex ..< endIndex, in: self)
        return regex.firstMatch(in: self, options: options, range: range) != nil
    }

    /// 使用 NSPredicate 验证正则表达式
    ///
    /// - Example:
    ///     `"123abc".dd_regexp("^\\d+$")` -> `false`
    ///
    /// - Parameter pattern: 正则表达式模式
    /// - Returns: 是否匹配
    func dd_regexp(_ pattern: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }

    /// 统一匹配正则表达式的通用方法
    ///
    /// 该方法用于执行正则表达式匹配操作，检查当前字符串是否符合指定的正则表达式模式。
    /// 它通过 `NSRegularExpression` 类进行匹配，适用于各种类型的正则表达式验证需求。
    ///
    /// - Parameter pattern: 正则表达式模式，作为字符串传入。该模式用于定义要匹配的规则。
    /// - Returns: 如果字符串符合正则表达式，返回 `true`，否则返回 `false`。
    ///
    /// - Example:
    /// ```swift
    /// let validEmail = "example@example.com"
    /// let isValid = validEmail.dd_matchPattern("^[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?")  // 返回 true
    ///
    /// let invalidEmail = "example@com"
    /// let isValid2 = invalidEmail.dd_matchPattern("^[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?")  // 返回 false
    /// ```
    ///
    /// - Note: 该方法内部使用 `NSRegularExpression` 类，因此需要确保传入的正则表达式是有效的。
    ///   正则表达式的构建和匹配是一个相对低级的操作，确保正则表达式没有语法错误是调用者的责任。
    private func dd_matchPattern(_ pattern: String) -> Bool {
        // 使用给定的正则表达式模式创建 NSRegularExpression 实例
        let regex = try! NSRegularExpression(pattern: pattern)
        // 创建一个范围，表示整个字符串
        let range = NSRange(location: 0, length: self.count)
        // 检查正则表达式是否与字符串匹配
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }

    /// 检查字符串中是否存在匹配正则表达式的内容
    ///
    /// - Example:
    ///     `"123abc".dd_isMatchRegexp("\\d+")` -> `true`
    ///
    /// - Parameter pattern: 正则表达式模式
    /// - Returns: 是否存在匹配
    func dd_isMatchRegexp(_ pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))
        return !matches.isEmpty
    }

    /// 获取符合正则表达式的捕获组内容
    ///
    /// - Example:
    ///     `"abc123xyz".dd_regexpText("(\\d+)", count: 1)` -> `["123"]`
    ///
    /// - Parameters:
    ///   - pattern: 正则表达式模式
    ///   - count: 捕获组数量
    /// - Returns: 捕获的内容数组，或 `nil` 如果无匹配
    func dd_regexpText(_ pattern: String, count: Int = 1) -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: self, range: NSRange(location: 0, length: utf16.count))
        else {
            return nil
        }
        return (1 ... count).compactMap {
            Range(match.range(at: $0), in: self).flatMap { String(self[$0]) }
        }
    }

    /// 获取匹配正则表达式的所有 `NSRange`
    ///
    /// - Example:
    ///     `"abc123xyz".dd_matchRange("\\d+")` -> `[NSRange(location: 3, length: 3)]`
    ///
    /// - Parameter pattern: 正则表达式模式
    /// - Returns: 匹配的 `[NSRange]` 数组
    func dd_matchRange(_ pattern: String) -> [NSRange] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return []
        }
        return regex.matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count)).map(\.range)
    }
}

// MARK: - 数字字符串
public extension String {
    /// 金额字符串，千分位表示
    ///
    /// - Parameters:
    ///   - roundOff: 是否四舍五入，默认为 `true`
    ///   - default: 默认返回值，如果格式化失败
    /// - Returns: 格式化后的字符串
    /// - Example:
    ///     ```swift
    ///     "1234567".dd_amountAsThousands() => "1,234,567"
    ///     "1234567.56".dd_amountAsThousands() => "1,234,567.56"
    ///     ```
    func dd_amountAsThousands(roundOff: Bool = true, or default: String = "") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0

        // 如果包含小数点，则设置最大最小小数位数
        if contains(".") {
            formatter.maximumFractionDigits = roundOff ? 0 : 2
            formatter.minimumFractionDigits = roundOff ? 0 : 2
        }

        // 使用 NSDecimalNumber 以保证处理小数时的准确性
        var num = NSDecimalNumber(string: self)
        if num.doubleValue.isNaN { num = NSDecimalNumber.zero }

        // 返回格式化结果
        return formatter.string(from: num) ?? `default`
    }

    /// 删除小数点后面多余的0
    /// - Returns: 删除多余0后的字符串
    /// - Example:
    ///     ```swift
    ///     "10.1200".dd_deleteMoreThanZeroFromAfterDecimalPoint()  // 返回 "10.12"
    ///     ```
    func dd_deleteMoreThanZeroFromAfterDecimalPoint() -> String {
        if self.firstIndex(of: ".") != nil {
            var trimmedString = self
            // 移除小数点后面的0
            while trimmedString.hasSuffix("0") {
                trimmedString.removeLast()
            }
            // 如果删除后最后一个字符是小数点，移除小数点
            if trimmedString.hasSuffix(".") {
                trimmedString.removeLast()
            }
            return trimmedString
        }
        return self
    }

    /// 保留小数点后面指定位数
    /// - Parameters:
    ///   - decimalPlaces: 保留的位数
    ///   - mode: 数值的舍入模式
    /// - Returns: 格式化后的字符串
    /// - Example:
    ///     ```swift
    ///     "12.34567".dd_keepDecimalPlaces(decimalPlaces: 2)  // 返回 "12.35"
    ///     ```
    func dd_keepDecimalPlaces(decimalPlaces: Int = 0, mode: NumberFormatter.RoundingMode = .floor) -> String {
        let formatter = NumberFormatter()
        formatter.roundingMode = mode
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = decimalPlaces
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 100

        // 将字符串转换为 NSDecimalNumber
        var decimalNumber = NSDecimalNumber(string: self)

        // 如果是非数字字符串，则设置为0
        if decimalNumber.doubleValue.isNaN {
            decimalNumber = .zero
        }

        // 格式化并返回结果
        return formatter.string(from: decimalNumber) ?? "0." + String(repeating: "0", count: decimalPlaces)
    }
}

// MARK: - 属性字符串相关
public extension String {
    /// 将 `HTML` 源码转换为属性字符串
    ///
    /// - Example:
    /// ```swift
    /// let font = UIFont.systemFont(ofSize: 16)
    /// let attributedString = "Some <b>HTML</b> content".dd_htmlToAttributedString(font: font, lineSpacing: 5)
    /// ```
    /// - Parameters:
    ///   - font: 字体，默认为系统字体大小12
    ///   - lineSpacing: 行间距，默认为10
    /// - Returns: 转换后的属性字符串
    func dd_htmlToAttributedString(font: UIFont? = UIFont.systemFont(ofSize: 12),
                                   lineSpacing: CGFloat? = 10) -> NSMutableAttributedString
    {
        var htmlString: NSMutableAttributedString?

        // 使用 UTF-8 编码将字符串中的换行符替换为 <br/> 进行处理
        do {
            if let data = replacingOccurrences(of: "\n", with: "<br/>").data(using: .utf8) {
                htmlString = try NSMutableAttributedString(data: data, options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue),
                ], documentAttributes: nil)

                // 删除尾部的换行符
                if let weakHtmlString = htmlString, weakHtmlString.string.hasSuffix("\n") {
                    let wrapHtmlString = NSMutableAttributedString(string: "\n")
                    htmlString?.deleteCharacters(in: NSRange(location: weakHtmlString.length - wrapHtmlString.length, length: wrapHtmlString.length))
                }
            }
        } catch {
            // 如果转换失败，返回空字符串
            Logger.fail("Error while parsing HTML to attributed string: \(error)")
        }

        // 设置属性字符串字体的大小
        if let font {
            htmlString?.addAttributes([.font: font], range: dd_fullNSRange())
        }

        // 设置行间距
        if let lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle.default()
                .dd_lineSpacing(lineSpacing)
            htmlString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: dd_fullNSRange())
        }

        return htmlString ?? dd_toNSMutableAttributedString()
    }

    /// 高亮显示关键字，并返回带有属性的字符串
    ///
    /// - Example:
    /// ```swift
    /// let highlightedString = "This is a test".dd_highlightKeyword(keyword: "test", highlightColor: .red, normalColor: .black)
    /// ```
    /// - Parameters:
    ///   - keyword: 要高亮的关键词
    ///   - highlightColor: 高亮文字的颜色
    ///   - normalColor: 非高亮文字的颜色
    ///   - options: 匹配选项（可选），默认为空
    /// - Returns: 高亮后的属性字符串
    func dd_highlightKeyword(keyword: String,
                             highlightColor: UIColor,
                             normalColor: UIColor,
                             options: NSRegularExpression.Options = []) -> NSMutableAttributedString
    {
        // 创建一个基础的属性字符串，设置非高亮文字颜色
        let fullString = self
        let attributedString = fullString
            .dd_toNSMutableAttributedString()
            .dd_addAttributes([
                NSAttributedString.Key.foregroundColor: normalColor,
            ])

        // 获取关键词匹配的范围
        let ranges = fullString.dd_matchRange(keyword)

        // 为匹配的范围设置高亮颜色
        for range in ranges {
            attributedString.addAttributes([
                NSAttributedString.Key.foregroundColor: highlightColor,
            ], range: range)
        }

        return attributedString
    }
}

// MARK: - URL 操作扩展
public extension String {
    /// 提取字符串中所有的 `URL` 链接
    /// - Returns: 包含所有 `URL` 链接的数组，如果没有匹配结果则返回 `nil`
    ///
    /// - Example:
    /// ```swift
    /// let text = "Check this out: https://example.com and also visit http://apple.com."
    /// let urls = text.dd_urls()
    /// print(urls) // 输出: ["https://example.com", "http://apple.com"]
    /// ```
    func dd_urls() -> [String]? {
        var urls = [String]()
        // 创建 `NSDataDetector` 实例，类型为链接检测
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }

        // 匹配字符串中的链接，返回结果数组
        let results = dataDetector.matches(in: self,
                                           options: [],
                                           range: NSRange(location: 0, length: utf16.count))

        // 提取所有匹配的链接
        for checkingResult in results {
            if let url = checkingResult.url {
                urls.append(url.absoluteString)
            }
        }

        return urls.isEmpty ? nil : urls
    }

    /// 解析 `URL` 中的查询参数
    /// - Returns: 包含 `URL` 参数的字典，如果没有查询参数则返回空字典
    ///
    /// - Example:
    /// ```swift
    /// let url = "https://example.com?name=John&age=30&hobby=reading&hobby=coding"
    /// let parameters = url.dd_urlParameters()
    /// print(parameters) // 输出: ["name": "John", "age": "30", "hobby": ["reading", "coding"]]
    /// ```
    func dd_urlParameters() -> [String: Any] {
        // 将字符串解析为 `NSURLComponents`
        guard let urlComponents = URLComponents(string: self),
              let queryItems = urlComponents.queryItems else { return [:] }

        var parameters = [String: Any]()
        for item in queryItems {
            guard let value = item.value else { continue }
            // 如果键已经存在，则将其值转换为数组
            if let existingValue = parameters[item.name] {
                if var existingArray = existingValue as? [String] {
                    existingArray.append(value)
                    parameters[item.name] = existingArray
                } else {
                    parameters[item.name] = [existingValue as! String, value]
                }
            } else {
                parameters[item.name] = value
            }
        }
        return parameters
    }
}

// MARK: - HTML字符引用操作扩展
public extension String {
    /// 将字符串转为 `HTML字符引用`
    ///
    /// - Example:
    /// ```swift
    /// let input = "Hello <world> & \"everyone\""
    /// let htmlEncoded = input.dd_stringAsHtmlCharacterEntityReferences()
    /// print(htmlEncoded) // 输出: "&#x0048;&#x0065;&#x006c;&#x006c;&#x006f;&#x0020;&#x003c;&#x0077;&#x006f;&#x0072;&#x006c;&#x0064;&#x003e;&#x0020;&#x0026;&#x0020;&#x0022;&#x0065;&#x0076;&#x0065;&#x0072;&#x0079;&#x006f;&#x006e;&#x0065;&#x0022;"
    /// ```
    ///
    /// - Returns: 转换为 `HTML字符引用` 的字符串
    func dd_stringAsHtmlCharacterEntityReferences() -> String {
        var result = ""
        for scalar in utf16 {
            // 将每个字符转换为 HTML 的 Unicode 字符引用格式
            let hexValue = String(format: "%04x", scalar) // 以 4 位十六进制表示
            result += "&#x\(hexValue);"
        }
        return result
    }

    /// 将 `HTML字符引用` 转回普通字符串
    ///
    /// - Example:
    /// ```swift
    /// let htmlEncoded = "&#x0048;&#x0065;&#x006c;&#x006c;&#x006f;&#x0020;&#x003c;&#x0077;&#x006f;&#x0072;&#x006c;&#x0064;&#x003e;"
    /// let decodedString = htmlEncoded.dd_htmlCharacterEntityReferencesAsString()
    /// print(decodedString) // 输出: "Hello <world>"
    /// ```
    ///
    /// - Returns: 转换为普通字符串的结果，如果转换失败则返回 `nil`
    func dd_htmlCharacterEntityReferencesAsString() -> String? {
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
        ]
        // 将字符串编码为 `Data`
        guard let encodedData = self.data(using: .utf8) else { return nil }
        // 使用 `NSAttributedString` 解析 HTML 数据
        guard let attributedString = try? NSAttributedString(data: encodedData,
                                                             options: attributedOptions,
                                                             documentAttributes: nil)
        else { return nil }
        return attributedString.string
    }
}

// MARK: - NSDecimalNumber四则运算
public extension String {
    /// 加法运算
    /// - Parameter strNumber: 加数字符串
    /// - Returns: 结果数字串
    /// - Example:
    ///     ```swift
    ///     let result = "10".dd_add("5")  // returns "15"
    ///     ```
    func dd_add(_ strNumber: String?) -> String {
        return dd_performOperation(strNumber) { $0.adding($1) }
    }

    /// 减法运算
    /// - Parameter strNumber: 减数字符串
    /// - Returns: 结果数字串
    /// - Example:
    ///     ```swift
    ///     let result = "10".dd_subtract("5")  // returns "5"
    ///     ```
    func dd_subtract(_ strNumber: String?) -> String {
        return dd_performOperation(strNumber) { $0.subtracting($1) }
    }

    /// 乘法运算
    /// - Parameter strNumber: 乘数字符串
    /// - Returns: 结果数字串
    /// - Example:
    ///     ```swift
    ///     let result = "10".dd_multiply("5")  // returns "50"
    ///     ```
    func dd_multiply(_ strNumber: String?) -> String {
        return dd_performOperation(strNumber) { $0.multiplying(by: $1) }
    }

    /// 除法运算
    /// - Parameter strNumber: 除数字符串
    /// - Returns: 结果数字串
    /// - Example:
    ///     ```swift
    ///     let result = "10".dd_divide("5")  // returns "2"
    ///     let result = "10".dd_divide("0")  // returns "10" (防止除零)
    ///     ```
    func dd_divide(_ strNumber: String?) -> String {
        return dd_performOperation(strNumber) { $0.dividing(by: $1) }
    }

    /// 执行加、减、乘、除等四则运算
    /// - Parameters:
    ///   - strNumber: 需要与当前字符串进行运算的数字字符串
    ///   - operation: 闭包操作，决定使用的数学运算
    /// - Returns: 结果数字串
    /// - Example:
    ///     ```swift
    ///     let result = dd_performOperation("5", operation: { $0.adding($1) })  // 返回计算后的结果
    ///     ```
    private func dd_performOperation(_ strNumber: String?, operation: (NSDecimalNumber, NSDecimalNumber) -> NSDecimalNumber) -> String {
        // 将当前字符串和传入的字符串转换为安全的NSDecimalNumber
        let ln = dd_safeDecimalNumber(self)
        let rn = dd_safeDecimalNumber(strNumber)

        // 执行指定的运算
        let result = operation(ln, rn)

        // 返回运算结果的字符串值
        return result.stringValue
    }

    /// 安全地将字符串转换为 `NSDecimalNumber`，如果转换失败或是无效数字则返回零
    /// - Parameter str: 需要转换的字符串
    /// - Returns: 转换后的 `NSDecimalNumber`
    /// - Example:
    ///     ```swift
    ///     let safeNumber = dd_safeDecimalNumber("5")  // returns 5.0 as NSDecimalNumber
    ///     ```
    private func dd_safeDecimalNumber(_ str: String?) -> NSDecimalNumber {
        // 如果字符串为空，返回零
        guard let str, !str.isEmpty else { return .zero }

        // 将字符串转换为 NSDecimalNumber
        let decimal = NSDecimalNumber(string: str)

        // 检查是否为 NaN，如果是则返回零
        return decimal.doubleValue.isNaN ? .zero : decimal
    }
}

// MARK: - 运算符
public extension String {
    /// 重载 `Swift` 的`包含运算符`以匹配正则表达式模式
    /// - Parameters:
    ///   - lhs: 用于匹配的字符串
    ///   - rhs: 用于匹配的正则字符串
    /// - Returns: 匹配结果
    /// - Example:
    ///     `"hello world" ~= "hello"` // returns true
    ///     `"hello world" ~= "^world"` // returns false
    static func ~= (lhs: String, rhs: String) -> Bool {
        return lhs.range(of: rhs, options: .regularExpression) != nil
    }

    /// 重载 `Swift` 的`包含运算符`以匹配正则表达式
    /// - Parameters:
    ///   - lhs: 用于匹配的字符串
    ///   - rhs: 用于匹配的正则表达式
    /// - Returns: 匹配结果
    /// - Example:
    ///     `"hello world" ~= try! NSRegularExpression("hello")` // returns true
    ///     `"hello world" ~= try! NSRegularExpression("world$")` // returns true
    static func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
        let range = NSRange(lhs.startIndex ..< lhs.endIndex, in: lhs)
        return rhs.firstMatch(in: lhs, range: range) != nil
    }

    /// 生成重复字符串
    ///
    /// - Parameters:
    ///   - lhs: 要重复的字符串
    ///   - rhs: 重复字符串个数
    /// - Returns: 结果重复字符串
    /// - Example:
    ///     `"bar" * 3` -> `"barbarbar"`
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    /// 生成重复字符串
    ///
    /// - Parameters:
    ///   - lhs: 重复字符串个数
    ///   - rhs: 要重复的字符串
    /// - Returns: 结果重复字符串
    /// - Example:
    ///     `3 * "bar"` -> `"barbarbar"`
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
}

// MARK: - JSON 转换与格式化
public extension String {
    /// 将 JSON 字符串转换为数组形式的字典 (`[[String: Any]]`)
    /// - Returns: 转换后的字典数组，如果转换失败则返回 `nil`
    /// - Example:
    ///     ```swift
    ///     let jsonString = "[{\"key\": \"value\"}]"
    ///     let jsonArray = jsonString.dd_toJSONDictionarys() // returns [["key": "value"]]
    ///     ```
    func dd_toJSONDictionarys() -> [[String: Any]]? {
        guard let data = self.dd_toData() else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    }

    /// 将 JSON 字符串转换为字典形式 (`[String: Any]`)
    /// - Returns: 转换后的字典，如果转换失败则返回 `nil`
    /// - Example:
    ///     ```swift
    ///     let jsonString = "{\"key\": \"value\"}"
    ///     let jsonObject = jsonString.dd_toJSONDictionary() // returns ["key": "value"]
    ///     ```
    func dd_toJSONDictionary() -> [String: Any]? {
        guard let data = self.dd_toData() else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }

    /// 格式化 JSON 字符串并返回格式化后的字符串
    /// - Returns: 格式化后的 JSON 字符串，如果格式化失败则返回原始字符串
    /// - Example:
    ///     ```swift
    ///     let jsonString = "{\"key\": \"value\"}"
    ///     let formattedString = jsonString.dd_JSONFormat() // returns a pretty-printed JSON string
    ///     ```
    func dd_JSONFormat() -> String {
        guard let data = self.dd_toData() else { return self }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)?
                .replacingOccurrences(of: "\\/", with: "/", options: .caseInsensitive) ?? self
        } catch {
            return self
        }
    }
}
