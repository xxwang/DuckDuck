//
//  ClosedRange+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

// MARK: - 计算属性
public extension DDExtension where Base == ClosedRange<Int> {
    /// 转换为索引数组
    var as2Indexs: [Int] {
        return self.base.map { $0 }
    }
}
