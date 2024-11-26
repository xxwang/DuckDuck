//
//  NSPredicate++.swift
//  DuckDuck
//
//  Created by xxwang on 22/11/2024.
//

import Foundation

// MARK: - 类型转换
public extension NSPredicate {
    /// 转换为`NOT`复合谓词
    /// - Returns: 返回一个 `NOT` 的复合谓词
    /// - Example:
    /// ```swift
    /// let predicate = NSPredicate(format: "age > 18")
    /// let notPredicate = predicate.dd_toNOT()
    /// print(notPredicate)  // age <= 18
    /// ```
    func dd_toNOT() -> NSCompoundPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self)
    }
}

// MARK: - 方法
public extension NSPredicate {
    /// 创建一个`AND`复合谓词
    /// - Parameter predicate: 谓词
    /// - Returns: 返回一个`AND`类型的复合谓词
    /// - Example:
    /// ```swift
    /// let predicate1 = NSPredicate(format: "age > 18")
    /// let predicate2 = NSPredicate(format: "age < 30")
    /// let andPredicate = predicate1.dd_mix2AND(predicate2)
    /// print(andPredicate)  // age > 18 AND age < 30
    /// ```
    func dd_mix2AND(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
    }

    /// 创建一个`OR`复合谓词
    /// - Parameter predicate: 谓词
    /// - Returns: 返回一个`OR`类型的复合谓词
    /// - Example:
    /// ```swift
    /// let predicate1 = NSPredicate(format: "age > 18")
    /// let predicate2 = NSPredicate(format: "age < 30")
    /// let orPredicate = predicate1.dd_mix2OR(predicate2)
    /// print(orPredicate)  // age > 18 OR age < 30
    /// ```
    func dd_mix2OR(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
    }
}

// MARK: - 运算符
public extension NSPredicate {
    /// 创建一个`NOT`复合谓词
    /// - Parameter rhs: 右边的 `NSPredicate`
    /// - Returns: 返回 `NOT` 的复合谓词
    /// - Example:
    /// ```swift
    /// let predicate = NSPredicate(format: "age > 18")
    /// let notPredicate = !predicate
    /// print(notPredicate)  // age <= 18
    /// ```
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        return rhs.dd_toNOT()
    }

    /// 创建一个`AND`复合谓词
    /// - Parameters:
    ///   - lhs: 左边的 `NSPredicate`
    ///   - rhs: 右边的 `NSPredicate`
    /// - Returns: 返回 `AND` 的复合谓词
    /// - Example:
    /// ```swift
    /// let predicate1 = NSPredicate(format: "age > 18")
    /// let predicate2 = NSPredicate(format: "age < 30")
    /// let andPredicate = predicate1 + predicate2
    /// print(andPredicate)  // age > 18 AND age < 30
    /// ```
    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.dd_mix2AND(rhs)
    }

    /// 创建一个`OR`复合谓词
    /// - Parameters:
    ///   - lhs: 左边的 `NSPredicate`
    ///   - rhs: 右边的 `NSPredicate`
    /// - Returns: 返回 `OR` 的复合谓词
    /// - Example:
    /// ```swift
    /// let predicate1 = NSPredicate(format: "age > 18")
    /// let predicate2 = NSPredicate(format: "age < 30")
    /// let orPredicate = predicate1 | predicate2
    /// print(orPredicate)  // age > 18 OR age < 30
    /// ```
    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.dd_mix2OR(rhs)
    }

    /// 从左值谓词中减去右值谓词
    /// - Parameters:
    ///   - lhs: 左边的 `NSPredicate`
    ///   - rhs: 右边的 `NSPredicate`
    /// - Returns: 返回从左值谓词减去右值谓词的结果
    /// - Example:
    /// ```swift
    /// let predicate1 = NSPredicate(format: "age > 18")
    /// let predicate2 = NSPredicate(format: "age < 30")
    /// let subtractPredicate = predicate1 - predicate2
    /// print(subtractPredicate)  // age > 18 AND NOT age < 30
    /// ```
    static func - (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs + !rhs
    }
}
