//
//  Character+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

// MARK: - 类型转换
public extension Character {
    /// 转换为`String`
    func dd_String() -> String {
        return String(self)
    }
}

//MARK: - 静态方法
public extension Character {
    /// 随机产生一个字符`(a-z | A-Z | 0-9)`
    static func dd_random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}
