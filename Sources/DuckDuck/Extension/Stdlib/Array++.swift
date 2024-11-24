//
//  Array++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 16/11/2024.
//

import Foundation

// MARK: - 下标扩展
public extension Array {
    /// 使用索引数组作为下标获取或设置数组数据
    ///
    /// - Example:
    /// ```
    /// let arr = [1, 2, 3, 4, 5, 6]
    /// let data = arr[dd_indexes: [1, 2, 3]] // [2, 3, 4]
    /// arr[dd_indexes: [1, 2, 3]] = [7, 8, 9] // [1, 7, 8, 9, 5, 6]
    /// ```
    /// - Parameter indexes: 索引数组
    /// - Returns: 结果数组切片
    subscript(dd_indexes indexes: [Int]) -> [Element] {
        get {
            let result = indexes.map { self[$0] }
            return result
        }
        set {
            for (index, idx) in indexes.enumerated() {
                self[idx] = newValue[index]
            }
        }
    }
}

// MARK: - 分组与切片
public extension Array {
    /// 按指定大小将数组分割为二维数组
    ///
    /// - Example:
    /// ```
    /// let arr = [1, 2, 3, 4, 5, 6]
    /// let result = arr.dd_split(size: 2) // [[1, 2], [3, 4], [5, 6]]
    /// ```
    func dd_split(size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        return stride(from: 0, to: count, by: size).map { Array(self[$0 ..< Swift.min($0 + size, count)]) }
    }

    /// 将相邻满足条件的元素分组
    ///
    /// - Example:
    /// ```
    /// let arr = [1, 2, 2, 3, 4, 4]
    /// let result = arr.grouped(where: ==) // [[1], [2, 2], [3], [4, 4]]
    /// ```
    func dd_grouped(where condition: (Element, Element) -> Bool) -> [[Element]] {
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
}

// MARK: - 插入/交换/获取
public extension Array {
    /// 将指定数组的所有元素添加到当前数组中
    ///
    /// - Example:
    /// ```
    /// var arr = [1, 2, 3]
    /// arr.dd_append(contentsOf: [4, 5]) // [1, 2, 3, 4, 5]
    /// ```
    mutating func dd_append(contentsOf elements: [Element]) {
        return elements.forEach { append($0) }
    }

    /// 插入一个元素到数组头部
    ///
    /// - Example:
    /// ```
    /// var arr = [2, 3, 4]
    /// arr.dd_prepend(1) // [1, 2, 3, 4]
    /// ```
    mutating func dd_prepend(_ newElement: Element) {
        self.insert(newElement, at: 0)
    }

    /// 交换数组中两个指定索引的元素
    ///
    /// - Example:
    /// ```
    /// var arr = [1, 2, 3, 4]
    /// arr.dd_swap(from: 1, to: 3) // [1, 4, 3, 2]
    /// ```
    mutating func dd_swap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex,
              indices.contains(index),
              indices.contains(otherIndex) else { return }
        self.swapAt(index, otherIndex)
    }

    /// 安全获取指定索引的值(越界返回`nil`)
    ///
    /// - Example:
    /// ```
    /// let arr = [1, 2, 3]
    /// print(arr.dd_safeValue(at: 1)) // Optional(2)
    /// print(arr.dd_safeValue(at: 5)) // nil
    /// ```
    func dd_safeValue(at index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}

// MARK: - 排序
public extension Array {
    /// 根据指定的`otherArray`数组与`keyPath`对数组进行排序
    ///
    ///     [MyStruct(x:3), MyStruct(x:1), MyStruct(x:2)]
    ///         .dd_sorted(like: [1, 2, 3], keyPath: \.x)
    ///     -> [MyStruct(x:1), MyStruct(x:2), MyStruct(x:3)]
    ///
    /// - Parameters:
    ///   - otherArray: 排序依据的数组
    ///   - keyPath: 排序的`keyPath`
    /// - Returns: 排序后的数组
    func dd_sorted<T: Hashable>(like otherArray: [T], keyPath: KeyPath<Element, T>) -> [Element] {
        let indexMap = Dictionary(uniqueKeysWithValues: otherArray.enumerated().map { ($1, $0) })
        return sorted {
            (indexMap[$0[keyPath: keyPath]] ?? .max) < (indexMap[$1[keyPath: keyPath]] ?? .max)
        }
    }
}

// MARK: - Element == String
public extension [String] {
    /// 将字符串数组转换为单个字符串
    ///
    ///     ["1", "2", "3"].dd_String(separator: "-")
    ///     -> "1-2-3"
    ///
    /// - Parameter separator: 分隔符，默认为空字符串
    /// - Returns: 拼接后的字符串
    func dd_String(separator: String = "") -> String {
        joined(separator: separator)
    }
}

// MARK: - Array Extension: Equatable
public extension Array where Element: Equatable {
    /// 获取指定元素在数组中的所有索引
    /// - Parameter item: 要查找的元素
    /// - Returns: 包含元素索引的数组
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 2, 4]
    /// let indexes = array.dd_indices(of: 2) // [1, 3]
    /// ```
    func dd_indices(of item: Element) -> [Int] {
        indices.filter { self[$0] == item }
    }

