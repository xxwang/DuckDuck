//
//  MutableCollection++.swift
//  DuckDuck
//
//  Created by xxwang on 16/11/2024.
//

import Foundation

// MARK: - 方法扩展
public extension MutableCollection {
    /// 为集合中所有元素的指定 `keyPath` 赋值
    ///
    /// - Example:
    /// ```swift
    /// struct Item {
    ///     var name: String
    /// }
    ///
    /// var items = [Item(name: "A"), Item(name: "B")]
    /// items.dd_assign(to: "Default", for: \.name)
    /// print(items) // 输出: [Item(name: "Default"), Item(name: "Default")]
    /// ```
    /// - Parameters:
    ///   - value: 要赋的值
    ///   - keyPath: 要赋值的 `keyPath`
    mutating func dd_assign<Value>(to value: Value, for keyPath: WritableKeyPath<Element, Value>) {
        for index in indices {
            self[index][keyPath: keyPath] = value
        }
    }
}

// MARK: - 排序扩展
public extension MutableCollection where Self: RandomAccessCollection {
    /// 根据指定的 `keyPath` 和比较函数对集合进行排序
    ///
    /// - Example:
    /// ```swift
    /// struct Item {
    ///     var value: Int
    /// }
    ///
    /// var items = [Item(value: 3), Item(value: 1), Item(value: 2)]
    /// items.dd_sort(by: \.value, with: >)
    /// print(items) // 输出: [Item(value: 3), Item(value: 2), Item(value: 1)]
    /// ```
    /// - Parameters:
    ///   - keyPath: 要排序的 `keyPath`
    ///   - compare: 自定义比较函数
    mutating func dd_sort<T>(by keyPath: KeyPath<Element, T>, with compare: (T, T) -> Bool) {
        self.sort { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    /// 根据指定的 `keyPath` 对集合进行升序排序
    ///
    /// - Example:
    /// ```swift
    /// struct Item {
    ///     var value: Int
    /// }
    ///
    /// var items = [Item(value: 3), Item(value: 1), Item(value: 2)]
    /// items.dd_sort(by: \.value)
    /// print(items) // 输出: [Item(value: 1), Item(value: 2), Item(value: 3)]
    /// ```
    /// - Parameter keyPath: 要排序的 `keyPath`
    mutating func dd_sort(by keyPath: KeyPath<Element, some Comparable>) {
        self.sort { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    /// 根据两个 `keyPath` 对集合进行多条件排序
    ///
    /// - Example:
    /// ```swift
    /// struct Item {
    ///     var priority: Int
    ///     var name: String
    /// }
    ///
    /// var items = [Item(priority: 2, name: "B"), Item(priority: 1, name: "A"), Item(priority: 2, name: "A")]
    /// items.dd_sort(by: \.priority, and: \.name)
    /// print(items) // 输出: [Item(priority: 1, name: "A"), Item(priority: 2, name: "A"), Item(priority: 2, name: "B")]
    /// ```
    /// - Parameters:
    ///   - keyPath1: 第一个排序依据
    ///   - keyPath2: 第二个排序依据
    mutating func dd_sort(by keyPath1: KeyPath<Element, some Comparable>, and keyPath2: KeyPath<Element, some Comparable>) {
        self.sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    /// 根据三个 `keyPath` 对集合进行多条件排序
    ///
    /// - Example:
    /// ```swift
    /// struct Item {
    ///     var priority: Int
    ///     var name: String
    ///     var id: Int
    /// }
    ///
    /// var items = [Item(priority: 2, name: "B", id: 1), Item(priority: 2, name: "A", id: 3), Item(priority: 1, name: "A", id: 2)]
    /// items.dd_sort(by: \.priority, and: \.name, and: \.id)
    /// print(items) // 输出: [Item(priority: 1, name: "A", id: 2), Item(priority: 2, name: "A", id: 3), Item(priority: 2, name: "B", id: 1)]
    /// ```
    /// - Parameters:
    ///   - keyPath1: 第一个排序依据
    ///   - keyPath2: 第二个排序依据
    ///   - keyPath3: 第三个排序依据
    mutating func dd_sort(by keyPath1: KeyPath<Element, some Comparable>, and keyPath2: KeyPath<Element, some Comparable>, and keyPath3: KeyPath<Element, some Comparable>) {
        self.sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            if $0[keyPath: keyPath2] != $1[keyPath: keyPath2] {
                return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
            }
            return $0[keyPath: keyPath3] < $1[keyPath: keyPath3]
        }
    }
}
