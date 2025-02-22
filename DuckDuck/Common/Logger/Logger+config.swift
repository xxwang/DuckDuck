import Foundation

// MARK: - 日志设置
public extension Logger {
    /// 最低日志级别，低于此级别的日志将不会输出
    static var level: LoggerLevel = .info

    /// 是否启用文件日志
    static var fileEnabled: Bool = false

    /// 日志文件路径
    static var filePath: String = "/tmp/logs.txt"

    /// 是否显示时间戳
    static var showTimestamp: Bool = true
}
