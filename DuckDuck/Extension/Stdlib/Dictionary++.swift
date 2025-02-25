import Foundation

// MARK: - 构造方法
public extension Dictionary {
    /// 根据`keyPath`对给定序列进行分组并构造字典
    ///
    /// - Example:
    /// ```swift
    /// struct Item {
    ///     let category: String
    ///     let value: Int
    /// }
    /// let items = [Item(category: "A", value: 1), Item(category: "B", value: 2), Item(category: "A", value: 3)]
    /// let groupedDict = Dictionary(dd_grouping: items, by: \.category)
    /// print(groupedDict) // ["A": [Item(category: "A", value: 1), Item(category: "A", value: 3)], "B": [Item(category: "B", value: 2)]]
    /// ```
    /// - Parameters:
    ///   - sequence: 要分组的序列
    ///   - keyPath: 分组依据
    init<S: Sequence>(dd_grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }
}

// MARK: - 下标
public extension Dictionary {
    /// 根据路径设置/获取嵌套字典的数据
    ///
    /// - Example:
    /// ```swift
    /// var dict = ["key": ["key1": ["key2": "value"]]]
    /// dict[dd_path: ["key", "key1", "key2"]] = "newValue"
    /// print(dict[dd_path: ["key", "key1", "key2"]]) // 输出 "newValue"
    /// ```
    /// - Note: 取值是迭代的，设置是递归的
    /// - Parameter dd_path: 键路径数组
    /// - Returns: 查找到的数据或`nil`
    subscript(dd_path path: [Key]) -> Any? {
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
            guard let first = path.first else { return }
            if path.count == 1, let value = newValue as? Value {
                self[first] = value
            } else {
                var nested = self[first] as? [Key: Any] ?? [:]
                nested[dd_path: Array(path.dropFirst())] = newValue
                self[first] = nested as? Value
            }
        }
    }
}

// MARK: - 方法
public extension Dictionary {
    /// 获取字典所有的键
    /// - Returns: 一个包含所有键的数组
    /// - Example:
    /// ```swift
    /// let dictionary = ["name": "John", "age": 25, "location": "New York"]
    /// let keys = dictionary.dd_keys()  // 返回 ["name", "age", "location"]
    /// ```
    func dd_keys() -> [Key] {
        return Array(self.keys)
    }

    /// 获取字典所有的值
    /// - Returns: 一个包含所有值的数组
    /// - Example:
    /// ```swift
    /// let dictionary = ["name": "John", "age": 25, "location": "New York"]
    /// let values = dictionary.dd_values()  // 返回 ["John", 25, "New York"]
    /// ```
    func dd_values() -> [Value] {
        return Array(self.values)
    }

    /// 遍历字典并根据映射闭包生成数组
    ///
    /// - Example:
    /// ```swift
    /// let dict = ["key1": 1, "key2": 2]
    /// let result = dict.dd_mapToArray { key, value in "\(key):\(value)" }
    /// print(result) // ["key1:1", "key2:2"]
    /// ```
    /// - Parameter transform: 映射闭包
    /// - Returns: 转换后的数组
    func dd_mapToArray<V>(_ transform: (Key, Value) -> V) -> [V] {
        map(transform)
    }

    /// 获取字典中所有键（乱序）
    ///
    /// - Example:
    /// ```swift
    /// let dict = ["key1": "value1", "key2": "value2"]
    /// print(dict.dd_shuffledKeys()) // ["key2", "key1"]
    /// ```
    /// - Returns: 键的数组
    func dd_shuffledKeys() -> [Key] {
        keys.shuffled()
    }

    /// 获取字典中所有值（乱序）
    ///
    /// - Example:
    /// ```swift
    /// let dict = ["key1": "value1", "key2": "value2"]
    /// print(dict.dd_shuffledValues()) // ["value2", "value1"]
    /// ```
    /// - Returns: 值的数组
    func dd_shuffledValues() -> [Value] {
        values.shuffled()
    }

    /// 判断字典中是否包含指定键
    ///
    /// - Example:
    /// ```swift
    /// let dict = ["key1": "value1"]
    /// print(dict.dd_contains(key: "key1")) // true
    /// print(dict.dd_contains(key: "key2")) // false
    /// ```
    /// - Parameter key: 要查询的键
    /// - Returns: 是否包含
    func dd_contains(key: Key) -> Bool {
        index(forKey: key) != nil
    }

    /// 从字典中移除指定键
    ///
    /// - Example:
    /// ```swift
    /// var dict = ["key1": "value1", "key2": "value2"]
    /// dict.dd_remove(keys: ["key1"])
    /// print(dict) // ["key2": "value2"]
    /// ```
    /// - Parameter keys: 要移除的键
    mutating func dd_remove(keys: some Sequence<Key>) {
        keys.forEach { removeValue(forKey: $0) }
    }

