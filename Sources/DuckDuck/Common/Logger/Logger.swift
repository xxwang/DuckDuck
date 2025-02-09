import Foundation

// MARK: - 日志记录器类，提供日志输出到控制台或文件的功能
@MainActor
public class Logger {
    /// 打印信息日志
    /// - Parameter message: 日志内容
    public class func info(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.output(level: .info, message: message, file: file, line: line, function: function)
    }

    /// 打印调试日志
    /// - Parameter message: 日志内容
    public class func debug(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.output(level: .debug, message: message, file: file, line: line, function: function)
    }

    /// 打印成功日志
    /// - Parameter message: 日志内容
    public class func success(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.output(level: .success, message: message, file: file, line: line, function: function)
    }

    /// 打印失败日志
    /// - Parameter message: 日志内容
    public class func fail(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.output(level: .fail, message: message, file: file, line: line, function: function)
    }

    /// 打印错误日志
    /// - Parameter message: 日志内容
    public class func error(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.output(level: .error, message: message, file: file, line: line, function: function)
    }
}
