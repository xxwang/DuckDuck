//
//  Bool+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

extension Bool: DDExtensionable {}

// MARK: - 计算属性
public extension DDExtension where Base == Bool {
    /// 转换为`Int`
    var as2Int: Int {
        return self.value ? 1 : 0
    }

    /// 转换为`String`
    var as2String: String {
        return self.value ? "true" : "false"
    }
}
