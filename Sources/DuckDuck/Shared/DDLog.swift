//
//  DDLog.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation
import os.log

public class DDLog {
    /// 日志保存在内存里 主要存储产生错误的信息
    public static func `default`(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.log(level: .default, message: message, file: file, line: line, function: function)
    }

    /// 日志保存在内存里 主要存储对分析错误有用的信息
    public static func info(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.log(level: .info, message: message, file: file, line: line, function: function)
    }

    /// 日志保存在内存中，在Debug状态下有用，主要用于开发阶段
    public static func debug(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.log(level: .debug, message: message, file: file, line: line, function: function)
    }

    /// 日志一直保存在数据仓库中，结合 Activity 使用，会有一个完整日志处理链 用存集成级别错误 process-level
    public static func error(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.log(level: .error, message: message, file: file, line: line, function: function)
    }

    /// 日志一直保存在数据仓库中，结合 Activity 使用，会有一个完整日志处理链 多用于系统级别错误和多进程错误
    public static func fault(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        self.log(level: .fault, message: message, file: file, line: line, function: function)
    }
}

private extension DDLog {
    @LoggerWrapper
    private static var logger

    private static func log(level: OSLogType, message: Any..., file: String, line: Int, function: String) {
        let content = self.makeLog(level: level, message: message, file: file, line: line, function: function)
        self.logger.log(level: level, "\(content)")
    }

    private static func makeLog(level: OSLogType, message: Any..., file: String, line: Int, function: String) -> String {
        let logEmoji = level.emoji
        let logDesc = level.desc
        let logDate = level.date
        let fileName = (file as NSString).lastPathComponent
        let content = message.map { "\($0)" }.joined(separator: " ")

        return "\(logEmoji)[\(logDesc)]:WG::[\(logDate)] [\(fileName)(\(line))] \(function): \(content)"
    }
}

private extension OSLogType {
    var emoji: String {
        switch self {
        case .info:
            return "🌸"
        case .debug:
            return "👻"
        case .error:
            return "❌"
        case .fault:
            return "💣"
        default:
            return "✅"
        }
    }

    var desc: String {
        switch self {
        case .info:
            return "信息"
        case .debug:
            return "调试"
        case .error:
            return "错误"
        case .fault:
            return "崩溃"
        default:
            return "正常"
        }
    }

    var date: String {
        let dateFormatter = DateFormatter()
        switch self {
        case .error, .fault:
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        default:
            dateFormatter.dateFormat = "HH:mm:ss.SSS"
        }
        return dateFormatter.string(from: Date())
    }
}
