//
//  NSRegularExpression++.swift
//  DuckDuck
//
//  Created by xxwang on 22/11/2024.
//

import Foundation

// MARK: - 方法
public extension NSRegularExpression {
    /// 为符合`正则表达式`的每个匹配项执行`block`闭包
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 匹配选项，默认是空数组
    ///   - range: 搜索范围，指定在哪个范围内进行匹配
    ///   - block: 作用于结果项的代码块
    ///
    /// ### 示例：
    /// ```swift
    /// let regex = try! NSRegularExpression(pattern: "\\d+")
    /// let text = "abc 123 def 456"
    /// regex.dd_enumerateMatches(in: text, range: text.startIndex..<text.endIndex) { result, flags, stop in
    ///     if let match = result {
    ///         print("Found match: \(text[Range(match.range, in: text)!])")
    ///     }
    /// }
    /// ```
    func dd_enumerateMatches(in string: String,
                             options: NSRegularExpression.MatchingOptions = [],
                             range: Range<String.Index>,
                             using block: (_ result: NSTextCheckingResult?,
                                           _ flags: NSRegularExpression.MatchingFlags,
                                           _ stop: inout Bool) -> Void)
    {
        self.enumerateMatches(in: string, options: options, range: NSRange(range, in: string)) { result, flags, stop in
            var shouldStop = false
            block(result, flags, &shouldStop)
            if shouldStop { stop.pointee = true }
        }
    }

    /// 返回所有符合`正则表达式`的匹配项
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 匹配选项，默认是空数组
    ///   - range: 搜索范围，指定在哪个范围内进行匹配
    /// - Returns: 结果数组，包含所有的匹配项
    ///
    /// ### 示例：
    /// ```swift
    /// let regex = try! NSRegularExpression(pattern: "\\d+")
    /// let text = "abc 123 def 456"
    /// let matches = regex.dd_matches(in: text, range: text.startIndex..<text.endIndex)
    /// print(matches.count) // 输出: 2
    /// ```
    func dd_matches(in string: String,
                    options: NSRegularExpression.MatchingOptions = [],
                    range: Range<String.Index>) -> [NSTextCheckingResult]
    {
        return self.matches(in: string, options: options, range: NSRange(range, in: string))
    }

    /// 获取指定范围内符合`正则表达式`的匹配项数量
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 匹配选项，默认是空数组
    ///   - range: 搜索范围，指定在哪个范围内进行匹配
    /// - Returns: 匹配项的数量
    ///
    /// ### 示例：
    /// ```swift
    /// let regex = try! NSRegularExpression(pattern: "\\d+")
    /// let text = "abc 123 def 456"
    /// let count = regex.dd_numberOfMatches(in: text, range: text.startIndex..<text.endIndex)
    /// print(count) // 输出: 2
    /// ```
    func dd_numberOfMatches(in string: String,
                            options: NSRegularExpression.MatchingOptions = [],
                            range: Range<String.Index>) -> Int
    {
        return self.numberOfMatches(in: string, options: options, range: NSRange(range, in: string))
    }

    /// 返回符合`正则表达式`的`第一个`匹配项
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 匹配选项，默认是空数组
    ///   - range: 搜索范围，指定在哪个范围内进行匹配
    /// - Returns: `NSTextCheckingResult?`，匹配项的第一个结果，若没有匹配返回`nil`
    ///
    /// ### 示例：
    /// ```swift
    /// let regex = try! NSRegularExpression(pattern: "\\d+")
    /// let text = "abc 123 def 456"
    /// let firstMatch = regex.dd_firstMatch(in: text, range: text.startIndex..<text.endIndex)
    /// if let match = firstMatch {
    ///     print("First match: \(text[Range(match.range, in: text)!])") // 输出: 123
    /// }
    /// ```
    func dd_firstMatch(in string: String,
                       options: NSRegularExpression.MatchingOptions = [],
                       range: Range<String.Index>) -> NSTextCheckingResult?
    {
        return self.firstMatch(in: string, options: options, range: NSRange(range, in: string))
    }

