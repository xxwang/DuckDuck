//
//  Array+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - 下标
public extension Array {
    /// 使用索引数组作为下标,获取或设置数组数据
    ///
    ///     let arr = [1,2,3,4,5,6]
    ///     let data = arr[indexs: [1,2,3]] // 1,2,3
    ///     arr[indexs: [1,2,3]] = [3,2,1] // [3,2,1,4,5,6]
    ///
    /// - Parameter input: 下标数组
    /// - Returns: 结果数组切片
    subscript(indexs input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < count && i >= 0, "index out of range")
                result.append(self[i])
            }
            return result
        }

        set {
            for (index, i) in input.enumerated() {
                assert(i < count && i >= 0, "index out of range")
                self[i] = newValue[index]
            }
        }
    }
}
