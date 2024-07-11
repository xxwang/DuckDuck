//
//  NSRegularExpression+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - 方法
public extension DDExtension where Base: NSRegularExpression {
    /// 为符合`正则表达式`的每个匹配项执行`block`闭包
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 选项
    ///   - range: 搜索范围
    ///   - block: 作用于结果项的代码块
    func enumerateMatches(in string: String,
                          options: NSRegularExpression.MatchingOptions = [],
                          range: Range<String.Index>,
                          using block: (_ result: NSTextCheckingResult?,
                                        _ flags: NSRegularExpression.MatchingFlags,
                                        _ stop: inout Bool) -> Void)
    {
        self.base.enumerateMatches(in: string, options: options, range: NSRange(range, in: string)) { result, flags, stop in
            var shouldStop = false
            block(result, flags, &shouldStop)
            if shouldStop { stop.pointee = true }
        }
    }

    /// 返回所有符合`正则表达式`的匹配项
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 选项
    ///   - range: 搜索范围
    /// - Returns: 结果数组
    func matches(in string: String,
                 options: NSRegularExpression.MatchingOptions = [],
                 range: Range<String.Index>) -> [NSTextCheckingResult]
    {
        return self.base.matches(in: string, options: options, range: NSRange(range, in: string))
    }

    /// 获取指定范围内符合`正则表达式`的匹配项数量
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 选项
    ///   - range: 搜索范围
    /// - Returns: 结果数量
    func numberOfMatches(in string: String,
                         options: NSRegularExpression.MatchingOptions = [],
                         range: Range<String.Index>) -> Int
    {
        return self.base.numberOfMatches(in: string, options: options, range: NSRange(range, in: string))
    }

    /// 返回符合`正则表达式`的`第一个`匹配项
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 选项
    ///   - range: 搜索范围
    /// - Returns: 结果`NSTextCheckingResult?`
    func firstMatch(in string: String,
                    options: NSRegularExpression.MatchingOptions = [],
                    range: Range<String.Index>) -> NSTextCheckingResult?
    {
        return self.base.firstMatch(in: string, options: options, range: NSRange(range, in: string))
    }

    /// 获取符合`正则表达式`的第一个匹配项的`Range`
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 选项
    ///   - range: 搜索范围
    /// - Returns: 结果`Range`
    func rangeOfFirstMatch(in string: String,
                           options: NSRegularExpression.MatchingOptions = [],
                           range: Range<String.Index>) -> Range<String.Index>?
    {
        return Range(self.base.rangeOfFirstMatch(in: string,
                                                 options: options,
                                                 range: NSRange(range, in: string)), in: string)
    }

    /// 使用`template`替换符合`正则表达式`的匹配项
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 选项
    ///   - range: 搜索范围
    ///   - template: 用于替换的字符串
    /// - Returns: 结果字符串
    func stringByReplacingMatches(in string: String,
                                  options: NSRegularExpression.MatchingOptions = [],
                                  range: Range<String.Index>,
                                  with template: String) -> String
    {
        return self.base.stringByReplacingMatches(in: string,
                                                  options: options,
                                                  range: NSRange(range, in: string),
                                                  withTemplate: template)
    }

    /// 使用`template`替换符合`正则表达式`的匹配项
    /// - Parameters:
    ///   - string: 用于正则匹配的字符串
    ///   - options: 选项
    ///   - range: 搜索范围
    ///   - template: 用于替换的字符串
    /// - Returns: 匹配项数量
    @discardableResult
    func replaceMatches(in string: inout String,
                        options: NSRegularExpression.MatchingOptions = [],
                        range: Range<String.Index>,
                        with template: String) -> Int
    {
        let mutableString = NSMutableString(string: string)
        let matches = self.base.replaceMatches(in: mutableString,
                                               options: options,
                                               range: NSRange(range, in: string),
                                               withTemplate: template)
        string = mutableString.copy() as! String
        return matches
    }
}