    /// 获取符合`正则表达式`的第一个匹配项的`Range`
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 匹配选项，默认是空数组
    ///   - range: 搜索范围，指定在哪个范围内进行匹配
    /// - Returns: `Range<String.Index>?`，第一个匹配项的范围，若没有匹配返回`nil`
    ///
    /// ### 示例：
    /// ```swift
    /// let regex = try! NSRegularExpression(pattern: "\\d+")
    /// let text = "abc 123 def 456"
    /// if let matchRange = regex.dd_rangeOfFirstMatch(in: text, range: text.startIndex..<text.endIndex) {
    ///     print("First match range: \(matchRange)") // 输出: "123"
    /// }
    /// ```
    func dd_rangeOfFirstMatch(in string: String,
                              options: NSRegularExpression.MatchingOptions = [],
                              range: Range<String.Index>) -> Range<String.Index>?
    {
        return Range(self.rangeOfFirstMatch(in: string,
                                            options: options,
                                            range: NSRange(range, in: string)), in: string)
    }

    /// 使用`template`替换符合`正则表达式`的匹配项
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 匹配选项，默认是空数组
    ///   - range: 搜索范围，指定在哪个范围内进行匹配
    ///   - template: 用于替换的模板字符串
    /// - Returns: 替换后的字符串
    ///
    /// ### 示例：
    /// ```swift
    /// let regex = try! NSRegularExpression(pattern: "\\d+")
    /// let text = "abc 123 def 456"
    /// let replaced = regex.dd_stringByReplacingMatches(in: text, range: text.startIndex..<text.endIndex, with: "XYZ")
    /// print(replaced) // 输出: abc XYZ def XYZ
    /// ```
    func dd_stringByReplacingMatches(in string: String,
                                     options: NSRegularExpression.MatchingOptions = [],
                                     range: Range<String.Index>,
                                     with template: String) -> String
    {
        return self.stringByReplacingMatches(in: string,
                                             options: options,
                                             range: NSRange(range, in: string),
                                             withTemplate: template)
    }

    /// 使用`template`替换符合`正则表达式`的匹配项，并返回替换的匹配项数量
    /// - Parameters:
    ///   - string: 用于正则匹配和替换的字符串，方法会修改此字符串
    ///   - options: 匹配选项，默认是空数组，可以选择如`caseInsensitive`等选项
    ///   - range: 搜索范围，指定在哪个范围内进行匹配和替换
    ///   - template: 用于替换的模板字符串，可以包含正则表达式中的捕获组（如`$1`, `$2`等）
    /// - Returns: 替换操作中涉及的匹配项数量
    ///
    /// ### 示例：
    /// ```swift
    /// let regex = try! NSRegularExpression(pattern: "\\d+")
    /// var text = "abc 123 def 456"
    /// let numberOfMatches = regex.dd_replaceMatches(in: &text, range: text.startIndex..<text.endIndex, with: "XYZ")
    /// print(text) // 输出: abc XYZ def XYZ
    /// print(numberOfMatches) // 输出: 2
    /// ```
    /// 在上述示例中，`dd_replaceMatches` 方法会将字符串中的所有数字替换为 "XYZ"，并返回替换的匹配项数量（2个匹配项）。
    @discardableResult
    func dd_replaceMatches(in string: inout String,
                           options: NSRegularExpression.MatchingOptions = [],
                           range: Range<String.Index>,
                           with template: String) -> Int
    {
        // 创建一个 NSMutableString 对象，允许我们在原始字符串上进行修改
        let mutableString = NSMutableString(string: string)

        // 使用正则表达式替换匹配项
        let matches = self.replaceMatches(in: mutableString,
                                          options: options,
                                          range: NSRange(range, in: string),
                                          withTemplate: template)

        // 将修改后的字符串重新赋值给原始字符串
        string = mutableString.copy() as! String

        // 返回替换的匹配项数量
        return matches
    }
}
