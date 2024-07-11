//
//  Sequence+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

public extension Sequence {
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }
}

// MARK: - 方法
public extension DDExtension where Base: Sequence {
    /// 检查集合中的所有元素是否符合条件
    ///
    ///     [2, 2, 4].dd.all(matching:{$0 % 2 == 0}) -> true
    ///     [2, 2, 4].dd.all(matching:{$0 % 2 == 0}) -> true
    ///
    /// - Parameter condition: 条件
    /// - Returns: 是否符合
    func all(matching condition: (Base.Element) throws -> Bool) rethrows -> Bool {
        try !self.base.contains { try !condition($0) }
    }

    /// 检查集合中是否所有元素都不符合条件
    ///
    ///     [2, 2, 4].dd.none(matching:{$0 % 2 == 0}) -> false
    ///     [1, 3, 5, 7].dd.none(matching:{$0 % 2 == 0}) -> true
    ///
    /// - Parameter condition: 条件
    /// - Returns: 是否不符合
    func none(matching condition: (Base.Element) throws -> Bool) rethrows -> Bool {
        try !self.base.contains { try condition($0) }
    }

    /// 检查集合中是否有任意元素匹配条件(全部不匹配,返回false)
    ///
    ///     [1, 3, 2, 2, 4].dd.any(matching:{$0 % 2 == 0}) -> true
    ///     [1, 3, 5, 7].dd.any(matching:{$0 % 2 == 0}) -> false
    ///
    /// - Parameter condition: 条件
    /// - Returns: 是否符合
    func any(matching condition: (Base.Element) throws -> Bool) rethrows -> Bool {
        try self.base.contains { try condition($0) }
    }

    /// 返回不符合条件的元素
    ///
    ///     [2, 2, 4, 7].dd.reject(where:{$0 % 2 == 0}) -> [7]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果数组
    func reject(where condition: (Base.Element) throws -> Bool) rethrows -> [Base.Element] {
        try self.base.filter { try !condition($0) }
    }

