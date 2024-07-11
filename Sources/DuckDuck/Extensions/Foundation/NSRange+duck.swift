//
//  NSRange+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

extension NSRange: DDExtensionable {}

// MARK: - 方法
public extension DDExtension where Base == NSRange {
    /// `NSRange`转`Range`
    /// - Parameter string: `NSRange`所在字符串
    /// - Returns: `Range<String.Index>`
    func range(string: String) -> Range<String.Index>? {
        guard let from16 = string.utf16.index(string.utf16.startIndex, offsetBy: self.base.location, limitedBy: string.utf16.endIndex),
              let to16 = string.utf16.index(from16, offsetBy: self.base.length, limitedBy: string.utf16.endIndex),
              let from = String.Index(from16, within: string),
              let to = String.Index(to16, within: string)
        else { return nil }
        return from ..< to
    }
}
