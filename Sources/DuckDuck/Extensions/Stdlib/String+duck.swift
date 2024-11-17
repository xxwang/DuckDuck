//
//  String+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//


// MARK: - 判断
public extension String {
    /// 检查字符串是否包含字母
    ///
    ///     "123abc".dd_hasLetters -> true
    ///     "123".dd_hasLetters -> false
    ///
    /// - Returns: 是否包含
    func dd_hasLetters() -> Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    /// 检查字符串是否只包含字母
    ///
    ///     "abc".dd_isAlphabetic -> true
    ///     "123abc".dd_isAlphabetic -> false
    ///
    /// - Returns: 是否包含
    func dd_isAlphabetic() -> Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    /// 检查字符串是否包含数字
    ///
    ///     "abcd".dd_hasNumbers -> false
    ///     "123abc".dd_hasNumbers -> true
    ///
    /// - Returns: 是否包含
    func dd_hasNumbers() -> Bool {
        rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    /// 检查字符串是否同时包含字母数字
    ///
    ///     "123abc".dd_isAlphaNumeric -> true
    ///     "abc".dd_isAlphaNumeric -> false
    ///
    /// - Returns: 是否包含
    func dd_isAlphaNumeric() -> Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }

    /// 检查字符串是否为有效的`Swift`数字
    ///
    ///     "123".dd_isSwiftNumeric -> true
    ///     "1.3".dd_isSwiftNumeric -> true (en_US)
    ///     "1,3".dd_isSwiftNumeric -> true (fr_FR)
    ///     "abc".dd_isSwiftNumeric -> false
    ///
    /// - Returns: 是否是有效的`Swift`数字
    func dd_isSwiftNumeric() -> Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        if #available(iOS 13.0, *) {
            return scanner.scanDecimal() != nil && scanner.isAtEnd
        } else {
            return scanner.scanDecimal(nil) && scanner.isAtEnd
        }
    }

    /// 判断是否是整数
    /// - Returns: 是否是整数
    func dd_isPureInt() -> Bool {
        let scan = Scanner(string: self)
        if #available(iOS 13.0, *) {
            return (scan.scanInt() != nil) && scan.isAtEnd
        } else {
            return scan.scanInt(nil) && scan.isAtEnd
        }
    }

    /// 检查字符串是否只包含数字
    ///
    ///     "123".dd_isDigits -> true
    ///     "1.3".dd_isDigits -> false
    ///     "abc".dd_isDigits -> false
    ///
    /// - Returns: 是否只包含数字
    func dd_isDigits() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    /// 检查给定的字符串是否只包含空格
    /// - Returns: 是否只包含空格
    func dd_isWhitespace() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 检查给定的字符串是否拼写正确
    /// - Returns: `Bool`
    func dd_isSpelledCorrectly() -> Bool {
        let checker = UITextChecker()
        let range = NSRange(startIndex ..< endIndex, in: self)

        let misspelledRange = checker.rangeOfMisspelledWord(
            in: self,
            range: range,
            startingAt: 0,
            wrap: false,
            language: Locale.preferredLanguages.first ?? "en"
        )
        return misspelledRange.location == NSNotFound
    }

    /// 检查字符串是否为回文字符串
    ///
    ///     "abcdcba".dd_isPalindrome -> true
    ///     "Mom".dd_isPalindrome -> true
    ///     "A man a plan a canal, Panama!".dd_isPalindrome -> true
    ///     "Mama".dd_isPalindrome -> false
    ///
    /// - Returns: 是否为回文字符串
    func dd_isPalindrome() -> Bool {
        let letters = filter(\.isLetter)
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex ..< midIndex]
        let secondHalf = letters[midIndex ..< letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }

    /// 检查字符串是否只包含唯一字符(没有重复字符)
    /// - Returns: 是否只包含唯一字符
    func dd_hasUniqueCharacters() -> Bool {
        guard count > 0 else { return false }
        var uniqueChars = Set<String>()
        for char in self {
            if uniqueChars.contains(String(char)) { return false }
            uniqueChars.insert(String(char))
        }
        return true
    }

    /// 判断是不是九宫格键盘
    /// - Returns: 是不是九宫格键盘
    func dd_isNineKeyBoard() -> Bool {
        let other: NSString = "➋➌➍➎➏➐➑➒"
        let len = count
        for _ in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        return true
    }

    /// 利用正则表达式判断是否是手机号码
    /// - Returns: 是否符合正则
    func dd_isTelNumber() -> Bool {
        let pattern = "^1[3456789]\\d{9}$"
        return dd_regexp(pattern)
    }

    /// 是否是字母数字(指定范围)
    /// - Parameters:
    ///   - minLen: 最小长度
    ///   - maxLen: 最大长度
    /// - Returns: 是否符合正则
    func dd_isAlphanueric(minLen: Int, maxLen: Int) -> Bool {
        let pattern = "^[0-9a-zA-Z_]{\(minLen),\(maxLen)}$"
        return dd_regexp(pattern)
    }

    /// 是否是字母与数字
    /// - Returns: 是否符合正则
    func dd_isAlphanueric() -> Bool {
        let pattern = "^[A-Za-z0-9]+$"
        return dd_isMatchRegexp(pattern)
    }

    /// 是否是纯汉字
    /// - Returns: 是否符合正则
    func dd_isChinese() -> Bool {
        let pattern = "(^[\u{4e00}-\u{9fef}]+$)"
        return dd_regexp(pattern)
    }

    /// 检查字符串是否为有效的电子邮件格式
    /// - Returns: 是否符合正则
    func dd_isEmail1() -> Bool {
        //     let pattern = "^([a-z0-9A-Z]+[-_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$"
        let pattern = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?"
        return dd_regexp(pattern)
    }

    /// 检查字符串是否为有效的电子邮件格式
    ///
    ///     "john@doe.com".dd_isEmai2 -> true
    ///
    /// - Note: 请注意,此属性不会针对电子邮件服务器验证电子邮件地址.
    ///         它只是试图确定其格式是否适合电子邮件地址
    /// - Returns: 是否符合正则
    func dd_isEmai2() -> Bool {
        // http://emailregex.com/
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 是否是有效昵称,即允许`中文`、`英文`、`数字`
    /// - Returns: 是否符合正则
    func dd_isNickName() -> Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        return dd_regexp(rgex)
    }

    /// 字符串是否为合法用户名
    /// - Returns: 是否符合正则
    func dd_validateUserName() -> Bool {
        let rgex = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        return dd_regexp(rgex)
    }

    /// 设置密码必须符合由`数字`、`大写字母`、`小写字母`、`特殊符`
    /// - Parameter complex: 是否复杂密码 至少其中(两种/三种)组成密码
    /// - Returns: 是否符合正则
    func dd_password(_ complex: Bool = false) -> Bool {
        var pattern = "^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{8,20}$"
        if complex {
            pattern = "^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\\W_]+$)(?![a-z0-9]+$)(?![a-z\\W_]+$)(?![0-9\\W_]+$)[a-zA-Z0-9\\W_]{8,20}$"
        }
        return dd_regexp(pattern)
    }

    /// 是否为`0-9`之间的数字(字符串的组成是:`0-9`之间的`数字`)
    /// - Returns: 是否符合正则
    func dd_isNumberValue() -> Bool {
        guard !isEmpty else {
            return false
        }
        let rgex = "^[\\d]*$"
        return dd_regexp(rgex)
    }

    /// 是否为`数字`或者`小数点`(字符串的组成是:`0-9之间`的`数字`或者`小数点`即可)
    /// - Returns: 是否符合正则
    func dd_isValidNumberAndDecimalPoint() -> Bool {
        guard !isEmpty else {
            return false
        }
        let rgex = "^[\\d.]*$"
        return dd_regexp(rgex)
    }

    /// 正则匹配用户身份证号15或18位
    /// - Returns: 是否符合正则
    func dd_isIDNumber() -> Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
        return dd_regexp(pattern)
    }

    /// 严格判断是否有效的身份证号码,检验了省份,生日,校验位,不过没检查市县的编码
    var isValidIDNumber: Bool {
        let str = trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let len = str.count
        if !str.dd_isIDNumber() {
            return false
        }
        // 省份代码
        let areaArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        if !areaArray.contains(str.dd_subString(to: 2)) {
            return false
        }
        var regex = NSRegularExpression()
        var numberOfMatch = 0
        var year = 0
        switch len {
        case 15:
            // 15位身份证
            // 这里年份只有两位,00被处理为闰年了,对2000年是正确的,对1900年是错误的,不过身份证是1900年的应该很少了
            year = Int(str.dd_subString(from: 6, length: 2))!
            if dd_isLeapYear(year: year) { // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: len))

            if numberOfMatch > 0 { return true } else { return false }
        case 18:
            // 18位身份证
            year = Int(str.dd_subString(from: 6, length: 4))!
            if dd_isLeapYear(year: year) {
                // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: len))
            if numberOfMatch > 0 {
                var s = 0
                let jiaoYan = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3]
                for i in 0 ..< 17 {
                    if let d = Int(str.dd_slice(i ..< (i + 1))) {
                        s += d * jiaoYan[i % 10]
                    } else {
                        return false
                    }
                }
                let Y = s % 11
                let JYM = "10X98765432"
                let M = JYM.dd_subString(from: Y, length: 1)
                if M == str.dd_subString(from: 17, length: 1) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        default:
            return false
        }
    }

    /// 是否是闰年
    /// - Parameter year: 年份
    /// - Returns: 是否是闰年
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

    /// 检查字符串是否是有效的`URL`
    ///
    ///     "https://google.com".dd_isValidUrl -> true
    ///
    /// - Returns: 是否是有效的`URL`
    func dd_isValidURL() -> Bool {
        return URL(string: self) != nil
    }

    /// 检查字符串是否是有效带协议头的`URL`
    ///
    ///     "https://google.com".dd_isValidSchemedUrl -> true
    ///     "google.com".dd_isValidSchemedUrl -> false
    ///
    /// - Returns: 是否符合
    func dd_isValidSchemedUrl() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// 检查字符串是否是有效的`https URL`
    ///
    ///     "https://google.com".dd_isValidHttpsUrl -> true
    ///
    /// - Returns: `Bool`
    func dd_isValidHttpsUrl() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }

    /// 检查字符串是否是有效的`http URL`
    ///
    ///     "http://google.com".dd_isValidHttpUrl -> true
    ///
    /// - Returns: `Bool`
    func dd_isValidHttpUrl() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }

    /// 检查字符串是否是有效的文件URL
    ///
    ///     "file://Documents/file.txt".dd_isValidFileUrl -> true
    ///
    /// - Returns: `Bool`
    func dd_isValidFileUrl() -> Bool {
        URL(string: self)?.isFileURL ?? false
    }

    /// 判断是否包含某个字符串`区分大小写`
    /// - Parameter find: 用于查询的字符串
    /// - Returns: 是否包含
    func dd_contains(find: String) -> Bool {
        self.dd_contains(find, caseSensitive: true)
    }

    /// 检查字符串是否包含`string`
    ///
    ///     "Hello World!".dd_contains("O") -> false
    ///     "Hello World!".dd_contains("o", caseSensitive:false) -> true
    ///
    /// - Parameters:
    ///   - string: 用于查询的字符串
    ///   - caseSensitive: 是否区分大小写
    /// - Returns: 是否包含
    func dd_contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }

    ///  判断是否包含`find` `忽略大小写`
    /// - Parameter find: 用于查询的字符串
    /// - Returns: 是否包含
    func dd_containsIgnoringCase(find: String) -> Bool {
        return dd_contains(find, caseSensitive: false)
    }

    /// 检查字符串是否以`prefix`开头
    ///
    ///     "hello World".dd_starts(with:"h") -> true
    ///     "hello World".dd_starts(with:"H", caseSensitive:false) -> true
    ///
    /// - Parameters:
    ///   - prefix: 用于查询的字符串
    ///   - caseSensitive: 是否区分大小写
    /// - Returns: 是否符合
    func dd_starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }

    /// 检查字符串是否以`suffix`结尾
    ///
    ///     "Hello World!".dd_ends(with:"!") -> true
    ///     "Hello World!".dd_ends(with:"WoRld!", caseSensitive:false) -> true
    ///
    /// - Parameters:
    ///   - suffix: 用于查询的字符串
    ///   - caseSensitive: 是否区分大小写
    /// - Returns: 是否符合
    func dd_ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
}

