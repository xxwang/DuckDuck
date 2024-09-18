//
//  CountableRange+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

// MARK: - 类型转换
public extension CountableRange<Int> {
    /// 转换为索引数组
    var dd_indexs: [Int] {
        return self.map { $0 }
    }
}
