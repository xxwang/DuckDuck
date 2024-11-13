//
//  Collection+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Dispatch
import Foundation

// MARK: - 类型转换
public extension Collection {
    /// 集合的索引`Range`
    func dd_range() -> Range<Self.Index> {
        return self.startIndex ..< self.endIndex
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
        return self.indices.contains(index) ? self[index] : nil
    }
}

// MARK: - 方法
public extension Collection {
    /// 对集合中的每个元素执行`each`闭包
    ///
    ///     array.dd_forEachInParallel { item in
    ///           print(item)
    ///     }
    ///
    /// - Parameter each: 作用于每个元素的闭包
    func dd_forEachInParallel(_ each: (Self.Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: self.count) {
            each(self[self.index(self.startIndex, offsetBy: $0)])
        }
    }

    /// 按指定大小把一维数组分组为多维数组
    ///
    ///     [0, 2, 4, 7].dd_group(by:2) -> [[0, 2], [4, 7]]
    ///     [0, 2, 4, 7, 6].dd_group(by:2) -> [[0, 2], [4, 7], [6]]
    ///
    /// - Parameter size: 子数组的大小
    /// - Returns: 二维数组
    func dd_group(by size: Int) -> [[Self.Element]]? {
        guard size > 0, !self.isEmpty else { return nil }
        var start = self.startIndex
        var slices = [[Self.Element]]()
        while start != self.endIndex {
            let end = self.index(start, offsetBy: size, limitedBy: self.endIndex) ?? self.endIndex
            slices.append(Array(self[start ..< end]))
            start = end
        }
        return slices
    }

    /// 获取满足条件的元素索引
    ///
    ///     [1, 7, 1, 2, 4, 1, 8].dd_indices(where:{ $0 == 1 }) -> [0, 2, 5]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果数组, 没有符合条件的返回`nil`
    func dd_indices(where condition: (Self.Element) throws -> Bool) rethrows -> [Self.Index]? {
        let indices = try self.indices.filter { try condition(self[$0]) }
        return indices.isEmpty ? nil : indices
    }

    /// 为指定长度的数组切片执行`body`闭包
    ///
    ///     [0, 2, 4, 7].dd_forEach(slice:2) { print($0) } -> // print:[0, 2], [4, 7]
    ///     [0, 2, 4, 7, 6].dd_forEach(slice:2) { print($0) } -> // print:[0, 2], [4, 7], [6]
    ///
    /// - Parameters:
    ///   - slice: 切片大小
    ///   - body: 作用于切片的闭包
    func dd_forEach(slice: Int, body: ([Self.Element]) throws -> Void) rethrows {
        var start = self.startIndex
        while case let end = self.index(start, offsetBy: slice, limitedBy: self.endIndex) ?? self.endIndex,
              start != end
        {
            try body(Array(self[start ..< end]))
            start = end
        }
    }
}

// MARK: - Element:Equatable
public extension Collection where Element: Equatable {
    /// 获取数组中与指定元素相同的索引
    ///
    ///     [1, 2, 2, 3, 4, 2, 5].dd_indices(of 2) -> [1, 2, 5]
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].dd_indices(of 2.3) -> [1]
    ///     ["h", "e", "l", "l", "o"].dd_indices(of "l") -> [2, 3]
    ///
    /// - Parameter item: 要查找的元素
    /// - Returns: 结果数组
    func dd_indices(of item: Self.Element) -> [Self.Index] {
        self.indices.filter { self[$0] == item }
    }
}

// MARK: - Element:BinaryInteger
public extension Collection where Element: BinaryInteger {
    /// 计算整数数组中元素的平均值
    ///
    ///     [1, 2, 4, 3, 4].dd_average() = 2.8
    ///
    /// - Returns: 平均值
    func dd_average() -> Double {
        guard !self.isEmpty else { return .zero }
        return Double(self.reduce(.zero, +)) / Double(self.count)
    }
}

// MARK: - Element:FloatingPoint
public extension Collection where Element: FloatingPoint {
    /// 计算浮点数数组中元素的平均值
    ///
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].dd_average() = 3.18
    ///
    /// - Returns: 平均值
    func dd_average() -> Self.Element {
        guard !self.isEmpty else { return .zero }
        return self.reduce(.zero, +) / Self.Element(self.count)
    }
}

// MARK: - JSON
public extension Collection {
    /// 将集合类型转成`String`
    /// - Parameter prettify: 是否美化`JSON`样式
    /// - Returns: `String`
    func dd_String(prettify: Bool = false) -> String? {
        if let data = self.dd_Data(prettify: prettify) {
            return data.dd_String()
        }
        return nil
    }

    /// 集合类型转`Data`
    /// - Parameter prettify: 是否美化`JSON`样式
    /// - Returns: `Data`
    func dd_Data(prettify: Bool = false) -> Data? {
        let isValidJSONObject = JSONSerialization.isValidJSONObject(self)
        let options: JSONSerialization.WritingOptions = (prettify == true && isValidJSONObject) ? .prettyPrinted : []
        do {
            return try JSONSerialization.data(withJSONObject: self, options: options)
        } catch {
            return nil
        }
    }
}