// MARK: - 正则相关运算符
infix operator =~: RegPrecedence
precedencegroup RegPrecedence {
    associativity: none
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

public extension String {
    /// 正则匹配操作符
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    /// - Returns: 是否匹配
    static func =~ (lhs: String, rhs: String) -> Bool {
        lhs.dd_regexp(rhs)
    }
}

// MARK: - 正则
public extension String {
    /// 为正则表达式加上`"\"`进行保护,将元字符转化成字面值
    ///
    ///     "hello ^$ there" -> "hello \\^\\$ there"
    ///
    /// - Returns: 结果字符串
    func dd_regexEscaped() -> String {
        return NSRegularExpression.escapedPattern(for: self)
    }

    /// 验证`字符串`是否匹配`正则表达式`
    /// - Parameter pattern: 正则表达式
    /// - Returns: 是否符合
    func dd_matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 验证`字符串`是否与`正则表达式`匹配
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配选项
    /// - Returns: 是否符合
    func dd_matches(regex: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        let range = NSRange(startIndex ..< endIndex, in: self)
        return regex.firstMatch(in: self, options: options, range: range) != nil
    }

    /// 验证`字符串`是否与`正则表达式`匹配
    /// - Parameter pattern: 正则表达式
    /// - Returns: 是否符合
    func dd_regexp(_ pattern: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }

    /// 是否有与`正则表达式`匹配的项
    /// - Parameter pattern: 正则表达式
    /// - Returns: 是否符合
    func dd_isMatchRegexp(_ pattern: String) -> Bool {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        let result = regx.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: utf16.count))
        return !result.isEmpty
    }

    /// 获取符合`正则表达式`的结果
    /// - Parameters:
    ///   - pattern: 正则表达式
    ///   - count: 匹配次数
    /// - Returns: 结果数组
    func dd_regexpText(_ pattern: String, count: Int = 1) -> [String]? {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))
        else { return nil }
        var texts = [String]()
        for idx in 1 ... count {
            let text = dd_NSString().substring(with: result.range(at: idx))
            texts.append(text)
        }
        return texts
    }

    /// 获取匹配项的`NSRange`
    /// - Parameter pattern: 正则表达式
    /// - Returns: 匹配的`[NSRange]`结果
    func dd_matchRange(_ pattern: String) -> [NSRange] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return []
        }
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))
        guard !matches.isEmpty else {
            return []
        }
        return matches.map { value in
            value.range
        }
    }
}

