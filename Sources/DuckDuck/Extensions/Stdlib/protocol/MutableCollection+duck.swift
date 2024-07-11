//
//  MutableCollection+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

public extension MutableCollection {
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }
}

// MARK: - 方法
public extension DDExtension where Base: MutableCollection {
    /// 为集合中所有元素的指定`keyPath`赋一个值
    /// - Parameters:
    ///   - value: 要赋的值
    ///   - keyPath: keyPath
    func assignToAll<Value>(value: Value, by keyPath: WritableKeyPath<Base.Element, Value>) {
        for idx in self.base.indices {
            self.base[idx][keyPath: keyPath] = value
        }
    }
}

// MARK: - 排序
public extension DDExtension where Base: MutableCollection, Base: RandomAccessCollection {
    /// 根据`keyPath`和`compare`函数对集合进行排序
    /// - Parameters:
    ///   - keyPath: keyPath
    ///   - compare: 比较函数
    func sort<T>(by keyPath: KeyPath<Base.Element, T>, with compare: (T, T) -> Bool) {
        self.base.sort { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    /// 根据`keyPath`对集合进行排序
    /// - Parameter keyPath: keyPath
    func sort(by keyPath: KeyPath<Base.Element, some Comparable>) {
        self.base.sort { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    /// 根据两个路径对集合进行排序, 需要遵守`Comparable`协议
    /// - Parameters:
    ///   - keyPath1: keyPath1
    ///   - keyPath2: keyPath2
    func sort(by keyPath1: KeyPath<Base.Element, some Comparable>, and keyPath2: KeyPath<Base.Element, some Comparable>) {
        self.base.sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    /// 根据三个路径对集合进行排序,需要遵守`Comparable`协议
    /// - Parameters:
    ///   - keyPath1: keyPath1
    ///   - keyPath2: keyPath2
    ///   - keyPath3: keyPath3
    func sort(by keyPath1: KeyPath<Base.Element, some Comparable>, and keyPath2: KeyPath<Base.Element, some Comparable>, and keyPath3: KeyPath<Base.Element, some Comparable>) {
        self.base.sort {
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
