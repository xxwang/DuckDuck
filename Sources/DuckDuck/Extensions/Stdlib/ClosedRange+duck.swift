//
//  ClosedRange+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

// MARK: - 类型转换
public extension ClosedRange<Int> {
    /// 转换为索引数组
    func dd_indexs() -> [Int] {
        return self.map { $0 }
    }
}