// MARK: - HTML字符引用
public extension String {
    /// `字符串`转为`HTML字符引用`
    /// - Returns: `HTML字符引用`
    func dd_stringAsHtmlCharacterEntityReferences() -> String {
        var result = ""
        for scalar in utf16 {
            // 将十进制转成十六进制,不足4位前面补0
            let tem = String().appendingFormat("%04x", scalar)
            result += "&#x\(tem);"
        }
        return result
    }

    /// `HTML字符引用`转`字符串`
    /// - Returns: 普通字符串
    func dd_htmlCharacterEntityReferencesAsString() -> String? {
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                                                     NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
        guard let encodedData = data(using: String.Encoding.utf8) else { return nil }
        guard let attributedString = try? NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil) else { return nil }
        return attributedString.string
    }
}

// MARK: - 属性字符串相关
public extension String {
    /// `HTML源码`转`属性字符串`
    /// - Parameters:
    ///   - font: 字体
    ///   - lineSpacing: 行间距
    /// - Returns: 属性字符串
    func dd_htmlCodeToAttributedString(font: UIFont? = UIFont.systemFont(ofSize: 12),
                                       lineSpacing: CGFloat? = 10) -> NSMutableAttributedString
    {
        var htmlString: NSMutableAttributedString?
        do {
            if let data = replacingOccurrences(of: "\n", with: "<br/>").data(using: .utf8) {
                htmlString = try NSMutableAttributedString(data: data, options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue),
                ], documentAttributes: nil)
                let wrapHtmlString = NSMutableAttributedString(string: "\n")
                // 判断尾部是否是换行符
                if let weakHtmlString = htmlString, weakHtmlString.string.hasSuffix("\n") {
                    htmlString?.deleteCharacters(in: NSRange(location: weakHtmlString.length - wrapHtmlString.length, length: wrapHtmlString.length))
                }
            }
        } catch {}
        // 设置属性字符串字体的大小
        if let font { htmlString?.addAttributes([.font: font], range: dd_fullNSRange()) }

        // 设置行间距
        if let weakLineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle.default().dd_lineSpacing(weakLineSpacing)
            htmlString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: dd_fullNSRange())
        }
        return htmlString ?? dd_NSMutableAttributedString()
    }

    /// 高亮显示关键字(返回属性字符串)
    /// - Parameters:
    ///   - keyword: 要高亮的关键词
    ///   - keywordCololor: 关键高亮字颜色
    ///   - otherColor: 非高亮文字颜色
    ///   - options: 匹配选项
    /// - Returns: 返回匹配后的属性字符串
    func dd_highlightSubString(keyword: String,
                               keywordCololor: UIColor,
                               otherColor: UIColor,
                               options: NSRegularExpression.Options = []) -> NSMutableAttributedString
    {
        // 整体字符串
        let fullString = self
        // 整体属性字符串
        let attributedString = fullString.dd_NSMutableAttributedString().dd_addAttributes([
            NSAttributedString.Key.foregroundColor: otherColor,
        ])

        // 与关键词匹配的range数组
        let ranges = fullString.dd_matchRange(keyword)

        // 设置高亮颜色
        for range in ranges {
            attributedString.addAttributes([.foregroundColor: keywordCololor], range: range)
        }
        return attributedString
    }
}

