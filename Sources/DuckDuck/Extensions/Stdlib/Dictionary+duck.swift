//
//  Dictionary+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//
import UIKit

// MARK: - 构造方法
public extension Dictionary {
    /// 根据`keyPath`对给定序列进行分组并构造字典
    /// - Parameters:
    ///   - sequence: 要分组的序列
    ///   - keyPath: 分组依据
    init<S: Sequence>(grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }
}

// MARK: - 下标
public extension Dictionary {
    /// 根据`path`来设置/获取嵌套字典的数据
    ///
    ///     var dict =  ["key":["key1":["key2":"value"]]]
    ///     dict[path:["key", "key1", "key2"]] = "newValue"
    ///     dict[path:["key", "key1", "key2"]] -> "newValue"
    ///
    /// - Note: 取值是迭代的,而设置是递归的
    /// - Parameter path: key路径数组
    /// - Returns: 要查找的目标数据
    subscript(path path: [Key]) -> Any? {
        get {
            guard !path.isEmpty else { return nil }
            var result: Any? = self
            for key in path {
                if let element = (result as? [Key: Any])?[key] {
                    result = element
                } else {
                    return nil
                }
            }
            return result
        }
        set {
            if let first = path.first {
                if path.count == 1, let new = newValue as? Value {
                    return self[first] = new
                }
                if var nested = self[first] as? [Key: Any] {
                    nested[path: Array(path.dropFirst())] = newValue
                    return self[first] = nested as? Value
                }
            }
        }
    }
}

// MARK: - 方法
public extension Dictionary {
    /// 遍历数组的数据并根据`map闭包`返回数组
    /// - Parameter map: 生产元素的闭包
    /// - Returns: 数组
    func dd_array<V>(_ map: (Key, Value) -> V) -> [V] {
        self.map(map)
    }

    /// 获取字典中所有的`Key`
    /// - Note: 乱序
    /// - Returns: 数组
    func dd_allKeys() -> [Key] {
        return self.keys.shuffled()
    }

    /// 获取字典中所有的`Value`
    /// - Note: 乱序
    /// - Returns: 数组
    func dd_allValues() -> [Value] {
        return values.shuffled()
    }

    /// 查询字典中是否存在指定`Key`
    ///
    ///     let dict:[String:Any] = ["testKey":"testValue", "testArrayKey":[1, 2, 3, 4, 5]]
    ///     dict.dd_has(key:"testKey") -> true
    ///     dict.dd_has(key:"anotherKey") -> false
    ///
    /// - Parameter key: 要查询的`Key`
    /// - Returns: 是否存在
    func dd_has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }

    /// 从字典中删除`keys`参数中包含的所有键
    ///
    ///     var dict :[String:String] = ["key1" :"value1", "key2" :"value2", "key3" :"value3"]
    ///     dict.dd_removeAll(keys:["key1", "key2"])
    ///     dict.keys.contains("key3") -> true
    ///     dict.keys.contains("key1") -> false
    ///     dict.keys.contains("key2") -> false
    ///
    /// - Parameter keys: 要删除的键
    mutating func dd_removeAll(keys: some Sequence<Key>) {
        keys.forEach { self.removeValue(forKey: $0) }
    }

    /// 从字典中删除随机键的值
    /// - Returns: 被删除键对应的值
    @discardableResult
    mutating func dd_removeValueForRandomKey() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return self.removeValue(forKey: randomKey)
    }

    /// 根据`transform`返回数据构造一个字典
    /// - Parameter transform: 转换闭包,返回一个(`Key`, `Value`)元组
    /// - Returns: 结果字典
    func dd_mapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        try [K: V](uniqueKeysWithValues: self.map(transform))
    }

    /// 根据`transform`返回数据构造一个字典
    /// - Note: 如果`transform`返回`nil`不会出现在结果字典中
    /// - Parameter transform: 转换闭包,返回一个(`Key`, `Value`)元组
    /// - Returns: 结果字典
    func dd_compactMapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)?) rethrows -> [K: V] {
        try [K: V](uniqueKeysWithValues: compactMap(transform))
    }

    /// 使用指定`Key`数组创建新字典
    ///
    ///     var dict =  ["key1":1, "key2":2, "key3":3, "key4":4]
    ///     dict.dd_pick(keys:["key1", "key3", "key4"]) -> ["key1":1, "key3":3, "key4":4]
    ///     dict.dd_pick(keys:["key2"]) -> ["key2":2]
    ///
    /// - Parameter keys: `Key`数组
    /// - Returns: 结果字典
    func dd_pick(keys: [Key]) -> [Key: Value] {
        return keys.reduce(into: [Key: Value]()) { result, item in
            result[item] = self[item]
        }
    }
}

