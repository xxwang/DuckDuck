//
//  DDLog.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

public class DDLog {
    /// 信息
    public static func info(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.log(logType: .info,
                 message: message,
                 file: file,
                 line: line,
                 function: function)
    }

    /// 调试
    public static func debug(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.log(logType: .debug,
                 message: message,
                 file: file,
                 line: line,
                 function: function)
    }

    /// 成功
    public static func success(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.log(logType: .success,
                 message: message,
                 file: file,
                 line: line,
                 function: function)
    }

    /// 失败
    public static func fail(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.log(logType: .fail,
                 message: message,
                 file: file,
                 line: line,
                 function: function)
    }

    /// 错误
    public static func error(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.log(logType: .error,
                 message: message,
                 file: file,
                 line: line,
                 function: function)
    }
}

private extension DDLog {
    /// 输出到终端
    private static func log(logType: DDLogType, message: Any..., file: String, line: Int, function: String) {
        let content = self.makeLog(level: logType, message: message, file: file, line: line, function: function)
        print(content)
    }

    /// 组装日志
    private static func makeLog(level: DDLogType, message: Any..., file: String, line: Int, function: String) -> String {
        let logEmoji = level.emoji
        let logDesc = level.description
        let logDate = level.date
        let fileName = (file as NSString).lastPathComponent
        let content = message.map { "\($0)" }.joined(separator: " ")

        return "\(logEmoji)[\(logDesc)]:DD::[\(logDate)] [\(fileName)(\(line))] \(function): \(content)"
    }
}

// MARK: - DDLogType
private enum DDLogType {
    case info // 信息
    case debug // 调试
    case success // 成功
    case fail // 失败
    case error // 错误

    /// 表情
    var emoji: String {
        switch self {
        case .info:
            return "🌸"
        case .debug:
            return "👻"
        case .success:
            return "✅"
        case .fail:
            return "❌"
        case .error:
            return "💣"
        }
    }

    /// 描述
    var description: String {
        switch self {
        case .info:
            return "信息"
        case .debug:
            return "调试"
        case .success:
            return "成功"
        case .fail:
            return "失败"
        case .error:
            return "错误"
        }
    }

    /// 日期
    var date: String {
        let dateFormatter = DateFormatter()
        switch self {
        case .error:
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        default:
            dateFormatter.dateFormat = "HH:mm:ss.SSS"
        }
        return dateFormatter.string(from: Date())
    }
}