    /// 获取指定元素在数组中的第一个或最后一个索引
    /// - Parameters:
    ///   - item: 要查找的元素
    ///   - isLast: 是否获取最后一个索引，默认`false`
    /// - Returns: 元素的索引，若未找到则返回`nil`
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 2, 4]
    /// let firstIndex = array.dd_index(of: 2) // 1
    /// let lastIndex = array.dd_index(of: 2, isLast: true) // 3
    /// ```
    func dd_index(of item: Element, isLast: Bool = false) -> Int? {
        isLast ? dd_indices(of: item).last : firstIndex(of: item)
    }

    /// 返回数组中`keyPath`等于指定值的最后一个元素
    /// - Parameters:
    ///   - keyPath: 用于比较的`keyPath`
    ///   - value: 要匹配的值
    /// - Returns: 匹配的最后一个元素，若未找到则返回`nil`
    ///
    /// - Example:
    /// ```swift
    /// struct Person {
    ///     let id: Int
    ///     let name: String
    /// }
    /// let people = [
    ///     Person(id: 1, name: "Alice"),
    ///     Person(id: 2, name: "Bob"),
    ///     Person(id: 1, name: "Alice")
    /// ]
    /// let lastPerson = people.dd_last(where: \.id, equals: 1)
    /// // Person(id: 1, name: "Alice")
    /// ```
    func dd_last<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        last { $0[keyPath: keyPath] == value }
    }

    /// 删除数组中的指定元素
    /// - Parameters:
    ///   - item: 要删除的元素
    ///   - removeAllOccurrences: 是否删除所有出现的元素，默认`true`
    /// - Returns: 删除后的数组
    ///
    /// - Example:
    /// ```swift
    /// var array = [1, 2, 3, 2, 4]
    /// array.dd_remove(2) // [1, 3, 4]
    /// array.dd_remove(2, removeAllOccurrences: false) // [1, 3, 2, 4]
    /// ```
    @discardableResult
    mutating func dd_remove(_ item: Element, removeAllOccurrences: Bool = true) -> [Element] {
        guard removeAllOccurrences else {
            if let index = firstIndex(of: item) { remove(at: index) }
            return self
        }
        removeAll { $0 == item }
        return self
    }

    /// 删除数组中出现于指定数组的元素
    /// - Parameters:
    ///   - items: 要删除的元素数组
    ///   - removeAllOccurrences: 是否删除所有出现的元素，默认`true`
    /// - Returns: 删除后的数组
    ///
    /// - Example:
    /// ```swift
    /// var array = [1, 2, 3, 2, 4, 5]
    /// array.dd_removeItems([2, 5]) // [1, 3, 4]
    /// ```
    @discardableResult
    mutating func dd_removeItems(_ items: [Element], removeAllOccurrences: Bool = true) -> [Element] {
        items.forEach { dd_remove($0, removeAllOccurrences: removeAllOccurrences) }
        return self
    }

    /// 返回删除重复元素后的数组（不会修改原数组）
    /// - Returns: 去重后的数组
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 2, 3, 4, 4, 5]
    /// let uniqueArray = array.dd_unique() // [1, 2, 3, 4, 5]
    /// ```
    func dd_unique() -> [Element] {
        reduce(into: [Element]()) { result, item in
            if !result.contains(item) { result.append(item) }
        }
    }

    /// 根据`keyPath`返回删除重复元素后的数组
    /// - Parameter keyPath: 用于去重的`keyPath`
    /// - Returns: 去重后的数组
    ///
    /// - Example:
    /// ```swift
    /// struct Person {
    ///     let id: Int
    ///     let name: String
    /// }
    /// let people = [
    ///     Person(id: 1, name: "Alice"),
    ///     Person(id: 2, name: "Bob"),
    ///     Person(id: 1, name: "Alice")
    /// ]
    /// let uniquePeople = people.dd_unique(by: \.id)
    /// // [Person(id: 1, name: "Alice"), Person(id: 2, name: "Bob")]
    /// ```
    func dd_unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}

