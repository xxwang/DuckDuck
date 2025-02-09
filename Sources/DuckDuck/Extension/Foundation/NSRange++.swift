import Foundation

// MARK: - 方法
public extension NSRange {
    /// 将 `NSRange` 转换为 `Range<String.Index>`
    /// - Parameter string: `NSRange` 所在的字符串
    /// - Returns: 返回对应的 `Range<String.Index>`，如果转换失败则返回 `nil`
    /// - Example:
    ///   ```swift
    ///   let nsRange = NSRange(location: 5, length: 3)
    ///   let string = "Hello, world!"
    ///   if let range = nsRange.dd_toRange(string: string) {
    ///       let substring = string[range]  // "o, "
    ///   }
    ///   ```
    func dd_toRange(string: String) -> Range<String.Index>? {
        // 将 NSRange 的 location 和 length 转换为 String.Index
        guard let from16 = string.utf16.index(string.utf16.startIndex, offsetBy: self.location, limitedBy: string.utf16.endIndex),
              let to16 = string.utf16.index(from16, offsetBy: self.length, limitedBy: string.utf16.endIndex),
              let from = String.Index(from16, within: string),
              let to = String.Index(to16, within: string)
        else { return nil }

        // 返回转换后的 Range<String.Index>
        return from ..< to
    }
}
