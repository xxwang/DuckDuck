//
//  Character+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

extension Character: DDExtensionable {}

// MARK: - 计算属性
public extension DDExtension where Base == Character {
    /// 转换为`String`
    var as2String: String {
        return String(self.value)
    }

    /// 随机产生一个字符`(a-z | A-Z | 0-9)`
    static var random: Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}
