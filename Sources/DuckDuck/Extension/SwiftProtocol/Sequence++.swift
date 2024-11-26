//
//  Sequence++.swift
//  DuckDuck
//
//  Created by xxwang on 16/11/2024.
//

import Foundation

// MARK: - 通用方法
public extension Sequence {
    /// 检查集合中的所有元素是否满足条件
    ///
    /// - Example:
    /// ```swift
    /// [2, 2, 4].dd_allSatisfy { $0 % 2 == 0 } // true
    /// ```
    func dd_allSatisfy(_ condition: (Self.Element) throws -> Bool) rethrows -> Bool {
        try !self.contains { try !condition($0) }
    }

    /// 检查集合中是否没有元素满足条件
    ///
    /// - Example:
    /// ```swift
    /// [1, 3, 5, 7].dd_noneSatisfy { $0 % 2 == 0 } // true
    /// ```
    func dd_noneSatisfy(_ condition: (Self.Element) throws -> Bool) rethrows -> Bool {
        try !self.contains { try condition($0) }
    }

    /// 返回不满足条件的元素
    ///
    /// - Example:
    /// ```swift
    /// [2, 4, 7].dd_filterNot { $0 % 2 == 0 } // [7]
    /// ```
    func dd_filterNot(_ condition: (Self.Element) throws -> Bool) rethrows -> [Self.Element] {
        try self.filter { try !condition($0) }
    }

    /// 返回满足条件的元素个数
    ///
    /// - Example:
    /// ```swift
    /// [2, 4, 7].dd_count(where: { $0 % 2 == 0 }) // 2
    /// ```
    func dd_count(where condition: (Self.Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self where try condition(element) {
            count += 1
        }
        return count
    }

    /// 反向迭代集合
    ///
    /// - Example:
    /// ```swift
    /// [0, 2, 4].dd_forEachReversed { print($0) } // 打印顺序：4, 2, 0
    /// ```
    func dd_forEachReversed(_ body: (Self.Element) throws -> Void) rethrows {
        try self.reversed().forEach(body)
    }

    /// 对满足条件的元素执行操作
    ///
    /// - Example:
    /// ```swift
    /// [0, 2, 4, 7].dd_forEach(where: { $0 % 2 == 0 }) { print($0) } // 打印：0, 2, 4
    /// ```
    func dd_forEach(where condition: (Self.Element) throws -> Bool, _ body: (Self.Element) throws -> Void) rethrows {
        try self.lazy.filter(condition).forEach(body)
    }

    /// 累积操作并返回结果数组
    ///
    /// - Example:
    /// ```swift
    /// [1, 2, 3].dd_accumulate(initial: 0, +) // [1, 3, 6]
    /// ```
    func dd_accumulate<U>(initial: U, _ next: (U, Self.Element) throws -> U) rethrows -> [U] {
        var runningTotal = initial
        return try self.map { element in
            runningTotal = try next(runningTotal, element)
            return runningTotal
        }
    }

    /// 查找符合条件的唯一元素
    ///
    /// - Example:
    /// ```swift
    /// [4].dd_single(where: { $0 % 2 == 0 }) // 4
    /// ```
    func dd_single(where condition: (Self.Element) throws -> Bool) rethrows -> Self.Element? {
        var singleElement: Self.Element?
        for element in self where try condition(element) {
            guard singleElement == nil else {
                singleElement = nil
                break
            }
            singleElement = element
        }
        return singleElement
    }

    /// 根据条件分割集合
    ///
    /// - Example:
    /// ```swift
    /// let (even, odd) = [0, 1, 2, 3].dd_partition(by: { $0 % 2 == 0 })
    /// ```
    func dd_partition(by condition: (Self.Element) throws -> Bool) rethrows -> (matching: [Self.Element], nonMatching: [Self.Element]) {
        var matching = [Self.Element]()
        var nonMatching = [Self.Element]()
        for element in self {
            try condition(element) ? matching.append(element) : nonMatching.append(element)
        }
        return (matching, nonMatching)
    }

    /// 根据 KeyPath 求和
    ///
    /// - Example:
    /// ```swift
    /// struct Item { let value: Int }
    /// let items = [Item(value: 2), Item(value: 4)]
    /// items.dd_sum(of: \.value) // 6
    /// ```
    func dd_sum<T: AdditiveArithmetic>(of keyPath: KeyPath<Self.Element, T>) -> T {
        self.reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }
}

// MARK: - Element: Equatable
public extension Sequence where Element: Equatable {
    /// 检查是否包含另一个数组的所有元素
    ///
    /// - Example:
    /// ```swift
    /// [1, 2, 3].dd_containsAll([1, 3]) // true
    /// ```
    func dd_containsAll(_ elements: [Self.Element]) -> Bool {
        elements.allSatisfy { self.contains($0) }
    }
}

// MARK: - Element: Hashable
public extension Sequence where Element: Hashable {
    /// 检查是否包含重复项
    ///
    /// - Example:
    /// ```swift
    /// [1, 2, 2, 3].dd_hasDuplicates() // true
    /// ```
    func dd_hasDuplicates() -> Bool {
        var set = Set<Self.Element>()
        for element in self {
            if !set.insert(element).inserted {
                return true
            }
        }
        return false
    }

    /// 获取数组中的重复元素
    ///
    /// - Example:
    /// ```swift
    /// [1, 1, 2, 3, 3].dd_findDuplicates() // [1, 3]
    /// ```
    func dd_findDuplicates() -> [Self.Element] {
        var set = Set<Self.Element>()
        var duplicates = Set<Self.Element>()
        for element in self {
            if !set.insert(element).inserted {
                duplicates.insert(element)
            }
        }
        return Array(duplicates)
    }
}

// MARK: - Element: AdditiveArithmetic
public extension Sequence where Element: AdditiveArithmetic {
    /// 求数组元素的总和
    ///
    /// - Example:
    /// ```swift
    /// [1, 2, 3].dd_sum() // 6
    /// ```
    func dd_sum() -> Self.Element {
        self.reduce(.zero, +)
    }
}
