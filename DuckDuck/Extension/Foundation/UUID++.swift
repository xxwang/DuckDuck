import Foundation

public extension UUID {
    /// 获取`UUID`字符串
    /// - Returns: `UUID`字符串
    static func dd_uuidString() -> String {
        return UUID().uuidString
    }
}
