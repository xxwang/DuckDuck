//
//  Range+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

extension Range: DDExtensionable where Bound == String.Index {}

// MARK: - 方法
public extension DDExtension where Base == Range<String.Index> {
    /// `Range<String.Index>`转`NSRange`
    /// - Parameter string: `Range`所在字符串
    /// - Returns: `NSRange`
    func as2NSRange(in string: String) -> NSRange {
        return NSRange(self.base, in: string)
    }
}
