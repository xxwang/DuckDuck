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

// MARK: - 方法
public extension Array {
    /// 安全的取某个索引的值(索引越界返回`nil`)
    /// - Parameter index: 元素索引
    /// - Returns: 索引对应的元素
    func dd_value(of index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    /// 添加数组的所有元素到当前数组中
    /// - Parameter elements: 要添加的数组
    mutating func dd_append(_ elements: [Element]) {
        for element in elements {
            self.append(element)
        }
    }

    /// 把相邻的符合条件的元素放到一个数组中
    ///
    ///     let array: [Int] = [1, 2, 2, 2, 3, 4, 4]
    ///     array.dd_split(where: ==) // [[1], [2, 2, 2], [3], [4, 4]]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果数组
    func dd_split(where condition: (Element, Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = self.isEmpty ? [] : [[self[0]]]
        for (previous, current) in zip(self, dropFirst()) {
            if condition(previous, current) {
                result[result.endIndex - 1].append(current)
            } else {
                result.append([current])
            }
        }
        return result
    }

    /// 按指定`size`把数组分段,并组装为二维数组
    /// - Parameter size: 子数组大小
    /// - Returns: 结果数组
    func dd_split(size: Int) -> [[Element]] {
        if self.count <= size {
            return [self]
        }

        let subCount = self.count % size == 0 ? (self.count / size) : (self.count / size + 1)
        var superArray: [[Element]] = []

        for i in 0 ..< subCount {
            var subArr: [Element] = []
            for j in 0 ..< size {
                let index = i * size + j
                if index < self.count {
                    let ele = self[index]
                    subArr.append(ele)
                } else {
                    break
                }
            }
            superArray.append(subArr)
        }
        return superArray
    }

    /// 插入元素到数组的头部
    ///
    ///     [2, 3, 4, 5].dd_prepend(1) -> [1, 2, 3, 4, 5]
    ///     ["e", "l", "l", "o"].dd_prepend("h") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement:要插入的元素
    mutating func dd_prepend(_ newElement: Element) {
        self.insert(newElement, at: 0)
    }

    /// 交换指定位置的两个元素
    ///
    ///     [1, 2, 3, 4, 5].dd_swap(from:3, to:0) -> [4, 2, 3, 1, 5]
    ///     ["h", "e", "l", "l", "o"].dd_swap(from:1, to:0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index:第一个元素位置
    ///   - otherIndex:第二个元素位置
    mutating func dd_swap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex ..< endIndex ~= index else { return }
        guard startIndex ..< endIndex ~= otherIndex else { return }
        self.swapAt(index, otherIndex)
    }
}

// MARK: - 排序
public extension Array {
    /// 根据指定的`otherArray`数组与`keyPath`对数组进行排序
    ///
    ///     [MyStruct(x:3), MyStruct(x:1), MyStruct(x:2)].dd_sorted(like:[1, 2, 3], keyPath:\.x)
    ///     -> [MyStruct(x:1), MyStruct(x:2), MyStruct(x:3)]
    ///
    /// - Parameters:
    ///   - otherArray: 排序依据索引数组
    ///   - keyPath: 排序依据`keyPath`
    /// - Returns: 排序完的数组
    func dd_sorted<T: Hashable>(like otherArray: [T], keyPath: KeyPath<Element, T>) -> [Element] {
        let dict = otherArray.enumerated().reduce(into: [:]) { $0[$1.element] = $1.offset }
        return sorted {
            guard let thisIndex = dict[$0[keyPath: keyPath]] else { return false }
            guard let otherIndex = dict[$1[keyPath: keyPath]] else { return true }
            return thisIndex < otherIndex
        }
    }
}

// MARK: - Element == String
public extension [String] {
    /// 数组转字符转
    ///
    ///     ["1", "2", "3"].dd_string(separator: "-") //"1-2-3"
    ///
    /// - Parameter separator: 分割符
    /// - Returns: 结果字符串
    func dd_string(separator: String = "") -> String {
        return self.joined(separator: separator)
    }
}

// MARK: - Element:Equatable
public extension Array where Element: Equatable {
    /// 获取数组中的指定元素的索引值
    /// - Parameter item:元素
    /// - Returns:索引数组
    func dd_indexes(_ item: Element) -> [Int] {
        var indexes = [Int]()
        for index in 0 ..< count where self[index] == item {
            indexes.append(index)
        }
        return indexes
    }