    /// 返回满足条件的元素个数
    ///
    ///     [2, 2, 4, 7].dd.count(where:{$0 % 2 == 0}) -> 3
    ///
    /// - Parameter condition: 条件
    /// - Returns: 符合条件的元素个数
    func count(where condition: (Base.Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self.base where try condition(element) {
            count += 1
        }
        return count
    }

    /// 反向迭代集合(从右到左)
    ///
    ///     [0, 2, 4, 7].dd.forEachReversed({ print($0)}) -> // Order of print:7,4,2,0
    ///
    /// - Parameter body: 作用于元素的闭包
    func forEachReversed(_ body: (Base.Element) throws -> Void) rethrows {
        try self.base.reversed().forEach(body)
    }

    /// 为`condition`条件为真的结果执行`body`闭包
    ///
    ///     [0, 2, 4, 7].forEach(where:{$0 % 2 == 0}, body:{ print($0)}) -> // print:0, 2, 4
    ///
    /// - Parameters:
    ///   - condition: 条件
    ///   - body: 作用于`condition`结果中每个元素的闭包
    func forEach(where condition: (Base.Element) throws -> Bool, body: (Base.Element) throws -> Void) rethrows {
        try self.base.lazy.filter(condition).forEach(body)
    }

    /// 积累操作, 操作结果作为返回结果数组元素
    ///
    ///     [1, 2, 3].accumulate(initial:0, next:+) -> [1, 3, 6]
    ///
    /// - Parameters:
    ///   - initial: 初始值
    ///   - next: 作用于元素的闭包
    /// - Returns: 最终累积值组合的数组
    func accumulate<U>(initial: U, next: (U, Base.Element) throws -> U) rethrows -> [U] {
        var runningTotal = initial
        return try self.base.map { element in
            runningTotal = try next(runningTotal, element)
            return runningTotal
        }
    }

    /// 过滤元素并为每个结果元素执行闭包
    ///
    ///     [1,2,3,4,5].filtered({ $0 % 2 == 0 }, map:{ $0.string }) -> ["2", "4"]
    ///
    /// - Parameters:
    ///   - isIncluded: 过滤元素的条件
    ///   - transform: 作用于过滤结果元素的闭包
    /// - Returns: 返回一个经过过滤和映射的数组
    func filtered<T>(_ isIncluded: (Base.Element) throws -> Bool, map transform: (Base.Element) throws -> T) rethrows -> [T] {
        try self.base.lazy.filter(isIncluded).map(transform)
    }

    /// 查找符合条件的元素,且元素唯一才返回元素,否则为`nil`
    ///
    ///     [].single(where:{_ in true}) -> nil
    ///     [4].single(where:{_ in true}) -> 4
    ///     [1, 4, 7].single(where:{$0 % 2 == 0}) -> 4
    ///     [2, 2, 4, 7].single(where:{$0 % 2 == 0}) -> nil
    ///
    /// - Parameter condition: 条件
    /// - Returns: 查找结果
    func single(where condition: (Base.Element) throws -> Bool) rethrows -> Base.Element? {
        var singleElement: Base.Element?
        for element in self.base where try condition(element) {
            guard singleElement == nil else {
                singleElement = nil
                break
            }
            singleElement = element
        }
        return singleElement
    }

    /// 根据条件删除重复元素
    ///
    ///     [1, 2, 1, 3, 2].withoutDuplicates { $0 } -> [1, 2, 3]
    ///     [(1, 4), (2, 2), (1, 3), (3, 2), (2, 1)].withoutDuplicates { $0.0 } -> [(1, 4), (2, 2), (3, 2)]
    ///
    /// - Parameter transform: 条件
    /// - Returns: 结果数组
    func withoutDuplicates<T: Hashable>(transform: (Base.Element) throws -> T) rethrows -> [Base.Element] {
        var set = Set<T>()
        return try self.base.filter { try set.insert(transform($0)).inserted }
    }

    /// 根据条件把元素分割为两个数组
    ///
    ///     let (even, odd) = [0, 1, 2, 3, 4, 5].divided { $0 % 2 == 0 }
    ///     let (minors, adults) = people.divided { $0.age < 18 }
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果元组
    func divided(by condition: (Base.Element) throws -> Bool) rethrows -> (matching: [Base.Element], nonMatching: [Base.Element]) {
        var matching = [Base.Element]()
        var nonMatching = [Base.Element]()

        for element in self.base {
            try condition(element) ? matching.append(element) : nonMatching.append(element)
        }
        return (matching, nonMatching)
    }

    /// 根据`keyPath`与条件排序
    /// - Parameters:
    ///   - keyPath: 排序依据`keyPath`
    ///   - compare: 排序条件
    /// - Returns: 排序后的数组
    func sorted<T>(by keyPath: KeyPath<Base.Element, T>, with compare: (T, T) -> Bool) -> [Base.Element] {
        self.base.sorted { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    /// 根据`keyPath`排序(升序)
    /// - Parameter keyPath: 排序依据`keyPath`
    /// - Returns: 排序后的数组
    func sorted(by keyPath: KeyPath<Base.Element, some Comparable>) -> [Base.Element] {
        self.base.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    /// 根据两个`keyPath`进行排序(如果第一个`keyPath`对应元素相等就使用第二个`keyPath`)
    /// - Parameters:
    ///   - keyPath1: 排序依据`keyPath`
    ///   - keyPath2: 排序依据`keyPath`
    /// - Returns: 排序后的数组
    func sorted(by keyPath1: KeyPath<Base.Element, some Comparable>, and keyPath2: KeyPath<Base.Element, some Comparable>) -> [Base.Element] {
        self.base.sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    /// 根据两个`keyPath`进行排序(如果第一个`keyPath`对应元素相等就使用第二个`keyPath`....)
    /// - Parameters:
    ///   - keyPath1: 排序依据`keyPath`
    ///   - keyPath2: 排序依据`keyPath`
    ///   - keyPath3: 排序依据`keyPath`
    /// - Returns: 排序后的数组
    func sorted(by keyPath1: KeyPath<Base.Element, some Comparable>,
                and keyPath2: KeyPath<Base.Element, some Comparable>,
                and keyPath3: KeyPath<Base.Element, some Comparable>) -> [Base.Element]
    {
        self.base.sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            if $0[keyPath: keyPath2] != $1[keyPath: keyPath2] {
                return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
            }
            return $0[keyPath: keyPath3] < $1[keyPath: keyPath3]
        }
    }

    /// 根据数组元素的`keyPath`求合,元素需要符合`AdditiveArithmetic`
    /// - Parameter keyPath: 元素`keyPath`
    /// - Returns: 求合结果
    func sum<T: AdditiveArithmetic>(for keyPath: KeyPath<Base.Element, T>) -> T {
        self.base.reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }

    /// 返回序列中第一个`keyPath`等于`value`的元素
    /// - Parameters:
    ///   - keyPath: keyPath
    ///   - value: 与 `Element` 属性比较的值
    /// - Returns: 相等的元素,没有符合的元素返回`nil`
    func first<T: Equatable>(where keyPath: KeyPath<Base.Element, T>, equals value: T) -> Base.Element? {
        self.base.first { $0[keyPath: keyPath] == value }
    }
}

// MARK: - Element:Equatable
public extension DDExtension where Base: Sequence, Base.Element: Equatable {
    /// 检查数组是否完全包含`elements`数组
    ///
    ///     [1, 2, 3, 4, 5].dd.contains([1, 2]) -> true
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].dd.contains([2, 6]) -> false
    ///     ["h", "e", "l", "l", "o"].dd.contains(["l", "o"]) -> true
    ///
    /// - Parameter elements: 要检查的元素数组
    /// - Returns: 检查结果
    func contains(_ elements: [Base.Element]) -> Bool {
        elements.allSatisfy { self.base.contains($0) }
    }
}

// MARK: - Element:Hashable
public extension DDExtension where Base: Sequence, Base.Element: Hashable {
    /// 检查数组是否完全包含`elements`数组(会排除数组中的相同元素之后再检查)
    ///
    ///     [1, 2, 3, 4, 5].dd.contains([1, 2]) -> true
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].dd.contains([2, 6]) -> false
    ///     ["h", "e", "l", "l", "o"].dd.contains(["l", "o"]) -> true
    ///
    /// - Parameter elements: 要检查的元素数组
    /// - Returns: 检查结果
    func contains(_ elements: [Base.Element]) -> Bool {
        let set = Set(self.base)
        return elements.allSatisfy { set.contains($0) }
    }

    /// 检查序列是否包含重复项
    /// - Returns: 是否包含重复项
    func containsDuplicates() -> Bool {
        var set = Set<Base.Element>()
        for element in self.base {
            if !set.insert(element).inserted {
                return true
            }
        }
        return false
    }

    /// 获取序列中的重复元素
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].dd.duplicates().sorted() -> [1, 2, 3])
    ///     ["h", "e", "l", "l", "o"].dd.duplicates().sorted() -> ["l"])
    ///
    /// - Returns: 重复元素的数组
    func duplicates() -> [Base.Element] {
        var set = Set<Base.Element>()
        var duplicates = Set<Base.Element>()
        for item in self.base {
            if !set.insert(item).inserted {
                duplicates.insert(item)
            }
        }
        return Array(duplicates)
    }
}

// MARK: - Element:AdditiveArithmetic
public extension DDExtension where Base: Sequence, Base.Element: AdditiveArithmetic {
    /// 求数组中所有元素的和
    ///
    ///     [1, 2, 3, 4, 5].dd.sum() -> 15
    ///
    /// - Returns: 求合结果
    func sum() -> Base.Element {
        self.base.reduce(.zero, +)
    }
}