// MARK: - URL编解码(属性)
public extension String {
    /// 转义字符串(`URL`编码)
    ///
    ///     var str = "it's easy to encode strings"
    ///     str.dd_urlEncode()
    ///     print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    /// - Returns: 编码后的字符串
    @discardableResult
    func dd_urlEncode() -> String {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return encoded
        }
        return self
    }

    /// `URL`字符串转换为可读字符串(`URL`转义字符串解码)
    ///
    ///     var str = "it's%20easy%20to%20decode%20strings"
    ///     str.dd_urlDecode()
    ///     print(str) // prints "it's easy to decode strings"
    ///
    /// - Returns: 解码后的字符串
    @discardableResult
    func dd_urlDecode() -> String {
        if let decoded = removingPercentEncoding { return decoded }
        return self
    }
}



// MARK: - unicode编码和解码
public extension String {
    /// `Unicode`编码
    /// - Returns: `unicode`编码后的字符串
    func dd_unicodeEncode() -> String {
        var tempStr = String()
        for v in utf16 {
            if v < 128 {
                tempStr.append(Unicode.Scalar(v)!.escaped(asASCII: true))
                continue
            }
            let codeStr = String(v, radix: 16, uppercase: false)
            tempStr.append("\\u" + codeStr)
        }

        return tempStr
    }

    /// `Unicode`解码
    /// - Returns:`unicode`解码后的字符串
    func dd_unicodeDecode() -> String {
        let tempStr1 = replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print("😭出错啦! \(error.localizedDescription)")
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}

// MARK: - Date
public extension String {
    /// `格式日期字符串`成`日期对象`
    /// - Parameter format: 日期格式
    /// - Returns: Date?`
    func dd_date(with format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

// MARK: - 位置
public extension String {
    /// 地理编码(`地址转坐标`)
    /// - Parameter completionHandler: 回调函数
    func dd_locationEncode(completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().geocodeAddressString(self, completionHandler: completionHandler)
    }
}

// MARK: - URL
public extension String {
    /// 提取出字符串中所有的`URL`链接
    /// - Returns: `URL`链接数组
    func dd_urls() -> [String]? {
        var urls = [String]()
        // 创建一个正则表达式对象
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue)) else {
            return nil
        }

        // 匹配字符串,返回结果集
        let res = dataDetector.matches(in: self,
                                       options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                       range: NSRange(location: 0, length: count))

        // 取出结果
        for checkingRes in res {
            urls.append(dd_NSString().substring(with: checkingRes.range))
        }
        return urls
    }

    /// 截取参数列表
    /// - Returns: `URL`中的参数列表
    func dd_urlParamters() -> [String: Any] {
        guard let urlComponents = NSURLComponents(string: self),
              let queryItems = urlComponents.queryItems else { return [:] }

        var parameters = [String: Any]()
        for item in queryItems {
            guard let value = item.value else { continue }
            if let exist = parameters[item.name] {
                if var exist = exist as? [String] {
                    exist.append(value)
                } else {
                    parameters[item.name] = [exist as! String, value]
                }
            } else { parameters[item.name] = value }
        }
        return parameters
    }
}

// MARK: - Path
public extension String {
    /// 获取路径字符串中最后一个路径组件
    /// - Returns: 最后一个路径组件
    func dd_lastPathComponent() -> String {
        return self.dd_NSString().lastPathComponent
    }

    /// 获取路径字符串的扩展名
    /// - Returns: 扩展名
    func dd_pathExtension() -> String {
        return self.dd_NSString().pathExtension
    }

    /// 返回删除了最后一个路径组件之后的字符串
    /// - Returns: 结果字符串
    func dd_deletingLastPathComponent() -> String {
        return self.dd_NSString().deletingLastPathComponent
    }

