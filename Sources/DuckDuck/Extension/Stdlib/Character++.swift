//
//  Character++.swift
//  DuckDuck
//
//  Created by xxwang on 15/11/2024.
//

import Foundation

// MARK: - Character 类型转换
public extension Character {
    /// 将字符转换为 `String` 类型。
    /// - Returns: 转换后的字符串。
    ///
    /// - Example:
    /// ```swift
    /// let char: Character = "A"
    /// print(char.dd_toString()) // 输出: "A"
    /// ```
    func dd_toString() -> String {
        return String(self)
    }
}

// MARK: - Character 的便捷扩展
public extension Character {
    /// 随机生成一个字符（包含字母、数字和特殊符号）。
    /// - Returns: 随机生成的字符。
    /// - Parameter includeSpecialChars: 是否包含特殊字符，默认为 `false`。
    ///
    /// - Example:
    /// ```swift
    /// let randomChar = Character.dd_random(includeSpecialChars: true)
    /// print(randomChar) // 输出: 随机字符，如 "$"
    /// ```
    static func dd_random(includeSpecialChars: Bool = false) -> Character {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" +
            (includeSpecialChars ? "!@#$%^&*()-_=+[]{}|;:'\",.<>?/" : "")
        return characters.randomElement()!
    }

    /// 将字符转换为大写字母。
    /// - Returns: 转换后的大写字母。
    ///
    /// - Example:
    /// ```swift
    /// let char: Character = "a"
    /// print(char.dd_toUpperCase()) // 输出: "A"
    /// ```
    func dd_toUpperCase() -> Character {
        return self.uppercased().first!
    }

    /// 将字符转换为小写字母。
    /// - Returns: 转换后的小写字母。
    ///
    /// - Example:
    /// ```swift
    /// let char: Character = "A"
    /// print(char.dd_toLowerCase()) // 输出: "a"
    /// ```
    func dd_toLowerCase() -> Character {
        return self.lowercased().first!
    }

    /// 获取字符对应的 Unicode 编码。
    /// - Returns: 字符的 Unicode 编码（以十六进制表示）。
    ///
    /// - Example:
    /// ```swift
    /// let char: Character = "A"
    /// print(char.dd_toHexUnicode()) // 输出: "0041"
    /// ```
    func dd_toHexUnicode() -> String {
        return String(format: "%04X", self.unicodeScalars.first!.value)
    }

    /// 将字符转换为对应的 ASCII 码。
    /// - Returns: 如果字符可以表示为 ASCII，返回其 ASCII 值；否则返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// let char: Character = "A"
    /// print(char.dd_toASCII()) // 输出: 65
    ///
    /// let char: Character = "🌟"
    /// print(char.dd_toASCII()) // 输出: nil
    /// ```
    func dd_toASCII() -> UInt8? {
        guard let scalar = self.unicodeScalars.first, scalar.isASCII else { return nil }
        return UInt8(scalar.value)
    }
}
