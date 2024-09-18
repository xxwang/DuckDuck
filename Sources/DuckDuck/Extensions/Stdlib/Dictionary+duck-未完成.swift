//
//  Dictionary+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//
// TODO: -
// import UIKit
//
// public extension Dictionary {
//    typealias WG = WGEx<Self>
//    var wg: WG {
//        return WGEx(self)
//    }
// }
//
//// MARK: - 构造方法
// public extension Dictionary {
//    /// 根据`keyPath`对给定序列进行分组并构造字典
//    /// - Parameters:
//    ///   - sequence: 要分组的序列
//    ///   - keyPath: 分组依据
//    init<S: Sequence>(grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
//        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
//    }
// }
//
//// MARK: - 下标
// public extension Dictionary {
//    /// 根据`path`来设置/获取嵌套字典的数据
//    ///
//    ///     var dict =  ["key":["key1":["key2":"value"]]]
//    ///     dict[path:["key", "key1", "key2"]] = "newValue"
//    ///     dict[path:["key", "key1", "key2"]] -> "newValue"
//    ///
//    /// - Note: 取值是迭代的,而设置是递归的
//    /// - Parameter path: key路径数组
//    /// - Returns: 要查找的目标数据
//    subscript(path path: [Key]) -> Any? {
//        get {
//            guard !path.isEmpty else { return nil }
//            var result: Any? = self
//            for key in path {
//                if let element = (result as? [Key: Any])?[key] {
//                    result = element
//                } else {
//                    return nil
//                }
//            }
//            return result
//        }
//        set {
//            if let first = path.first {
//                if path.count == 1, let new = newValue as? Value {
//                    return self[first] = new
//                }
//                if var nested = self[first] as? [Key: Any] {
//                    nested[path: Array(path.dropFirst())] = newValue
//                    return self[first] = nested as? Value
//                }
//            }
//        }
//    }
// }
//
//// MARK: - Key:StringProtocol
// public extension Dictionary where Key: StringProtocol {
//    /// 把字典中所有的`Key`转化为小写
//    ///
//    ///     var dict = ["tEstKeY":"value"]
//    ///     dict.dd.lowercaseAllKeys()
//    ///     print(dict) // prints "["testkey":"value"]"
//    ///
//    mutating func lowercaseAllKeys() {
//        for key in keys {
//            if let lowercaseKey = String(describing: key).lowercased() as? Key {
//                self[lowercaseKey] = removeValue(forKey: key)
//            }
//        }
//    }
// }
//
// public extension DDExtension where Base == Dictionary<AnyHashable, Any> {
//    func tttt1() {
//
//    }
//
//    func ttts() {
//        let dict: [AnyHashable: Any] = [:]
//        dict.dd.tttt1()
//    }
// }
//
//// MARK: - 运算符
// public extension Dictionary {
//    /// 合并两个字典
//    ///
//    ///     let dict:[String:String] = ["key1":"value1"]
//    ///     let dict2:[String:String] = ["key2":"value2"]
//    ///     let result = dict + dict2
//    ///     result["key1"] -> "value1"
//    ///     result["key2"] -> "value2"
//    ///
//    /// - Note: 返回一个新字典
//    /// - Parameters:
//    ///   - lhs: 左值字典
//    ///   - rhs: 右值字典
//    /// - Returns: 结果字典
//    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
//        var result = lhs
//        rhs.forEach { result[$0] = $1 }
//        return result
//    }
//
//    /// 把运算符右侧字典追加到左侧字典
//    ///
//    ///     var dict:[String:String] = ["key1":"value1"]
//    ///     let dict2:[String:String] = ["key2":"value2"]
//    ///     dict += dict2
//    ///     dict["key1"] -> "value1"
//    ///     dict["key2"] -> "value2"
//    ///
//    /// - Note: 不返回新字典
//    /// - Parameters:
//    ///   - lhs: 左值字典
//    ///   - rhs: 右值字典
//    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
//        rhs.forEach { lhs[$0] = $1 }
//    }
//
//    /// 从字典中删除`Key`序列中包含的键对应的数据
//    ///
//    ///     let dict:[String:String] = ["key1":"value1", "key2":"value2", "key3":"value3"]
//    ///     let result = dict-["key1", "key2"]
//    ///     result.keys.contains("key3") -> true
//    ///     result.keys.contains("key1") -> false
//    ///     result.keys.contains("key2") -> false
//    ///
//    /// - Note: 会返回新字典
//    /// - Parameters:
//    ///   - lhs: 左值字典
//    ///   - keys: 右值字典
//    /// - Returns: 结果字典
//    static func - (lhs: [Key: Value], keys: some Sequence<Key>) -> [Key: Value] {
//        var result = lhs
//        result.pd_removeAll(keys: keys)
//        return result
//    }
//
//    /// 从字典中删除`Key`序列中包含的键对应的数据
//    ///
//    ///     var dict:[String:String] = ["key1":"value1", "key2":"value2", "key3":"value3"]
//    ///     dict-=["key1", "key2"]
//    ///     dict.keys.contains("key3") -> true
//    ///     dict.keys.contains("key1") -> false
//    ///     dict.keys.contains("key2") -> false
//    ///
//    /// - Note: 不会返回新字典
//    /// - Parameters:
//    ///   - lhs: 左值字典
//    ///   - keys: 右值字典
//    static func -= (lhs: inout [Key: Value], keys: some Sequence<Key>) {
//        lhs.pd_removeAll(keys: keys)
//    }
// }