    /// 返回删除了路径扩展之后的字符串
    /// - Returns: 结果字符串
    func dd_deletingPathExtension() -> String {
        return self.dd_NSString().deletingPathExtension
    }

    /// 获取路径组件数组
    /// - Returns: 路径组件数组
    func dd_pathComponents() -> [String] {
        return self.dd_NSString().pathComponents
    }

    /// 在路径字符串尾部添加路径组件
    ///
    /// - Note: 此方法仅适用于文件路径(例如,URL 的字符串表示形式
    /// - Parameter str: 要添加的路径组件(如果需要可以在前面添加分隔符`/`)
    /// - Returns: 新的路径字符串
    func dd_appendingPathComponent(_ str: String) -> String {
        return self.dd_NSString().appendingPathComponent(str)
    }

    /// 添加路径扩展
    /// - Parameter str: 要添加的扩展
    /// - Returns: 新的路径字符串
    func dd_appendingPathExtension(_ str: String) -> String? {
        return self.dd_NSString().appendingPathExtension(str)
    }
}

// MARK: - 沙盒路径
public extension String {
    /// 在`Support`目录后追加`目录/文件地址`
    ///
    /// - Note: `Support`备份在 iCloud
    /// - Returns: 拼接后的路径字符串
    func dd_appendBySupport() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        self.dd_createDirs(directory)
        return directory + "/\(self)"
    }

    /// 在`Documents`目录后追加`目录/文件地址`
    /// - Returns: 拼接后的路径字符串
    func dd_appendByDocument() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.dd_createDirs(directory)
        return directory + "/\(self)"
    }

    /// 在`Cachees`目录后追加`目录/文件地址`
    /// - Returns: 拼接后的路径字符串
    func dd_appendByCache() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        self.dd_createDirs(directory)
        return directory + "/\(self)"
    }

    /// 在`tmp`目录后追加`目录/文件地址`
    /// - Returns: 拼接后的路径字符串
    func dd_appendByTemp() -> String {
        let directory = NSTemporaryDirectory()
        self.dd_createDirs(directory)
        return directory + "\(self)"
    }
}

// MARK: - 沙盒URL
public extension String {
    /// 在`Support`目录后追加`目录/文件地址`
    ///
    /// - Note: `Support`备份在 iCloud
    /// - Returns: 拼接后的路径`URL`
    func dd_urlBySupport() -> URL {
        _ = dd_appendByDocument()
        let fileUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }

    /// 在`Cachees`目录后追加`目录/文件地址`
    /// - Returns: 拼接后的路径`URL`
    func dd_urlByDocument() -> URL {
        _ = dd_appendByDocument()
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }

    /// 在`Cachees`目录后追加`目录/文件地址`
    /// - Returns: 拼接后的路径`URL`
    func dd_urlByCache() -> URL {
        _ = dd_appendByCache()
        let fileUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }
}

// MARK: - 文件操作
public extension String {
    /// 删除文件
    func dd_removeFile() {
        if FileManager.default.fileExists(atPath: self) {
            do {
                try FileManager.default.removeItem(atPath: self)
            } catch {
                debugPrint("文件删除失败!")
            }
        }
    }

    /// 创建目录/文件
    ///
    /// - Note: 以`/`结束代表是`目录`, 如 `cache/`
    /// - Parameter directory: 路径
    func dd_createDirs(_ directory: String = NSHomeDirectory()) {
        let path = contains(NSHomeDirectory()) ? self : "\(directory)/\(self)"
        let dirs = path.components(separatedBy: "/")
        let dir = dirs[0 ..< dirs.count - 1].joined(separator: "/")
        if !FileManager.default.fileExists(atPath: dir) {
            do {
                try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint(error)
            }
        }
    }
}

// MARK: - 剪切板
public extension String {
    /// 将字符串复制到全局粘贴板
    ///
    ///     "SomeText".dd_copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    func dd_copyToPasteboard() {
        #if os(iOS)
            UIPasteboard.general.string = self
        #elseif os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(base, forType: .string)
        #endif
    }
}

// MARK: - 字符串尺寸计算
public extension String {
    /// 根据参数计算字符串`CGSize`
    /// - Parameters:
    ///   - lineWidth: 最大宽度
    ///   - font: 字体
    /// - Returns: 结果`CGSize`
    func dd_stringSize(_ lineWidth: CGFloat = Double.greatestFiniteMagnitude, font: UIFont) -> CGSize {
        let constraint = CGSize(width: lineWidth, height: .greatestFiniteMagnitude)
        // .usesDeviceMetrics, .truncatesLastVisibleLine
        let size = self.dd_NSString()
            .boundingRect(with: constraint,
                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                          attributes: [.font: font],
                          context: nil)
        return CGSize(width: size.width.dd_ceil(), height: size.height.dd_ceil())
    }

