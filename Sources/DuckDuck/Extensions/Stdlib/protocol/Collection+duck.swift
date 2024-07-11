//
//  Collection+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Dispatch
import Foundation

public extension Collection {
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }
}

// MARK: - 计算属性
public extension DDExtension where Base: Collection {
    /// 集合的索引`Range`
    var range: Range<Base.Index> {
        return self.base.startIndex ..< self.base.endIndex
    }
}

// MARK: - 下标
public extension Collection {
    /// 从集合中安全的读取数据(越界返回`nil`)
    ///
    ///     let arr = [1, 2, 3, 4, 5]
    ///     arr[safe:1] -> 2
    ///     arr[safe:10] -> nil
    ///
    /// - Parameter index: 元素下标索引
    /// - Returns: 下标对应元素
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - 方法
public extension DDExtension where Base: Collection {
    /// 对集合中的每个元素执行`each`闭包
    ///
    ///     array.pd_forEachInParallel { item in
    ///           print(item)
    ///     }
    ///
    /// - Parameter each: 作用于每个元素的闭包
    func forEachInParallel(_ each: (Base.Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: self.base.count) {
            each(self.base[self.base.index(self.base.startIndex, offsetBy: $0)])
        }
    }

    /// 按指定大小把一维数组分组为多维数组
    ///
    ///     [0, 2, 4, 7].dd.group(by:2) -> [[0, 2], [4, 7]]
    ///     [0, 2, 4, 7, 6].dd.group(by:2) -> [[0, 2], [4, 7], [6]]
    ///
    /// - Parameter size: 子数组的大小
    /// - Returns: 二维数组
    func group(by size: Int) -> [[Base.Element]]? {
        guard size > 0, !self.base.isEmpty else { return nil }
        var start = self.base.startIndex
        var slices = [[Base.Element]]()
        while start != self.base.endIndex {
            let end = self.base.index(start, offsetBy: size, limitedBy: self.base.endIndex) ?? self.base.endIndex
            slices.append(Array(self.base[start ..< end]))
            start = end
        }
        return slices
    }

    /// 获取满足条件的元素索引
    ///
    ///     [1, 7, 1, 2, 4, 1, 8].dd.indices(where:{ $0 == 1 }) -> [0, 2, 5]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果数组, 没有符合条件的返回`nil`
    func indices(where condition: (Base.Element) throws -> Bool) rethrows -> [Base.Index]? {
        let indices = try self.base.indices.filter { try condition(self.base[$0]) }
        return indices.isEmpty ? nil : indices
    }

    /// 为指定长度的数组切片执行`body`闭包
    ///
    ///     [0, 2, 4, 7].dd.forEach(slice:2) { print($0) } -> // print:[0, 2], [4, 7]
    ///     [0, 2, 4, 7, 6].dd.forEach(slice:2) { print($0) } -> // print:[0, 2], [4, 7], [6]
    ///
    /// - Parameters:
    ///   - slice: 切片大小
    ///   - body: 作用于切片的闭包
    func forEach(slice: Int, body: ([Base.Element]) throws -> Void) rethrows {
        var start = self.base.startIndex
        while case let end = self.base.index(start, offsetBy: slice, limitedBy: self.base.endIndex) ?? self.base.endIndex,
              start != end
        {
            try body(Array(self.base[start ..< end]))
            start = end
        }
    }
}

// MARK: - Element:Equatable
public extension DDExtension where Base: Collection, Base.Element: Equatable {
    /// 获取数组中与指定元素相同的索引
    ///
    ///     [1, 2, 2, 3, 4, 2, 5].dd.indices(of 2) -> [1, 2, 5]
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].dd.indices(of 2.3) -> [1]
    ///     ["h", "e", "l", "l", "o"].dd.indices(of "l") -> [2, 3]
    ///
    /// - Parameter item: 要查找的元素
    /// - Returns: 结果数组
    func pd_indices(of item: Base.Element) -> [Base.Index] {
        self.base.indices.filter { self.base[$0] == item }
    }
}

// MARK: - Element:BinaryInteger
public extension DDExtension where Base: Collection, Base.Element: BinaryInteger {
    /// 计算整数数组中元素的平均值
    ///
    ///     [1, 2, 4, 3, 4].dd.average() = 2.8
    ///
    /// - Returns: 平均值
    func average() -> Double {
        guard !self.base.isEmpty else { return .zero }
        return Double(self.base.reduce(.zero, +)) / Double(self.base.count)
    }
}

// MARK: - Element:FloatingPoint
public extension DDExtension where Base: Collection, Base.Element: FloatingPoint {
    /// 计算浮点数数组中元素的平均值
    ///
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].dd.average() = 3.18
    ///
    /// - Returns: 平均值
    func average() -> Base.Element {
        guard !self.base.isEmpty else { return .zero }
        return self.base.reduce(.zero, +) / Base.Element(self.base.count)
    }
}
