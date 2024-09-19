//
//  NSPredicate+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - 类型转换
public extension NSPredicate {
    /// 转换为`NOT`复合谓词
    func dd_NOT() -> NSCompoundPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self)
    }
}

// MARK: - 方法
public extension NSPredicate {
    /// 创建一个`AND`复合谓词
    /// - Parameter predicate: 谓词
    /// - Returns: 结果复合谓词
    func dd_mix2AND(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
    }

    /// 创建一个`OR`复合谓词
    /// - Parameter predicate: 谓词
    /// - Returns: 结果复合谓词
    func dd_mix2OR(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
    }
}

// MARK: - 运算符
public extension NSPredicate {
    /// 创建一个`NOT`复合谓词
    /// - Parameter rhs: `NSPredicate`
    /// - Returns: 结果复合谓词
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        return rhs.dd_NOT()
    }

    /// 创建一个`AND`复合谓词
    /// - Parameters:
    ///   - lhs: `NSPredicate`
    ///   - rhs: `NSPredicate`
    /// - Returns: 结果复合谓词
    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.dd_mix2AND(rhs)
    }

    /// 返创建一个`OR`复合谓词
    ///
    /// - Parameters:
    ///   - lhs: `NSPredicate`
    ///   - rhs: `NSPredicate`
    /// - Returns: 结果复合谓词
    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.dd_mix2OR(rhs)
    }

    /// 从左值谓词中减去右值谓词
    /// - Parameters:
    ///   - lhs: `NSPredicate`.
    ///   - rhs: `NSPredicate`.
    /// - Returns: 结果复合谓词
    static func - (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs + !rhs
    }
}