    /// 根据参数计算字符串`CGSize`
    /// - Parameters:
    ///   - lineWidth: 最大宽度
    ///   - font: 字体
    ///   - lineSpacing: 行间距
    ///   - wordSpacing: 字间距
    /// - Returns: 结果`CGSize`
    func dd_attributedSize(_ lineWidth: CGFloat = Double.greatestFiniteMagnitude,
                           font: UIFont,
                           lineSpacing: CGFloat = 0,
                           wordSpacing: CGFloat = 0) -> CGSize
    {
        // 段落样式
        let paragraphStyle = NSMutableParagraphStyle.default()
            .dd_lineBreakMode(.byCharWrapping)
            .dd_alignment(.left)
            .dd_lineSpacing(lineSpacing)
            .dd_hyphenationFactor(1.0)
            .dd_firstLineHeadIndent(0.0)
            .dd_paragraphSpacingBefore(0.0)
            .dd_headIndent(0)
            .dd_tailIndent(0)

        // 属性字符串
        let attributedString = self.dd_NSMutableAttributedString()
            .dd_addAttributes([
                .font: font,
                .kern: wordSpacing,
                .paragraphStyle: paragraphStyle,
            ])

        let constraint = CGSize(width: lineWidth, height: CGFloat.greatestFiniteMagnitude)
        /*
         .usesDeviceMetrics,
         .truncatesLastVisibleLine,
          */
        let size = attributedString.boundingRect(with: constraint,
                                                 options: [
                                                     .usesLineFragmentOrigin,
                                                     .usesFontLeading,
                                                 ], context: nil).size
        // 向上取整(由于计算结果小数问题, 导致界面字符串显示不完整)
        return CGSize(width: size.width.dd_ceil(), height: size.height.dd_ceil())
    }
}

// MARK: - 方法
public extension String {
    /// 从字符串中提取数字
    /// - Returns: 数字字符串
    func dd_extractNumber() -> String {
        return self.filter(\.isNumber)
    }

    /// 字符串中第一个字符
    /// - Returns: 第一个字符(字符串)
    func dd_firstCharacter() -> String? {
        guard let first = first?.dd_String() else { return nil }
        return first
    }

    /// 字符串中最后一个字符
    /// - Returns: 最后一个字符(字符串)
    func dd_lastCharacter() -> String? {
        guard let last = last?.dd_String() else { return nil }
        return last
    }