    /// 获取元素首次出现的位置
    /// - Parameter item: 元素
    /// - Returns: 元素索引
    func dd_firstIndex(_ item: Element) -> Int? {
        for (index, value) in enumerated() where value == item {
            return index
        }
        return nil
    }

    /// 获取元素最后出现的位置
    /// - Parameter item: 元素
    /// - Returns: 元素索引
    func dd_lastIndex(_ item: Element) -> Int? {
        return self.dd_indexes(item).last
    }

    /// 返回序列中`keyPath`等于`value`的最后一个元素
    /// - Parameters:
    ///   - keyPath: 比较依据
    ///   - value: 要比较的`value`
    /// - Returns: 返回符合条件的元素(没有返回`nil`)
    func dd_last<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        last { $0[keyPath: keyPath] == value }
    }

    /// 反序删除数组中的指定元素
    /// - Parameter object: 要删除的元素
    mutating func dd_remove(_ object: Element) {
        for idx in self.dd_indexes(object).reversed() {
            remove(at: idx)
        }
    }

    /// 删除数组中的指定元素(默认删除第一个)
    /// - Parameters:
    ///   - element: 要删除的元素
    ///   - isRepeat: 是否删除指定的所有元素
    /// - Returns: 结果数组
    @discardableResult
    mutating func dd_remove(_ element: Element, isRepeat: Bool = true) -> Array {
        var removeIndexs: [Int] = []

        for i in 0 ..< count {
            if self[i] == element {
                removeIndexs.append(i)
                if !isRepeat { break }
            }
        }
        // 倒序删除
        for index in removeIndexs.reversed() {
            remove(at: index)
        }
        return self
    }

    /// 从数组中删除在`elements`数组中出现的元素(默认删除第一个出现的)
    /// - Parameters:
    ///   - elements: 要删除的元素数组
    ///   - isRepeat: 是否删除指定的所有元素
    /// - Returns: 结果数组
    @discardableResult
    mutating func dd_removeArray(_ elements: [Element], isRepeat: Bool = true) -> Array {
        for element in elements {
            if contains(element) { self.dd_remove(element, isRepeat: isRepeat) }
        }
        return self
    }

    /// 删除数组中指定的所有元素
    ///
    ///     [1, 2, 2, 3, 4, 5].dd_removeAll(2) -> [1, 3, 4, 5]
    ///     ["h", "e", "l", "l", "o"].dd_removeAll("l") -> ["h", "e", "o"]
    ///
    /// - Parameter item: 要删除的元素
    /// - Returns: 结果数组
    @discardableResult
    mutating func dd_removeAll(_ item: Element) -> [Element] {
        removeAll(where: { $0 == item })
        return self
    }

    /// 删除指定数组中的所有元素
    ///
    ///     [1, 2, 2, 3, 4, 5].dd_removeAll([2,5]) -> [1, 3, 4]
    ///     ["h", "e", "l", "l", "o"].dd_removeAll(["l", "h"]) -> ["e", "o"]
    ///
    /// - Parameter items: 要删除的元素数组
    /// - Returns: 结果数组
    @discardableResult
    mutating func dd_removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }

    /// 删除数组中的重复元素
    ///
    ///     [1, 2, 2, 3, 4, 5].dd_removeDuplicates() -> [1, 2, 3, 4, 5]
    ///     ["h", "e", "l", "l", "o"]. dd_removeDuplicates() -> ["h", "e", "l", "o"]
    ///
    /// - Returns: 结果数组
    @discardableResult
    mutating func dd_removeDuplicates() -> [Element] {
        self = reduce(into: [Element]()) {
            if !$0.contains($1) { $0.append($1) }
        }
        return self
    }

    /// 删除数组中的重复元素(不修改当前数组, 只是返回删除后的数组)
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].dd_withoutDuplicates() -> [1, 2, 3, 4, 5])
    ///     ["h", "e", "l", "l", "o"].dd_withoutDuplicates() -> ["h", "e", "l", "o"])
    ///
    /// - Returns: 结果数组
    func dd_withoutDuplicates() -> [Element] {
        reduce(into: [Element]()) {
            if !$0.contains($1) { $0.append($1) }
        }
    }

    /// 根据`keyPath`删除重复元素(不修改当前数组, 只是返回删除后的数组)
    /// - Parameter path: 删除依据`keyPath`
    /// - Returns: 结果数组
    func dd_withoutDuplicates(keyPath path: KeyPath<Element, some Equatable>) -> [Element] {
        reduce(into: [Element]()) { result, element in
            if !result.contains(where: { $0[keyPath: path] == element[keyPath: path] }) {
                result.append(element)
            }
        }
    }

    /// 根据`keyPath`删除重复元素(不修改当前数组, 只是返回删除后的数组)
    /// - Parameter path: 删除依据`keyPath`
    /// - Returns: 结果数组
    func dd_withoutDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        var set = Set<E>()
        return filter { set.insert($0[keyPath: path]).inserted }
    }
}