// MARK: - Array Extension: NSObjectProtocol
public extension Array where Element: NSObjectProtocol {
    /// 删除数组中符合给定`object`的元素
    /// - Parameters:
    ///   - object: 删除依据对象
    ///   - removeAllOccurrences: 是否删除所有匹配的元素，默认为`true`
    /// - Returns: 删除后的数组
    ///
    /// - Example:
    /// ```swift
    /// var array = [object1, object2, object3]
    /// array.dd_remove(object: object2) // 删除第一次出现的 object2
    /// ```
    @discardableResult
    mutating func dd_remove(object: NSObjectProtocol, removeAllOccurrences: Bool = true) -> Array {
        guard let index = firstIndex(where: { $0.isEqual(object) }) else { return self }
        remove(at: index)

        guard removeAllOccurrences else { return self }

        // 删除所有匹配的元素
        return dd_remove(object: object, removeAllOccurrences: true)
    }

    /// 删除数组中符合`objects`的所有元素
    /// - Parameters:
    ///   - objects: 要删除的对象数组
    ///   - removeAllOccurrences: 是否删除所有匹配的元素，默认为`true`
    /// - Returns: 删除后的数组
    ///
    /// - Example:
    /// ```swift
    /// var array = [object1, object2, object3]
    /// array.dd_remove(objects: [object1, object3]) // 删除 object1 和 object3
    /// ```
    @discardableResult
    mutating func dd_remove(objects: [NSObjectProtocol], removeAllOccurrences: Bool = true) -> Array {
        for object in objects {
            if let index = firstIndex(where: { $0.isEqual(object) }) {
                remove(at: index)
                // 如果不删除所有，停止进一步删除
                if !removeAllOccurrences { continue }
            }
        }
        return self
    }
}

// MARK: - 方法(数组:Element:NSAttributedString)
public extension Array where Element: NSAttributedString {
    /// 拼接数组元素为`NSAttributedString`并使用`separator`分割
    /// - Parameter separator: `NSAttributedString`分割符
    /// - Returns: 拼接后的`NSAttributedString`
    ///
    /// - Example:
    /// ```swift
    /// let attributedStrings: [NSAttributedString] = [
    ///     NSAttributedString(string: "Hello"),
    ///     NSAttributedString(string: "World"),
    ///     NSAttributedString(string: "Swift")
    /// ]
    /// let separator = NSAttributedString(string: " | ")
    /// let result = attributedStrings.dd_joined(separator: separator)
    /// print(result)  // 输出: "Hello | World | Swift"
    /// ```
    func dd_joined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = first else { return "".dd_toNSAttributedString() }
        return dropFirst()
            .reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
                result.append(separator)
                result.append(element)
            }
    }

    /// 拼接数组元素为`NSAttributedString`并使用`separator`分割
    /// - Parameter separator: `String`分割符
    /// - Returns: 拼接后的`NSAttributedString`
    ///
    /// - Example:
    /// ```swift
    /// let attributedStrings: [NSAttributedString] = [
    ///     NSAttributedString(string: "Apple"),
    ///     NSAttributedString(string: "Banana"),
    ///     NSAttributedString(string: "Cherry")
    /// ]
    /// let separator = " & "
    /// let result = attributedStrings.dd_joined(separator: separator)
    /// print(result)  // 输出: "Apple & Banana & Cherry"
    /// ```
    func dd_joined(separator: String) -> NSAttributedString {
        let separator = NSAttributedString(string: separator)
        return dd_joined(separator: separator)
    }
}

