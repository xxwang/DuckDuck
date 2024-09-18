//
//  Bool+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

// MARK: - 类型转换
public extension Bool {
    /// 转换为`Int`
    func dd_Int() -> Int {
        return self ? 1 : 0
    }

    /// 转换为`String`
    func dd_String() -> String {
        return self ? "true" : "false"
    }
}
