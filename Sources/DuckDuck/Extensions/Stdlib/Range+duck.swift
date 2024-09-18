//
//  Range+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

// MARK: - 方法
public extension Range<String.Index> {
    /// `Range<String.Index>`转`NSRange`
    /// - Parameter string: `Range`所在字符串
    /// - Returns: `NSRange`
    func dd_NSRange(in string: String) -> NSRange {
        return NSRange(self, in: string)
    }
}