    /// 删除随机键的值
    ///
    /// - Example:
    /// ```swift
    /// var dict = ["key1": "value1", "key2": "value2"]
    /// let removedValue = dict.dd_removeRandomValue()
    /// print(removedValue) // 随机值，例如 "value1"
    /// ```
    /// - Returns: 被删除的值
    @discardableResult
    mutating func dd_removeRandomValue() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return removeValue(forKey: randomKey)
    }

    /// 返回映射后的新字典
    ///
    /// - Example:
    /// ```swift
    /// let dict = ["key1": 1, "key2": 2]
    /// let result = dict.dd_mapToDictionary { key, value in (key.uppercased(), value * 2) }
    /// print(result) // ["KEY1": 2, "KEY2": 4]
    /// ```
    /// - Parameter transform: 转换闭包
    /// - Returns: 映射后的字典
    func dd_mapToDictionary<K, V>(_ transform: ((Key, Value)) throws -> (K, V)) rethrows -> [K: V] {
        try [K: V](uniqueKeysWithValues: map(transform))
    }

    /// 返回过滤和映射后的新字典
    ///
    /// - Example:
    /// ```swift
    /// let dict = ["key1": 1, "key2": 2]
    /// let result = dict.dd_compactMapToDictionary { key, value in
    ///     value > 1 ? ("filtered_" + key, value * 2) : nil
    /// }
    /// print(result) // ["filtered_key2": 4]
    /// ```
    /// - Parameter transform: 转换闭包
    /// - Returns: 转换后的字典
    func dd_compactMapToDictionary<K, V>(_ transform: ((Key, Value)) throws -> (K, V)?) rethrows -> [K: V] {
        try [K: V](uniqueKeysWithValues: compactMap(transform))
    }

    /// 返回包含指定键的新字典
    ///
    /// - Example:
    /// ```swift
    /// let dict = ["key1": 1, "key2": 2, "key3": 3]
    /// let result = dict.dd_filter(keys: ["key1", "key3"])
    /// print(result) // ["key1": 1, "key3": 3]
    /// ```
    /// - Parameter keys: 键数组
    /// - Returns: 新字典
    func dd_filter(keys: [Key]) -> [Key: Value] {
        keys.reduce(into: [Key: Value]()) { result, key in
            if let value = self[key] {
                result[key] = value
            }
        }
    }
}

// MARK: - Value: Equatable
public extension Dictionary where Value: Equatable {
    /// 获取与指定值相等的所有键
    ///
    /// - Example:
    /// ```swift
    /// let dict = ["key1": "value1", "key2": "value1", "key3": "value2"]
    /// let keys = dict.dd_keys(forValue: "value1")
    /// print(keys) // ["key1", "key2"]
    /// ```
    /// - Parameter value: 要比较的值
    /// - Returns: 包含相等值的键数组
    func dd_keys(forValue value: Value) -> [Key] {
        keys.filter { self[$0] == value }
    }
}

// MARK: - Key: StringProtocol
public extension Dictionary where Key: StringProtocol {
    /// 将字典中的所有键转换为小写
    ///
    /// - Example:
    /// ```swift
    /// var dict = ["KEY": "value", "AnotherKey": "anotherValue"]
    /// dict.dd_lowercaseAllKeys()
    /// print(dict) // ["key": "value", "anotherkey": "anotherValue"]
    /// ```
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
    /// 合并两个字典并返回新字典
    ///
    /// - Example:
    /// ```swift
    /// let dict1 = ["key1": "value1"]
    /// let dict2 = ["key2": "value2"]
    /// let result = dict1 + dict2
    /// print(result) // ["key1": "value1", "key2": "value2"]
    /// ```
    /// - Parameters:
    ///   - lhs: 左值字典
    ///   - rhs: 右值字典
    /// - Returns: 合并后的字典
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }

    /// 将右侧字典的内容追加到左侧字典
    ///
    /// - Example:
    /// ```swift
    /// var dict = ["key1": "value1"]
    /// let dict2 = ["key2": "value2"]
    /// dict += dict2
    /// print(dict) // ["key1": "value1", "key2": "value2"]
    /// ```
    /// - Parameters:
    ///   - lhs: 左值字典
    ///   - rhs: 右值字典
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }

    /// 从字典中移除包含在给定键序列中的键并返回新字典
    ///
    /// - Example:
    /// ```swift
    /// let dict = ["key1": "value1", "key2": "value2", "key3": "value3"]
    /// let result = dict - ["key1", "key2"]
    /// print(result) // ["key3": "value3"]
    /// ```
    /// - Parameters:
    ///   - lhs: 原始字典
    ///   - keys: 要移除的键
    /// - Returns: 移除后的新字典
    static func - (lhs: [Key: Value], keys: some Sequence<Key>) -> [Key: Value] {
        var result = lhs
        result.dd_remove(keys: keys)
        return result
    }

    /// 从字典中移除包含在给定键序列中的键
    ///
    /// - Example:
    /// ```swift
    /// var dict = ["key1": "value1", "key2": "value2", "key3": "value3"]
    /// dict -= ["key1", "key2"]
    /// print(dict) // ["key3": "value3"]
    /// ```
    /// - Parameters:
    ///   - lhs: 被修改的字典
    ///   - keys: 要移除的键
    static func -= (lhs: inout [Key: Value], keys: some Sequence<Key>) {
        lhs.dd_remove(keys: keys)
    }
}

// MARK: - JSON
public extension Dictionary {
    /// 将字典转换为`Data?`
    /// - Returns: 转换后的 `Data` 类型 JSON 数据，若转换失败返回 `nil`
    /// - Example:
    /// ```swift
    /// if let jsonData = myDictionary.dd_toData() {
    ///     print(jsonData)
    /// }
    /// ```
    func dd_toData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self)
    }
}