// MARK: - Value:Equatable
public extension Dictionary where Value: Equatable {
    /// 获取与指定`Value`相等的所有`Key`
    ///
    ///     let dict = ["key1":"value1", "key2":"value1", "key3":"value2"]
    ///     dict.dd_keys(forValue:"value1") -> ["key1", "key2"]
    ///     dict.dd_keys(forValue:"value2") -> ["key3"]
    ///     dict.dd_keys(forValue:"value3") -> []
    ///
    /// - Parameter value: 要比较的`Value`
    /// - Returns: 结果数组
    func dd_keys(forValue value: Value) -> [Key] {
        keys.filter { self[$0] == value }
    }
}

// MARK: - Key:StringProtocol
public extension Dictionary where Key: StringProtocol {
    /// 把字典中所有的`Key`转化为小写
    ///
    ///     var dict = ["tEstKeY":"value"]
    ///     dict.dd_lowercaseAllKeys()
    ///     print(dict) // prints "["testkey":"value"]"
    ///
    mutating func dd_lowercaseAllKeys() {
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
}

// MARK: - 运算符
public extension Dictionary {
    /// 合并两个字典
    ///
    ///     let dict:[String:String] = ["key1":"value1"]
    ///     let dict2:[String:String] = ["key2":"value2"]
    ///     let result = dict + dict2
    ///     result["key1"] -> "value1"
    ///     result["key2"] -> "value2"
    ///
    /// - Note: 返回一个新字典
    /// - Parameters:
    ///   - lhs: 左值字典
    ///   - rhs: 右值字典
    /// - Returns: 结果字典
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }

    /// 把运算符右侧字典追加到左侧字典
    ///
    ///     var dict:[String:String] = ["key1":"value1"]
    ///     let dict2:[String:String] = ["key2":"value2"]
    ///     dict += dict2
    ///     dict["key1"] -> "value1"
    ///     dict["key2"] -> "value2"
    ///
    /// - Note: 不返回新字典
    /// - Parameters:
    ///   - lhs: 左值字典
    ///   - rhs: 右值字典
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }

    /// 从字典中删除`Key`序列中包含的键对应的数据
    ///
    ///     let dict:[String:String] = ["key1":"value1", "key2":"value2", "key3":"value3"]
    ///     let result = dict-["key1", "key2"]
    ///     result.keys.contains("key3") -> true
    ///     result.keys.contains("key1") -> false
    ///     result.keys.contains("key2") -> false
    ///
    /// - Note: 会返回新字典
    /// - Parameters:
    ///   - lhs: 左值字典
    ///   - keys: 右值字典
    /// - Returns: 结果字典
    static func - (lhs: [Key: Value], keys: some Sequence<Key>) -> [Key: Value] {
        var result = lhs
        result.dd_removeAll(keys: keys)
        return result
    }

    /// 从字典中删除`Key`序列中包含的键对应的数据
    ///
    ///     var dict:[String:String] = ["key1":"value1", "key2":"value2", "key3":"value3"]
    ///     dict-=["key1", "key2"]
    ///     dict.keys.contains("key3") -> true
    ///     dict.keys.contains("key1") -> false
    ///     dict.keys.contains("key2") -> false
    ///
    /// - Note: 不会返回新字典
    /// - Parameters:
    ///   - lhs: 左值字典
    ///   - keys: 右值字典
    static func -= (lhs: inout [Key: Value], keys: some Sequence<Key>) {
        lhs.dd_removeAll(keys: keys)
    }
}