    /// 字符串中的单词数量(`word`)
    ///
    ///     "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: 单词数量
    func dd_wordCount() -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }

    /// 字符串中的数字个数
    /// - Returns: 数字个数
    func dd_numericCount() -> Int {
        var count = 0
        for c in self where ("0" ... "9").contains(c) {
            count += 1
        }
        return count
    }

    /// 计算字符个数
    ///
    /// - Note: `英文 == 1`,`数字 == 1`,`汉语 == 2`
    /// - Returns: 字符数量
    func dd_countOfChars() -> Int {
        var count = 0
        guard !isEmpty else {
            return 0
        }
        for i in 0 ... self.count - 1 {
            let c: unichar = self.dd_NSString().character(at: i)
            if c >= 0x4E00 {
                count += 2
            } else {
                count += 1
            }
        }
        return count
    }

    /// 计算字符串中包含的`string`个数
    ///
    ///     "Hello World!".dd_count(of:"o") -> 2
    ///     "Hello World!".dd_count(of:"L", caseSensitive:false) -> 3
    ///
    /// - Parameters:
    ///   - string: 查询目标
    ///   - caseSensitive: 是否区分大小写
    /// - Returns: 结果数量
    func dd_count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive { return self.lowercased().components(separatedBy: string.lowercased()).count - 1 }
        return self.components(separatedBy: string).count - 1
    }

    /// 查找字符串中出现最频繁的字符
    ///
    ///     "This is a test, since e is appearing everywhere e should be the common character".dd_mostCommonCharacter() -> "e"
    ///
    /// - Returns: 结果字符
    func dd_mostCommonCharacter() -> Character? {
        let mostCommon = self.dd_withoutSpacesAndNewLines().reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.key
        return mostCommon
    }

    /// 校验`字符串位置`是否有效,并返回`String.Index`
    /// - Parameter original: 位置
    /// - Returns: 返回索引位置
    func dd_validIndex(original: Int) -> String.Index {
        switch original {
        case ...startIndex.utf16Offset(in: self):
            return startIndex
        case endIndex.utf16Offset(in: self)...:
            return endIndex
        default:
            return index(startIndex, offsetBy: original)
        }
    }

    /// 字符串中所有字符的`unicode`数组
    ///
    ///     "SwifterSwift".dd_unicodeArray() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    ///
    /// - Returns: `unicode`数组
    func dd_unicodeArray() -> [Int] {
        return self.unicodeScalars.map { Int($0.value) }
    }

    /// 字符串中所有单词的数组
    ///
    ///     "Swift is amazing".dd_words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: 单词数组
    func dd_words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }

    /// 从`HTML`字符串中提取链接和文本
    /// - Returns: `(link: String, text: String)?`
    func dd_hrefText() -> (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\"(.*?)>(.*?)</a>"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count))
        else { return nil }
        let link = dd_NSString().substring(with: result.range(at: 1))
        let text = dd_NSString().substring(with: result.range(at: 3))
        return (link, text)
    }

    /// 从字符串中提取链接所在位置的`NSRange`数组
    /// - Returns: `NSRange`数组
    func dd_linkRanges() -> [NSRange]? {
        // url, ##, 中文字母数字
        let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
        // 遍历数组,生成range的数组
        var ranges = [NSRange]()

        for pattern in patterns {
            guard let regx = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
                return nil
            }
            let matches = regx.matches(in: self, options: [], range: NSRange(location: 0, length: count))
            for m in matches {
                ranges.append(m.range(at: 0))
            }
        }
        return ranges
    }

    /// 由换行符分隔的字符串数组(获取字符串行数, `\n`分割)
    ///
    ///     "Hello\ntest".dd_lines() -> ["Hello", "test"]
    ///
    /// - Returns: 分割后的字符串数组
    func dd_lines() -> [String] {
        var result = [String]()
        self.enumerateLines { line, _ in result.append(line) }
        return result
    }

    /// 获取字符串每一行的内容
    ///
    /// - Note: 空字符串为空数组(⚠️不适用于属性文本)
    /// - Parameters:
    ///   - lineWidth: 行宽度
    ///   - font: 字体
    /// - Returns: 字符串数组
    func dd_lines(_ lineWidth: CGFloat, font: UIFont) -> [String] {
        // 段落样式
        let style = NSMutableParagraphStyle.default().dd_lineBreakMode(.byCharWrapping)

        // UIFont字体转CFFont
        let cfFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)

        // 属性字符串
        let attributedString = dd_NSMutableAttributedString()
            .dd_addAttributes([
                .paragraphStyle: style,
                NSAttributedString.Key(kCTFontAttributeName as String): cfFont,
            ], for: dd_fullNSRange())

        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)

        let path = CGMutablePath().dd_addRect(CGRect(x: 0, y: 0, width: lineWidth, height: 100_000))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(CFIndex(0), CFIndex(0)), path, nil)
        let lines = CTFrameGetLines(frame) as? [AnyHashable]

        var result: [String] = []
        for line in lines ?? [] {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            let range = NSRange(location: lineRange.location, length: lineRange.length)

            let lineString = (self as NSString).substring(with: range)
            CFAttributedStringSetAttribute(attributedString, lineRange, kCTKernAttributeName, NSNumber(value: 0.0))
            result.append(lineString)
        }
        return result
    }

    /// 字符串转换成驼峰命名法
    ///
    ///     "sOme vAriable naMe".dd_camelCase -> "someVariableName"
    ///
    /// - Note: 移除空字符并把单词首字母大写, 第一个单词首字母小写
    /// - Returns: 转换结果
    func dd_camelCase() -> String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }

    /// `汉字字符串`转成`拼音字符串`
    /// - Parameter isTone: 是否带声调
    /// - Returns: 拼音字符串
    func dd_pinYin(_ isTone: Bool = false) -> String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        // 将汉字转换为拼音(带音标)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        // 去掉拼音的音标
        if !isTone { CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false) }
        return mutableString as String
    }

    /// 提取汉字拼音首字母(每个汉字)
    ///
    ///     "爱国".dd_pinYinInitials() --> AG
    ///
    /// - Parameter isUpper: 是否大写
    /// - Returns: 字符串的拼音首字母字符串
    func dd_pinYinInitials(_ isUpper: Bool = true) -> String {
        let pinYin = dd_pinYin(false).components(separatedBy: " ")
        let initials = pinYin.compactMap { String(format: "%c", $0.cString(using: .utf8)![0]) }
        return isUpper ? initials.joined().uppercased() : initials.joined()
    }

    /// 返回一个本地化的字符串,带有可选的翻译注释
    /// - Parameter comment: 注释
    /// - Returns: 本地化字符串
    func dd_localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    /// 将字符串转换为slug字符串
    ///
    ///     "Swift is amazing".dd_slug() -> "swift-is-amazing"
    ///
    /// - Returns: 结果字符串
    func dd_slug() -> String {
        let lowercased = lowercased()
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        while filtered.dd_lastCharacter() == "-" {
            filtered = String(filtered.dropLast())
        }
        while filtered.dd_firstCharacter() == "-" {
            filtered = String(filtered.dropFirst())
        }

        return filtered.replacingOccurrences(of: "--", with: "-")
    }

    /// 删除字符串开着和结尾的空格及换行符
    ///
    ///     var str = "  \n Hello World \n\n\n"
    ///     str.dd_trim()
    ///     print(str) // prints "Hello World"
    ///
    /// - Returns: 结果字符串
    @discardableResult
    func dd_trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 移除字符串前后的空格
    /// - Returns: 结果字符串
    func dd_trimmedSpace() -> String {
        let resultString = trimmingCharacters(in: CharacterSet.whitespaces)
        return resultString
    }

    /// 移除字符前后的换行符
    /// - Returns: 结果字符串
    func dd_trimmedNewLines() -> String {
        let resultString = trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }

    /// 移除字符串中的所有空格
    /// - Returns: 结果字符串
    func dd_withoutSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }

    /// 移除字符串中的所有换行符
    /// - Returns: 结果字符串
    func dd_withoutNewLines() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
    }

    /// 移除字符串中所有的空格和换行符
    ///
    ///     "   \n Swifter   \n  Swift  ".dd_withoutSpacesAndNewLines -> "SwifterSwift"
    ///
    /// - Returns: 结果字符串
    func dd_withoutSpacesAndNewLines() -> String {
        replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }

    /// 字符串的首字符大写,其它字符保持原样
    ///
    ///     "hello world".dd_firstCharacterUppercased() -> "Hello world"
    ///     "".dd_firstCharacterUppercased() -> ""
    ///
    /// - Returns: 结果字符串
    func dd_firstCharacterUppercased() -> String? {
        guard let first else { return nil }
        return String(first).uppercased() + dropFirst()
    }

    /// 将字符串反转
    /// - Returns: 结果字符串
    @discardableResult
    mutating func dd_reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }

    /// 分割字符串
    /// - Parameter char: 分割依据
    /// - Returns: 结果数组
    func dd_split(with char: String) -> [String] {
        let components = self.components(separatedBy: char)
        return components != [""] ? components : []
    }

    /// 在字符串头部填充字符串以适应长度
    ///
    ///     "hue".dd_padStart(10) -> "       hue"
    ///     "hue".dd_padStart(10, with:"br") -> "brbrbrbhue"
    ///
    /// - Note: 只有字符串小于指定长度才会发生填充
    /// - Parameters:
    ///   - length: 字符串长度
    ///   - string: 用于填充的字符串
    /// - Returns: 结果字符串
    @discardableResult
    func dd_padStart(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex ..< string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex ..< padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }

    /// 在字符串尾部填充字符串以适应长度
    ///
    ///     "hue".dd_padEnd(10) -> "hue       "
    ///     "hue".dd_padEnd(10, with:"br") -> "huebrbrbrb"
    ///
    /// - Note: 只有字符串小于指定长度才会发生填充
    /// - Parameters:
    ///   - length: 字符串长度
    ///   - string: 用于填充的字符串
    /// - Returns: 结果字符串
    @discardableResult
    func dd_padEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex ..< string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex ..< padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }

    /// 使用`template`替换`regex`匹配的项
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - template: 用于替换的字符串
    ///   - options: 匹配选项
    ///   - searchRange: 搜索范围
    /// - Returns: 结果字符串
    func dd_replacingOccurrences(of regex: NSRegularExpression,
                                 with template: String,
                                 options: NSRegularExpression.MatchingOptions = [],
                                 range searchRange: Range<String.Index>? = nil) -> String
    {
        let range = NSRange(searchRange ?? startIndex ..< endIndex, in: self)
        return regex.stringByReplacingMatches(in: self,
                                              options: options,
                                              range: range,
                                              withTemplate: template)
    }

    /// 使用`template`替换`regex`匹配的项
    /// - Parameters:
    ///   - pattern: 正则表达式
    ///   - template: 用于替换的字符串
    ///   - options: 匹配选项
    /// - Returns: 结果字符串
    func dd_replacingOccurrences(of pattern: String,
                                 with template: String,
                                 options: NSRegularExpression.Options = []) -> String
    {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self,
                                              options: [],
                                              range: NSRange(location: 0, length: count),
                                              withTemplate: template)
    }

    /// 从字符串中删除指定的前缀
    ///
    ///     "Hello, World!".dd_removePrefix("Hello, ") -> "World!"
    ///
    /// - Parameter prefix: 要从字符串中删除的前缀
    /// - Returns: 结果字符串
    func dd_removePrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    /// 从字符串中删除给定的后缀
    ///
    ///     "Hello, World!".dd_removeSuffix(", World!") -> "Hello"
    ///
    /// - Parameter suffix: 要从字符串中删除的后缀
    /// - Returns: 结果字符串
    func dd_removeSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// 为字符串添加前缀
    ///
    ///     "www.apple.com".dd_withPrefix("https://") -> "https://www.apple.com"
    ///
    /// - Parameter prefix: 前缀
    /// - Returns: 结果字符串
    func dd_withPrefix(_ prefix: String) -> String {
        guard !hasPrefix(prefix) else { return self }
        return prefix + self
    }

    /// 为字符串添加前缀
    ///
    ///     "https://www.apple".dd_withSuffix(".com") -> "https://www.apple.com"
    ///
    /// - Parameter prefix: 前缀
    /// - Returns: 结果字符串
    func dd_withSuffix(_ suffix: String) -> String {
        guard !hasSuffix(suffix) else { return self }
        return self + suffix
    }

    /// 在任意位置插入字符串
    /// - Parameters:
    ///   - content: 插入内容
    ///   - locat: 插入的位置
    /// - Returns: 结果字符串
    func dd_insertString(content: String, locat: Int) -> String {
        guard locat < count else {
            return self
        }
        let str1 = self.dd_subString(to: locat)
        let str2 = self.dd_subString(from: locat + 1)
        return str1 + content + str2
    }

    /// 替换字符串
    /// - Parameters:
    ///   - string: 被替换的字符串
    ///   - withString: 以于替换的字符串
    /// - Returns: 结果字符串
    func dd_replace(_ string: String, with withString: String) -> String {
        return self.replacingOccurrences(of: string, with: withString)
    }

    /// 隐藏字符串中的敏感内容
    ///
    ///     "012345678912".dd_hideSensitiveContent(range:3..<8, replace:"*****") -> "012*****912"
    ///
    /// - Parameters:
    ///   - range: 要隐藏的内容`Range<Int>`
    ///   - replace: 用来替换敏感内容的字符串
    /// - Returns: 结果字符串
    func dd_hideSensitiveContent(range: Range<Int>, replace: String = "****") -> String {
        if count < range.upperBound {
            return self
        }
        guard let subStr = self[safe: range] else {
            return self
        }
        return self.dd_replace(subStr, with: replace)
    }

    /// 生成指定数量的重复字符串
    /// - Parameter count: 重复个数
    /// - Returns: 结果字符串
    func dd_repeat(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }

    /// 删除字符串中指定的字符
    /// - Parameter characterString: 要删除的字符
    /// - Returns: 结果字符串
    func dd_removeCharacter(characterString: String) -> String {
        let characterSet = CharacterSet(charactersIn: characterString)
        return self.trimmingCharacters(in: characterSet)
    }

    /// 获取最长相同后缀
    /// - Parameters:
    ///   - aString: 用于与`self`比较的字符串
    ///   - options: 选项
    /// - Returns: 结果字符串
    func dd_commonSuffix(with aString: String, options: CompareOptions = []) -> String {
        return String(zip(reversed(), aString.reversed())
            .lazy
            .prefix(while: { (lhs: Character, rhs: Character) in
                return String(lhs).compare(String(rhs), options: options) == .orderedSame
            })
            .map { (lhs: Character, rhs: Character) in
                return lhs
            }
            .reversed())
    }
}

