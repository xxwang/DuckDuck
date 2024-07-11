//
//  NSPredicate+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - 计算属性
public extension DDExtension where Base: NSPredicate {
    /// 转换为`NOT`复合谓词
    var as2NOT: NSCompoundPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self.base)
    }
}

// MARK: - 方法
public extension DDExtension where Base: NSPredicate {
    /// 创建一个`AND`复合谓词
    /// - Parameter predicate: 谓词
    /// - Returns: 结果复合谓词
    func mix2AND(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self.base, predicate])
    }

    /// 创建一个`OR`复合谓词
    /// - Parameter predicate: 谓词
    /// - Returns: 结果复合谓词
    func mix2OR(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self.base, predicate])
    }
}

// MARK: - 运算符
public extension NSPredicate {
    /// 创建一个`NOT`复合谓词
    /// - Parameter rhs: `NSPredicate`
    /// - Returns: 结果复合谓词
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        return rhs.dd.as2NOT
    }

    /// 创建一个`AND`复合谓词
    /// - Parameters:
    ///   - lhs: `NSPredicate`
    ///   - rhs: `NSPredicate`
    /// - Returns: 结果复合谓词
    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.dd.mix2AND(rhs)
    }

    /// 返创建一个`OR`复合谓词
    ///
    /// - Parameters:
    ///   - lhs: `NSPredicate`
    ///   - rhs: `NSPredicate`
    /// - Returns: 结果复合谓词
    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.dd.mix2OR(rhs)
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