// MARK: - Element: NSObjectProtocol
public extension Array where Element: NSObjectProtocol {
    /// 删除数组中符合`object`的元素
    /// - Parameters:
    ///   - object: 删除依据
    ///   - isRepeat: 是否重复删除
    /// - Returns: 结果数组
    @discardableResult
    mutating func dd_remove(object: NSObjectProtocol, isRepeat: Bool = true) -> Array {
        var removeIndexs: [Int] = []
        for i in 0 ..< count {
            if self[i].isEqual(object) {
                removeIndexs.append(i)
                if !isRepeat { break }
            }
        }
        for index in removeIndexs.reversed() {
            remove(at: index)
        }
        return self
    }

    /// 删除数组中符合`objects`的元素
    /// - Parameters:
    ///   - objects: 删除依据
    ///   - isRepeat: 是否重复删除
    /// - Returns: 结果数组
    @discardableResult
    mutating func dd_removeArray(objects: [NSObjectProtocol], isRepeat: Bool = true) -> Array {
        for object in objects {
            if contains(where: { $0.isEqual(object) }) {
                self.dd_remove(object: object, isRepeat: isRepeat)
            }
        }
        return self
    }
}

// MARK: - 方法(数组:Element:NSAttributedString)
public extension Array where Element: NSAttributedString {
    /// 拼接数组元素为`NSAttributedString`并使用`separator`分割
    /// - Parameter separator: `NSAttributedString`分割符
    /// - Returns: `NSAttributedString`
    func dd_joined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = first else { return "".dd_NSAttributedString() }
        return dropFirst()
            .reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
                result.append(separator)
                result.append(element)
            }
    }

    /// 拼接数组元素为`NSAttributedString`并使用`separator`分割
    /// - Parameter separator: `String`分割符
    /// - Returns: `NSAttributedString`
    func dd_joined(separator: String) -> NSAttributedString {
        let separator = NSAttributedString(string: separator)
        return dd_joined(separator: separator)
    }
}

// MARK: - Array<Encodable>
public extension Array where Element: Encodable {
    /// 将`Array<Encodable>`的数组转换为`Data`
    /// - Returns: `Data`
    func dd_Data() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }

    /// 将`Array<Encodable>`的数组转换为`String`
    /// - Returns: `String`
    func dd_String() -> String? {
        if let data = self.dd_Data() {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

// MARK: - Array<Decodable>
public extension Array where Element: Decodable {
    /// 将`[[String: Any]]`反序列化为遵守`Decodable`协议的模型对象数组
    /// - Parameter dictionary: 要反序列化的`[[String: Any]]`
    /// - Returns: 遵守`Decodable`协议的模型对象数组
    static func dd_models(_ array: [[String: Any]]?) -> Self where Self: Decodable {
        guard let array else { return [] }
        do {
            let data = try JSONSerialization.data(withJSONObject: array)
            return self.dd_models(data)
        } catch {
            return []
        }
    }

    /// 将`String`反序列化为遵守`Decodable`协议的模型对象数组
    /// - Parameter string: 要反序列化的`String`
    /// - Returns: 遵守`Decodable`协议的模型对象数组
    static func dd_models(_ string: String?) -> Self where Self: Decodable {
        if let data = string?.dd_Data() {
            return self.dd_models(data)
        }
        return []
    }

    /// 将`Data`反序列化为遵守`Decodable`协议的模型对象数组
    /// - Parameter data: 要反序列化的`Data`
    /// - Returns: 遵守`Decodable`协议的模型对象数组
    static func dd_models(_ data: Data?) -> Self where Self: Decodable {
        guard let data else { return [] }
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            return []
        }
    }
}