// MARK: - Array<Encodable>
public extension Array {
    /// 将数组转换为 `Data`
    /// - Returns: 转换后的 `Data`，若转换失败返回 `nil`
    /// - Example:
    /// ```swift
    /// let array: [Any] = [...]
    /// if let data = array.dd_toJSONData() {
    ///     print("Data: \(data)")
    /// }
    /// ```
    func dd_toJSONData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self)
    }

    /// 将数组转换为 `String`
    /// - Returns: 转换后的 `String`，若转换失败返回 `nil`
    /// - Example:
    /// ```swift
    /// let array: [Any] = [...]
    /// if let jsonString = array.dd_toJSONString() {
    ///     print("String: \(jsonString)")
    /// }
    /// ```
    func dd_toJSONString() -> String? {
        guard let data = dd_toJSONData() else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - Array<Encodable>
public extension Array where Element: Encodable {
    /// 将 `Array<Encodable>` 的数组转换为 `Data`
    /// - Returns: 转换后的 `Data`，若转换失败返回 `nil`
    /// - Example:
    /// ```swift
    /// let encodableArray: [SomeEncodableModel] = [...]
    /// if let data = encodableArray.dd_toJSONData() {
    ///     print("Encoded Data: \(data)")
    /// }
    /// ```
    func dd_toJSONData() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }

    /// 将 `Array<Encodable>` 的数组转换为 `String`
    /// - Returns: 转换后的 `String`，若转换失败返回 `nil`
    /// - Example:
    /// ```swift
    /// let encodableArray: [SomeEncodableModel] = [...]
    /// if let jsonString = encodableArray.dd_toJSONString() {
    ///     print("Encoded String: \(jsonString)")
    /// }
    /// ```
    func dd_toJSONString() -> String? {
        guard let data = dd_toJSONData() else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - Array<Decodable>
public extension Array where Element: Decodable {
    /// 将 `[[String: Any]]` 反序列化为遵守 `Decodable` 协议的模型对象数组
    /// - Parameter dictionarys: 要反序列化的 `[[String: Any]]`
    /// - Returns: 遵守 `Decodable` 协议的模型对象数组
    /// - Example:
    /// ```swift
    /// let jsonArray: [[String: Any]] = [...]
    /// let models: [SomeDecodableModel] = SomeDecodableModel.dd_fromJSONDictionarys(jsonArray)
    /// print(models)
    /// ```
    static func dd_fromJSONDictionarys(_ dictionarys: [[String: Any]]?) -> Self where Self: Decodable {
        guard let dictionarys else { return [] }
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionarys)
            return self.dd_fromJSONData(data)
        } catch {
            return []
        }
    }

    /// 将 `Data` 反序列化为遵守 `Decodable` 协议的模型对象数组
    /// - Parameter data: 要反序列化的 `Data`
    /// - Returns: 遵守 `Decodable` 协议的模型对象数组
    /// - Example:
    /// ```swift
    /// let jsonData: Data = ...
    /// let models: [SomeDecodableModel] = SomeDecodableModel.dd_fromJSONData(jsonData)
    /// print(models)
    /// ```
    static func dd_fromJSONData(_ data: Data) -> Self where Self: Decodable {
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            return []
        }
    }

    /// 将 `String` 反序列化为遵守 `Decodable` 协议的模型对象数组
    /// - Parameter string: 要反序列化的 `String`
    /// - Returns: 遵守 `Decodable` 协议的模型对象数组
    /// - Example:
    /// ```swift
    /// let jsonString: String = "{\"key\": \"value\"}"
    /// let models: [SomeDecodableModel] = SomeDecodableModel.dd_fromJSONString(jsonString)
    /// print(models)
    /// ```
    static func dd_fromJSONString(_ string: String) -> Self where Self: Decodable {
        guard let data = string.data(using: .utf8) else { return [] }
        return self.dd_fromJSONData(data)
    }
}
